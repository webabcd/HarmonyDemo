/*
 * ContainerSpan - Text 的容器子组件（其内可声明多个 Span, ImageSpan）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct ContainerSpanDemo {
  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * textBackgroundStyle() - ContainerSpan 的背景样式（一个 TextBackgroundStyle 对象）
       *   color - 背景颜色
       *   radius - 背景的圆角半径
       */

      Text() {
        ContainerSpan() {
          ImageSpan($r('app.media.app_icon'))
            .width(50)
            .height(50)
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('hello').fontSize(24).fontColor(Color.White)
        }
        .textBackgroundStyle({
          color: Color.Orange,
          radius: 5
        })

        ContainerSpan() {
          ImageSpan($r('app.media.app_icon'))
            .width(50)
            .height(50)
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('webabcd').fontSize(24).fontColor(Color.White)
        }
        .textBackgroundStyle({
          color: Color.Orange,
          radius: 5
        })
      }
      .width('100%')
      .height(100)
      .backgroundColor(Color.Red)
    }
  }
}