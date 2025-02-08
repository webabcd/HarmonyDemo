/*
 * 图像效果
 */

import { RadioBar, TitleBar } from '../TitleBar'
import { Helper } from '../Helper'

@Entry
@Component
struct EffectDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('常用效果').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('离屏渲染').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('子组件与父容器的混合方式').align(Alignment.Top)
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
    Column({ space: 10 }) {

      Image($r('app.media.son')).width('90%').height(50)

      // grayscale() - 灰度效果（0 到 1 之间，1 代表完全灰色），默认值为 0
      Image($r('app.media.son')).width('90%').height(50).grayscale(1)

      // sepia() - 深褐色效果（0 到 1 之间，1 代表颜色完全深褐色），默认值为 0
      Image($r('app.media.son')).width('90%').height(50).sepia(1.0)

      // brightness() - 亮度效果（0 到 2 之间），默认值为 1
      Image($r('app.media.son')).width('90%').height(50).brightness(1.2)

      // saturate() - 饱和度效果（0 到 50 之间），默认值为 1
      Image($r('app.media.son')).width('90%').height(50).saturate(2.0)

      // contrast() - 对比度效果（0 到 10 之间），默认值为 1
      Image($r('app.media.son')).width('90%').height(50).contrast(2.0)

      // invert() - 颜色反转效果（0 到 1 之间，1 代表颜色完全反转），默认值为 0
      Image($r('app.media.son')).width('90%').height(50).invert(1.0)

      // hueRotate() - 色相旋转效果，指定一个旋转角度，默认值为 0
      Image($r('app.media.son')).width('90%').height(50).hueRotate(90)

      // colorBlend() - 颜色叠加效果
      Image($r('app.media.son')).width('90%').height(50).colorBlend(Color.Red)
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column({space:10}) {

      /*
       * renderGroup() - 用于设置当前组件是否需要离屏渲染（默认值为 false）
       * 离屏渲染的意思是，将图像渲染过程从直接显示的屏幕缓冲区转移到一个不直接可见的缓冲区进行处理，处理完成之后再绘制，其好处是不会影响主线程
       *
       * 注：启用离屏渲染后，当组件的 opacity 不为 1 时，子组件的绘制结果可能会与预期不符
       */

      Column() {
        Column().width(50).height(50).backgroundColor(Color.Blue)
      }
      .width(100).height(100).backgroundColor(Color.Red).alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center)
      .opacity(0.3)
      .renderGroup(false)

      Column() {
        Column().width(50).height(50).backgroundColor(Color.Blue)
      }
      .width(100).height(100).backgroundColor(Color.Red).alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center)
      .opacity(0.3)
      .renderGroup(true)
    }
  }
}

@Component
struct MySample3 {

  @State myBlendMode: BlendMode = BlendMode.NONE
  valueList = Helper.enumToString(BlendMode)

  build() {
    Column({space:10}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.myBlendMode = BlendMode[this.valueList[selectedIndex]]
      }})

      /*
       * blendMode() - 用于设置子组件与父容器的混合方式
       *   value - 混合方式（BlendMode 枚举）
       *   type - 一个 BlendApplyType 枚举
       *     FAST - 默认渲染方式
       *     OFFSCREEN - 离屏渲染方式
       */

      Column() {
        Circle()
          .width(100)
          .height(100)
          .fill(Color.Orange)
          .blendMode(this.myBlendMode, BlendApplyType.OFFSCREEN)
      }
      .height(200)
      .width(200)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundImage($r('app.media.son'))
      .backgroundImageSize(ImageSize.FILL)
    }
  }
}