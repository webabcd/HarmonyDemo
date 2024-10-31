/*
 * 单位相关
 * vp, lpx, px, fp, 百分比
 */

import { TitleBar } from '../TitleBar';
import { display } from '@kit.ArkUI';

@Entry
@Component
struct UnitDemo {

  @State message: string = ''

  aboutToAppear() {
    let context = this.getUIContext()
    let ui = display.getDefaultDisplaySync()

    // vp, lpx, fp, px 之间的相互转换
    this.message += `1vp ${context.vp2px(1)}px`
    this.message += '\n'
    this.message += `1lpx ${context.lpx2px(1)}px`
    this.message += '\n'
    this.message += `1fp ${context.fp2px(1)}px`
    this.message += '\n'

    // dpi(Dots Per Inch) 每英寸点数
    this.message += `densityDPI ${ui.densityDPI}`
    this.message += '\n'
    // 逻辑像素的密度，比如此值为 3 时 1vp 等于 3px
    this.message += `densityPixels ${ui.densityPixels}`
    this.message += '\n'
    // 字体像素的密度，比如此值为 3 时 1fp 等于 3px
    this.message += `scaledDensity ${ui.scaledDensity}`
    this.message += '\n'
    // 屏幕宽度，单位 px
    this.message += `width ${ui.width}`
    this.message += '\n'
    // 屏幕高度，单位 px
    this.message += `height ${ui.height}`
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 'auto' 就是自适应的意思
      Column() {
        Column() {
          Text('123')
        }.width('auto').height('auto').backgroundColor(Color.Orange)
      }
      .width(200)
      .height(50)
      .backgroundColor(Color.Blue)

      // 百分比，相对于父容器的百分比
      Column().backgroundColor(Color.Blue)
        .width('80%')
        .height('5%')

      // 整型，单位是 vp
      Column().backgroundColor(Color.Blue)
        .width(200)
        .height(50)

      // 整型的字符串，单位是 vp
      Column().backgroundColor(Color.Blue)
        .width('200')
        .height('50')

      // vp，与屏幕的像素密度相关，逻辑分辨率
      Column().backgroundColor(Color.Blue)
        .width('200vp')
        .height('50vp')

      // px，像素，真实分辨率
      Column().backgroundColor(Color.Blue)
        .width('200px')
        .height('50px')

      // lpx，与 designWidth 相关
      // 比如 designWidth 是 720，真实宽度是 1440px，则 1lpx 等于 2px
      // designWidth 是在 /entry/src/main/resources/base/profile/main_pages.json 文件中配置的，说明如下
      // {
      //   "window": {
      //     "designWidth": 720, // 设计的基准宽度，与 lpx 相关，缺省值为 720
      //     "autoDesignWidth": false // 是否根据屏幕的像素密度自动计算 designWidth 的值，此值配置为 true 时则会忽略 designWidth 配置的值，缺省值为 false
      //   }
      // }
      Column().backgroundColor(Color.Blue)
        .width('200lpx')
        .height('50lpx')

      // fp，字体大小，与屏幕的像素密度相关，且与系统字体大小的设置相关
      Text("单位包括 vp, lpx, px, fp, 百分比").width(200).height(50).backgroundColor(Color.Blue).fontColor(Color.White)
        .fontSize('16fp')

      // 从资源文件中引用，配置在 /entry/src/main/resources/base/element/integer.json 文件，其内容如下
      // {
      //   "integer": [
      //     {
      //       "name": "200",
      //       "value": 200
      //     },
      //     {
      //       "name": "50",
      //       "value": 50
      //     }
      //   ]
      // }
      Column().backgroundColor(Color.Blue)
        .width($r("app.integer.200"))
        .height($r("app.integer.50"))

      Text(this.message)
    }
  }
}