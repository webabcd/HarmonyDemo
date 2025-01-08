/*
 * Navigation - 导航组件
 * 包括顶部的导航栏，中部的内容区，底部的工具栏
 *
 * 本例用于演示导航组件的显示
 */

import { TitleBar, RadioBar } from '../../TitleBar';
import { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';

@Entry
@Component
struct NavigationDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('标准化的导航栏和工具栏').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('导航组件与导航目标页分栏显示').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  // 自定义标题栏的标题
  @Builder navigationTitle() {
    Text('Title').fontSize(64)
  }

  // 自定义标题栏的右上角的菜单
  @Builder navigationMenus() {
    Row({space:10}) {
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
    }
  }

  // 自定义工具栏
  @Builder navigationToolbarConfiguration() {
    Row() {
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
  }

  @State navigationTitleMode: NavigationTitleMode = NavigationTitleMode.Free
  navigationTitleMode_valueList =  ["Free", "Full", "Mini"]

  @State title_barStyle: BarStyle = BarStyle.STANDARD
  barStyle_valueList =  ["STANDARD", "STACK"]

  build() {
    Column({space:5}) {
      RadioBar({valueList: this.navigationTitleMode_valueList, groupName: "group1", onChange: (selectedIndex: number) => {
        this.navigationTitleMode = NavigationTitleMode[this.navigationTitleMode_valueList[selectedIndex]]
      }})

      RadioBar({valueList: this.barStyle_valueList, groupName: "group2", onChange: (selectedIndex: number) => {
        this.title_barStyle = BarStyle[this.barStyle_valueList[selectedIndex]]
      }})

      /*
       * Navigation - 导航组件
       *   title() - 标题栏的标题
       *     value - 标题内容（指定一个自定义组件）
       *     options - 选项（一个 NavigationTitleOptions 对象）
       *       backgroundColor, backgroundBlurStyle - 背景颜色，背景模糊效果
       *       paddingStart, paddingEnd - 左右内边距
       *       barStyle - 标题栏的样式（BarStyle 枚举）
       *         STANDARD - 导航栏与内容区在上下分开布局
       *         STACK - 导航栏堆叠在内容区的上部
       *   menus() - 标题栏的右上角的菜单（指定一个自定义组件）
       *   子组件 - 内容区
       *   toolbarConfiguration() - 工具栏
       *     value - 工具栏内容（指定一个自定义组件）
       *     options - 选项（一个 NavigationToolbarOptions 对象）
       *       backgroundColor, backgroundBlurStyle - 背景颜色，背景模糊效果
       *   hideTitleBar() - 是否隐藏标题栏
       *   hideToolBar() - 是否隐藏工具栏
       *   titleMode() - 标题栏的模式（NavigationTitleMode 枚举）
       *     Free - 内容区滚动时，标题栏会有联动特效
       *     Full - 标题栏固定大小（较大尺寸），不会随内容区的滚动做联动
       *     Mini - 标题栏固定大小（较小尺寸），不会随内容区的滚动做联动
       *   onTitleModeChange() - 标题栏的模式发生变化时的回调
       *   backButtonIcon() - 标题栏上的返回按钮图标（仅在标题栏的模式为 NavigationTitleMode.Mini 时才会显示返回按钮）
       *   hideBackButton() - 是否隐藏标题栏上的返回按钮
       */
      Navigation() {
        Text("Text").fontSize(32)

        List({ space: 20 }) {
          ForEach(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], (item: string) => {
            ListItem() {
              Text(item).width('100%').height(100).fontSize(48)
                .textAlign(TextAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
            }
            .margin({ left: 20, right: 20 })
          }, (item: string) => item)
        }
      }
      .title(this.navigationTitle, {
        backgroundColor: Color.Green,
        backgroundBlurStyle: BlurStyle.Thin,
        paddingStart: LengthMetrics.vp(10),
        paddingEnd: LengthMetrics.vp(10),
        barStyle: this.title_barStyle
      })
      .menus(this.navigationMenus)
      .toolbarConfiguration(this.navigationToolbarConfiguration, {
        backgroundColor: Color.Green,
        backgroundBlurStyle: BlurStyle.Thin
      })
      .hideTitleBar(false)
      .hideToolBar(false)
      .titleMode(this.navigationTitleMode)
      .onTitleModeChange((titleModel: NavigationTitleMode) => { })
      .backButtonIcon(new SymbolGlyphModifier($r('sys.symbol.wifi')).fontColor([Color.Blue]))
      .hideBackButton(false)
      .layoutWeight(1)
      .backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample2 {

  // 标题栏的标题
  commonTitle: NavigationCommonTitle =  {
    main: "main",
    sub: "sub"
  }

  // 标题栏的右上角的菜单
  menuItems: Array<NavigationMenuItem> = [
    {
      value: 'item1',
      icon: 'resources/base/media/ic_settings.svg',
      isEnabled: true,
      action: () => { }
    },
    {
      value: 'item2',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.wifi')).fontColor([Color.Red])
    },
  ]

  // 工具栏
  toolItems: Array<ToolbarItem> = [
    {
      value: 'item1',
      icon: 'resources/base/media/ic_settings.svg',
      status: ToolbarItemStatus.NORMAL,
      action: () => { }
    },
    {
      value: 'item2',
      icon: 'resources/base/media/ic_settings.svg',
      activeIcon: 'resources/base/media/son.jpg',
      status: ToolbarItemStatus.ACTIVE,
      action: () => { }
    },
    {
      value: 'item3',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.ohos_star')),
      activeSymbolIcon: new SymbolGlyphModifier($r('sys.symbol.ohos_lungs')),
      status: ToolbarItemStatus.ACTIVE,
      action: () => {  }
    }
  ]

  build() {
    Column({space:5}) {

      /*
       * Navigation - 导航组件
       *   本例用于演示如何使用标准化的导航栏和工具栏（自定义的导航栏和工具栏请参见上面的 MySample1 示例）
       *   title() - 标题栏的标题
       *     value - 标题内容（一个 NavigationCommonTitle 对象）
       *       main - 主标题
       *       sub - 子标题
       *     options - 选项（一个 NavigationTitleOptions 对象）
       *       backgroundColor, backgroundBlurStyle - 背景颜色，背景模糊效果
       *       paddingStart, paddingEnd - 左右内边距
       *       barStyle - 标题栏的样式（BarStyle 枚举）
       *         STANDARD - 导航栏与内容区在上下分开布局
       *         STACK - 导航栏堆叠在内容区的上部
       *   menus() - 标题栏的右上角的菜单（一个 NavigationMenuItem 对象数组）
       *     value - 选项文本
       *     icon - 选项图标的资源路径
       *     symbolIcon - 选项图标的 symbol 资源
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       *   toolbarConfiguration() - 工具栏
       *     value - 工具栏内容（一个 ToolbarItem 对象数组）
       *       value - 选项文本
       *       icon - 选项图标的资源路径
       *       activeIcon - 激活状态的选项图标的资源路径
       *       symbolIcon - 选项图标的 symbol 资源
       *       activeSymbolIcon - 激活状态的选项图标的 symbol 资源
       *       action - 点击后的回调
       *       status - 选项的状态（ToolbarItemStatus 枚举）
       *         NORMAL - 可点击
       *         DISABLED - 不可点击
       *         ACTIVE - 双状态按钮（点击后从普通状态转到激活状态，再点击则从激活状态转到普通状态）
       *     options - 选项（一个 NavigationToolbarOptions 对象）
       *       backgroundColor, backgroundBlurStyle - 背景颜色，背景模糊效果
       */
      Navigation() {
        Text("Text").fontSize(32)

        List({ space: 20 }) {
          ForEach(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], (item: string) => {
            ListItem() {
              Text(item).width('100%').height(100).fontSize(48)
                .textAlign(TextAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
            }
            .margin({ left: 20, right: 20 })
          }, (item: string) => item)
        }
      }
      .title(this.commonTitle, {
        backgroundColor: Color.Green,
        backgroundBlurStyle: BlurStyle.Thin,
        paddingStart: LengthMetrics.vp(10),
        paddingEnd: LengthMetrics.vp(10),
        barStyle: BarStyle.STANDARD
      })
      .menus(this.menuItems)
      .toolbarConfiguration(this.toolItems, {
        backgroundColor: Color.Green,
        backgroundBlurStyle: BlurStyle.Thin
      })
      .mode(NavigationMode.Stack)
      .titleMode(NavigationTitleMode.Mini)
      // 返回按钮
      .backButtonIcon(new SymbolGlyphModifier($r('sys.symbol.chevron_backward')).fontColor([Color.Blue]))
      .layoutWeight(1)
      .backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample3 {

  private navPathStack: NavPathStack = new NavPathStack()

  @State isVisible: boolean = true

  @State navigationMode: NavigationMode = NavigationMode.Split
  navigationMode_valueList =  ["Stack", "Split", "Auto"]

  build() {
    Column({space:5}) {
      RadioBar({valueList: this.navigationMode_valueList, selectedIndex:1, onChange: (selectedIndex: number) => {
        this.navigationMode = NavigationMode[this.navigationMode_valueList[selectedIndex]]
      }})

      Button('显示或隐藏导航组件').onClick(() => {
        this.isVisible = !this.isVisible
      })

      /*
       * Navigation - 导航组件
       *   mode() - 导航组件的显示模式（NavigationMode 枚举）
       *     Stack - 导航组件（Navigation）与导航目标页（NavDestination）之间独立显示，相当于两个页面
       *     Split - 导航组件（Navigation）与导航目标页（NavDestination）之间在一个面里，左右分栏显示
       *     Auto - 根据窗口宽度自动确定用 Stack 模式还是 Split 模式
       *   onNavigationModeChange() - 导航组件的显示模式发生变化时的回调
       *   navBarPosition() - 分栏显示时，导航组件的位置（NavBarPosition 枚举）
       *     Start - 导航组件在左侧显示
       *     End - 导航组件在右侧显示
       *   navBarWidthRange() - 分栏显示时，导航组件的最小宽度和最大宽度
       *   navBarWidth() - 分栏显示时，导航组件的默认宽度
       *   minContentWidth() - 分栏显示时，导航目标页（NavDestination）的最小宽度
       *   hideNavBar() - 是否隐藏导航组件
       *   onNavBarStateChange() - 导航组件的显示和隐藏状态发生变化时的回调
       *
       * 注：
       * 1、本例中，关于导航的实现请参见 NavigationDemo2.ets 中的说明
       * 2、本例中，关于 NavDestination 的用法请参见 NavDestinationDemo.ets 中的说明
       */
      Navigation(this.navPathStack) {

        Button('pushPath').onClick(() => {
          this.navPathStack.pushPath({ name: "navigationDemo_myPage" })
        }).margin({ bottom: 10 })

        List({ space: 20 }) {
          ForEach(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], (item: string) => {
            ListItem() {
              Text(item).width('100%').height(100).fontSize(48)
                .textAlign(TextAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
            }
            .margin({ left: 20, right: 20 })
          }, (item: string) => item)
        }
      }
      .mode(this.navigationMode)
      .onNavigationModeChange((mode: NavigationMode) => { })
      .navBarPosition(NavBarPosition.Start)
      .navBarWidthRange([200, 800]) // 导航组件的最小宽度 200，最大宽度 800
      .navBarWidth(400)
      .minContentWidth(360)
      .hideNavBar(!this.isVisible)
      .onNavBarStateChange((isVisible: boolean) => { })
      .layoutWeight(1)
      .backgroundColor(Color.Yellow)
    }
  }
}

@Builder function myPageBuilder(name: string, param: Object) {
  MyPage()
}

@Component
struct MyPage {

  private navPathStack: NavPathStack | null = null;

  build() {
    NavDestination() {
      Column({space:5}) {
        Button('pushPath').onClick(() => {
          this.navPathStack?.pushPath({ name: "navigationDemo_myPage" });
        })

        Button('pop').onClick(() => {
          this.navPathStack?.pop()
        })
      }
    }
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
    })
  }
}