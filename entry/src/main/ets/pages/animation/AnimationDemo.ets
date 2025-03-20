/*
 * 属性动画
 *
 * 通过 animation() 实现属性动画（当某些属性的值发生变化时，执行对应的动画效果）
 * 支持的属性有 width, height, backgroundColor, opacity, scale, rotate, translate 等，这些属性称之为可动画属性
 * 如果想让不可动画属性支持 animation() 动画，则可以通过 @AnimatableExtend 结合 AnimatableArithmetic<T> 实现，详见 AnimatableExtendDemo.ets 中的说明
 *
 * 关于 scale, rotate, translate 请参见 /component/shape/TransformDemo.ets 中的说明
 */

import { RadioBar, TitleBar } from '../TitleBar'

@Entry
@Component
struct AnimationDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('animation()').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('renderFit()').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State translateY:number = 0
  @State translateX:number = 0

  @State curve: Curve = Curve.Linear
  curve_valueList =  ["Linear", "Ease", "EaseIn", "EaseOut", "EaseInOut", "FastOutSlowIn", "LinearOutSlowIn", "FastOutLinearIn", "ExtremeDeceleration", "Sharp", "Rhythm", "Smooth", "Friction"]

  build() {
    Column({space:20}) {

      RadioBar({valueList: this.curve_valueList, onChange: (selectedIndex: number) => {
        this.curve = Curve[this.curve_valueList[selectedIndex]]
      }})

      /*
       * animation() - 属性动画（指定一个 AnimateParam 对象）
       *   duration - 动画时长（单位：毫秒）
       *   tempo - 动画速度，默认值为 1.0，越大越快，越小越慢
       *   curve - 动画曲线，即动画的缓动类型（Curve 枚举）
       *   delay - 动画的延迟播放时间（单位：毫秒）
       *   iterations - 动画的播放次数（0 代表无动画，-1 代表无线循环）
       *   playMode - 动画的播放模式（PlayMode 枚举）
       *     Normal - 正向播放
       *     Reverse - 反向播放
       *     Alternate - 动画在第奇数次播放时为正向播放，动画在第偶数次播放时为反向播放
       *     AlternateReverse - 动画在第奇数次播放时为反向播放，动画在第偶数次播放时为正向播放
       *   expectedFrameRateRange - 动画的期望帧率
       *     min - 期望的最小帧率
       *     max - 期望的最大帧率
       *     expected - 期望的最优帧率
       *   onFinish - 动画播放完成后的回调
       */
      Column().width(100).height(100).backgroundColor(Color.Red)
        .translate({ y: this.translateY })
        .animation(
          {
            duration: 1000,
            tempo: 1.0,
            curve: this.curve,
            delay: 0,
            iterations: 1,
            playMode: PlayMode.Normal,
            expectedFrameRateRange: {
              min: 20,
              max: 120,
              expected: 90,
            },
            onFinish: () => {
              this.translateY = 0
            }
          })

      Column().width(100).height(100).backgroundColor(Color.Green)
        .translate({ x: this.translateX })
        .animation(
          {
            duration: 1000,
            iterations: 5,
            playMode: PlayMode.Alternate,
          })

      Button('button')
        .onClick(() => {
          this.translateY = 200
          this.translateX = 200
        })
    }
  }
}

@Component
struct MySample2 {

  @State myWidth:number = 100
  @State myHeight:number = 50

  build() {
    Column({space:20}) {

      /*
       * renderFit() - 在宽高变化的动画中，组件内容的填充方式（RenderFit 枚举）
       *   CENTER, TOP, BOTTOM, LEFT, RIGHT, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT, RESIZE_FILL, RESIZE_CONTAIN, RESIZE_CONTAIN_TOP_LEFT, RESIZE_CONTAIN_BOTTOM_RIGHT, RESIZE_COVER, RESIZE_COVER_TOP_LEFT
       */

      Text("Text").fontSize(16)
        .width(this.myWidth)
        .height(this.myHeight)
        .backgroundColor(Color.Orange)
        .textAlign(TextAlign.Center)
        .animation({
          duration: 1000,
          iterations: -1,
          playMode: PlayMode.Alternate,
        })

      Text("Text").fontSize(16)
        .width(this.myWidth)
        .height(this.myHeight)
        .backgroundColor(Color.Orange)
        .textAlign(TextAlign.Center)
        .renderFit(RenderFit.CENTER)
        .animation({
          duration: 1000,
          iterations: -1,
          playMode: PlayMode.Alternate,
        })

      Text("Text").fontSize(16)
        .width(this.myWidth)
        .height(this.myHeight)
        .backgroundColor(Color.Orange)
        .textAlign(TextAlign.Center)
        .renderFit(RenderFit.RESIZE_FILL)
        .animation({
          duration: 1000,
          iterations: -1,
          playMode: PlayMode.Alternate,
        })

      Button('button')
        .onClick(() => {
          this.myWidth = 200
          this.myHeight = 100
        })
    }
  }
}