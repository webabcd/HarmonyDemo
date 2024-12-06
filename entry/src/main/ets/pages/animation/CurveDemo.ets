/*
 * Curve - 动画曲线
 */

import { MyLog, RadioBar, TitleBar } from '../TitleBar'
import { curves } from '@kit.ArkUI'

@Entry
@Component
struct CurveDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('Curve 枚举').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('ICurve 接口').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('将 Curve 可视化').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State offsetY_list: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

  myAnimateTo(curve: Curve, index: number) {
    this.getUIContext().animateTo({
      duration: 10000,
      curve: curve,
      playMode: PlayMode.Alternate,
      iterations: -1,
    }, () => {
      this.offsetY_list[index] = 380
    })
  }

  build() {
    Column({space:10}) {
      Button('click me')
        .onClick(() => {
          // 匀速动画
          this.myAnimateTo(Curve.Linear, 0)

          // 下面这些动画都源自三次贝塞尔曲线
          this.myAnimateTo(Curve.Ease, 1)
          this.myAnimateTo(Curve.EaseIn, 2)
          this.myAnimateTo(Curve.EaseOut, 3)
          this.myAnimateTo(Curve.EaseInOut, 4)
          this.myAnimateTo(Curve.FastOutSlowIn, 5)
          this.myAnimateTo(Curve.LinearOutSlowIn, 6)
          this.myAnimateTo(Curve.FastOutLinearIn, 7)
          this.myAnimateTo(Curve.ExtremeDeceleration, 8)
          this.myAnimateTo(Curve.Sharp, 9)
          this.myAnimateTo(Curve.Rhythm, 10)
          this.myAnimateTo(Curve.Smooth, 11)
          this.myAnimateTo(Curve.Friction, 12)
        })

      Row() {
        Rect().fill(Color.Red).width(20).height(20).translate({ y: this.offsetY_list[0] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[1] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[2] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[3] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[4] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[5] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[6] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[7] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[8] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[9] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[10] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[11] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[12] })
      }
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor(Color.Yellow)
      .width(300)
      .height(400)
    }
  }
}

@Component
struct MySample2 {

  @State offsetY_list: number[] = [0, 0, 0, 0, 0, 0, 0, 0]

  myAnimateTo(curve: ICurve, index: number) {
    this.getUIContext().animateTo({
      duration: 10000,
      curve: curve,
      playMode: PlayMode.Alternate,
      iterations: -1,
    }, () => {
      this.offsetY_list[index] = 380
    })
  }

  // 自定义曲线的算法
  // fraction 代表 x 轴的从 0（对应动画起点）到 1（对应动画终点）的值，返回值为 y 轴的值
  interpolate = (fraction:number):number => {
    return Math.sqrt(fraction)
  }

  build() {
    Column({space:10}) {
      Button('click me')
        .onClick(() => {
          // 匀速动画
          this.myAnimateTo(curves.initCurve(Curve.Linear), 0)

          // 离散动画，可以通过 n 步一步一步地跳着到目标值
          this.myAnimateTo(curves.stepsCurve(9, false), 1)
          // 三次贝塞尔曲线，指定三次贝塞尔曲线的 2 个点的坐标
          this.myAnimateTo(curves.cubicBezierCurve(0.1, 0.0, 0.1, 1.0), 2)
          // 弹簧曲线
          this.myAnimateTo(curves.springCurve(10, 1, 200, 50), 3)
          // 弹簧曲线
          this.myAnimateTo(curves.springMotion(0.55, 0.825, 0), 4)
          // 弹簧曲线
          this.myAnimateTo(curves.responsiveSpringMotion(0.15, 0.86, 0.25), 5)
          // 弹簧曲线
          this.myAnimateTo(curves.interpolatingSpring(10, 1, 200, 50), 6)
          // 自定义曲线
          this.myAnimateTo(curves.customCurve(this.interpolate), 7)
        })

      Row() {
        Rect().fill(Color.Red).width(20).height(20).translate({ y: this.offsetY_list[0] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[1] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[2] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[3] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[4] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[5] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[6] })
        Rect().fill(Color.Blue).width(20).height(20).translate({ y: this.offsetY_list[7] })
      }
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor(Color.Yellow)
      .width(300)
      .height(400)
    }
  }
}

// 将 Curve 枚举的各种类型的曲线绘制出来，方便理解
@Component
struct MySample3 {

  @State points:Array<number[]> = []

  valueList = ["Linear", "Ease", "EaseIn", "EaseOut", "EaseInOut", "FastOutSlowIn", "LinearOutSlowIn", "FastOutLinearIn", "ExtremeDeceleration", "Sharp", "Rhythm", "Smooth", "Friction"]

  updatePoints(curve: Curve): void {
    let myCurve = curves.initCurve(curve)
    this.points = []
    for (let i = 0; i < 1000; i++) {
      /*
       * ICurve - 曲线接口
       *   interpolate() - 根据指定的 x 轴的值，返回曲线的 y 轴的值
       *   注：interpolate() 是归一化函数，参数值和返回值的取值范围在 0 - 1 之间
       */
      this.points.push([i / 1000.0 * 300, myCurve.interpolate(i / 1000.0) * 300])
    }
  }

  aboutToAppear(): void {
    this.updatePoints(Curve.Linear)
  }

  build() {
    Column({space:10}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.updatePoints(Curve[this.valueList[selectedIndex]])
      }})

      Polyline({ width: 300, height: 300 })
        .strokeWidth(1)
        .stroke(Color.Red)
        .fill(Color.Transparent)
        .backgroundColor(Color.Yellow)
        .points(this.points)
    }
  }
}