/*
 * TabContent - 页签导航的页签内容
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct TabContentDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础1').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({space:10}) {

    }
  }
}