/*
 * 本例用于演示元服务（atomic service）
 *
 * 元服务的创建：
 * 先在 AGC 上的“证书、APP ID和Profile”的“APP ID”中新建一个 APP ID
 * 然后再在 DevEco Studio 中创建 atomic service 项目，创建的过程中需要将当前的 atomic service 项目绑定到 AGC 上的 APP ID
 * 如果需要手动配置的话，则在 AppScope/app.json5 中做类似如下的配置
 * {
 *   "app": {
 *     "bundleName": "com.atomicservice.6917572560037685495", // 在 AGC 上的“证书、APP ID和Profile”的“APP ID”中创建的包名
 *     "bundleType": "atomicService", // 元服务
 *   }
 * }
 *
 * 元服务的特性：
 * 元服务免安装，自动更新
 * 元服务是跟随华为账号的
 * 元服务无法使用一些 api，比如 import { displaySync } from '@kit.ArkGraphics2D'; 等
 * 元服务不支持 feature 类型的模块
 * 元服务支持分包，将 entry 类型的 hap 作为首包，其他 hsp 作为分包，只需下载和安装首包后即可立即启动元服务
 * 元服务的单个包的大小不能超过 2MB，所有包的总大小不能超过 10MB
 *
 * 注：
 * 1、如果要在元服务中使用账号系统，则在你的多种登录方式中必须要包含华为账号登录的方式（这是元服务的一个审核要求）
 * 2、可以为元服务开发卡片
 * 3、可以通过负一屏搜索并打开指定的元服务，也可以通过元服务的卡片打开元服务（点击元服务右上角的按钮，可以找到生成卡片的入口）
 * 4、元服务的图标有特殊要求，可以通过 DevEco Studio -> File -> New -> Image Asset 生成符合标准的元服务图标
 */
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {

  build() {
    Column({space:10}) {
      Text('atomic service')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}