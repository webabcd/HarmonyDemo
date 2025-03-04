/*
 *
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct LocalStorageDemo {

  @State age1: number = 0

  build() {
    Column({ space: 10 }) {
      TitleBar()


    }
  }
}