/*
 * SymbolSpan - Text 的图标符号子组件
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct SymbolSpanDemo {
  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text() {
        Span('span').fontSize(32)

        /*
         * SymbolSpan - Text 的图标符号子组件
         *   value - 指定一个系统内置的图标资源
         *   fontWeight() - 图标的粗细
         *   fontSize() - 图标的大小
         *   fontColor() - 图标的颜色
         *   effectStrategy() - 图标初次显示时的动画效果
         *     NONE - 无效果
         *     SCALE - 缩放动画效果
         *     HIERARCHICAL - 层级渐变动画效果
         */

        SymbolSpan($r('sys.symbol.ohos_wifi'))
          .fontWeight(FontWeight.Normal)
          .fontSize(100)

        SymbolSpan($r('sys.symbol.ohos_wifi'))
          .fontSize(100)
          .fontColor([Color.Orange])

        SymbolSpan($r('sys.symbol.ohos_wifi'))
          .fontSize(100)
          .effectStrategy(SymbolEffectStrategy.SCALE)

        SymbolSpan($r('sys.symbol.ohos_wifi'))
          .fontSize(100)
          .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
      }
    }
  }
}