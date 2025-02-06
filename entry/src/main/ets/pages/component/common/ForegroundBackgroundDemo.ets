/*
 * 前景和背景
 *
 * 注：关于前景和背景的模糊和滤镜，请参见 /shape/BlurDemo.ets 中的说明
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct ForegroundBackgroundDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('前景').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('背景').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {
  build() {
    Column({space:10}) {

      /*
       * foregroundColor() - 前景色
       *   指定一个颜色值
       *   如果指定为 ColoringStrategy.INVERT 则代表背景色的反色
       * foregroundEffect() - 前景色效果
       *   radius - 模糊半径
       */

      Circle().width(200).height(100).backgroundColor(Color.Blue)
        .foregroundColor(Color.Red)

      Circle().width(200).height(100).backgroundColor(Color.Blue)
        .foregroundColor(ColoringStrategy.INVERT)

      Rect().width(200).height(100)
        .foregroundColor(Color.Blue)
        .foregroundEffect({
          radius: 20
        })
    }
  }
}

@Component
struct MySample2 {

  @Builder myBuilder() {
    Circle().width(40).height(40).backgroundColor(Color.Green)
  }

  build() {
    Column({space:10}) {

      /*
       * backgroundImage() - 背景图片
       *   src - 图片
       *   repeat - 图片填充父容器时的重复方式（ImageRepeat 枚举）
       *     NoRepeat - 不重复
       *     XY - 在两个轴上都重复
       *     X - 仅在水平轴上重复
       *     Y - 仅在垂直轴上重复
       * backgroundImageSize() - 背景图片尺寸
       *   可以设置 width 和 height
       *   可以设置 ImageSize 枚举
       *     Auto - 自动，宽高比不变
       *     Cover - 等比拉伸到目标大小，并剪裁，不会有黑边
       *     Contain - 等比拉伸到目标大小，不剪裁，可能有黑边
       *     FILL - 拉伸到目标大小，可能会变形
       * backgroundImagePosition - 背景图片相对于父容器的显示位置
       *   可以设置 x 和 y
       *   可以设置 Alignment 枚举
       *     TopStart, Top, TopEnd, Start, Center, End, BottomStart, Bottom, BottomEnd
       * background() - 自定义背景
       *   builder - 指定一个自定义组件
       *   options - 自定义背景相对于父容器的对齐方式（Alignment 枚举）
       *     TopStart, Top, TopEnd, Start, Center, End, BottomStart, Bottom, BottomEnd
       *
       * backgroundBrightness() - 背景亮度
       *   rate - 亮度变化的速率（0 到无限大），默认值为 0
       *   lightUpDegree - 提亮程度（-1 到 1 之间），默认值为 0
       *   注：亮度增加值为 -rate * 像素点灰阶值（归一到 0 到 1 之间） + lightUpDegree
       *   例：像素点灰阶值为 0.2，rate 为 0.5，lightUpDegree 为 0.5，则亮度增加值为 -0.5 * 0.2 + 0.5 = 0.4
       * backgroundEffect() - 背景效果
       *   radius - 模糊半径
       *   saturation - 饱和度（0 到 50 之间），默认值为 1
       *   brightness - 亮度（0 到 2 之间），默认值为 1
       */

      Column() {
        Column().width('100%').height('100%')
          .backgroundImage($r('app.media.son'), ImageRepeat.NoRepeat)
          .backgroundImageSize({
            width: 80,
            height: 40
          })
          .backgroundImagePosition(Alignment.BottomEnd)
      }.width(100).height(50).backgroundColor(Color.Red)

      Column() {
        Column().width('100%').height('100%')
          .backgroundImage($r('app.media.son'), ImageRepeat.NoRepeat)
          .backgroundImageSize(ImageSize.Cover)
          .backgroundImagePosition({
            x: 10,
            y: 10
          })
      }.width(100).height(50).backgroundColor(Color.Red)

      Column() {
        Column().width('100%').height('100%')
          .backgroundImage($r('app.media.son'), ImageRepeat.XY)
          .backgroundImageSize({
            width: 10,
            height: 10
          })
      }.width(100).height(50).backgroundColor(Color.Red)

      Column() {
        Column().width('100%').height('100%')
          .background(this.myBuilder(), {
            align: Alignment.BottomEnd
          })
      }.width(100).height(50).backgroundColor(Color.Red)

      Column().width(100).height(100)
        .backgroundImage($r('app.media.son'))
        .backgroundImageSize(ImageSize.FILL)
        .backgroundBrightness({
          rate: 0.5,
          lightUpDegree: 0.5
        })

      Column().width(100).height(100)
        .backgroundImage($r('app.media.son'))
        .backgroundImageSize(ImageSize.FILL)
        .backgroundEffect({
          radius: 1,
          saturation: 5,
          brightness: 1.2
        })
    }
  }
}
