/*
 * AlphabetIndexer - 单字符二级联动列表
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct AlphabetIndexerDemo {

  private arrayC: string[] = ['苍', '岑', '常', '柴', '陈', '成', '池', '车', '楚', '崔', '寸']
  private arrayF: string[] = ['樊', '房', '方', '冯', '傅', '弗']
  private value: string[] = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      /*
       * AlphabetIndexer - 单字符二级联动列表
       *   autoCollapse() - 当字符列表过长时，是否需要收缩显示
       *   enableHapticFeedback() - 是否启用触觉反馈
       *   usingPopup() - 一级列表的 item 被选中时，是否弹出相关的二级列表
       *   alignStyle() - 一级列表相对于二级列表的位置
       *
       *   itemSize() - 一级列表的 item 的尺寸
       *   itemBorderRadius() - 一级列表的 item 的圆角半径
       *   selectedColor() - 一级列表的 item 被选中时，文字的颜色
       *   selectedBackgroundColor() - 一级列表的 item 被选中时，背景的颜色
       *   font() - 一级列表的 item 的字体样式
       *   selectedFont() - 一级列表的 item 被选中时的字体样式
       *
       *   popupBackground() - 二级列表背景色
       *   popupBackgroundBlurStyle() - 二级列表的背景模糊效果
       *   popupItemBorderRadius() - 二级列表的 item 的圆角半径
       *   popupColor() - 二级列表的标题 item 的文本颜色
       *   popupTitleBackground() - 二级列表的标题 item 的背景色
       *   popupFont() - 二级列表的标题 item 的字体样式
       *   popupSelectedColor() - 二级列表的 item 选中时的文本颜色
       *   popupUnselectedColor() - 二级列表的 item 未选中时的文本颜色
       *   popupItemBackgroundColor() - 二级列表的 item 的背景色
       *   popupItemFont() - 二级列表的 item 的字体样式
       *
       *   onSelect() - 一级列表的 item 被选中时的回调
       *   onPopupSelect() - 二级列表的 item 被选中时的回调
       *   onRequestPopupData() - 一级列表的 item 被选中后弹出二级列表之前的回调，需要在此回调内返回二级列表的数据
       */
      AlphabetIndexer({ arrayValue: this.value, selected: 0 })
        .autoCollapse(false)
        .enableHapticFeedback(false)
        .usingPopup(true)
        .alignStyle(IndexerAlign.Left) // 一级列表在二级列表的左侧

        .itemSize(24)
        .itemBorderRadius(14)
        .selectedColor(Color.White)
        .selectedBackgroundColor(Color.Red)
        .font({ size: 14, weight: FontWeight.Normal })
        .selectedFont({ size: 16, weight: FontWeight.Bolder })

        .popupBackground(Color.Blue)
        .popupBackgroundBlurStyle(BlurStyle.Thin)
        .popupItemBorderRadius(24)
        .popupColor(Color.Green)
        .popupTitleBackground(Color.Orange)
        .popupFont({ size: 32, weight: FontWeight.Bolder })
        .popupSelectedColor(Color.Brown)
        .popupUnselectedColor(Color.Yellow)
        .popupItemBackgroundColor(Color.Pink)
        .popupItemFont({ size: 24, style: FontStyle.Normal })

        .onSelect((index: number) => {
          this.message = `onSelect:${index}`
        })
        .onPopupSelect((index: number) => {
          this.message = `onPopupSelect:${index}`
        })
        .onRequestPopupData((index: number) => {
          // 根据一级列表中选中的 item 返回相关的二级列表的数据
          if (this.value[index] == 'C') {
            return this.arrayC
          } else if (this.value[index] == 'F') {
            return this.arrayF
          } else {
            return []
          }
        })
        .layoutWeight(1)
    }
  }
}