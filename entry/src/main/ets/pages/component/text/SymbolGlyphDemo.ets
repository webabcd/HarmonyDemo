/*
 * SymbolGlyph - 图标符号
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct SymbolGlyphDemo {

  @State triggerValue: number = 0;
  @State flag: boolean = true;
  aboutToAppear() {
    setInterval(() => {
      this.flag = !this.flag;
      this.triggerValue = this.triggerValue + 1;
    }, 5000);
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * SymbolGlyph() - 图标符号
       *   value - 指定一个系统内置的图标资源
       *   fontWeight() - 图标的粗细
       *   fontSize() - 图标的大小
       *   fontColor() - 图标的颜色
       *   effectStrategy() - 图标初次显示时的动画效果
       *     NONE - 无效果
       *     SCALE - 缩放动画效果
       *     HIERARCHICAL - 层级渐变动画效果
       *   symbolEffect() - 图标的动画效果
       *     symbolEffect - 效果对象
       *       HierarchicalSymbolEffect() - 层级渐变动画效果
       *       ReplaceSymbolEffect() - 图标发生变化时的动画效果
       *     isActive - 是否启用效果
       *     triggerValue - 一个 number 值，当此值发生变化时触发效果
       */

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontWeight(FontWeight.Normal)
        .fontSize(100)

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(100)
        .fontColor([Color.Orange])

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(100)
        .effectStrategy(SymbolEffectStrategy.SCALE)

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(100)
        .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(100)
        .symbolEffect(
          new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE),
          true
        )

      SymbolGlyph(this.flag ? $r('sys.symbol.ohos_wifi') : $r('sys.symbol.ohos_star'))
        .fontSize(100)
        .symbolEffect(
          new ReplaceSymbolEffect(EffectScope.WHOLE),
          this.triggerValue
        )
    }
  }
}