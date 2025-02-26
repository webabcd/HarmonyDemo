/*
 *
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct GestureDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('ccc').align(Alignment.Top)
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
    Column({ space: 10 }) {


    }
  }
}
