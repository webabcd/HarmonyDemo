/*
 * router - 路由接口，通过页面地址做路由
 *
 * 官方建议可能的话最好使用 Navigation 组件做导航
 */

import { TitleBar } from '../../../TitleBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct RouterDemo_Page1 {

  @State message: string = ""

  aboutToAppear() {
    // 获取传递过来的数据
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
