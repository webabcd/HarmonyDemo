/*
 *
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct HuaweiDefaultLoginDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('xxx').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('yyy').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = '';

  build() {
    Column({space:10}) {

    }
  }
}

@Component
struct MySample2 {

  @State message: string = '';

  build() {
    Column({space:10}) {

    }
  }
}