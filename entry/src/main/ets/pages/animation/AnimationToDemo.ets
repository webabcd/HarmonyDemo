/*
 * 显式动画
 *
 * animateTo() - 显式动画，建议使用 this.getUIContext().animateTo()
 *   指定动画效果，以及需要做动画的属性的值
 * animateToImmediately() - 高优先级的 animateTo()
 *
 * 关于动画效果请参见 AnimationDemo.ets 中的说明
 */

import { RadioBar, TitleBar } from '../TitleBar'

@Entry
@Component
struct AnimationToDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('animateTo()').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('renderFit()').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('animateToImmediately()').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State translateY:number = 0

  build() {
    Column({space:20}) {

      Column().width(100).height(100).backgroundColor(Color.Red)
        .translate({ y: this.translateY })

      Button('button')
        .onClick(() => {
          /*
           * animateTo() - 显式动画，建议使用 this.getUIContext().animateTo()
           */
          this.getUIContext().animateTo({ // 关于动画效果请参见 AnimationDemo.ets 中的说明
            duration: 1000,
            tempo: 1.0,
            curve: Curve.Linear,
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
          }, () => { // 设置需要做动画的属性的值
            this.translateY = 200
          })
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

      Text("Text").fontSize(16)
        .width(this.myWidth)
        .height(this.myHeight)
        .backgroundColor(Color.Orange)
        .textAlign(TextAlign.Center)
        .renderFit(RenderFit.CENTER)

      Text("Text").fontSize(16)
        .width(this.myWidth)
        .height(this.myHeight)
        .backgroundColor(Color.Orange)
        .textAlign(TextAlign.Center)
        .renderFit(RenderFit.RESIZE_FILL)

      Button('button')
        .onClick(() => {
          this.getUIContext().animateTo({
            duration: 1000,
            iterations: -1,
            playMode: PlayMode.Alternate,
          }, () => {
            this.myWidth = 200
            this.myHeight = 100
          })
        })
    }
  }
}

@Component
struct MySample3 {

  @State translateY:number = 0

  build() {
    Column({space:20}) {

      Column().width(100).height(100).backgroundColor(Color.Red)
        .translate({ y: this.translateY })

      /*
       * animateTo() - 高优先级的 animateTo()
       */
      Button('button')
        .onClick(() => {
          animateToImmediately({
            duration: 1000,
            iterations: -1,
            playMode: PlayMode.Alternate,
          }, () => {
            this.translateY = 200
          })
        })
    }
  }
}
