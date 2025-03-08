/*
 * router - 路由接口，通过页面地址做路由
 *
 * 官方建议可能的话最好使用 Navigation 组件做导航
 *
 * 注：本例演示的是如何通过页面地址做路由（必须是 @Entry 组件），如需要通过路由表做路由（允许非 @Entry 组件）请参见 NavigationDemo2.ets, NavigationDemo3.ets 中的说明
 */

import { TitleBar } from '../../../TitleBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct RouterDemo_Page1 {

  // 自定义转场动画（参见 /animation/PageTransitionDemo.ets 中的说明）
  pageTransition() {

  }

  @State message: string = ""

  aboutToAppear() {
    /*
     * router.getParams() - 获取 router 传递过来的数据
     */
    const params = router.getParams() as Record<string, string>
    this.message += `RouterDemo_Page1 pageId:${Math.floor(Math.random() * 1000).toString()}\n`
    this.message += `p1:${params?.p1 || ""}, p2:${params?.p2 || ""}\n`
  }

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * RouterMode.Standard - 标准的入栈方式
       * RouterMode.Single - 从栈顶到栈底查找，如果找到了目标页则将其移动到栈顶，找不动目标页则使用标准方式入栈
       */

      Button("pushUrl RouterMode.Standard").onClick(() => {
        router.pushUrl({
          url: 'pages/component/navigation/RouterDemo',
        }, router.RouterMode.Standard)
      })

      Button("pushUrl RouterMode.Single").onClick(() => {
        router.pushUrl({
          url: 'pages/component/navigation/RouterDemo',
        }, router.RouterMode.Single)
      })

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1)
    }
  }
}
