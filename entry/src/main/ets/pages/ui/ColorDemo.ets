/*
 * 颜色相关
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct ColorDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // Color 类型的枚举（White, Black, Blue, Brown, Gray, Green, Grey, Orange, Pink, Red, Yellow, Transparent）
      Column().width(200).height(50)
        .backgroundColor(Color.Blue)

      // number 类型的 rgb
      Column().width(200).height(50)
        .backgroundColor(0x0000ff)

      // number 类型的 argb
      Column().width(200).height(50)
        .backgroundColor(0xff0000ff)

      // string 类型的 rgb
      // string 类型的 argb
      // string 类型的 ‘rgb(0, 0, 255)’
      // string 类型的 ‘rgba(0, 0, 255, 255)’
      Column().width(200).height(50)
        .backgroundColor('#ff0000ff')

      // Resource 类型的颜色资源
      // 先在 /entry/src/main/resources/base/element/color.json 配置如下
      // {
      //   "color": [
      //     {
      //       "name": "color_demo",
      //       "value": "#0000FF"
      //     }
      //   ]
      // }
      // 然后通过 $r("app.color.color_demo") 引用此颜色资源
      Column().width(200).height(50)
        .backgroundColor($r("app.color.color_demo"))

      // opacity() - 不透明度（0 - 1 之间）
      Column().width(200).height(50)
        .backgroundColor(Color.Blue)
        .opacity(0.1)
    }
  }
}