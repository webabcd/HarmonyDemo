/*
 * 模糊相关
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct BlurDemo {
  @State myWidth: number = 100
  @State myHeight: number = 100

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // backdropBlur() - 仅对组件的背景做模糊处理
      //   指定的值越大模糊的越狠
      Column(){
        Text('blur').fontSize(24).fontColor(Color.Red)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundImage($r('app.media.son'))
      .backgroundImageSize({ width: 100, height: 100 })
      .backdropBlur(10)

      // blur() - 对组件整体做模糊处理
      //   指定的值越大模糊的越狠
      Column(){
        Text('blur').fontSize(24).fontColor(Color.Red)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundImage($r('app.media.son'))
      .backgroundImageSize({ width: 100, height: 100 })
      .blur(10)

      // backgroundBlurStyle() - 仅对组件的背景做模糊处理，并指定模糊的样式
      //   BlurStyle 枚举
      Column(){
        Text('blur').fontSize(24).fontColor(Color.Red)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundImage($r('app.media.son'))
      .backgroundImageSize({ width: 100, height: 100 })
      .backgroundBlurStyle(BlurStyle.Thin, {
        scale: 0.2 // 模糊的程度 0 - 1 之间，越大越狠
      })

      // foregroundBlurStyle() - 对组件整体做模糊处理，并指定模糊的样式
      //   BlurStyle 枚举
      Column(){
        Text('blur').fontSize(24).fontColor(Color.Red)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundImage($r('app.media.son'))
      .backgroundImageSize({ width: 100, height: 100 })
      .foregroundBlurStyle(BlurStyle.Thin, {
        scale: 0.2 // 模糊的程度 0 - 1 之间，越大越狠
      })

      // motionBlur() - 运动模糊效果
      //   radius - 模糊半径，值越大模糊的越狠
      //   anchor - 运动模糊锚点坐标（其中的 x, y 的取值范围都是 0 - 1 之间）
      Column(){
        Text('blur').fontSize(24).fontColor(Color.Red)
      }
      .width(this.myWidth)
      .height(this.myHeight)
      .justifyContent(FlexAlign.Center)
      .backgroundImage($r('app.media.son'))
      .backgroundImageSize({ width: this.myWidth, height: this.myHeight })
      .onClick(() => {
        if (this.myWidth != 100) {
          this.myWidth = 100;
          this.myHeight = 100;
        } else {
          this.myWidth = 200;
          this.myHeight = 200;
        }
      })
      .animation({
        duration: 1000,
        curve: Curve.EaseInOut,
      })
      .motionBlur({
        radius: 5,
        anchor: {
          x: 0.5,
          y: 0.5,
        }
      })
    }
  }
}