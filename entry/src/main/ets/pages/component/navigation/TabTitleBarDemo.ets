/*
 * TabTitleBar - 页签标题栏
 * 支持多个页签和多个菜单项，每个页签可以对应一个页面且支持横扫切换
 */

import { TabTitleBar } from '@kit.ArkUI'
import { TitleBar } from '../../TitleBar'

// 对应 TabTitleBarTabItem
class TabItem {
  title: ResourceStr;
  icon?: ResourceStr;
  constructor(title: ResourceStr, icon?: ResourceStr) {
    this.title = title
    this.icon = icon
  }
}

// 对应 TabTitleBarMenuItem
interface MenuItem {
  value: ResourceStr;
  isEnabled?: boolean;
  action?: () => void
}

@Entry
@Component
struct TabTitleBarDemo {

  // 左侧的页签集合
  tabItems: Array<TabItem> = [
    new TabItem('tab1'),
    new TabItem('tab2'),
    new TabItem('tab3'),
    new TabItem("tab4", $r('app.media.app_icon')),
    new TabItem('tab5')
  ]

  // 页签集合关联的页面集合
  @Builder mySwiperContent() {
    Text("Text 1").fontSize(48).textAlign(TextAlign.Center).fontColor(Color.White).backgroundColor(Color.Red)
    Text("Text 2").fontSize(48).textAlign(TextAlign.Center).fontColor(Color.White).backgroundColor(Color.Green)
    Text("Text 3").fontSize(48).textAlign(TextAlign.Center).fontColor(Color.White).backgroundColor(Color.Blue)
    Text("Text 4").fontSize(48).textAlign(TextAlign.Center).fontColor(Color.White).backgroundColor(Color.Orange)
    Text("Text 5").fontSize(48).textAlign(TextAlign.Center).fontColor(Color.White).backgroundColor(Color.Pink)
  }

  // 右侧的菜单项集合
  private  readonly menuItems: Array<MenuItem> = [
    {
      value: $r('app.media.ic_settings'),
      isEnabled: true,
      action: () => { }
    },
    {
      value: $r('app.media.ic_settings'),
      isEnabled: false,
      action: () => { }
    },
    {
      value: $r('app.media.ic_settings'),
      isEnabled: true,
      action: () => { }
    },
  ]

  build() {
    Column({space:10}) {
      TitleBar()

      /*
       * TabTitleBar - 页签标题栏
       *   tabItems - 栏上左侧的页签集合（一个 TabTitleBarTabItem 对象数组）
       *     title - 标题
       *     icon - 图标
       *   swiperContent - 页签集合关联的页面集合
       *     注：tabItems 数组的元素与 swiperContent 数组的元素是一一对应的
       *   menuItems - 栏上右侧的菜单项集合（一个 TabTitleBarMenuItem 对象数组）
       *     value - 图标
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       */
      TabTitleBar({
        swiperContent: this.mySwiperContent,
        tabItems: this.tabItems,
        menuItems: this.menuItems,
      })
    }
  }
}