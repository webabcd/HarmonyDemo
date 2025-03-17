/*
 * router - 路由接口，通过页面地址做路由
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

    /*
     * queryRouterPageInfo() - 组件的内置方法，可以获取当前的 RouterPageInfo
     *   index - 当前页面在栈中的从栈底开始的索引位置（注：此处的索引是从 1 开始的）
     *   name - 当前页面的文件名称
     *   path - 当前页面的文件地址
     *   pageId - 由系统生成的当前页面的唯一标识
     *   state - 页面状态（一个 RouterPageState 枚举）
     *     ABOUT_TO_APPEAR - 页面即将显示
     *     ABOUT_TO_DISAPPEAR - 页面即将销毁
     *     ON_PAGE_SHOW - 页面显示了
     *     ON_PAGE_HIDE - 页面隐藏了
     *     ON_BACK_PRESS - 页面返回时
     */
    let routerPageInfo = this.queryRouterPageInfo()
    this.message += `routerPageInfo:${JSON.stringify(routerPageInfo)}\n`
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
