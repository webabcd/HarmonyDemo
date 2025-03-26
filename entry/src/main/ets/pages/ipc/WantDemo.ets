/*
 *
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct WantDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('xxx').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

    }
  }
}