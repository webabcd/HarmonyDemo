/*
 * NavRouter - 简版导航
 *
 * NavRouter 组件需要放在 Navigation 组件内
 * NavRouter 组件内需要有 2 个子组件
 * 第 2 个子组件是一个 NavDestination 组件，点击第 1 个子组件后，Navigation 会导航至第 2 个子组件
 *
 * 注：此组件已过时（deprecated）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct NavRouterDemo {

  @State message: string = ""

  build() {

    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Navigation() {

        /*
         * NavRouter - 简版导航
         *   mode() - 路由模式
         *     PUSH_WITH_RECREATE - 跳转到新页面时，老页面销毁但会保存在导航栈中
         *     PUSH - 跳转到新页面时，老页面不销毁且会保存在导航栈中
         *     REPLACE - 跳转到新页面时，老页面销毁且会从导航栈中清除
         *   onStateChange()- 状态变化时的回调
         *     true - NavRouter 显示了对应的 NavDestination 时
         *     false - NavRouter 不再显示对应的 NavDestination 时
         */
        NavRouter() {
          Text("PUSH")

          NavDestination() {
            Text("NavDestination")
          }
          .title("NavDestination")
        }
        .mode(NavRouteMode.PUSH)
        .onStateChange((isActivated: boolean) => {
          this.message = `onStateChange:${isActivated}`
        })
      }
    }
  }
}