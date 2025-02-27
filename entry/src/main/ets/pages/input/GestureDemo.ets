/*
 * 手势识别
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct GestureDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('TapGesture').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('LongPressGesture').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('PanGesture').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('PinchGesture').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('RotationGesture').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('SwipeGesture').align(Alignment.Top)
        TabContent() { MySample7() }.tabBar('GestureGroup').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * TapGesture - 可识别手指的单击、双击和多击手势
       *   count - 需要识别的连续单击的次数（点击间隔在 300 毫秒内）
       *   fingers - 触发手势的手指数（默认值为 1）
       *   onAction() - 手势识别成功后的回调
       */
      Text('TapGesture').fontSize(32)
        .gesture(
          TapGesture({
            count: 2, // 双击
            fingers: 1
          })
            .onAction((event: GestureEvent) => {
              this.message = `TapGesture`
            })
        )
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * LongPressGesture - 可识别手指的长按手势
       *   duration - 触发长按手势的最短时间（默认值为 500 毫秒）
       *   repeat - 如果一直长按不抬起，是否需要连续触发 onAction() 回调
       *   fingers - 触发手势的手指数（默认值为 1）
       *   onAction() - 手势识别成功后的回调
       *   onActionEnd() - 最后一根手指抬起后的回调
       */
      Text('LongPressGesture').fontSize(32)
        .gesture(
          LongPressGesture({
            duration: 500,
            repeat: true,
            fingers: 1
          })
            .onAction((event: GestureEvent) => {
              this.message = `LongPressGesture onAction ${new Date().getTime()}`
            })
            .onActionEnd((event: GestureEvent) => {
              this.message = `LongPressGesture onActionEnd`
            })
        )
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  @State offsetX: number = 0
  @State offsetY: number = 0
  @State lastOffsetX: number = 0
  @State lastOffsetY: number = 0

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * PanGesture - 可识别手指的按下后移动的手势
       *   direction - 可识别的手指移动的方向（PanDirection 枚举，支持 & 和 |）
       *     None, Horizontal, Left, Right, Vertical, Up, Down, All
       *   fingers - 触发手势的手指数（默认值为 1）
       *   onActionStart() - 移动手势开始时的回调
       *   onActionUpdate() - 移动手势过程中的回调
       *   onActionEnd() - 移动手势结束时的回调
       */
      Text('PanGesture').width(300).height(200).border({ width: 1 })
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .gesture(
          PanGesture({
            direction: PanDirection.All,
            fingers: 1
          })
            .onActionStart((event: GestureEvent) => {
              this.message = `onActionStart`
            })
            .onActionUpdate((event: GestureEvent) => {
              /*
               * event.offsetX - 当前的手势识别中，移动的 x 轴方向的距离
               * event.offsetY - 当前的手势识别中，移动的 y 轴方向的距离
               */
              this.message = `onActionUpdate offsetX:${event.offsetX}, offsetY:${event.offsetY}`
              this.offsetX = this.lastOffsetX + event.offsetX
              this.offsetY = this.lastOffsetY + event.offsetY
            })
            .onActionEnd((event: GestureEvent) => {
              this.message = `onActionEnd`
              this.lastOffsetX = this.offsetX
              this.lastOffsetY = this.offsetY
            })
      )
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  @State scaleValue: number = 1
  @State lastScaleValue: number = 1

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * PinchGesture - 可识别手指的缩放手势
       *   fingers - 触发手势的手指数
       *   onActionStart() - 缩放手势开始时的回调
       *   onActionUpdate() - 缩放手势过程中的回调
       *   onActionEnd() - 缩放手势结束时的回调
       */
      Text('PinchGesture').width(300).height(200).border({ width: 1 })
        .scale({ x: this.scaleValue, y: this.scaleValue, z: 1 })
        .gesture(
          PinchGesture({
            fingers: 2
          })
            .onActionStart((event: GestureEvent) => {
              this.message = `onActionStart`
            })
            .onActionUpdate((event: GestureEvent) => {
              /*
               * event.scale - 当前缩放手势的缩放倍数
               * event.pinchCenterX, event.pinchCenterY - 缩放手势中心点的坐标
               */
              this.message = `onActionUpdate scale:${event.scale}`
              this.scaleValue = this.lastScaleValue * event.scale
            })
            .onActionEnd((event: GestureEvent) => {
              this.message = `onActionEnd`
              this.lastScaleValue = this.scaleValue
            })
        )
    }
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  @State angle: number = 0
  @State lastAngle: number = 0

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * RotationGesture - 可识别手指的旋转手势
       *   fingers - 触发手势的手指数
       *   onActionStart() - 旋转手势开始时的回调
       *   onActionUpdate() - 旋转手势过程中的回调
       *   onActionEnd() - 旋转手势结束时的回调
       */
      Text('RotationGesture').width(300).height(200).border({ width: 1 })
        .rotate({ angle: this.angle })
        .gesture(
          RotationGesture({
            fingers: 2
          })
            .onActionStart((event: GestureEvent) => {
              this.message = `onActionStart`
            })
            .onActionUpdate((event: GestureEvent) => {
              /*
               * event.angle - 当前旋转手势的旋转角度
               */
              this.message = `onActionUpdate angle:${event.angle}`
              this.angle = this.lastAngle + event.angle
            })
            .onActionEnd((event: GestureEvent) => {
              this.message = `onActionEnd`
              this.lastAngle = this.angle
            })
        )
    }
  }
}

@Component
struct MySample6 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * SwipeGesture - 可识别手指的滑动（轻扫）手势
       *   direction - 可识别的滑动的方向（SwipeDirection 枚举）
       *     None, Horizontal, Vertical, All
       *   speed - 触发滑动手势的最小速度（默认值为 100vp/s）
       *   fingers - 触发手势的手指数
       *   onAction() - 手势识别成功后的回调
       */
      Text('RotationGesture').width(300).height(200).border({ width: 1 })
        .gesture(
          SwipeGesture({
            direction: SwipeDirection.All,
            fingers: 1
          })
            .onAction((event: GestureEvent) => {
              /*
               * event.speed - 滑动手势的速度（单位为 vp/s）
               * event.angle - 滑动手势的角度
               */
              this.message = `onAction speed:${event.speed}, angle:${event.angle}`
            })
        )
    }
  }
}

@Component
struct MySample7 {

  @State message: string = ""

  @State offsetX: number = 0
  @State offsetY: number = 0
  @State lastOffsetX: number = 0
  @State lastOffsetY: number = 0

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * gesture() - 手势识别
       *
       * GestureGroup - 手势组
       *   GestureMode.Sequence - 顺序识别，组内手势按顺序识别，前一个识别成功后才能识别后一个
       *   GestureMode.Parallel - 并发识别，组内手势同时识别
       *   GestureMode.Exclusive - 互斥识别，组内手势只能有一个被识别成功
       */
      Text('GestureGroup').width(300).height(200).border({ width: 1 })
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .gesture(
          GestureGroup(GestureMode.Sequence,
            LongPressGesture()
              .onAction((event: GestureEvent) => {
                this.message = "LongPressGesture onAction"
              }),
            PanGesture()
              .onActionStart(() => {
                this.message = "PanGesture onActionStart"
              })
              .onActionUpdate((event: GestureEvent) => {
                this.message = "PanGesture onActionUpdate"
                this.offsetX = this.lastOffsetX + event.offsetX
                this.offsetY = this.lastOffsetY + event.offsetY
              })
              .onActionEnd(() => {
                this.message = "PanGesture onActionEnd"
                this.lastOffsetX = this.offsetX
                this.lastOffsetY = this.offsetY
              })
          )
        )
    }
  }
}