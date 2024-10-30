/*
 * 位置相关
 * align, direction, position, markAnchor, offset
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CommonStyleDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // align() - 组件内的组件相对于父组件的对齐方式
      //   TopStart, Top, TopEnd, Start, Center, End, BottomStart, Bottom, BottomEnd
      Stack() {
        Text('BottomEnd').width('50%').height('80%').backgroundColor(Color.Yellow)
          // textAlign() - 文本框中的文字的对齐方式
          .textAlign(TextAlign.End)
      }.width('90%').height(50).backgroundColor(Color.Orange)
      .align(Alignment.BottomEnd)

      // direction() - 组件内的多个组件的排列方向
      //   Ltr - 从左到右
      //   Rtl - 从右到左
      Row() {
        Text('1')
        Text('2')
        Text('3')
        Text('4')
      }.width('90%').height(50).backgroundColor(Color.Orange)
      .direction(Direction.Rtl)

      // position() - 设置组件相对于父组件的绝对位置
      //   可以指定一个 Position 对象，即 x/y 值
      //   也可以指定一个 Edges 对象，即 top/right/bottom/left 值
      //   单位可以是 vp, px, lpx, 百分比等
      Stack() {
        Text('position1')
          .backgroundColor(Color.Yellow)
          .position({ x: 30, y: 10 })
        Text('position2')
          .backgroundColor(Color.Yellow)
          .position({ x: '30%', y: '10%' })
        Text('position3')
          .backgroundColor(Color.Yellow)
          .position({ right: 0, top: 0 })
      }.width('90%').height(50).backgroundColor(Color.Orange).align(Alignment.BottomEnd)

      // markAnchor() - 设置组件相对于父组件在其原本位置上的偏移量（x > 0 向左偏移，y > 0 向上偏移）
      //   可以指定一个 Position 对象，即 x/y 值
      //   也可以指定一个 Edges 对象，即 top/right/bottom/left 值
      //   单位可以是 vp, px, lpx, 百分比等
      Stack() {
        Text('markAnchor')
          .backgroundColor(Color.Yellow)
          .align(Alignment.Start)
          .markAnchor({ x: '-30', y: '-10' })
      }.width('90%').height(50).backgroundColor(Color.Orange).align(Alignment.TopStart)

      // offset() - 设置组件相对于父组件在其原本位置上的偏移量（x > 0 向右偏移，y > 0 向下偏移）
      //   可以指定一个 Position 对象，即 x/y 值
      //   也可以指定一个 Edges 对象，即 top/right/bottom/left 值
      //   单位可以是 vp, px, lpx, 百分比等
      Stack() {
        Text('offset')
          .backgroundColor(Color.Yellow)
          .align(Alignment.Start)
          .offset({ x: '30', y: '10' })
      }.width('90%').height(50).backgroundColor(Color.Orange).align(Alignment.TopStart)
    }
  }
}