/*
 * 关键帧动画
 *
 * this.getUIContext().keyframeAnimateTo() - 关键帧动画
 *   可以指定动画中，不同时间点的关键帧的状态
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct KeyframeAnimateDemo {

  @State myScale: number = 1.0;

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Column().width(100).height(100).backgroundColor(Color.Red)
        .scale({ x: this.myScale, y: this.myScale })
        .onClick(() => {
          this.myScale = 1;
          /*
           * this.getUIContext().keyframeAnimateTo() - 关键帧动画
           *   param - 动画参数（KeyframeAnimateParam 对象）
           *     delay - 动画的延迟播放时间（单位：毫秒）
           *     iterations - 动画的播放次数（0 代表无动画，-1 代表无线循环）
           *     onFinish - 动画播放完成后的回调
           *   keyframes - 关键帧状态集合（KeyframeState 对象集合）
           *     duration - 此关键帧时间点与上一个关键帧时间点之间的时长（单位：毫秒）
           *     curve - 动画曲线，即动画的缓动类型（参见 AnimationDemo.ets 中的说明）
           *     event - 在此处指定此关键帧需要达到的状态
           */
          this.getUIContext().keyframeAnimateTo({
            delay: 0,
            iterations: 3,
            onFinish: () => {

            }
          }, [
            {
              // 第 1 段关键帧动画时长 200 毫秒，scale 1 到 1.5 做动画
              duration: 200,
              event: () => {
                this.myScale = 1.5;
              }
            },
            {
              // 第 2 段关键帧动画时长 2000 毫秒，scale 1.5 到 1 做动画
              duration: 2000,
              event: () => {
                this.myScale = 1;
              }
            }
          ]);
        })
    }
  }
}