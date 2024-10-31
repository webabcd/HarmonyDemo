/*
 * Stack - 堆叠布局
 *   alignContent, alignContent() - Stack 内的组件相对于父组件的对齐方式
 *   zIndex - Z 轴方向上的排列顺序
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct StackDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // alignContent, alignContent() - Stack 内的组件相对于父组件的对齐方式（Alignment 枚举）
      //   TopStart, Top, TopEnd, Start, Center, End, BottomStart, Bottom, BottomEnd
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column().width(100).height(50).backgroundColor(Color.Orange)
      }.width('100%').height(150).backgroundColor(Color.Blue)
      Stack() {
        Column().width(100).height(50).backgroundColor(Color.Orange)
      }.width('100%').height(150).backgroundColor(Color.Blue)
      .alignContent(Alignment.TopStart)

      // zIndex - Z 轴方向上的排列顺序
      //   无 zIndex 时，Stack 内后面的组件会显示在前面
      //   有 zIndex 时，Stack 内 zIndex 数值大的组件会显示在前面
      Stack() {
        Column().width(100).height(50).backgroundColor(Color.Red).offset({x:10, y:10})
          .zIndex(3)
        Column().width(100).height(50).backgroundColor(Color.Green).offset({x:20, y:20})
          .zIndex(1)
        Column().width(100).height(50).backgroundColor(Color.Blue).offset({x:30, y:30})
          .zIndex(2)
      }.width('100%').height(100).backgroundColor(Color.Orange)
      .alignContent(Alignment.TopStart)
    }
  }
}