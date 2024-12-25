/*
 * RowSplit - 水平分栏布局（每个分栏的宽度可以通过手动拖动调整）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct RowSplitDemo {

  build() {
    Column({space:10}) {
      TitleBar()
      RowSplit() {
        Text('1').width('25%').height(100).backgroundColor(Color.Red).textAlign(TextAlign.Center)
        Text('2').width('25%').height(100).backgroundColor(Color.Green).textAlign(TextAlign.Center)
        Text('3').width('25%').height(100).backgroundColor(Color.Blue).textAlign(TextAlign.Center)
        Text('4').width('25%').height(100).backgroundColor(Color.Orange).textAlign(TextAlign.Center)
      }
      .resizeable(true)
    }
  }
}