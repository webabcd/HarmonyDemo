/*
 * 渐变相关
 *
 * LinearGradient - 线性渐变
 * RadialGradient - 放射渐变（径向渐变）
 * SweepGradient - 扫描式渐变（角度渐变）
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct GradientDemo {
  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('线性渐变').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('放射渐变').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('扫描式渐变').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {
  build() {
    Column({space: 10}) {

      /*
       * linearGradient - 线性渐变
       *   angle - 线性渐变的角度（0 点方向顺时针角度，默认值为 180）
       *   colors - 渐变色数组，分别指定关键颜色点的色值和位置
       *   repeating - 当未指定结尾处的关键颜色点的色值时，是否重复之前的渐变色
       */

      Column() {
        Text('angle: 180').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        colors: [
          [Color.Red, 0.0], // 关键颜色点的色值，及其位置（0 - 1 之间）
          [Color.Green, 1.0], // 关键颜色点的色值，及其位置（0 - 1 之间）
        ]
      })

      Column() {
        Text('angle: 45').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        angle: 45, // 从左下向右上渐变
        colors: [
          [Color.Red, 0.0],
          [Color.Green, 1.0],
        ]
      })

      Column() {
        Text('repeat: true').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        repeating: false, // 只有 0.0 到 0.3 之间有颜色渐变效果
        colors: [
          [Color.Red, 0.0],
          [Color.Green, 0.3],
        ]
      })

      Column() {
        Text('repeat: false').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        repeating: true, // 0.3 之后会重复 0.0 到 0.3 之间的颜色渐变效果
        colors: [
          [Color.Red, 0.0],
          [Color.Green, 0.3],
        ]
      })
    }
  }
}

@Component
struct MySample2 {
  build() {
    Column({space: 10}) {

      /*
       * radialGradient - 放射渐变（径向渐变）
       *   center - 放射渐变的中心点坐标
       *   radius - 放射渐变半径，值越大放射的圆圈越大
       *   repeating - 当未指定结尾处的关键颜色点的色值时，是否重复之前的渐变色
       *   colors - 渐变色数组，分别指定关键颜色点的色值和位置
       */

      Column() {
        Text('repeat: true').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .radialGradient({
        center: [50, 50],
        radius: 100,
        repeating: true, // 0.25 之后会重复 0.0 到 0.25 之间的颜色渐变效果
        colors: [
          [Color.Red, 0], // 关键颜色点的色值，及其位置（0 - 1 之间）
          [Color.Green, 0.125], // 关键颜色点的色值，及其位置（0 - 1 之间）
          [Color.Blue, 0.25], // 关键颜色点的色值，及其位置（0 - 1 之间）
        ]
      })

      Column() {
        Text('repeat: false').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .radialGradient({
        center: [50, 50],
        radius: 100,
        repeating: false, // 只有 0.0 到 0.25 之间有颜色渐变效果
        colors: [
          [Color.Red, 0],
          [Color.Green, 0.125],
          [Color.Blue, 0.25],
        ]
      })
    }
  }
}

@Component
struct MySample3 {
  build() {
    Column({space: 10}) {

      /*
       * sweepGradient - 扫描式渐变（角度渐变）
       *   center - 扫描式渐变的中心点坐标
       *   start - 扫描的起始点的角度
       *   end - 扫描的结束点的角度
       *   repeating - 当未指定结尾处的关键颜色点的色值时，是否重复之前的渐变色
       *   colors - 渐变色数组，分别指定关键颜色点的色值和位置
       */

      Column() {
        Text('repeat: true').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .sweepGradient({
        center: [50, 50],
        start: 0,
        end: 360,
        repeating: true, // 0.25 之后会重复 0.0 到 0.25 之间的颜色渐变效果
        colors: [
          [Color.Red, 0], // 关键颜色点的色值，及其位置（0 - 1 之间）
          [Color.Green, 0.125], // 关键颜色点的色值，及其位置（0 - 1 之间）
          [Color.Blue, 0.25], // 关键颜色点的色值，及其位置（0 - 1 之间）
        ]
      })

      Column() {
        Text('repeat: false').fontSize(16).fontColor(Color.White)
      }
      .width(100)
      .height(100)
      .justifyContent(FlexAlign.Center)
      .sweepGradient({
        center: [50, 50],
        start: 0,
        end: 360,
        repeating: false, // 只有 0.0 到 0.25 之间有颜色渐变效果
        colors: [
          [Color.Red, 0],
          [Color.Green, 0.125],
          [Color.Blue, 0.25],
        ]
      })
    }
  }
}