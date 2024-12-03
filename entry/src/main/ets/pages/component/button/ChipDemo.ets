/*
 * Chip - 带文字和图标的支持双状态的按钮
 */

import { TitleBar } from '../../TitleBar';
import { Chip, ChipSize, SymbolGlyphModifier } from '@kit.ArkUI';

@Entry
@Component
struct ChipDemo {

  @State message: string = ""
  @State isActivated: boolean = false

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * Chip - 带文字和图标的支持双状态的按钮
       *   size - 尺寸
       *     ChipSize.SMALL 或 ChipSize.NORMAL 或指定一个具体的尺寸（width 和 height）
       *   direction - 布局方向（Direction 枚举）
       *     Auto - 使用系统的默认布局方向
       *     Ltr - 从左到右布局
       *     Rtl - 从右到左布局
       *   borderRadius - 圆角半径
       *   enabled - 是否可用
       *   allowClose - 是否显示关闭按钮（点击此按钮后，会移除当前 Chip 组件）
       *   label - 按钮文字
       *     text - 文字内容
       *     fontSize, fontColor, fontFamily - 字体样式
       *     labelMargin - 文字与左右侧图标的间距
       *       left, right
       *     activatedFontColor - 激活状态时的颜色
       *   prefixIcon, suffixIcon - 文字的左侧图标和右侧图标
       *     src - 图标地址
       *     size - 尺寸（width 和 height）
       *     fillColor - 填充色
       *     activatedFontColor - 激活状态时的颜色
       *   prefixSymbol, suffixSymbol - 文字的左侧符号图标和右侧符号图标
       *     normal - 普通状态的符号图标
       *     activated - 激活状态的符号图标
       *   activated - 是否是激活状态
       *   backgroundColor - 普通状态的背景颜色
       *   activatedBackgroundColor - 激活状态的背景颜色
       *   onClose - 点击关闭按钮后的回调
       *   onClicked - 点击 Chip 组件时的回调
       */

      Chip({
        size: ChipSize.SMALL,
        direction: Direction.Auto,
        label: {
          text: "label",
        },
        enabled: true,
        allowClose: true,
        onClose:() => {
          this.message = "onClose()"
        },
        onClicked:() => {
          this.message = "onClicked()"
        },
      })

      Chip({
        allowClose: false,
        size: ChipSize.NORMAL,
        label: {
          text: "label",
          fontSize: 12,
          fontColor: Color.Red,
          fontFamily: "HarmonyOS Sans",
          labelMargin: { left: 20, right: 30 },
          activatedFontColor: Color.White
        },
        prefixIcon: {
          src: $r('app.media.app_icon'),
          size: { width: 16, height: 16 },
          fillColor: Color.Red,
          activatedFillColor: Color.White,
        },
        suffixIcon: {
          src: $r('app.media.ic_settings'),
          size: { width: 16, height: 16 },
          fillColor: Color.Red,
          activatedFillColor: Color.White,
        },
        activated: this.isActivated,
        backgroundColor: Color.Orange,
        activatedBackgroundColor: Color.Blue,
        onClicked:() => {
          this.isActivated = !this.isActivated
        }
      })

      Chip({
        allowClose: false,
        size: {
          width: 200,
          height: 50
        },
        label: {
          text: "label",
          fontSize: 12,
          fontColor: Color.Blue,
          fontFamily: "HarmonyOS Sans",
          labelMargin: { left: 16, right: 16 }
        },
        prefixSymbol: {
          normal: new SymbolGlyphModifier($r('sys.symbol.ohos_star'))
            .fontSize(16).fontColor([Color.Red]),
          activated: new SymbolGlyphModifier($r('sys.symbol.ohos_star'))
            .fontSize(16).fontColor([Color.White]),
        },
        suffixSymbol: {
          normal: new SymbolGlyphModifier($r('sys.symbol.ohos_trash'))
            .fontSize(16).fontColor([Color.Red]),
          activated: new SymbolGlyphModifier($r('sys.symbol.ohos_trash'))
            .fontSize(16).fontColor([Color.White]),
        },
        activated: this.isActivated,
        backgroundColor: Color.Orange,
        activatedBackgroundColor: Color.Blue,
        onClicked:() => {
          this.isActivated = !this.isActivated
        }
      })
    }
  }
}