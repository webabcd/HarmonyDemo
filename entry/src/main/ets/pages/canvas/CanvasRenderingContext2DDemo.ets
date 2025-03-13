/*
 * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口（效率比 DrawingRenderingContext 低）
 *
 * 本例用于演示如何通过 CanvasRenderingContext2D 实现简单图形，路径图形，贝塞尔曲线，画笔样式，渐变色
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct CanvasRenderingContext2DDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('简单图形').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('路径图形').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('贝塞尔曲线').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('画笔样式').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('渐变色').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

// 演示简单图形
@Component
struct MySample1 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   width, height - 画布的宽和高
       *   fillStyle - 填充颜色
       *   strokeStyle - 画笔颜色
       *   lineWidth - 画笔宽度
       *   fillRect() - 用填充颜色填充一个矩形区域
       *     通过参数指定矩形的 x, y, width, height
       *   strokeRect() - 用画笔画一个矩形框
       *     通过参数指定矩形的 x, y, width, height
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {
          this.message = `canvas width:${this.context.width}\n`
          this.message += `canvas height:${this.context.height}`

          this.context.fillStyle = Color.Red
          this.context.fillRect(0, 0, 200, 100)

          this.context.strokeStyle = Color.Green
          this.context.lineWidth = 20
          this.context.strokeRect(0, 120, 200, 100)
        })
    }
  }
}

// 路径图形
@Component
struct MySample2 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   fillStyle - 填充颜色
       *   strokeStyle - 画笔颜色
       *   lineWidth - 画笔宽度
       *
       *   beginPath() - 绘制新的路径
       *   closePath() - 通过直线路径连接路径的首尾两端
       *   stroke() - 用画笔连接路径
       *   fill() - 填充路径组成的图形的内部
       *
       *   move() - 路径移动到指定的点
       *   lineTo() - 之前 move() 点通过直线路径连接 lineTo() 点
       *   rect() - 矩形路径
       *   ellipse() - 椭圆路径
       *   arc() - 圆弧路径
       *   arcTo() - 圆弧路径
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.strokeStyle = Color.Green
          this.context.lineWidth = 2

          this.context.beginPath()
          this.context.moveTo(0, 0)
          this.context.lineTo(100, 40)
          this.context.stroke()

          this.context.beginPath()
          this.context.moveTo(200, 0)
          this.context.lineTo(300, 0)
          this.context.lineTo(250, 40)
          this.context.closePath()
          this.context.stroke()
          this.context.fill()

          this.context.beginPath()
          // 矩形路劲，参数按顺序分别是 x, y, width, height
          this.context.rect(0, 50, 200, 40)
          this.context.stroke()
          this.context.fill()

          this.context.beginPath()
          // 椭圆路劲，参数按顺序分别是
          //   圆心的 x, 圆心的 y, 椭圆的 x 轴半径, 椭圆的 y 轴半径
          //   椭圆的旋转弧度, 绘制的起始点的弧度, 绘制的结束点的弧度, 是否逆时针方向绘制
          this.context.ellipse(100, 150, 100, 40, 0, 0, Math.PI * 1.5, false)
          this.context.stroke()

          this.context.beginPath()
          // 圆弧路劲，参数按顺序分别是
          //   圆心的 x, 圆心的 y, 圆弧的半径
          //   绘制的起始点的弧度, 绘制的结束点的弧度, 是否逆时针方向绘制
          this.context.arc(100, 250, 40, 0, Math.PI * 1.5, false)
          this.context.stroke()

          this.context.beginPath()
          this.context.rect(50, 300, 100, 100)
          this.context.fill()
          this.context.beginPath();
          this.context.moveTo(50, 300)
          // 圆弧路劲，参数按顺序分别是
          //   控制点 1 的 x, y, 控制点 2 的 x, y, 圆弧的半径
          // 关于 arcTo() 的说明：以 moveTo() 点为起点, 控制点 2 为终点，圆弧偏向控制点 1 的方向，然后通过指定的半径画圆弧
          this.context.arcTo(50, 400, 150, 400, 100);
          this.context.stroke()
        })
    }
  }
}

// 贝塞尔曲线
@Component
struct MySample3 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      Row() {
        Image('/pages/canvas/quadratic.gif').layoutWeight(1)
        Image('/pages/canvas/bezier.gif').layoutWeight(1)
      }

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   quadraticCurveTo() - 二次贝赛尔曲线
       *   bezierCurveTo() - 三次贝赛尔曲线
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.strokeStyle = Color.Green
          this.context.lineWidth = 2

          this.context.beginPath()
          this.context.moveTo(10, 100)
          // 二次贝赛尔曲线，参数按顺序分别是
          //   控制点的 x, y, 曲线终点的 x, y
          // 注：曲线起点为 moveTo() 点
          this.context.quadraticCurveTo(30, 10, 300, 100)
          this.context.stroke()

          this.context.beginPath()
          this.context.moveTo(10, 300)
          // 三次贝赛尔曲线，参数按顺序分别是
          //   控制点 1 的 x, y, 控制点 2 的 x, y, 曲线终点的 x, y
          // 注：曲线起点为 moveTo() 点
          this.context.bezierCurveTo(20, 120, 70, 150, 300, 300)
          this.context.stroke()
        })
    }
  }
}

// 画笔样式
@Component
struct MySample4 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   strokeStyle - 画笔颜色
       *   lineWidth - 画笔宽度
       *   lineCap - 线段两端的样式（默认值为 butt）
       *     butt - 无特殊处理
       *     round - 有一个半圆形的延伸（这个半圆形的半径为: lineWidth / 2）
       *     square - 有一个矩形的延伸（这个矩形的长度为: lineWidth / 2）
       *   lineJoin - 线段交点的处理方式（默认值为 miter），比如三角形的三个顶点
       *     round - 圆角处理
       *     bevel - 斜切处理
       *     miter - 尖角处理
       *   miterLimit - 当 lineJoin 为 miter 时，线段连接处的那个“尖”的极限长度（默认值为 10px）
       *   setLineDash() - 一个数组，第 1 个元素是虚线的实线部分的长度，第 2 个元素是虚线的空白部分的长度
       *   lineDashOffset - 虚线的偏移距离
       *     虚线的起始部分是先实线再空白，如果需要调整虚线的起始部分就可以通过 lineDashOffset 实现
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.strokeStyle = Color.Green
          this.context.lineWidth = 20

          this.context.beginPath()
          this.context.lineCap = 'butt'
          this.context.moveTo(20, 20)
          this.context.lineTo(300, 20)
          this.context.stroke()
          this.context.beginPath()
          this.context.lineCap = 'round'
          this.context.moveTo(20, 50)
          this.context.lineTo(300, 50)
          this.context.stroke()
          this.context.beginPath()
          this.context.lineCap = 'square'
          this.context.moveTo(20, 80)
          this.context.lineTo(300, 80)
          this.context.stroke()

          this.context.beginPath()
          this.context.lineJoin = 'round'
          this.context.moveTo(20, 120)
          this.context.lineTo(100, 150)
          this.context.lineTo(20, 180)
          this.context.stroke()
          this.context.beginPath()
          this.context.lineJoin = 'bevel'
          this.context.moveTo(120, 120)
          this.context.lineTo(200, 150)
          this.context.lineTo(120, 180)
          this.context.stroke()
          this.context.beginPath()
          this.context.lineJoin = 'miter'
          this.context.moveTo(220, 120)
          this.context.lineTo(300, 150)
          this.context.lineTo(220, 180)
          this.context.stroke()

          this.context.lineJoin = 'miter'
          this.context.miterLimit = 0
          this.context.beginPath()
          this.context.moveTo(20, 220)
          this.context.lineTo(100, 250)
          this.context.lineTo(20, 280)
          this.context.stroke()
          this.context.beginPath()
          this.context.miterLimit = 10
          this.context.moveTo(120, 220)
          this.context.lineTo(200, 250)
          this.context.lineTo(120, 280)
          this.context.stroke()

          this.context.lineCap = 'butt'
          this.context.lineWidth = 2
          this.context.beginPath()
          this.context.setLineDash([10, 30])
          this.context.lineDashOffset = 0
          this.context.moveTo(0, 320)
          this.context.lineTo(300, 320)
          this.context.stroke()
          this.context.beginPath()
          this.context.setLineDash([10, 30])
          this.context.lineDashOffset = -5
          this.context.moveTo(0, 350)
          this.context.lineTo(300, 350)
          this.context.stroke()
        })
    }
  }
}

// 渐变色
@Component
struct MySample5 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   createLinearGradient() - 线性渐变
       *   createRadialGradient() - 放射渐变
       *   createConicGradient() - 扫描式渐变
       *     addColorStop() - 设置渐变点的位置和颜色
       *       offset - 渐变点的位置（0 - 1 之间）
       *       color - 渐变点的颜色
       *   fillStyle - 使用指定的渐变作为填充色
       *   strokeStyle - 使用指定的渐变作为画笔色
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {
          // 线性渐变，参数按顺序分别是
          //   渐变起始点的 x, y, 渐变结束点的 x, y
          let linearGradient = this.context.createLinearGradient(0, 0, 300, 100)
          linearGradient.addColorStop(0.0, '#ff0000')
          linearGradient.addColorStop(0.5, '#00ff00')
          linearGradient.addColorStop(1.0, '#0000ff')
          this.context.fillStyle = linearGradient
          this.context.fillRect(0, 0, 300, 100)

          // 放射渐变，参数按顺序分别是
          //   渐变起始圆的 x, y, 半径, 渐变结束圆的 x, y, 半径
          let radialGradient = this.context.createRadialGradient(100, 250, 10, 100, 250, 100)
          radialGradient.addColorStop(0.0, '#ff0000')
          radialGradient.addColorStop(0.5, '#00ff00')
          radialGradient.addColorStop(1.0, '#0000ff')
          this.context.fillStyle = radialGradient
          this.context.fillRect(0, 150, 200, 200)

          // 扫描式渐变，参数按顺序分别是
          //   渐变的起始弧度, 渐变中心点的 x, y
          let conicGradient = this.context.createConicGradient(0, 100, 500)
          conicGradient.addColorStop(0.0, '#ff0000')
          conicGradient.addColorStop(0.5, '#00ff00')
          conicGradient.addColorStop(1.0, '#0000ff')
          this.context.fillStyle = conicGradient
          this.context.fillRect(0, 400, 200, 200)
        })
    }
  }
}