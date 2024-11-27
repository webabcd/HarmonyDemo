/*
 * QRCode - 二维码
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct QRCodeDemo {

  build() {
    Column({space:10}) {
      TitleBar()

      /*
       * QRCode - 二维码
       *   color() - 二维码的颜色
       *   backgroundColor() - 二维码的背景颜色
       *   contentOpacity() - 二维码的不透明度（注：不包括背景和边框等）
       */

      QRCode("abc").width(100).height(100)

      QRCode("abc").width(100).height(100)
        .color(Color.Red)
        .backgroundColor(Color.Orange)
        .borderColor(Color.Blue)
        .borderWidth(5)

      QRCode("abc").width(100).height(100)
        .color(Color.Red)
        .backgroundColor(Color.Orange)
        .borderColor(Color.Blue)
        .borderWidth(5)
        .contentOpacity(0.3)
    }
  }
}