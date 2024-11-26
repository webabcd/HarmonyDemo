/*
 * 一组件显示一组件消失时的过渡动画
 *
 * 用于一个组件消失的同时，另一个组件显示的场景，并且两个组件的几何形状不一样（比如他们的大小不一样），并在这个过程中执行一段丝滑的过渡动画效果
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct GeometryTransitionDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State flag: boolean = true;

  build() {
    Column({space:10}) {

      Button('button').width(100).height(30)
        .onClick(() => {
          animateTo({ duration: 1000 }, () => {
            this.flag = !this.flag;
          })
        })

      /*
       * geometryTransition() - 指定一个标识（此标识相同的不同组件，在显示和消失时，他们的几何形状的变化会有一段过渡动画效果）
       *
       * 注：
       * 1、先参看 TransitionDemo.ets 中的说明
       * 2、如果几何形状没有变化，则用不到 geometryTransition()
       * 3、以本例来说，要想几何形状的变化之间有过渡动画效果，除了指定 geometryTransition() 外
       * 对 flag 的变化也要做动画处理（此处动画的时长就是几何变化动画的时长），类似如下
       * animateTo({ duration: 1000 }, () => {
       *   this.flag = !this.flag;
       * })
       */

      if (this.flag) {
        Image($r('app.media.app_icon'))
          .width(100)
          .height(100)
          .geometryTransition("group1")
          .transition(TransitionEffect.OPACITY.animation({
            duration: 3000,
            curve: Curve.Ease
          }))
      } else {
        Image($r('app.media.son'))
          .width(200)
          .height(200)
          .geometryTransition("group1")
          .transition(TransitionEffect.OPACITY.animation({
            duration: 3000,
            curve: Curve.Ease
          }))
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}