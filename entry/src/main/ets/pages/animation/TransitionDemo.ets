/*
 * 单个组件显示和消失时的过渡动画（用于组件插入或移除时，显示一段过渡动画效果）
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct TransitionDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('简单效果').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('复杂效果').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('出现和消失使用不同的效果').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State flag: boolean = true;

  build() {
    Column({space:10}) {

      Text(this.message).fontSize(16)

      Button('button').width(100).height(30)
        .onClick(() => {
          this.flag = !this.flag;
        })

      // 下面的示例用于演示组件插入和删除时的过渡动画效果（出现和消失的动画是正好相反的）
      if (this.flag) {
        /*
         * transition() - 用于指定组件的过渡动画（即组件插入或移除时的过渡效果）
         *   effect - 效果（一个 TransitionEffect 对象）
         *     TransitionEffect.IDENTITY - 无过渡效果
         *     TransitionEffect.OPACITY - 出现效果为透明度 0 变为 1，消失效果为透明度 1 变为 0
         *     TransitionEffect.SLIDE - 出现效果为左侧滑入，消失效果为右侧滑出
         *     TransitionEffect.SLIDE_SWITCH - 出现效果为右侧先缩小再放大滑入，消失效果为左侧先缩小再放大滑出
         *     TransitionEffect.rotate() - 消失时的旋转效果，显示时的效果正好相反
         *     TransitionEffect.scale() - 消失时的缩放效果，显示时的效果正好相反
         *     TransitionEffect.translate() - 消失时的位移效果，显示时的效果正好相反
         *     注：
         *     1、调用以上属性或方法后，再调用 animation() 指定一个 AnimateParam 类型的动画参数（参见 AnimationDemo.ets 中的说明）
         *     2、关于 scale, rotate, translate 请参见 /component/shape/TransformDemo.ets 中的说明
         *   onFinish - 动画效果结束后的回调
         *     回调参数为 true 代表出现动画效果结束后的回调
         *     回调参数为 false 代表消失动画效果结束后的回调
         */
        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.IDENTITY.animation({
            duration: 2000,
            curve: Curve.Ease
          }))

        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.OPACITY.animation({
            duration: 2000,
            curve: Curve.Ease
          }), (transitionIn: boolean) => {
            this.message = `TransitionEffect.OPACITY transitionIn: ${transitionIn}`
          })

        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.SLIDE.animation({
            duration: 2000,
            curve: Curve.Ease
          }))

        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.SLIDE_SWITCH.animation({
            duration: 2000,
            curve: Curve.Ease
          }))

        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.rotate({
            z: 1,
            angle: 180
          }).animation({
            duration: 2000,
            curve: Curve.Ease
          }))

        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.scale({
            x: 0.5,
            y: 0.5
          }).animation({
            duration: 2000,
            curve: Curve.Ease
          }))

        Image($r('app.media.app_icon')).width(50).height(50)
          .transition(TransitionEffect.translate({
            y: 100
          }).animation({
            duration: 2000,
            curve: Curve.Ease
          }))
      }
    }
  }
}

@Component
struct MySample2 {

  @State flag: boolean = true;

  build() {
    Column({space:10}) {

      Button('button').width(100).height(30)
        .onClick(() => {
          this.flag = !this.flag;
        })

      // 下面的示例用于演示组件插入和删除时的过渡动画效果（出现和消失的动画是正好相反的）
      if (this.flag) {
        Image($r('app.media.app_icon')).width(100).height(100)
          .transition(
            TransitionEffect.OPACITY.animation({
              duration: 2000,
              curve: Curve.Ease
            })
              /*
               * 通过 combine() 叠加过渡动画效果，叠加的是组件消失时的效果（默认，组件显示时的效果与消失时的效果是正好相反的）
               *   TransitionEffect.rotate() - 旋转
               *   TransitionEffect.scale() - 缩放
               *   TransitionEffect.translate() - 位移
               *   注：关于 scale, rotate, translate 请参见 /component/shape/TransformDemo.ets 中的说明
               */
              .combine(
                TransitionEffect.rotate({
                  z: 1,
                  angle: 180
                }))
              .combine(
                TransitionEffect.scale({
                  x: 0.5,
                  y: 0.5
                }))
              .combine(
                TransitionEffect.translate({
                  y: 100
                }))
          )

        Image($r('app.media.app_icon')).width(100).height(100)
          .transition(
            TransitionEffect.scale({
              x: 0.5,
              y: 0.5
            }).animation({
              duration: 2000,
              curve: Curve.Ease
            })
              /*
               * 通过 combine() 叠加过渡动画效果，叠加的是组件消失时的效果（默认，组件显示时的效果与消失时的效果是正好相反的）
               *   TransitionEffect.move() - 移动到特殊位置
               *     TOP, BOTTOM, START, END
               *   TransitionEffect.opacity() - 不透明度
               */
              .combine(TransitionEffect.move(TransitionEdge.BOTTOM))
              .combine(TransitionEffect.opacity(0.5))
          )
      }
    }
  }
}

@Component
struct MySample3 {
  @State flag: boolean = true

  build() {
    Column({ space: 10 }) {

      Button('button').width(100).height(30)
        .onClick(() => {
          this.flag = !this.flag;
        })

      if (this.flag) {
        /*
         * 上面介绍的实现过渡动画效果的方法，都是使用的一个 TransitionEffect 实例，即出现效果与消失效果是完全相反的
         * TransitionEffect.asymmetric() - 用于为出现和消失指定不同的 TransitionEffect 实例
         */
        Image($r('app.media.app_icon')).width(100).height(100)
          .transition(
            TransitionEffect.asymmetric(
              // 组件出现时的过渡动画效果
              TransitionEffect.SLIDE.animation({ duration: 1000 }),
              // 组件消失时的过渡动画效果
              TransitionEffect.OPACITY.animation({ duration: 1000 })
            )
          )
      }
    }
  }
}