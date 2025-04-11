/*
 * 单位相关
 * vp, lpx, px, fp, 百分比
 */

import { TitleBar } from '../TitleBar';
import { display, LengthMetrics } from '@kit.ArkUI';

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
    this.message += `densityDPI: ${ui.densityDPI}`
    this.message += '\n'
    // 逻辑像素的密度，比如此值为 3 时 1vp 等于 3px
    this.message += `densityPixels: ${ui.densityPixels}`
    this.message += '\n'
    // 字体像素的密度，比如此值为 3 时 1fp 等于 3px
    this.message += `scaledDensity: ${ui.scaledDensity}`
    this.message += '\n'
    // 屏幕宽度，单位 px
    this.message += `width: ${ui.width}px`
    this.message += '\n'
    // 屏幕高度，单位 px
    this.message += `height: ${ui.height}px`
    this.message += '\n'
    // 屏幕宽度，单位 vp
    this.message += `width: ${context.px2vp(ui.width)}vp`
    this.message += '\n'
    // 屏幕高度，单位 vp
    this.message += `height: ${context.px2vp(ui.height)}vp`
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
      .height(30)
      .backgroundColor(Color.Blue)

      // 百分比，相对于父容器的百分比
      Column().backgroundColor(Color.Blue)
        .width('80%')
        .height('5%')

      // 整型，单位是 vp
      Column().backgroundColor(Color.Blue)
        .width(200)
        .height(30)

      // 整型的字符串，单位是 vp
      Column().backgroundColor(Color.Blue)
        .width('200')
        .height('30')

      // vp，与屏幕的像素密度相关，逻辑分辨率
      Column().backgroundColor(Color.Blue)
        .width('200vp')
        .height('30vp')

      // px，像素，真实分辨率
      Column().backgroundColor(Color.Blue)
        .width('200px')
        .height('30px')

      // lpx，与 designWidth 相关
      // 比如 designWidth 是 720，真实宽度是 1440px，则 1lpx 等于 2px
      // designWidth 是在 main_pages.json 文件（在 module.json5 中通过 "pages":"$profile:main_pages" 指定的）中配置的，说明如下
      // {
      //   "window": {
      //     "designWidth": 720, // 设计的基准宽度，与 lpx 相关，缺省值为 720
      //     "autoDesignWidth": false // 是否根据屏幕的像素密度自动计算 designWidth 的值，此值配置为 true 时则会忽略 designWidth 配置的值，缺省值为 false
      //   }
      // }
      Column().backgroundColor(Color.Blue)
        .width('200lpx')
        .height('30lpx')

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
        .height($r("app.integer.30"))

      // LengthMetrics - 用于设置长度属性，有的地方需要使用 LengthMetrics 类型的值，可以通过类似如下的方式指定
      //   LengthMetrics.vp()
      //   LengthMetrics.px()
      //   LengthMetrics.fp()
      //   LengthMetrics.lpx()
      //   LengthMetrics.percent()
      //   LengthMetrics.resource()
      Text('HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。')
        .width(200)
        .height(60)
        .fontSize(14)
        .lineSpacing(LengthMetrics.vp(10))
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)

      Text(this.message)
    }
  }
}