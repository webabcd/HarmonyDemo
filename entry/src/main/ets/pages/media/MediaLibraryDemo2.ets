/*
 * 从媒体库读取文件
 *
 * 注：如果需要任意存取相册中的文件，则需要申请 ACL 权限
 */

import { TitleBar } from '../TitleBar'
import { AlbumInfo, AlbumPickerComponent,
  AlbumPickerOptions,
  DataType,
  photoAccessHelper, PickerColorMode } from '@kit.MediaLibraryKit'
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  BaseItemInfo,
  ItemInfo,
  PhotoBrowserInfo,
  ClickType,
  MaxCountType,
  PhotoBrowserRange,
  ReminderMode,
} from '@ohos.file.PhotoPickerComponent';
import { PhotoSource,
  RecentPhotoComponent,
  RecentPhotoInfo,
  RecentPhotoOptions } from '@ohos.file.RecentPhotoComponent';

@Entry
@Component
struct MediaLibraryDemo2 {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        // PhotoViewPicker - 弹出媒体选择页
        TabContent() { MySample1() }.tabBar('PhotoViewPicker').align(Alignment.Top)
        // PhotoPickerComponent - 在当前页面中显示媒体选择组件
        TabContent() { MySample2() }.tabBar('PhotoPickerComponent').align(Alignment.Top)
        // RecentPhotoComponent - 在当前页面中显示最近保存的媒体
        TabContent() { MySample3() }.tabBar('RecentPhotoComponent').align(Alignment.Top)
        // AlbumPickerComponent - 在当前页面中显示相册选择组件，并且可以与 PhotoPickerComponent 联动
        TabContent() { MySample4() }.tabBar('AlbumPickerComponent').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State albumImageUrl: string = ""
  @State sandboxImageUrl: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Image(this.albumImageUrl).width(100).height(100)

      Image(this.sandboxImageUrl).width(100).height(100)

      Button("打开 PhotoViewPicker").onClick(async () => {

        /*
         * photoAccessHelper.PhotoSelectOptions() - 创建 PhotoSelectOptions 对象
         * photoAccessHelper.PhotoViewPicker() - 创建 PhotoViewPicker 对象
         *
         * PhotoSelectOptions - 拉起图片选择器的选项
         *   MIMEType - 可以选择的文件的类型（PhotoViewMIMETypes 枚举）
         *     IMAGE_TYPE, VIDEO_TYPE, IMAGE_VIDEO_TYPE, MOVING_PHOTO_IMAGE_TYPE（动态照片，类似苹果的实况照片）
         *   maxSelectNumber - 允许选择的最大的文件数量
         *
         * PhotoViewPicker - 图片选择器
         *   select() - 拉起图片选择器
         *     option - 选项（一个 PhotoSelectOptions 对象）
         *     回调参数是一个 PhotoSelectResult 对象
         *
         * PhotoSelectResult - 通过图片选择器选择文件后的结果
         *   photoUris - 选中的媒体文件的地址数组（当前应用会获得这些文件的临时授权）
         *   isOriginalPhoto - 选中的媒体文件是否为原图
         */
        const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
        photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
        photoSelectOptions.maxSelectNumber = 3

        const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
        photoViewPicker.select(photoSelectOptions).then(async (photoSelectResult: photoAccessHelper.PhotoSelectResult) => {

          // 获取用户选中的第一个文件的地址
          this.albumImageUrl = photoSelectResult.photoUris[0]
          // 需要将选中的文件保存到的沙箱地址
          this.sandboxImageUrl = "file://" + getContext(this).filesDir + '/test.jpg'

          // 将从相册中选中的图片复制到指定的沙箱地址
          let albumImageFile = fs.openSync(this.albumImageUrl, fs.OpenMode.READ_ONLY)
          let sandboxImageFile = fs.openSync(this.sandboxImageUrl, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
          fs.copyFileSync(albumImageFile.fd, sandboxImageFile.fd)

          this.message = '从媒体库读取文件成功'

        }).catch((err: BusinessError) => {
          this.message = `从媒体库读取文件失败 errCode:${err.code}, errMessage:${err.message}`
        })
      })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  // 已选择的图片的相册地址数组
  @State selectUris: Array<string> = new Array<string>();

  /*
   * PickerController - 用于和绑定的 PhotoPickerComponent 之间的交互
   *   setPhotoBrowserItem() - 进入大图模式
   *   exitPhotoBrowser() - 离开大图模式
   */
  @State pickerController: PickerController = new PickerController();

  pickerOptions: PickerOptions = new PickerOptions();

  aboutToAppear() {
    /*
     * PickerOptions - 图片选择器组件的选项
     *   MIMEType - 可以选择的文件的类型（PhotoViewMIMETypes 枚举）
     *     IMAGE_TYPE, VIDEO_TYPE, IMAGE_VIDEO_TYPE, MOVING_PHOTO_IMAGE_TYPE（动态照片，类似苹果的实况照片）
     *   maxSelectNumber - 允许选择的最大的文件数量
     *   maxSelectedReminderMode - 选择的文件的数量超过允许的最大值时的提示方式（ReminderMode	枚举）
     *     NONE - 无提示
     *     TOAST - 弹出 toast 提示
     *     MASK - 灰色遮罩
     *   isSearchSupported - 是否显示搜索框
     *   isPhotoTakingSupported - 是否显示拍照按钮
     *   selectMode - 选择方式（SelectMode 枚举）
     *     SINGLE_SELECT, MULTI_SELECT
     */
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    this.pickerOptions.maxSelectNumber = 3
    this.pickerOptions.maxSelectedReminderMode = ReminderMode.TOAST
    this.pickerOptions.isSearchSupported = true
    this.pickerOptions.isPhotoTakingSupported = true
  }

  // 某个文件被点击后（可能是选中，也可能是取消选中）
  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {

    /*
     * ItemInfo
     *   uri, mimeType, width, height
     *   size - 文件大小（单位：KB）
     *   duration - 视频时长（单位：毫秒）
     *   itemType - 点击了缩略图则为 ItemType.THUMBNAIL，点击了相机按钮则为 ItemType.CAMERA
     * ClickType
     *   SELECTED - 选中操作
     *   DESELECTED - 取消选中操作
     */
    this.message = `onItemClicked uri:${itemInfo.uri}, clickType:${clickType}`

    if (clickType === ClickType.SELECTED) {
      if (itemInfo.uri) {
        this.selectUris.push(itemInfo.uri);
      }
    } else {
      if (itemInfo.uri) {
        this.selectUris = this.selectUris.filter((item: string) => {
          return item != itemInfo.uri;
        })
      }
    }

    // 如果此次是选中操作，那么返回 true 则勾选，返回 false 则不响应
    return true
  }

  // 图片选择器组件准备好后的回调
  private onPickerControllerReady(): void {

  }

  // 进入大图模式时的回调
  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    return true // 允许进入大图模式
  }

  // 离开大图模式时的回调
  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    return true // 允许离开大图模式
  }

  // 大图模式，左右滑动时的回调
  private onPhotoBrowserChanged(browserItemInfo: BaseItemInfo): boolean {
    return true // 允许左右滑动
  }

  // 已选中文件被取消选中后的回调
  private onSelectedItemsDeleted(baseItemInfos: Array<BaseItemInfo>): void {

  }

  // 选中的文件数量超过允许选择的最大的文件数量后，尝试再次选中新的文件时的回调
  private onExceedMaxSelected(exceedMaxCountType: MaxCountType): void {

  }

  // 当前相册被删除时的回调
  private onCurrentAlbumDeleted(): void {

  }

  build() {
    Column({space:10}) {

      Text(this.message)

      Image(this.selectUris[0]).width(20).height(20)

      /*
       * PhotoPickerComponent - 图片选择器组件
       *   pickerOptions - 绑定的 PickerController 对象
       *   pickerOptions - 选项
       *   onPickerControllerReady - 图片选择器组件准备好后的回调
       *   onItemClicked - 某个文件被点击后（可能是选中，也可能是取消选中）
       *   onEnterPhotoBrowser - 进入大图模式时的回调
       *   onExitPhotoBrowser - 离开大图模式时的回调
       *   onPhotoBrowserChanged - 大图模式，左右滑动时的回调
       *   onSelectedItemsDeleted - 已选中文件被取消选中后的回调
       *   onExceedMaxSelected - 选中的文件数量超过允许选择的最大的文件数量后，尝试再次选中新的文件时的回调
       *   onCurrentAlbumDeleted - 当前相册被删除时的回调
       */
      PhotoPickerComponent({
        pickerController: this.pickerController,
        pickerOptions: this.pickerOptions,
        onPickerControllerReady: (): void => this.onPickerControllerReady(),
        onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo, clickType),
        onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => this.onEnterPhotoBrowser(photoBrowserInfo),
        onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => this.onExitPhotoBrowser(photoBrowserInfo),
        onPhotoBrowserChanged: (browserItemInfo: BaseItemInfo): boolean => this.onPhotoBrowserChanged(browserItemInfo),
        onSelectedItemsDeleted: (BaseItemInfo: Array<BaseItemInfo>) => this.onSelectedItemsDeleted(BaseItemInfo),
        onExceedMaxSelected: (exceedMaxCountType: MaxCountType) => this.onExceedMaxSelected(exceedMaxCountType),
        onCurrentAlbumDeleted: () => this.onCurrentAlbumDeleted(),

      }).height('70%')

      Button('显示大图模式').onClick(() => {
        this.pickerController.setPhotoBrowserItem(this.selectUris[0], PhotoBrowserRange.SELECTED_ONLY);
      })

      Button('隐藏大图模式').onClick(() => {
        this.pickerController.exitPhotoBrowser()
      })
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""
  recentPhotoOptions: RecentPhotoOptions = new RecentPhotoOptions();

  aboutToAppear() {
    /*
     * RecentPhotoOptions - 最近保存的图片组件的选项
     *   MIMEType - 文件类型
     *   period - 在 RecentPhotoComponent 中显示的图片，必须是在此时间内保存的（单位：秒，配置为 0 则不限制时间）
     *   photoSource - 图片来源
     *     ALL, CAMERA, SCREENSHOT
     */
    this.recentPhotoOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.recentPhotoOptions.period = 0;
    this.recentPhotoOptions.photoSource = PhotoSource.ALL;
  }

  // 用于告知是否存在最近的资源
  private onRecentPhotoCheckResult(recentPhotoExists: boolean): void {
    this.message += `onRecentPhotoCheckResult recentPhotoExists:${recentPhotoExists}\n`
  }

  // 用于告知最近资源的信息
  private onRecentPhotoCheckInfo(recentPhotoExists: boolean, info: RecentPhotoInfo): void {
    // info.dateTaken - 最近资源的创建时间戳
    this.message += `onRecentPhotoCheckInfo recentPhotoExists:${recentPhotoExists}, dateTaken:${info.dateTaken}\n`
  }

  // 点击后的回调
  private onRecentPhotoClick(recentPhotoInfo: BaseItemInfo): boolean {
    /*
     * BaseItemInfo
     *   uri, mimeType, width, height
     *   size - 文件大小（单位：KB）
     *   duration - 视频时长（单位：毫秒）
     */
    this.message += `onRecentPhotoClick uri:${recentPhotoInfo.uri}\n`
    return true;
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * RecentPhotoComponent - 最近保存的图片组件（用于显示一个最近保存的媒体的缩略图）
       *   recentPhotoOptions - 选项
       *   onRecentPhotoCheckResult - 用于告知是否存在最近的资源
       *   onRecentPhotoCheckInfo - 用于告知最近资源的信息
       *   onRecentPhotoClick - 点击后的回调
       */
      RecentPhotoComponent({
        recentPhotoOptions: this.recentPhotoOptions,
        onRecentPhotoCheckResult: (recentPhotoExists: boolean) => this.onRecentPhotoCheckResult(recentPhotoExists),
        onRecentPhotoCheckInfo: (recentPhotoExists: boolean, info: RecentPhotoInfo) => this.onRecentPhotoCheckInfo(recentPhotoExists, info),
        onRecentPhotoClick: (recentPhotoInfo: BaseItemInfo): boolean => this.onRecentPhotoClick(recentPhotoInfo)
      })
        .height(100).width(100)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  albumOptions: AlbumPickerOptions = new AlbumPickerOptions()
  @State pickerController: PickerController = new PickerController()

  aboutToAppear() {
    /*
     * AlbumPickerOptions - 相册选择器组件的选项
     *   themeColorMode - 深色浅色模式（PickerColorMode 枚举）
     *     AUTO - 跟随系统的深色浅色模式
     *     LIGHT - 浅色模式
     *     DARK - 深色模式
     *   filterType - 过滤类型
     *     IMAGE_TYPE, VIDEO_TYPE, IMAGE_VIDEO_TYPE, MOVING_PHOTO_IMAGE_TYPE（动态照片，类似苹果的实况照片）
     */
    this.albumOptions.themeColorMode = PickerColorMode.AUTO
    this.albumOptions.filterType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
  }

  // 选择某个相册后的回调
  private onAlbumClick(albumInfo: AlbumInfo): boolean {
    /*
     * AlbumInfo
     *   uri - 相册地址
     *   albumName - 相册名称
     */
    if (albumInfo?.uri) {
      this.message = `onAlbumClick ${albumInfo.uri}`
      // pickerController.setData() - 根据用户选择的相册，更新图片选择器组件中的显示内容
      this.pickerController.setData(DataType.SET_ALBUM_URI, albumInfo.uri)
    }
    return true
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * AlbumPickerComponent - 相册选择器组件
       *   albumPickerOptions - 选项
       *   onAlbumClick - 选择某个相册后的回调
       *   onEmptyAreaClick - 点击组件内空白区域时的回调
       */
      AlbumPickerComponent({
        albumPickerOptions: this.albumOptions,
        onAlbumClick: (albumInfo: AlbumInfo): boolean => this.onAlbumClick(albumInfo),
        onEmptyAreaClick: () => {
          this.message = `onEmptyAreaClick`
        },
      }).height('40%')

      /*
       * PhotoPickerComponent - 图片选择器组件
       *   pickerOptions - 绑定的 PickerController 对象
       */
      PhotoPickerComponent({
        pickerController: this.pickerController
      }).height('40%')
    }
  }
}