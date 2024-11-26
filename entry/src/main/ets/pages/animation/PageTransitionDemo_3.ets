/*
 * 页面转场效果（即页面路由切换时的动画）
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct PageTransitionDemo_3 {

  build() {
    Column() {
      TitleBar()

      Column() {

        /*
         * sharedTransition() - 页面路由切换时，相同组件的切换效果
         *   id - 标识
         *     此标识相同的不同页面的不同组件（但是组件显示的内容是一样的），在页面路由切换时，他们之间会有一段转场动画
         *   options - 选项
         *     delay - 动画的延迟播放时间（单位：毫秒）
         *     duration - 动画时长（单位：毫秒）
         *     curve - 动画曲线，即动画的缓动类型（参见 AnimationDemo.ets 中的说明）
         */
        Image($r("app.media.app_icon"))
          .width('80%')
          .height('80%')
          .objectFit(ImageFit.Fill)
          .sharedTransition('group1', {
            delay: 0,
            duration: 1500,
            curve: Curve.Linear
          })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
  }
}