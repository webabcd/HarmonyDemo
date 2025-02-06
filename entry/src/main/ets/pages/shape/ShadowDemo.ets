/*
 * 阴影相关
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct ShadowDemo {
  build() {
    Column({ space: 30 }) {
      TitleBar()

      /*
       * shadow() - 可以指定内置的阴影效果（ShadowStyle 枚举）
       *   OUTER_DEFAULT_XS, OUTER_DEFAULT_SM, OUTER_DEFAULT_MD, OUTER_DEFAULT_LG, OUTER_FLOATING_SM, OUTER_FLOATING_MD
       */
      Column() {
        Text('shadow').fontSize(12)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.Orange)
      .borderRadius(20)
      .shadow(ShadowStyle.OUTER_DEFAULT_MD)

      /*
       * shadow() - 可以指定自定义的阴影效果（一个 ShadowOptions 对象）
       *   radius - 阴影半径
       *   color - 阴影颜色
       *   offsetX - 阴影 X 轴方向上的偏移量
       *   offsetY - 阴影 Y 轴方向上的偏移量
       *   fill - 阴影是否内部填充
       */
      Column() {
        Text('shadow').fontSize(12)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.Orange)
      .borderRadius(20)
      .opacity(0.7)
      .shadow({
        radius: 10,
        color: Color.Gray,
        offsetX: 20,
        offsetY: 20,
        fill: false
      })

      Column() {
        Text('shadow').fontSize(12)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.Orange)
      .borderRadius(20)
      .opacity(0.7)
      .shadow({
        radius: 10,
        color: Color.Gray,
        offsetX: 20,
        offsetY: 20,
        fill: true
      })
    }
  }
}