/*
 * Marquee - 跑马灯
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct MarqueeDemo {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * Marquee - 跑马灯
       *   start - 是否播放跑马灯
       *   step - 跑马灯每次滚动的距离（默认 6vp），即跑马灯的速度
       *   loop - 重复滚动的次数（默认值为 -1 即无限循环）
       *   fromStart - 跑马灯滚动的方向
       *     true - 文字从右往左跑
       *     false - 文字从左往右跑
       *   src - 跑马灯的文字
       *   fontColor(), fontSize(), fontWeight(), fontFamily() - 设置文字的相关样式
       *   marqueeUpdateStrategy() - 跑马灯更新后的滚动策略（MarqueeUpdateStrategy 枚举）
       *     DEFAULT - 跑马灯组件属性更新后，从开始位置重新播放跑马灯
       *     PRESERVE_POSITION - 跑马灯组件属性更新后，保持当前位置继续播放跑马灯
       *   onStart() - 开始滚动时的回调
       *   onBounce() - 每完整滚动完成一次，触发一次回调
       *   onFinish() - 滚动的全部循环次数完成后触发的回调
       */
      Marquee({
        start: true,
        step: 6,
        loop: -1,
        fromStart: true,
        src: 'HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。'
      })
        .width(300)
        .height(100)
        .backgroundColor(Color.Orange)
        .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
        .fontColor(Color.White)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyOS Sans')
        .onStart(() => {
          this.message = "onStart()"
        })
        .onBounce(() => {
          this.message = "onBounce()"
        })
        .onFinish(() => {
          this.message = "onFinish()"
        })
    }
  }
}