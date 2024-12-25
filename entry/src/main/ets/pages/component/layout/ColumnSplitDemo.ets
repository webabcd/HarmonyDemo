/*
 * ColumnSplit - 垂直分栏布局（每个分栏的高度可以通过手动拖动调整）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct ColumnSplitDemo {

  build() {
    Column({space:10}){
      TitleBar()
      /*
       * ColumnSplit - 垂直分栏布局（每个分栏的高度可以通过手动拖动调整）
       *   resizeable() - 是否可以通过手动拖动调整每个分栏的高度
       */
      ColumnSplit() {
        Text('1').width('100%').height(100).backgroundColor(Color.Red).textAlign(TextAlign.Center)
        Text('2').width('100%').height(100).backgroundColor(Color.Green).textAlign(TextAlign.Center)
        Text('3').width('100%').height(100).backgroundColor(Color.Blue).textAlign(TextAlign.Center)
        Text('4').width('100%').height(100).backgroundColor(Color.Orange).textAlign(TextAlign.Center)
      }
      .resizeable(true)
    }
  }
}