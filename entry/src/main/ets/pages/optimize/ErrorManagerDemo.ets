/**
 * errorManager - 捕获未处理异常
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct ErrorManagerDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
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
    Column({ space: 10 }) {

      /*
       * 通过 import { errorManager } from '@kit.AbilityKit'; 可以监听到未处理异常
       * 也就是说可以在 app 崩溃之前拿到未处理异常
       *
       * 详见 /entry/src/main/ets/entryability/EntryAbility.ets 中的相关说明
       */
      Button("触发一个未处理异常").onClick(() => {
        let result: object = JSON.parse("");
      })

      Text(this.message)
    }
  }
}