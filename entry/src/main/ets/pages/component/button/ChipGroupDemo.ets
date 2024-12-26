/*
 * ChipGroup - Chip 组
 */

import { TitleBar } from '../../TitleBar';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { ChipSize, ChipGroup, IconGroupSuffix } from '@kit.ArkUI'

@Entry
@Component
struct ChipGroupDemo {

  @State message: string = "";

  // 自定义整个 chip 组的最右侧的内容
  @LocalBuilder ChipGroupSuffix(): void {
    IconGroupSuffix({
      items: [
        {
          icon: {
            src: $r('app.media.app_icon'),
            size: {
              width: 24,
              height: 24
            }
          },
          action: () => {
            this.message = "ChipGroupSuffix clicked"
          }
        }
      ]
    })
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * ChipGroup - Chip 组
       *   items - 组中的 Chip 集合（ChipGroupItemOptions 对象集合）
       *     prefixIcon, suffixIcon - 文字的左侧图标和右侧图标
       *       src - 图标地址
       *       size - 尺寸（width 和 height）
       *     prefixSymbol, suffixSymbol - 文字的左侧符号图标和右侧符号图标
       *       normal - 普通状态的符号图标
       *       activated - 激活状态的符号图标
       *     allowClose - 是否显示关闭按钮（点击此按钮后，会移除当前 Chip 组件）
       *     label - 按钮文字
       *       text - 文字内容
       *   itemStyle - 组中每个 Chip 的样式
       *     size - 尺寸
       *     backgroundColor - 普通状态的背景颜色
       *     fontColor - 普通状态的文字颜色
       *     selectedBackgroundColor - 激活状态的背景颜色
       *     selectedFontColor - 激活状态的文字颜色
       *   multiple - 是否支持多选
       *   selectedIndexes - 激活状态的 chip 的索引位置的集合
       *   chipGroupSpace - 边距相关
       *     itemSpace - chip 和 chip 之间的间距
       *     startSpace - 整个 chip 组的左侧内边距
       *     endSpace - 整个 chip 组的右侧内边距
       *   chipGroupPadding - 边距相关
       *     top - 整个 chip 组的顶部内边距
       *     bottom - 整个 chip 组的底部内边距
       *   suffix - 整个 chip 组的最右侧的内容（指定一个自定义组件）
       *   onChange - 组内 chip 是否激活的状态发生变化时的回调
       *     selectedIndexes - 激活状态的 chip 的索引位置的集合
       */
      ChipGroup({
        items: [
          {
            prefixIcon: { src: $r('app.media.ic_settings'), size: { width: 16, height: 16 } },
            label: { text: "aaaaaa" },
            suffixIcon: { src: $r('sys.media.ohos_ic_public_cut'), size: { width: 16, height: 16 } },
            allowClose: false
          },
          {
            prefixSymbol: {
              normal: new SymbolGlyphModifier($r('sys.symbol.ohos_star')).fontColor([Color.Red]).fontSize(16),
              activated: new SymbolGlyphModifier($r('sys.symbol.ohos_star')).fontColor([Color.White]).fontSize(16)
            },
            label: { text: "bbbbbb" },
            suffixSymbol: {
              normal: new SymbolGlyphModifier($r('sys.symbol.ohos_trash')).fontColor([Color.Red]).fontSize(16),
              activated: new SymbolGlyphModifier($r('sys.symbol.ohos_trash')).fontColor([Color.White]).fontSize(16)
            },
            allowClose: false,
          },
          {
            prefixIcon: { src: $r('sys.media.ohos_ic_public_clock') },
            label: { text: "cccccc" },
            allowClose: true
          },
          {
            prefixIcon: { src: $r('sys.media.ohos_ic_public_cast_stream') },
            label: { text: "dddddd" },
            allowClose: true
          },
          {
            prefixIcon: { src: $r('sys.media.ohos_ic_public_cast_mirror') },
            label: { text: "eeeeee" },
            allowClose: true
          },
        ],
        itemStyle: {
          size: ChipSize.NORMAL,
          backgroundColor: Color.Orange,
          fontColor: Color.Green,
          selectedBackgroundColor: Color.Blue,
          selectedFontColor: Color.White,
        },
        multiple: true,
        selectedIndexes: [1, 2],
        chipGroupSpace: {
          itemSpace: 10,
          startSpace: 5,
          endSpace: 5,
        },
        chipGroupPadding: {
          top: 10,
          bottom: 10
        },
        suffix: this.ChipGroupSuffix,
        onChange: (selectedIndexes:Array<number>) => {
          this.message = `selectedIndexes: ${selectedIndexes}`
        },
      })
    }
  }
}