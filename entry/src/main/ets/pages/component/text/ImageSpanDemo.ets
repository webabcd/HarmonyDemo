/*
 * ImageSpan - Text 的图片子组件（也可作为 ContainerSpan 的子组件）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct ImageSpanDemo {
  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * verticalAlign() - 图片基于当前行高的对齐方式（ImageSpanAlignment 枚举）
       *   BASELINE, BOTTOM, CENTER, TOP
       * objectFit() - 拉伸方式（参见 /component/media/ImageDemo.ets 中的相关说明）
       * textBackgroundStyle() - 图片的背景样式（一个 TextBackgroundStyle 对象）
       *   color - 背景颜色
       *   radius - 背景的圆角半径
       */

      Text() {
        ImageSpan($r('app.media.app_icon'))
          .width(50)
          .height(50)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
        Span('aXq').fontSize(25)
      }
      .width('100%')
      .height(100)
      .backgroundColor(Color.Orange)

      Text() {
        ImageSpan($r('app.media.app_icon'))
          .width(50)
          .height(50)
          .verticalAlign(ImageSpanAlignment.BOTTOM)
        Span('aXq').fontSize(25)
      }
      .width('100%')
      .height(100)
      .backgroundColor(Color.Orange)

      Text() {
        ImageSpan($r('app.media.app_icon'))
          .width(50)
          .height(50)
          .verticalAlign(ImageSpanAlignment.BASELINE)
        Span('aXq').fontSize(25)
      }
      .width('100%')
      .height(100)
      .backgroundColor(Color.Orange)

      Text() {
        ImageSpan($r('app.media.app_icon'))
          .width(200)
          .height(100)
          .objectFit(ImageFit.Contain)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .textBackgroundStyle({
            color: Color.Red,
            radius: 5}
          )
      }
    }
  }
}