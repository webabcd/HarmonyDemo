/*
 * Badge -
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct BadgeDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Column() {
        Badge({
          value: '',
          style: { badgeSize: 6, badgeColor: '#FA2A2D' }
        }) {
          Image($r('app.media.son'))
            .width(24)
            .height(24)
        }
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
        Text('Tab')
          .fontColor('#182431')
          .fontSize(10)
          .fontWeight(500)
          .lineHeight(14)
      }.width('100%').height('100%').justifyContent(FlexAlign.Center)
    }
  }
}