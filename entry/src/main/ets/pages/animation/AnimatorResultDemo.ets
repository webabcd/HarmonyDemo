/*
 * AnimatorResult - number 动画
 * 用于对一个 number 值做动画处理
 */

import { TitleBar } from '../TitleBar'
import { Animator as animator, AnimatorResult } from '@kit.ArkUI';

@Entry
@Component
struct AnimatorResultDemo {

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

  animatorResult: AnimatorResult | undefined = undefined

  @State myWidth: number = 100
  @State myHeight: number = 100

  @State message: string = ""

  aboutToAppear() {
    /*
     * animator.create() 或 this.getUIContext().createAnimator() - 通过传入一个 AnimatorOptions 对象来创建一个 AnimatorResult 对象
     * 注：建议使用 this.getUIContext().createAnimator()
     *
     * AnimatorOptions - 动画选项
     *   duration - 动画时长（单位：毫秒）
     *   easing - 动画曲线，即动画的缓动类型（关于不同动画曲线的效果，可以参见 CurveDemo.ets 中的相关说明）
     *     linear, ease, ease-in, ease-out, ease-in-out, fast-out-slow-in, linear-out-slow-in, fast-out-linear-in, friction, extreme-deceleration, rhythm, sharp, smooth 等
     *   delay - 动画的延迟播放时间（单位：毫秒）
     *   fill - 用于指定播放停止后的停留帧
     *     none - 停留在第 1 帧
     *     forwards - 停留在最后一帧
     *   iterations - 动画的播放次数（0 代表无动画，-1 代表无线循环）
     *   direction - 动画的播放方向
     *     normal - 正向播放
     *     reverse - 反向播放
     *     alternate - 动画在第奇数次播放时为正向播放，动画在第偶数次播放时为反向播放
     *     alternate-reverse - 动画在第奇数次播放时为反向播放，动画在第偶数次播放时为正向播放
     *   begin - 动画的初始 number 值
     *   end - 动画的结束 number 值
     *
     * AnimatorResult - number 动画，用于对一个 number 值做动画处理（此 number 动画的相关参数是由 AnimatorOptions 指定的）
     *   onFinish() - 动画完成时的回调
     *   onRepeat() - 动画重复时的回调
     *   onCancel() - 动画取消时的回调
     *   onFrame() - 动画中 number 值发生变化时的回调，回调参数为当前 number 值
     *   setExpectedFrameRateRange() - 设置期望帧率的范围（指定一个 ExpectedFrameRateRange 对象）
     *     expected - 期望的最优帧率
     *     min - 期望的最小帧率
     *     max - 期望的最大帧率
     *   play() - 播放动画
     *   pause() - 暂停动画
     *   finish() - 结束动画
     *   reverse() - 反向播放动画
     *   cancel() - 取消动画
     *   reset() - 指定一个新的 AnimatorOptions 对象
     */
    // this.animatorResult = this.getUIContext().createAnimator({
    this.animatorResult = animator.create({
      duration: 2000,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      iterations: 1,
      direction: "normal",
      begin: 100,
      end: 200
    })
    this.animatorResult.onFinish = () => {
      this.message = "onFinish"
    }
    this.animatorResult.onRepeat = () => {
      this.message = "onRepeat"
    }
    this.animatorResult.onCancel = () => {
      this.message = "onCancel"
    }
    this.animatorResult.onFrame = (value: number) => {
      this.message = `onFrame: ${value}`
      this.myWidth = value
      this.myHeight = value
    }

    let expectedFrameRateRange: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 30
    }
    this.animatorResult.setExpectedFrameRateRange(expectedFrameRateRange);
  }

  aboutToDisappear() {
    // 因为 animatorResult 的 onFrame() 回调中引用了 this，为了避免内存泄漏，需要在适当的时候将 animatorResult 置空
    this.animatorResult = undefined;
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      Column() {
        Column().width(this.myWidth).height(this.myHeight).backgroundColor(Color.Red)
      }
      .width(200)
      .height(200)

      Button('play').onClick(() => {
        this.animatorResult?.play()
      })

      Button('pause').onClick(() => {
        this.animatorResult?.pause()
      })

      Button('finish').onClick(() => {
        this.animatorResult?.finish()
      })

      Button('reverse').onClick(() => {
        this.animatorResult?.reverse()
      })

      Button('cancel').onClick(() => {
        this.animatorResult?.cancel()
      })

      Button('reset').onClick(() => {
        this.animatorResult?.reset({
          duration: 2000,
          easing: "ease",
          delay: 0,
          fill: "forwards",
          direction: "alternate",
          iterations: -1,
          begin: 50,
          end: 150
        })
      })
    }
  }
}
