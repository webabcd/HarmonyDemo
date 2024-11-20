/*
 * Blank - 空白
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct BlankDemo {

  build() {
    Column({space:10}) {
      TitleBar()

      /*
       * Blank - 空白
       *   color() - 颜色
       */
      Blank().width(200).height(100)
        .color(Color.Red)

      /*
       * Blank - 空白（用于自动拉伸，从而填满 Row/Column/Flex 的剩余空间）
       *   min - 自动拉伸过程中的最小值
       */
      Row() {
        Text('abc').fontSize(24).fontColor(Color.White)
        // 这里的 100 用于指定 Blank 在自动拉伸过程中的最小值为 100（对于在 Row 中的 Blank 来说就是宽度的最小值为 100）
        Blank(100).color(Color.Red)
        Text('xyz').fontSize(24).fontColor(Color.White)
      }
      .width('100%')
      .backgroundColor(Color.Orange)
    }
  }
}