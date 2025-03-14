/*
 * Canvas - 画布，用于绘制各种图形（GPU 加速）
 *
 * DrawingRenderingContext - 本地绘图接口（效率比 CanvasRenderingContext2D 高）
 * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口（效率比 DrawingRenderingContext 低）
 * DisplaySync - 可以监听每一帧的回调，从而实现动画
 */

import { MyLog, TitleBar } from '../TitleBar';
import { LengthMetricsUnit } from '@kit.ArkUI';
import { displaySync } from '@kit.ArkGraphics2D';

@Entry
@Component
struct CanvasDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('DrawingRenderingContext').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('CanvasRenderingContext2D').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('动画').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  /*
   * Canvas - 画布组件（指定一个 DrawingRenderingContext 作为上下文对象）
   *   onReady() - 画布准备好之后的回调（在此处可以通过 DrawingRenderingContext 绘制图形）
   *
   * DrawingRenderingContext() - 本地绘图接口
   *   构造函数的参数是一个 LengthMetricsUnit 枚举
   *     DEFAULT - 通过 .size 获取到的画布的尺寸的单位为 vp
   *     PX - 通过 .size 获取到的画布的尺寸的单位为 px
   *   size - 获取画布的尺寸
   *   canvas - 获取画布（注：在此画布上绘制的图形的单位为 px）
   *   invalidate() - 重新渲染画布
   */
  private context: DrawingRenderingContext = new DrawingRenderingContext(LengthMetricsUnit.DEFAULT)

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {
          this.message = `width:${this.context.size.width}\n`
          this.message += `height:${this.context.size.height}`

          this.context.canvas.drawRect({
            left: this.getUIContext().vp2px(50),
            right: this.getUIContext().vp2px(250),
            top: this.getUIContext().vp2px(50),
            bottom: this.getUIContext().vp2px(250),
          })
          this.context.invalidate()
        })
    }
  }
}

@Component
struct MySample2 {

  /*
   * Canvas - 画布组件（指定一个 CanvasRenderingContext2D 作为上下文对象）
   *   onReady() - 画布准备好之后的回调（在此处可以通过 CanvasRenderingContext2D 绘制图形）
   *
   * RenderingContextSettings() - 用于 CanvasRenderingContext2D 的配置
   *   构造函数的参数是一个 boolean 类型，用于说明是否需要开启抗锯齿
   * CanvasRenderingContext2D() - 按照 W3C 标准封装了本地绘图接口
   *   构造函数的第 1 个参数是一个 RenderingContextSettings 对象
   *   构造函数的第 2 个参数是一个 LengthMetricsUnit 枚举
   *     DEFAULT - 在当前 context 中绘制的图形的单位为 vp
   *     PX - 在当前 context 中绘制的图形的单位为 px
   *   width - 画布宽
   *   height - 画布高
   */
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings, LengthMetricsUnit.DEFAULT)

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {
          this.message = `width:${this.context.width}\n`
          this.message += `height:${this.context.height}`

          this.context.fillRect(50, 50, 200, 200)
        })
    }
  }
}

@Component
struct MySample3 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  private displaySync: displaySync.DisplaySync = displaySync.create()!
  private prevTimestamp: number = 0
  private isReady: boolean = false
  private isDown: boolean = true // 当前是否是向下运动
  private rectY: number = 0

  @State message: string = ""

  /*
   * displaySync.create() - 创建 DisplaySync 对象
   *
   * DisplaySync - 用于监听每一帧的回调
   *   on("frame", callback) - 注册监听（回调参数是一个 IntervalInfo 对象）
   *   off("frame") - 取消注册监听
   *   start() - 开始监听
   *   stop() - 停止监听
   *   setExpectedFrameRateRange() - 设置期望帧率的范围（指定一个 ExpectedFrameRateRange 对象）
   *     expected - 期望的最优帧率
   *     min - 期望的最小帧率
   *     max - 期望的最大帧率
   *
   * IntervalInfo - 每一帧回调时的相关信息
   *   timestamp - 当前帧到达的时间戳（单位：纳秒）
   *   targetTimestamp - 下一帧预期到达的时间戳（单位：纳秒）
   */
  aboutToAppear(): void {
    let callback = (frameInfo: displaySync.IntervalInfo) => {
      this.message = `timestamp:${frameInfo.timestamp}, targetTimestamp:${frameInfo.targetTimestamp}\n`
      if (this.prevTimestamp > 0) {
        this.message += `fps:${ 1_000_000_000 / (frameInfo.timestamp - this.prevTimestamp)}` // 计算当前的实际帧率
      }
      this.prevTimestamp = frameInfo.timestamp

      // 每一帧都重绘，从而实现自定义动画
      if (this.isReady) {
        if (this.rectY + 200 > this.context.height) {
          this.isDown = false
        } else if (this.rectY < 0) {
          this.isDown = true
        }
        if (this.isDown) {
          this.rectY += 1
        } else {
          this.rectY -= 1
        }
      }
      this.context.reset()
      this.context.fillRect(50, this.rectY, 200, 200)
    }

    this.displaySync.setExpectedFrameRateRange({
      expected: 60,
      min: 0,
      max: 120
    })
    this.displaySync.on("frame", callback)
    this.displaySync.start()
  }

  aboutToDisappear(): void {
    this.displaySync.off("frame")
    this.displaySync.stop()
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Canvas(this.context).width('100%').height(400).backgroundColor(Color.Yellow)
        .onReady(() => {
          this.isReady = true
        })
    }
  }
}
