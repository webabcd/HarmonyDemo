/*
 * 页面转场效果
 */

import { TitleBar } from '../TitleBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct PageTransitionDemo_1 {

  /*
   * pageTransition() - 用于设置当前页面移入和移出时的转场动画
   *   PageTransitionEnter() - 页面移入时的转场动画
   *     slide() - 整个页面的滑入滑出动画（SlideEffect 枚举）
   *       Left, Right, Top, Bottom, START, END - 从指定的位置滑入
   *     translate() - 整个页面的位移动画（参见 /component/shape/TransformDemo.ets 中的说明）
   *     scale() - 整个页面的缩放动画（参见 /component/shape/TransformDemo.ets 中的说明）
   *     opacity() - 整个页面的不透明度动画
   *
   *   PageTransitionExit() - 页面移出时的转场动画
   *     和上面介绍的 PageTransitionEnter() 的用法是一致的
   */
  pageTransition() {
    PageTransitionEnter({
      delay: 0,
      duration: 1500,
      curve: Curve.Ease,
      type: RouteType.None
    })
      // 整个页面移入时的转场动画
      .slide(SlideEffect.Left)

    PageTransitionExit({
      delay: 0,
      duration: 1500,
      curve: Curve.Ease,
      type: RouteType.None
    })
      // 整个页面移出时的转场动画
      .translate({ x: 100.0, y: 100.0 })
      .scale({ x: 0.5, y: 0.5 })
      .opacity(0)
  }

  build() {
    Column() {
      TitleBar()

      Column() {
        Image($r("app.media.son"))
          .width('80%')
          .height('80%')
          .objectFit(ImageFit.Fill)
          .onClick(() => {
            router.pushUrl({ url: 'pages/animation/PageTransitionDemo_2', params: { title: "页面转场效果_测试页 2" } })
          })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
  }
}