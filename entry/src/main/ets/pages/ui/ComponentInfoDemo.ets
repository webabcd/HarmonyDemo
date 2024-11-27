/*
 * 获取组件的尺寸和位置
 */

import { TitleBar } from '../TitleBar'
import { componentUtils } from '@kit.ArkUI'

@Entry
@Component
struct ComponentInfoDemo {

  @State message: string = ""

  build() {
    Column() {
      TitleBar()

      Stack() {
        Stack()
          .width(100).height(50).backgroundColor(Color.Green)
          /*
           * id() - 设置组件的 id
           */
          .id("myComponent")
      }
      .width(200).height(100).backgroundColor(Color.Red)

      Button('button')
        .margin({ top: 20 })
        .onClick((event) => {
          /*
           * componentUtils.getRectangleById() - 根据 id 获取指定的组件占用的矩形区域的尺寸和位置
           *   size - 宽和高（单位 px）
           *   localOffset - 相对于父组件的偏移量（单位 px）
           *   windowOffset - 相对于窗口的偏移量（单位 px）
           *     比如手机时，如果 app 显示在悬浮框中，这个悬浮框就是一个窗口
           *     比如桌面时，不同 app 会显示在不同的窗口中
           *   screenOffset - 相对于屏幕的偏移量（单位 px）
           *   translate, rotate, scale, transform - 变换的相关信息（参见 /shape/TransformDemo.ets 中的说明）
           *
           * 注：此方式 Previewer 不支持，需要用模拟器或真机测试
           */
          let info: componentUtils.ComponentInfo = componentUtils.getRectangleById('myComponent');

          let context = this.getUIContext()
          this.message = `info: ${JSON.stringify(info)}\n`

          this.message += `size width:${context.px2vp(info.size.width).toFixed(0)}, height:${context.px2vp(info.size.height).toFixed(0)}\n`
          this.message += `localOffset x:${context.px2vp(info.localOffset.x).toFixed(0)}, y:${context.px2vp(info.localOffset.y).toFixed(0)}\n`
          this.message += `windowOffset x:${context.px2vp(info.windowOffset.x).toFixed(0)}, y:${context.px2vp(info.windowOffset.y).toFixed(0)}\n`
          this.message += `screenOffset x:${context.px2vp(info.screenOffset.x).toFixed(0)}, y:${context.px2vp(info.screenOffset.y).toFixed(0)}\n`

          this.message += `translate  ${JSON.stringify(info.translate)}\n`
          this.message += `rotate  ${JSON.stringify(info.rotate)}\n`
          this.message += `scale  ${JSON.stringify(info.scale)}\n`
          this.message += `transform  ${JSON.stringify(info.transform)}\n`
        })

      Text(this.message)
        .margin({ top: 20 })
    }
    .height('100%')
    .backgroundColor(Color.Orange)
  }
}