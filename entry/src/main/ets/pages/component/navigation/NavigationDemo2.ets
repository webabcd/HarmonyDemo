/*
 * Navigation - 导航组件
 * 包括顶部的导航栏，中部的内容区，底部的工具栏
 *
 * 本例用于演示导航组件的导航
 * Navigation 是导航的根组件，导航到的目标页是 NavDestination 组件，导航栈中包含的是多个 NavDestination 组件（Navigation 组件不在导航栈中）
 *
 * 如果需要通过 Navigation 实现导航，则先要配置路由表
 * 1、在 src/main/module.json5 中做类似如下的配置（指定路由表）
 * {
 *   "module": {
 *     "routerMap": "$profile:route_map"
 *   }
 * }
 * 2、在 src/main/resources/profile/route_map.json 中配置路由表
 * {
 *   "routerMap": [
 *     {
 *       // 路由的名称
 *       "name": "navigationDemo2_page1",
 *       // 指定一个页面地址，此页面中包含 buildFunction 指定的函数
 *       "pageSourceFile": "src/main/ets/pages/component/navigation/pages/NavigationDemo2_Page1.ets",
 *       // 指定一个 @Builder 函数的名称，其用于构造此路由指向的组件
 *       "buildFunction": "navigationDemo2_page1_builder"
 *     }
 *   ]
 * }
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
        TabContent() { MySample1() }.tabBar('导航的基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('导航的拦截').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('入栈的模式').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  /*
   * NavPathStack - 导航栈（实例化 Navigation 时指定一个 NavPathStack 对象，后续可以通过此 NavPathStack 对象实现导航）
   *   pushPath() - 将指定的页面入栈
   *     info - 入栈页面的信息（一个 NavPathInfo 对象）
   *       name - 目标路由的名称（即 routerMap 中的 name）
   *       param - 传给目标页的数据
   *       isEntry - 目标页是否是 @Entry 装饰的
   *       onPop - 目标页出栈且传回了数据时的回调（回调参数是一个 PopInfo 对象）
   *         info - 出栈的页的 NavPathInfo 对象
   *         result - 出栈的页传回的数据
   *     options - 选项（一个 NavigationOptions 对象）
   *       animated - 是否启用转场动画
   *       launchMode - 页面入栈的模式
   *   pushPathByName(name: string, param: Object, onPop: Callback<PopInfo>, animated?: boolean) - 将指定的页面入栈，参数的用法可以参考 pushPath() 的说明
   *   pushDestination(info: NavPathInfo, animated?: boolean) - 将指定的页面入栈，参数的用法可以参考 pushPath() 的说明
   *     返回一个 Promise 对象
   *   pushDestinationByName(name: string, param: Object, animated?: boolean) - 将指定的页面入栈，参数的用法可以参考 pushPath() 的说明
   *     返回一个 Promise 对象
   *   disableAnimation() - 是否禁用所有转场动画
   *   getParent() - 当 Navigation 嵌套 Navigation 时，可以获取当前 Navigation 的父 Navigation 的 NavPathStack 对象
   *
   * 注：本例导航到的页面请参见 component/navigation/pages/NavigationDemo2_Page1.ets
   */
  navPathStack: NavPathStack = new NavPathStack()

  @State message: string = ""

  aboutToAppear(): void {
    this.navPathStack.disableAnimation(false)
    let parent_navPathStack = this.navPathStack.getParent()
  }

  build() {
    Navigation(this.navPathStack) {
      Column({space:10}) {

        Button('pushPath').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page1',
            param: "abc",
            isEntry: false,
            onPop: (popInfo: PopInfo) => {
              this.message += `onPop name:${popInfo.info.name}, result:${popInfo.result}\n`
            },
          }, {
            animated: true,
            launchMode: LaunchMode.STANDARD
          })
        })

        Button('pushPathByName').onClick(() => {
          this.navPathStack.pushPathByName(
            'navigationDemo2_page1',
            "abc",
            (popInfo: PopInfo) => {
              this.message += `onPop name:${popInfo.info.name}, result:${popInfo.result}\n`
            },
            true
          )
        })

        Button('pushDestination').onClick(() => {
          this.navPathStack.pushDestination({
            name: 'navigationDemo2_page1',
            param: "abc",
            onPop: (popInfo: PopInfo) => {
              this.message += `onPop name:${popInfo.info.name}, result:${popInfo.result}\n`
            }
          }, {
            animated: true,
            launchMode: LaunchMode.STANDARD
          }).catch((error: Error) => {
            this.message += "pushDestination err\n"
          }).then(() => {
            this.message += "pushDestination ok\n"
          });
        })

        Button('pushDestinationByName').onClick(() => {
          this.navPathStack.pushDestinationByName(
            'navigationDemo2_page1',
            "abc",
            (popInfo: PopInfo) => {
              this.message += `onPop ${popInfo.info.name} ${popInfo.result}\n`
            },
            true
          ).catch((error: Error) => {
            this.message += "pushDestinationByName err\n"
          }).then(() => {
            this.message += "pushDestinationByName ok\n"
          });
        })

        Scroll() {
          Text(this.message)
        }
        .layoutWeight(1)
      }
    }
    .titleMode(NavigationTitleMode.Mini)
    .title("NavigationDemo_MySample1")
  }
}

@Component
struct MySample2 {

  navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Column({space:10}) {

        /*
         * 本例用于演示导航的拦截，请参见 component/navigation/pages/NavigationDemo2_Page2.ets
         */
        Button('pushPath').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page2',
          })
        })
      }
    }
    .titleMode(NavigationTitleMode.Mini)
    .title("NavigationDemo_MySample2")
  }
}

@Component
struct MySample3 {

  navPathStack: NavPathStack = new NavPathStack()

  @State message: string = ""

  build() {
    Navigation(this.navPathStack) {
      Column({space:10}) {

        /*
         * 本例用于演示入栈的模式，请参见 component/navigation/pages/NavigationDemo2_Page3.ets
         */
        Button('pushPath').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page3',
          }, {
            launchMode: LaunchMode.STANDARD
          })
        })
      }
    }
    .titleMode(NavigationTitleMode.Mini)
    .title("NavigationDemo_MySample3")
  }
}