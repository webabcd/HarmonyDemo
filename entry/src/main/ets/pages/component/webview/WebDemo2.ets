/*
 *
 */

import { TitleBar } from '../../TitleBar';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebDemo2 {

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
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

    }
  }
}