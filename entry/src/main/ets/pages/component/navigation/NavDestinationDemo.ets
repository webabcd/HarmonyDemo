/*
 * NavDestination - 导航组件（Navigation）导航到的目标页
 * Navigation 是导航的根组件，导航到的目标页是 NavDestination 组件，导航栈中包含的是多个 NavDestination 组件（Navigation 组件不在导航栈中）
 */

import { SymbolGlyphModifier } from '@kit.ArkUI'

@Entry
@Component

struct NavDestinationDemo {

  navPathStack: NavPathStack = new NavPathStack()
  @State message: string = ""

  build() {
    Navigation(this.navPathStack) {
      Column({space:10}) {

        Text(this.message)

        Button('push navDestinationDemo_page1').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navDestinationDemo_page1',
          })
        })

        Button('push navDestinationDemo_page2').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navDestinationDemo_page2',
          })
        })
      }
    }
    .titleMode(NavigationTitleMode.Mini)
    .title("NavDestinationDemo")
  }
}

@Builder function navDestinationDemo_page1_builder(name: string, param: Object) {
  NavDestinationDemo_Page1()
}
@Component
struct NavDestinationDemo_Page1 {

  private navPathStack: NavPathStack | null = null;
  @State message: string = ""

  // 自定义标题栏的右上角的菜单
  @Builder myMenus() {
    Row({space:10}) {
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
      Image($r("sys.media.ohos_ic_public_add")).width(24).height(24)
    }
  }

  build() {

    /*
     * NavDestination - 导航组件（Navigation）导航到的目标页
     *   title() - 标题栏的标题（和 Navigation 的用法差不多，参见 NavigationDemo.ets 中的说明）
     *   menus() - 标题栏的右上角的菜单（和 Navigation 的用法差不多，参见 NavigationDemo.ets 中的说明）
     *   backButtonIcon() - 标题栏上的返回按钮图标
     *   hideTitleBar() - 是否隐藏标题栏
     *   mode() - 显示模式（NavDestinationMode 枚举）
     *     STANDARD - 标准模式
     *     DIALOG - 对话框模式
     *       默认透明
     *       无转场动画
     *       入栈时上一层页面不会走到 onWillHide() 和 onHidden()
     *       出栈时上一层页面不会走到 onWillShow() 和 onShown()
     *   onReady() - 当 NavDestination 构造子组件之前时的回调（回调参数是一个 NavDestinationContext 对象）
     *     pathInfo - 页面的信息（一个 NavPathInfo 对象，关于 NavPathInfo 请参见 NavigationDemo2.ets 中的说明）
     *     pathStack - 当前的导航栈（一个 NavPathStack 对象）
     *     navDestinationId - 当前 NavDestination 的标识（由系统自动生成）
     *   onBackPressed() - 页面返回时的回调
     *     return false 则使用默认的返回行为
     *     return true 则使用自定义的返回行为
     *   onWillShow() - 页面将要显示时触发的回调
     *   onWillHide() - 页面将要隐藏时触发的回调
     *   onShown() - 页面显示时触发的回调
     *   onHidden() - 页面隐藏时触发的回调
     *   onWillAppear() - 将要挂载到组件树上时的回调
     *   onWillDisappear() - 将要从组件树上卸载时的回调
     *   onAppear() - 挂载到组件树上时的回调
     *   onDisAppear() - 从组件树上卸载时的回调
     */
    NavDestination() {
      Column({space:5}) {

        Button('push navDestinationDemo_page1').onClick(() => {
          this.navPathStack?.pushPath({
            name: 'navDestinationDemo_page1',
          })
        })

        Button('pop').onClick(() => {
          this.navPathStack?.pop()
        })

        Scroll() {
          Text(this.message)
        }
        .layoutWeight(1)
      }
    }
    // 标题可以是一个字符串，也可以是一个自定义组件，也可以是一个 NavDestinationCommonTitle 对象（包含主标题和子标题）
    .title("NavDestinationDemo_Page1")
    // 右上角的菜单可以是一个自定义组件，也可以是一个 NavigationMenuItem 对象数组
    .menus(this.myMenus())
    .backButtonIcon(new SymbolGlyphModifier($r('sys.symbol.chevron_backward')).fontColor([Color.Blue]))
    .hideTitleBar(false)
    .mode(NavDestinationMode.STANDARD)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
      this.message += `navDestinationId:${ctx.navDestinationId}\n`
    })
    .onBackPressed(() => {
      this.message += "onBackPressed\n";
      return false
    })
    .onWillShow(() => {
      this.message += "onWillShow\n";
    })
    .onWillHide(() => {
      this.message += "onWillHide\n";
    })
    .onShown(() => {
      this.message += "onShown\n";
    })
    .onHidden(() => {
      this.message += "onHidden\n";
    })
    .onWillAppear(() => {
      this.message += "onWillAppear\n";
    })
    .onWillDisappear(() => {
      this.message += "onWillDisappear\n";
    })
    .onAppear(() => {
      this.message += "onAppear\n";
    })
    .onDisAppear(() => {
      this.message += "onDisAppear\n";
    })
  }
}

@Builder function navDestinationDemo_page2_builder(name: string, param: Object) {
  NavDestinationDemo_Page2()
}
@Component
struct NavDestinationDemo_Page2 {

  private navPathStack: NavPathStack | null = null;
  @State message: string = ""

  build() {
    NavDestination() {
      Column({space:5}) {

        Button('push navDestinationDemo_page2').onClick(() => {
          this.navPathStack?.pushPath({
            name: 'navDestinationDemo_page2',
          })
        })

        Button('pop').onClick(() => {
          this.navPathStack?.pop()
        })

        Scroll() {
          Text(this.message)
        }
        .layoutWeight(1)
      }
    }
    .title({
      main: "main", // 主标题
      sub: "sub" // 子标题
    })
    .mode(NavDestinationMode.DIALOG)
    .onReady((ctx: NavDestinationContext) => {
      this.navPathStack = ctx.pathStack;
      this.message += `navDestinationId:${ctx.navDestinationId}\n`
    })
    .onBackPressed(() => {
      this.message += "onBackPressed\n";
      return false
    })
    .onWillShow(() => {
      this.message += "onWillShow\n";
    })
    .onWillHide(() => {
      this.message += "onWillHide\n";
    })
    .onShown(() => {
      this.message += "onShown\n";
    })
    .onHidden(() => {
      this.message += "onHidden\n";
    })
    .onWillAppear(() => {
      this.message += "onWillAppear\n";
    })
    .onWillDisappear(() => {
      this.message += "onWillDisappear\n";
    })
    .onAppear(() => {
      this.message += "onAppear\n";
    })
    .onDisAppear(() => {
      this.message += "onDisAppear\n";
    })
    .backgroundColor(Math.floor(Math.random() * (0xffffff + 1)))
    .opacity(0.7)
  }
}