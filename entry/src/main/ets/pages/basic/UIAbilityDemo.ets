/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 * 一个应用可以包含一个或多个 UIAbility，每个 UIAbility 实例都会在最近任务列表中显示为一个对应的任务窗口
 * 一个 UIAbility 可以包含多个页面
 * 关于 UIAbility 的相关配置，请参见 module.json5 配置文件中的 abilities 标签
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct UIAbilityDemo {

  build() {
    Column() {
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

      Text(this.message)

    }
  }
}
