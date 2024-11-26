/*
 * 页面转场效果（即页面路由切换时的动画）
 */

import { MyLog, TitleBar } from '../TitleBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct PageTransitionDemo {

  @State myScale: number = 1
  @State myOpacity: number = 1

  /*
   * pageTransition() - 用于设置当前页面移入和移出时的转场动画
   *   PageTransitionEnter() - 页面移入时的转场动画
   *     delay - 动画的延迟播放时间（单位：毫秒）
   *     duration - 动画时长（单位：毫秒）
   *     curve - 动画曲线，即动画的缓动类型（参见 AnimationDemo.ets 中的说明）
   *     type - 触发 onEnter() 回调的类型（RouteType 枚举）
   *       Push - 页面移入是因为此页面被 push 了，则会调用 onEnter() 回调
   *       Pop - 页面移入是因为其他页面被 pop 了，则会调用 onEnter() 回调
   *       None - 以上两种情况都会调用 onEnter() 回调
   *     onEnter() - 页面移入过程中的回调，根据进度的不同会调用多次
   *       type - 页面移入的类型
   *         RouteType.Push 或 RouteType.Pop
   *       progress - 页面移入的进度
   *         即页面移入时，此页面的转场动画的进度，此值在 0 - 1 之间
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
      // 根据移入动画进度，自定义当前的页面的状态
      .onEnter((type: RouteType, progress: number) => {
        if (type == RouteType.Push || type == RouteType.Pop) {
          this.myScale = progress
          this.myOpacity = progress
        }
      })

    PageTransitionExit({
      delay: 0,
      duration: 1500,
      curve: Curve.Ease,
      type: RouteType.None
    })
      // 根据移出动画进度，自定义当前的页面的状态
      .onExit((type: RouteType, progress: number) => {
        if (type == RouteType.Push || type == RouteType.Pop) {
          this.myScale = 1 - progress
          this.myOpacity = 1 - progress
        }
      })
  }

  build() {
    Column() {
      TitleBar()

      Column() {
        Image($r("app.media.app_icon"))
          .width('80%')
          .height('80%')
          .objectFit(ImageFit.Fill)
          .scale({ x: this.myScale, y: this.myScale })
          .opacity(this.myOpacity)
          .onClick(() => {
            router.pushUrl({ url: 'pages/animation/PageTransitionDemo_1', params: { title: "页面转场效果_测试页 1" } })
          })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
  }
}