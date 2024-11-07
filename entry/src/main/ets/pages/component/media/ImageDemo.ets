/*
 * Image - 图片
 */

import { MyLog, RadioBar, TitleBar } from '../../TitleBar'
import { LengthMetrics } from '@kit.ArkUI'
import { font } from '@kit.ArkUI'

@Entry
@Component
struct ImageDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('拉伸').align(Alignment.Top)
      }
    }
  }
}

@Component
struct MySample1 {

  @State resourceStr:ResourceStr = ""
  aboutToAppear() {
    setTimeout(() => this.resourceStr = $r('app.media.loading'), 3000);
  }

  build() {
    Column({space: 10}) {

      /*
       * Image - 图片
       *   src - 支持 png, jpg, bmp, svg, gif, heif 等类型
       *   alt - 用于指定图片在加载过程中的占位图
       */

      Image($r('app.media.son'))
        .width(100).height(100)

      // 可以直接显示 gif 动画
      Image($r('app.media.loading'))
        .width(100).height(100)

      Image(this.resourceStr)
        .alt($r('app.media.son'))
        .width(100).height(100)
    }
  }
}

@Component
struct MySample2 {

  @State imageFit: ImageFit = ImageFit.Auto
  valueList =  ["Contain", "Cover", "Auto", "Fill", "ScaleDown", "None", "TOP_START", "TOP", "TOP_END", "START", "CENTER", "END", "BOTTOM_START", "BOTTOM", "BOTTOM_END"]

  build() {
    Column({space: 10}) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.imageFit = ImageFit[this.valueList[selectedIndex]]
      }})

      /*
       * objectFit() - 拉伸方式
       *   Contain - 等比拉伸到目标大小，不剪裁，可能有黑边（本例所谓的黑边只是一个形容，实际要看父的颜色，可能是透明的，也可能是其他颜色）
       *   Cover - 等比拉伸到目标大小，并剪裁，不会有黑边
       *   Fill - 拉伸到目标大小，可能会变形
       *   TOP_START, TOP, TOP_END, START, CENTER, END, BOTTOM_START, BOTTOM, BOTTOM_END - 图片以原始大小显示在这些位置上
       */
      Image($r('app.media.son'))
        .width(300).height(200)
        .backgroundColor(Color.Orange)
        .objectFit(this.imageFit)

    }
  }
}
