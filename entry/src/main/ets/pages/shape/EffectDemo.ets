/*
 *
 */

import { TitleBar } from '../TitleBar'
import { uiEffect } from '@kit.ArkGraphics2D'

@Entry
@Component
struct EffectDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('常用效果').align(Alignment.Top)
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