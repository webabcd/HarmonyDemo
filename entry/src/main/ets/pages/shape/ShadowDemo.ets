/*
 * 阴影相关
 */

import { RadioBar, TitleBar } from '../TitleBar'

@Entry
@Component
struct ShadowDemo {

  @State shadowStyle: ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD
  valueList =  ["OUTER_DEFAULT_XS", "OUTER_DEFAULT_SM", "OUTER_DEFAULT_MD", "OUTER_DEFAULT_LG", "OUTER_FLOATING_SM", "OUTER_FLOATING_MD"]

  build() {
    Column({ space: 30 }) {
      TitleBar()

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.shadowStyle = ShadowStyle[this.valueList[selectedIndex]]
      }})

      /*
       * shadow() - 可以指定内置的阴影效果（ShadowStyle 枚举）
       *   OUTER_DEFAULT_XS, OUTER_DEFAULT_SM, OUTER_DEFAULT_MD, OUTER_DEFAULT_LG, OUTER_FLOATING_SM, OUTER_FLOATING_MD
       */
      Column() {
        Text('shadow').fontSize(12)
      }.width(100).height(100).justifyContent(FlexAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
      .shadow(this.shadowStyle)

      /*
       * shadow() - 可以指定自定义的阴影效果（一个 ShadowOptions 对象）
       *   radius - 阴影半径
       *   color - 阴影颜色
       *   offsetX - 阴影 X 轴方向上的偏移量
       *   offsetY - 阴影 Y 轴方向上的偏移量
       *   type - 阴影类型（ShadowType 枚举）
       *     COLOR - 按照指定的阴影颜色实现阴影效果
       *     BLUR - 按照组件边缘模糊的方式实现阴影效果
       *   fill - 阴影是否内部填充
       */
      Column() {
        Text('shadow').fontSize(12)
      }.width(100).height(100).justifyContent(FlexAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
      .opacity(0.7)
      .shadow({
        radius: 10,
        color: Color.Gray,
        offsetX: 20,
        offsetY: 20,
        type: ShadowType.COLOR,
        fill: false
      })

      Column() {
        Text('shadow').fontSize(12)
      }.width(100).height(100).justifyContent(FlexAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
      .opacity(0.7)
      .shadow({
        radius: 10,
        offsetX: 20,
        offsetY: 20,
        type: ShadowType.BLUR,
        fill: false
      })

      Column() {
        Text('shadow').fontSize(12)
      }.width(100).height(100).justifyContent(FlexAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
      .opacity(0.7)
      .shadow({
        radius: 10,
        color: Color.Gray,
        offsetX: 20,
        offsetY: 20,
        type: ShadowType.COLOR,
        fill: true
      })
    }
  }
}