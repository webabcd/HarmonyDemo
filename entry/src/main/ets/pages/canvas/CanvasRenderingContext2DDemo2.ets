/*
 * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口（效率比 DrawingRenderingContext 低）
 *
 * 本例用于演示如何通过 CanvasRenderingContext2D 实现
 */

import { MyLog, TitleBar } from '../TitleBar';

@Entry
@Component
struct CanvasRenderingContext2DDemo2 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('文字').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  text = "hello webabcd"

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.font = '24vp'
          this.context.fillText(this.text, 0, 50, 2000)
          this.context.font = 'italic 400 24vp HarmonyOS Sans'
          this.context.fillText(this.text, 0, 100)

          this.message = `measureText width: ${this.context.measureText(this.text).width}`

          this.context.lineWidth = 2
          this.context.strokeStyle = Color.Green
          this.context.strokeText(this.text, 0, 150, 2000)

          this.context.moveTo(0, 200)
          this.context.lineTo(this.context.width, 200)
          this.context.stroke()
          this.context.font = '12vp'
          this.context.textBaseline = 'top'
          this.context.fillText('top', 0, 200)
          this.context.textBaseline = 'bottom'
          this.context.fillText('bottom', 55, 200)
          this.context.textBaseline = 'middle'
          this.context.fillText('middle', 125, 200)
          this.context.textBaseline = 'alphabetic'
          this.context.fillText('alphabetic', 195, 200)
          this.context.textBaseline = 'hanging'
          this.context.fillText('hanging', 295, 200)

          this.context.moveTo(this.context.width / 2, 250)
          this.context.lineTo(this.context.width / 2, 550)
          this.context.stroke()
          this.context.font = '12vp'
          this.context.textAlign = 'start'
          this.context.fillText('textAlign=start', this.context.width / 2, 300)
          this.context.textAlign = 'end'
          this.context.fillText('textAlign=end', this.context.width / 2, 350)
          this.context.textAlign = 'left'
          this.context.fillText('textAlign=left', this.context.width / 2, 400)
          this.context.textAlign = 'center'
          this.context.fillText('textAlign=center', this.context.width / 2, 450)
          this.context.textAlign = 'right'
          this.context.fillText('textAlign=right', this.context.width / 2, 500)
        })
    }
  }
}