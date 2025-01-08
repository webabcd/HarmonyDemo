/*
 * NavDestination - 导航组件（Navigation）导航到的目标页
 */

import { promptAction } from '@kit.ArkUI'

// 路由表中 routerMap 的 buildFunction 指定的 @Builder 函数，用于构造此路由指向的组件
// name - 路由名称
// param - 传递过来的数据
@Builder function navigationDemo2_page2_builder(name: string, param: Object) {
  NavigationDemo2_Page2()
}

@Component
struct NavigationDemo2_Page2 {

  /*
   * NavPathStack - 导航栈
   *   onReady() - 当 NavDestination 构造子组件之前时的回调（回调参数是一个 NavDestinationContext 对象）
   *     pathInfo - 页面的信息（一个 NavPathInfo 对象，关于 NavPathInfo 请参见 NavigationDemo2.ets 中的说明）
   *     pathStack - 当前的导航栈（一个 NavPathStack 对象）
   *     navDestinationId - 当前 NavDestination 的标识（由系统自动生成）
   *   setInterception() - 设置当前导航栈的拦截行为（指定一个 NavigationInterception 对象）
   *     willShow(), didShow() - 页面跳转前和跳转后的回调
   *       from - 页面跳转之前的栈顶页面信息（一个 NavDestinationContext 对象），如果此值为 "navBar" 则表示跳转前的页为 Navigation 组件
   *       to - 页面跳转之后的栈顶页面信息（一个 NavDestinationContext 对象），如果此值为 "navBar" 则表示跳转的目标页为 Navigation 组件
   *       operation - 页面跳转的类型（NavigationOperation 枚举）
   *         PUSH	- 此次转场为页面进场
   *         POP - 此次转场为页面退场
   *         REPLACE - 此次转场为页面替换
   *       isAnimated -	页面跳转是否启用了转场动画
   *     modeChange() - 导航组件的显示模式发生变化时的回调（关于导航组件的显示模式请参见 NavigationDemo.ets 中的说明）
   *   onBackPressed() - 拦截返回行为
   *     return false 则使用默认的返回行为
   *     return true 则使用自定义的返回行为
   */
  navPathStack: NavPathStack = new NavPathStack()

  @State message: string = ""

  build() {
    NavDestination() {
      Column({space:10}) {
        Button('pushPath').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page2',
          })
        })

        Scroll() {
          Text(this.message)
        }
        .layoutWeight(1)
      }
    }
    .title('NavigationDemo2_Page2')
    .onBackPressed(() => {
      // 自定义返回行为
      promptAction.showDialog({
        title: '确认返回码？',
        buttons: [ { text: '确认', color: '#ff0000' }, ]
      }, (err, data) => {
        if (!err) {
          this.navPathStack.pop()
        }
      });
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.navPathStack = context.pathStack;

      this.navPathStack.setInterception({
        // 页面跳转前拦截
        willShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar", operation: NavigationOperation, isAnimated: boolean) => {
          this.message += `willShow from:${JSON.stringify(from)}\n\n`
          this.message += `willShow to:${JSON.stringify(to)}\n\n`
          this.message += `willShow operation:${JSON.stringify(operation)}\n\n`
          this.message += `willShow animated:${JSON.stringify(isAnimated)}\n\n`
        },
        // 页面跳转后回调
        didShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar",  operation: NavigationOperation, isAnimated: boolean) => {
          this.message += `didShow from:${JSON.stringify(from)}\n\n`
          this.message += `didShow to:${JSON.stringify(to)}\n\n`
          this.message += `didShow operation:${JSON.stringify(operation)}\n\n`
          this.message += `didShow animated:${JSON.stringify(isAnimated)}\n\n`
        },
        // 导航组件的显示模式发生变化时的回调
        modeChange: (mode: NavigationMode) => {
          this.message += `modeChange mode:${JSON.stringify(mode)}\n\n`
        }
      })
    })
  }
}