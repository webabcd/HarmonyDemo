/*
 *
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct AppLinkingDemo {

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)
    }
  }
}