/*
 * Span - Text 的文本子组件（也可作为 ContainerSpan 的子组件）
 *   会自动继承父 Text 组件的 fontColor, fontSize, fontStyle, fontWeight, decoration, letterSpacing, textCase, fontFamily, textShadow 等属性
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct SpanDemo {
  build() {
    Column({ space: 10 }) {
      TitleBar()

      Column() {
        Text("如果在 Text 中设置了 Span 之类的子组件，则这里的文本是不会被显示的") {
          Span('hello').fontSize(32)

          /*
           * textBackgroundStyle() - 文本的背景样式（一个 TextBackgroundStyle 对象）
           *   color - 背景颜色
           *   radius - 背景的圆角半径
           */
          Span('webabcd').fontSize(32)
            .textBackgroundStyle({
              color: Color.Blue,
              radius: 15
            })
        }
        .fontColor(Color.White)
      }
      .width(300)
      .height(100)
      .backgroundColor(Color.Orange)
    }
  }
}