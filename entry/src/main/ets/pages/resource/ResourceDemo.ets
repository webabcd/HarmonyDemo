/*
 * 资源
 *
 *
 * 下面以 module 级的资源为例做说明
 * src/main/resources/base/ - 默认资源目录（此内的文件会被编译且赋予资源文件 ID）
 *   element - 用于存放字符串，整型，颜色值等（不支持子目录）
 *   media - 用于存放媒体数据（不支持子目录）
 *   profile - 用于存放配置数据（不支持子目录）
 * 限定词（qualifiers）目录（此内的文件会被编译且赋予资源文件 ID），如果匹配不到限定词目录则使用默认资源目录
 *   src/main/resources/zh_CN/ - 中文资源
 *   src/main/resources/vertical-xxxldpi/ - 竖屏且屏幕密度为 xxxldpi 时的资源
 *   src/main/resources/zh_CN-vertical-car-dark-mdpi/ - 限定词可以省略，但是不能改变顺序
 *     语言：参见 InternationalizationDemo.ets 中的说明
 *     横竖屏：vertical, horizontal
 *     设备类型：car, tablet, tv, wearable
 *     颜色模式：dark, light
 *     屏幕密度：sdpi, mdpi, ldpi, xldpi, xxldpi, xxxldpi
 * src/main/resources/rawfile/ - 此内的文件会被直接打进包中，不会被编译（支持子目录）
 * src/main/resources/resfile/ - 此内的文件会被直接打进包中，不会被编译，第一次安装后会被复制到应用的沙箱路径中（支持子目录）
 *   注：可以通过 context.resourceDir 获取 resfile 对应的沙箱目录
 *
 *
 * 注：
 * app 级的资源在 AppScope 目录内，目录结构与 module 级的资源一致，编译后 AppScope 的资源会合并到 module 的资源中，对于重名资源来说只会保留 AppScope 中的资源
 * 另外 AppScope 中的 app.json5 中的字段也会在编译后合并到 module 的 module.json5 中
 */

import { TitleBar } from '../TitleBar'
import { fileIo } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'
import { util } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'
import { display } from '@kit.ArkUI'

@Entry
@Component
struct ResourceDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('图片').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('文件').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  context = getContext(this) as common.UIAbilityContext;

  @State message: string = "";
  @State pixelMap: PixelMap | undefined = undefined;

  async aboutToAppear() {

    // sdpi - dpi 在 0 - 120（左开右闭）
    // mdpi - dpi 在 120 - 160（左开右闭）
    // ldpi - dpi 在 160 - 240（左开右闭）
    // xldpi - dpi 在 240 - 320（左开右闭）
    // xxldpi - dpi 在 320 - 480（左开右闭）
    // xxxldpi - dpi 在 480 - 640（左开右闭）
    this.message += `dpi: ${display.getDefaultDisplaySync().densityDPI}\n`

    // 创建资源管理对象，用于获取 src/main/resources/base/ 或 src/main/resources/限定词/ 中的数据
    let resourceManager = this.context.resourceManager
    // 获取资源中的字符串数据，建议保存在 element/string.json 中（虽然不限制文件名，但还是建议用 string.json）
    let a = resourceManager.getStringSync($r('app.string.hello_webabcd').id)
    // 获取资源中的布尔型数据，建议保存在 element/boolean.json 中
    let b = resourceManager.getBoolean($r('app.boolean.my_boolean').id)
    // 获取资源中的颜色值数据，建议保存在 element/color.json 中
    let c = resourceManager.getColorSync($r('app.color.color_demo').id).toString(16)
    // 获取资源中的浮点型数据，建议保存在 element/float.json 中
    let d = resourceManager.getNumber($r('app.float.my_float').id)
    // 获取资源中的整型数据，建议保存在 element/integer.json 中
    let e = resourceManager.getNumber($r('app.integer.200').id)
    // 获取资源中的字符串数组数据，建议保存在 element/strarray.json 中
    let f = resourceManager.getStringArrayValueSync($r('app.strarray.my_strarray').id)

    this.message += `string: ${a}\n`
    this.message += `boolean: ${b}\n`
    this.message += `color: ${c}\n`
    this.message += `float: ${d}\n`
    this.message += `integer: ${e}\n`
    this.message += `strarray: ${f.join(",")}\n`

    let configuration = await resourceManager.getConfiguration()
    // 获取当前的区域信息
    this.message += `locale: ${configuration.locale}\n`
    // 获取当前的屏幕方向（Direction 枚举）
    // DIRECTION_VERTICAL, DIRECTION_HORIZONTAL
    this.message += `direction: ${configuration.direction}\n`
    // 获取当前的设备类型（DeviceType 枚举）
    // DEVICE_TYPE_PHONE, DEVICE_TYPE_TABLET, DEVICE_TYPE_CAR, DEVICE_TYPE_PC, DEVICE_TYPE_TV, DEVICE_TYPE_WEARABLE, DEVICE_TYPE_2IN1
    this.message += `deviceType: ${configuration.deviceType}\n`
    // 获取当前的颜色模式（ColorMode 枚举）
    // DARK, LIGHT
    this.message += `colorMode: ${configuration.colorMode}\n`
  }

  build() {
    Column({space:10}) {

      // $r() - 直接引用资源中的数据（返回的是一个 Resource 对象）
      Text($r('app.string.hello_webabcd')).fontColor($r('app.color.color_demo'))

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  context = getContext(this) as common.UIAbilityContext;

  @State pixelMap: PixelMap | undefined = undefined;

  async aboutToAppear() {

    // 创建资源管理对象，用于获取 src/main/resources/base/ 或 src/main/resources/限定词/ 中的数据
    let resourceManager = this.context.resourceManager
    // 图片资源转 PixelMap 对象
    let g = resourceManager.getMediaContentSync($r('app.media.son').id)
    this.pixelMap = await this.getPixmap(g)
  }

  // 图片 Uint8Array 对象转 PixelMap 对象
  async getPixmap(uint8Array: Uint8Array): Promise<image.PixelMap> {
    let imageSource = image.createImageSource(uint8Array.buffer)
    let pixelMap: image.PixelMap = await imageSource.createPixelMap({
      // RGBA_8888 的意思是 r 占用 8 位，g 占用 8 位，b 占用 8 位，a 占用 8 位
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    })
    await imageSource.release()
    return pixelMap
  }

  build() {
    Column({space:10}) {

      // $r() - 直接引用资源中的数据（返回的是一个 Resource 对象）
      Image($r('app.media.son')).width(100).height(100)

      // 显示一个 PixelMap 对象
      Image(this.pixelMap).width(100).height(100)

      // 引用应用级的资源，来自 /AppScope/resources/base/media/app_icon.png
      Image($r('app.media.app_icon')).width(100).height(100)
    }
  }
}

@Component
struct MySample3 {

  context = getContext(this) as common.UIAbilityContext;

  @State message: string = "";
  @State imagePath: string = "";

  // 将指定的资源文件复制到指定的沙箱目录
  async copyFile(src: Resource, dst: string) {
    let context = getContext() as common.UIAbilityContext;
    let resourceManager = context.resourceManager
    let buffer = resourceManager.getMediaContentSync(src.id).buffer
    let outputStream = await fileIo.createStream(dst, 'w+');
    let writeLength = await outputStream.write(buffer, {
      offset: 0,
      length: buffer.byteLength
    })
    await outputStream.close();
  }

  async aboutToAppear() {

    // 读取 src/main/resources/rawfile/mytext.txt 文件（从对应的包内路径获取数据）
    const rawFile = await this.context.resourceManager.getRawFileContent("mytext.txt")
    const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const rawFileContent = textDecoder.decodeToString(rawFile, { stream: false })
    this.message += `rawfile/mytext: ${rawFileContent}\n`

    // 读取 src/main/resources/resfile/mytext.txt 文件（从对应的沙箱路径获取数据）
    const resFileContent = await fileIo.readText(this.context.resourceDir + "/mytext.txt", { encoding: 'utf-8' })
    this.message += `resfile/mytext: ${resFileContent}\n`

    // 将指定的资源文件复制到指定的沙箱目录
    try {
      let imagePath = this.context.filesDir + '/ResourceDemo.jpg'
      await this.copyFile($r('app.media.son'), imagePath)
    } catch (error) {
      this.message = `将指定的资源文件复制到指定的沙箱目录时失败：${JSON.stringify(error)}`
    }
  }

  build() {
    Column({space:10}) {

      // 显示沙箱目录中的图片文件
      Image(`file://${getContext().filesDir + "/ResourceDemo.jpg"}`)
        .width(50).height(50)

      Text(this.message)
    }
  }
}
