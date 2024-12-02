/*
 * SymbolGlyph, SymbolGlyphModifier - 图标符号
 */

import { TitleBar } from '../../TitleBar'
import { Chip, SymbolGlyphModifier } from '@kit.ArkUI';

@Entry
@Component
struct SymbolGlyphDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('aaa').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('bbb').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({ space: 10 }) {

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
       *
       * SymbolGlyphModifier() - 图标符号
       *   其他 UI 组件如果需要使用图标符号，一般会通过 SymbolGlyphModifier 实现
       */

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontWeight(FontWeight.Normal)
        .fontSize(80)

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        .fontColor([Color.Orange])

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        .effectStrategy(SymbolEffectStrategy.SCALE)

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)

      Chip({
        label: { text: 'label' },
        size: { width: 200, height:50 },
        allowClose: false,
        prefixSymbol: {
          normal: new SymbolGlyphModifier($r('sys.symbol.ohos_wifi'))
            .fontSize(24).fontColor([Color.Orange])
        },
      })
    }
  }
}

@Component
struct MySample2 {

  @State triggerValue: number = 0;
  @State flag: boolean = true;
  aboutToAppear() {
    setInterval(() => {
      this.flag = !this.flag;
      this.triggerValue = this.triggerValue + 1;
    }, 2000);
  }

  build() {
    Column({ space: 10 }) {
      /*
       * SymbolGlyph() - 图标符号
       *   symbolEffect() - 图标的动画效果
       *     symbolEffect - 效果对象
       *       HierarchicalSymbolEffect() - 层级渐变动画效果
       *       ScaleSymbolEffect() - 缩放动画效果
       *       BounceSymbolEffect() - 缩放且回弹的动画效果
       *       ReplaceSymbolEffect() - 图标变化时的动画效果
       *     isActive - 是否启用效果
       *     triggerValue - 一个 number 值，当此值发生变化时触发效果
       */

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        // 无限循环的层级渐变动画效果
        .symbolEffect(
          new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE),
          true
        )

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        .symbolEffect(
          // 当 triggerValue 发生变化时，会触发层级渐变动画效果
          new HierarchicalSymbolEffect(EffectFillStyle.CUMULATIVE),
          this.triggerValue
        )

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        .symbolEffect(
          new ScaleSymbolEffect(),
          this.triggerValue
        )

      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(80)
        .symbolEffect(
          new BounceSymbolEffect(),
          this.triggerValue
        )

      SymbolGlyph(this.flag ? $r('sys.symbol.ohos_wifi') : $r('sys.symbol.ohos_star'))
        .fontSize(80)
        .symbolEffect(
          new ReplaceSymbolEffect(),
          this.triggerValue
        )
    }
  }
}