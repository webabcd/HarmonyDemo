/*
 *
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CommonStyleDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Column()
        .width(100)
        .height(20)
        .backgroundColor(Color.Blue)
        .border({

        })
    }
  }
}