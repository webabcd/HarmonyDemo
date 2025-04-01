/*
 * 保存文件到媒体库
 */

import { TitleBar } from '../TitleBar'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { common } from '@kit.AbilityKit'
import { fileIo as fs } from '@kit.CoreFileKit';

@Entry
@Component
struct MediaLibraryDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('通过 SaveButton 保存文件到媒体库').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过弹窗授权保存文件到媒体库').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

// 将指定的资源文件保存到指定的沙箱目录
async function copyFile(src: Resource, dst: string) {
  let context = getContext() as common.UIAbilityContext;
  let resourceManager = context.resourceManager
  let buffer = resourceManager.getMediaContentSync(src.id).buffer
  let outputStream = await fs.createStream(dst, 'w+');
  let writeLength = await outputStream.write(buffer, {
    offset: 0,
    length: buffer.byteLength
  })
  await outputStream.close();
}

@Component
struct MySample1 {

  @State message: string = ""
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * SaveButton - 保存按钮（是一种安全控件，第一次使用会弹出授权框，用户授权后，后续再次使用则不会再弹出授权框）
       *   保存按钮的作用是临时获取存储权限
       *   自定义保存按钮的样式和位置时，要保证其可以清晰可见，且用户能够明确识别
       *   第一次单击某个保存按钮并弹出授权框后，如果用户允许授权，则之后再点击此按钮就会默认授权成功，不会再弹出授权框了
       *   点击保存按钮后，如果判断授权成功，则会授予临时的存储权限，此权限 10 秒内有效
       *
       *   icon - 按钮的文字左侧的图标的风格，不指定则代表没有图标
       *   text - 按钮的文字（SaveDescription 枚举，也就是说保存按钮的文字只能显示枚举中包括的值），不指定则代表没有文字
       *     DOWNLOAD - 下载
       *     DOWNLOAD_FILE - 下载文件
       *     SAVE - 保存
       *     SAVE_IMAGE - 保存图片
       *     SAVE_FILE - 保存文件
       *     DOWNLOAD_AND_SHARE - 下载分享
       *     RECEIVE - 接收
       *     CONTINUE_TO_RECEIVE - 继续接收
       *     SAVE_TO_GALLERY - 保存至图库
       *     EXPORT_TO_GALLERY - 导出
       *     QUICK_SAVE_TO_GALLERY - 快速保存图片
       *     RESAVE_TO_GALLERY - 重新保存
       *   buttonType - 按钮类型（ButtonType 枚举）
       *     Normal - 普通
       *     Circle - 圆形
       *     Capsule - 胶囊（圆角矩形）
       *
       *   backgroundColor(), fontColor(), fontSize(), fontWeight(), iconColor(), iconSize() - 按钮的背景颜色，字体颜色，字体大小，字体粗细，图标颜色，图标大小
       *   onClick() - 回调，第 2 个回调参数是一个 SaveButtonOnClickResult 枚举（SUCCESS - 临时获取存储权限成功；TEMPORARY_AUTHORIZATION_FAILED - 临时获取存储权限失败）
       *     用户点击保存按钮后，如果之间没有授权成功，则弹出授权框，如果用户点击了允许则回调，如果用户点击了取消则不回调
       *     用户点击保存按钮后，如果之前已经授权成功（之前如果通过此按钮授权成功一次，则后续再次点击此按钮时就认为已经授权了，不会再弹出授权框），则回调
       *
       *
       * photoAccessHelper.getPhotoAccessHelper() - 获取 PhotoAccessHelper 对象
       * PhotoAccessHelper - 访问媒体库的帮助对象
       *   MediaAssetChangeRequest.createImageAssetRequest() - 创建一个保存指定文件到媒体库的请求，返回一个 MediaAssetChangeRequest 对象
       *     context - 上下文
       *     fileUri - 需要保存到媒体库的文件的沙箱路径
       *   applyChanges() - 提交指定的 MediaAssetChangeRequest 请求
       *   getAsset().uri - 获取保存到媒体库后的文件的地址
       */
      SaveButton( {
        icon: SaveIconStyle.FULL_FILLED,
        text: SaveDescription.SAVE_TO_GALLERY,
        buttonType: ButtonType.Capsule
      })
        .backgroundColor(Color.Blue)
        .fontColor(Color.Orange)
        .fontSize(24)
        .fontWeight(600)
        .iconColor(Color.Orange)
        .iconSize(24)
        .onClick(async (event, result: SaveButtonOnClickResult) => {

          if (result == SaveButtonOnClickResult.SUCCESS) { // 拿到了临时的存储权限，此权限 10 秒内有效

            let imagePath = this.context.filesDir + '/abc.jpg'

            // 将指定的资源文件保存到指定的沙箱目录
            try {
              await copyFile($r('app.media.son'), imagePath)
            } catch (error) {
              this.message = `将指定的资源文件保存到指定的沙箱目录时失败：${JSON.stringify(error)}`
            }

            // 保存沙箱文件到相册
            try {
              let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
              let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(this.context, imagePath);
              await phAccessHelper.applyChanges(assetChangeRequest);
              this.message = `保存沙箱文件到相册成功，保存到相册后的文件的地址：${assetChangeRequest.getAsset().uri}`
            } catch (err) {
              this.message = `保存沙箱文件到相册失败 errCode:${err.code}, errMessage:${err.message}`
            }

          } else {
            this.message = "临时获取存储权限失败"
          }
        })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""
  context = getContext(this) as common.UIAbilityContext

  // 用于保存有权限写入数据的媒体库的文件的地址
  mediaLibraryFileUris: Array<string> = []

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * photoAccessHelper.getPhotoAccessHelper() - 获取 PhotoAccessHelper 对象
       * PhotoAccessHelper - 访问媒体库的帮助对象
       *   showAssetsCreationDialog() - 弹出保存文件到媒体库的授权框
       *     srcFileUris - 需要保存到媒体库的文件的地址的数组
       *     photoCreationConfigs - 相关配置数组（一个 PhotoCreationConfig 对象数组），要与 srcFileUris 一一对应
       *       fileNameExtension - 文件扩展名
       *       photoType - 文件类型（PhotoType.IMAGE 或 PhotoType.VIDEO）
       *   如果用户允许授权，则返回值为媒体库的文件的地址数组，程序可以向这些地址中写入数据，并且当前 app 永久拥有媒体库中的这些地址的权限
       */
      Button("通过弹窗授权保存文件到媒体库").onClick(async () => {

        let imagePath = this.context.filesDir + '/abc.jpg'

        // 将指定的资源文件保存到指定的沙箱目录
        try {
          await copyFile($r('app.media.son'), imagePath)
        } catch (error) {
          this.message = `将指定的资源文件保存到指定的沙箱目录时失败：${JSON.stringify(error)}`
        }

        try {
          let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context)
          let srcFileUris: Array<string> = [
            imagePath
          ];
          let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [
            {
              fileNameExtension: 'jpg',
              photoType: photoAccessHelper.PhotoType.IMAGE,
            }
          ];

          // 弹出保存文件到媒体库的授权框
          // 如果用户允许授权，则返回值为媒体库的文件的地址数组，程序可以向这些地址中写入数据，并且当前 app 永久拥有媒体库中的这些地址的权限
          let dstFileUris: Array<string> = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs)
          this.mediaLibraryFileUris.push(...dstFileUris)
          this.message = `允许写入数据的媒体库的文件的地址：${dstFileUris.join(',')}\n`

          // 保存文件到媒体库
          let srcFile: fs.File = await fs.open(imagePath, fs.OpenMode.READ_ONLY);
          let dstFile: fs.File = await fs.open(dstFileUris[0], fs.OpenMode.WRITE_ONLY);
          await fs.copyFile(srcFile.fd, dstFile.fd);
          fs.closeSync(srcFile);
          fs.closeSync(dstFile);

          this.message += `保存指定地址的文件到相册成功`
        } catch (err) {
          // 用户禁止授权则会走到这里
          this.message += `保存指定地址的文件到相册失败 errCode:${err.code}, errMessage:${err.message}`
        }
      })

      // 先执行几遍上面的那个按钮，然后再执行这个按钮，以便理解
      Button("向媒体库中已有权限的地址写入数据").onClick(async () => {

        let imagePath = this.context.filesDir + '/xyz.jpg'
        // 将指定的资源文件保存到指定的沙箱目录
        try {
          await copyFile($r('app.media.app_icon'), imagePath)
        } catch (error) {
          this.message = `将指定的资源文件保存到指定的沙箱目录时失败：${JSON.stringify(error)}`
        }

        // 向媒体库中已有权限的地址写入数据
        this.mediaLibraryFileUris.forEach(async (item) => {
          let srcFile: fs.File = await fs.open(imagePath, fs.OpenMode.READ_ONLY);
          let dstFile: fs.File = await fs.open(item, fs.OpenMode.WRITE_ONLY);
          await fs.copyFile(srcFile.fd, dstFile.fd);
          fs.closeSync(srcFile);
          fs.closeSync(dstFile);
        })

        this.message += `向媒体库中已有权限的地址写入数据成功`
      })
    }
  }
}
