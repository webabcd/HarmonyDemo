/*
 * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口（效率比 DrawingRenderingContext 低）
 *
 * 本例用于演示如何通过 CanvasRenderingContext2D 绘制文本，图像，变换，透明，阴影
 */

import { MyLog, TitleBar } from '../TitleBar';
import { LengthMetricsUnit } from '@kit.ArkUI';

@Entry
@Component
struct CanvasRenderingContext2DDemo2 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('文本').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('图像').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('变换').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('透明').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('阴影').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

// 文本
@Component
struct MySample1 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  text = "hello webabcd"

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   fillStyle - 填充颜色
       *   strokeStyle - 画笔颜色
       *   lineWidth - 画笔宽度
       *
       *   font - 字体
       *     格式为 'font-style font-weight font-size font-family’
       *   fillText() - 用 fillStyle 填充文本
       *     参数按顺序分别为: 文本内容, 文本左下角的 x, y, 最大宽度（可选参数，不指定则不限制宽度）
       *   strokeText() - 用 strokeStyle 描边文本
       *     参数按顺序分别为: 文本内容, 文本左下角的 x, y, 最大宽度（可选参数，不指定则不限制宽度）
       *   measureText() - 测量指定的文本内容在当前上下文中绘制后的尺寸
       *   textBaseline - 文本的基线对齐方式
       *     alphabetic（默认值）, top, hanging, middle, ideographic, bottom
       *   textAlign - 文本的对齐方式
       *     left, right, center, start（默认值）, end
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.strokeStyle = Color.Green
          this.context.lineWidth = 2

          this.context.font = '24vp'
          this.context.fillText(this.text, 0, 50, 2000)
          this.context.font = 'italic 400 24vp HarmonyOS Sans'
          this.context.fillText(this.text, 0, 100)

          this.message = `measureText width: ${this.context.measureText(this.text).width}` // 指定的文本内容在当前上下文中绘制后的宽
          this.message = `measureText height: ${this.context.measureText(this.text).height}` // 指定的文本内容在当前上下文中绘制后的高

          this.context.font = '24vp'
          this.context.strokeText("ABC", 0, 150)

          this.context.moveTo(0, 200)
          this.context.lineTo(this.context.width, 200)
          this.context.stroke()
          this.context.font = '12vp'
          this.context.textBaseline = 'top'
          this.context.fillText('top', 0, 200)
          this.context.textBaseline = 'bottom'
          this.context.fillText('bottom', 40, 200)
          this.context.textBaseline = 'middle'
          this.context.fillText('middle', 100, 200)
          this.context.textBaseline = 'alphabetic'
          this.context.fillText('alphabetic', 160, 200)
          this.context.textBaseline = 'hanging'
          this.context.fillText('hanging', 240, 200)
          this.context.textBaseline = 'ideographic'
          this.context.fillText('ideographic', 300, 200)

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

// 图像
@Component
struct MySample2 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  /*
   * ImageBitmap - 图像
   *   src - 图像地址
   *   unit - 一个 LengthMetricsUnit 枚举
   *     DEFAULT - 单位为 vp
   *     PX - 单位为 px
   */
  private imageBitmap = new ImageBitmap("resources/base/media/son.jpg", LengthMetricsUnit.DEFAULT)

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   imageSmoothingEnabled - 绘制图片时是否进行图像平滑度调整（默认值为 true）
       *   imageSmoothingQuality - 图像平滑度（当 imageSmoothingEnabled 为 true 时有效）
       *     low（默认值）, medium, high
       *
       *   drawImage() - 绘制图像
       *   getPixelMap(), setPixelMap() - 获取和设置 PixelMap 对象
       *   getImageData(), putImageData() - 获取和设置 ImageData 对象
       *   createImageData() - 创建 ImageData 对象
       *
       * PixelMap - 无压缩位图，支持各种格式的图片转为 PixelMap，也支持 PixelMap 转为各种格式的图片，支持图片的剪裁、缩放、旋转等操作
       * ImageData - 无压缩位图，用于存储或设置 canvas 上的图像
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.imageSmoothingEnabled = true
          this.context.imageSmoothingQuality = 'low'

          // drawImage() - 绘制图像，参数按顺序分别是
          //   图像, 绘制区域左上角的 x, y
          //   图像, 绘制区域左上角的 x, y, width, height
          //   图像, 对源图像做剪裁的左上角的 x, y, width, height, 将剪裁后的图像放到的绘制区域的左上角的 x, y, width, height,
          this.context.drawImage(this.imageBitmap, 0, 0)
          this.context.drawImage(this.imageBitmap, 80, 0, 100, 100)
          this.context.drawImage(this.imageBitmap, this.imageBitmap.width / 2 , this.imageBitmap.height / 2, this.imageBitmap.width / 2 , this.imageBitmap.height / 2, 200, 0, 100, 100)

          this.context.drawImage(this.imageBitmap, 0, 120, 100, 100)
          // getImageData() - 获取指定区域的 ImageData 对象，参数按顺序分别是
          //   需要获取的区域的左上角的 x, y, width, height
          // putImageData - 将 ImageData 对象绘制到指定的区域，参数按顺序分别是
          //   ImageData 对象, 绘制区域左上角的 x, y
          //   ImageData 对象, 绘制区域左上角的 x, y, 对源图像做剪裁的左上角的 x, y, width, height
          let data = this.context.getImageData(0, 120, 100, 100)
          this.context.putImageData(data, 0, 240)
          this.context.putImageData(data, 120, 240, 50, 50, 50, 50)

          // createImageData() - 创建 ImageData 对象
          //   参数按顺序分别是图像的宽和高
          //   每 4 个字节描述一个像素点，这 4 个字节分别指的是 r, g, b, a
          let myData = this.context.createImageData(100, 100)
          for (let i = 0; i < myData.data.length; i += 4) {
            myData.data[i + 0] = 0
            myData.data[i + 1] = 0
            myData.data[i + 2] = 255
            myData.data[i + 3] = 255
          }
          this.context.putImageData(myData, 0, 360)
        })
    }
  }
}

// 变换
@Component
struct MySample3 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   translate() - 位移
       *   scale() - 缩放
       *   rotate() - 旋转（单位：弧度）
       *   transform() - 在原有 transform 的基础上叠加一个 transform
       *     参数按顺序分别为: scaleX, skewY, skewX, scaleY, translateX, translateY
       *   resetTransform() - 重置 transform
       *   setTransform() - 清除原有 transform 并设置一个新的 transform
       *     参数按顺序分别为: scaleX, skewY, skewX, scaleY, translateX, translateY
       *     也可以设置一个 Matrix2D 对象
       *   getTransform() - 获取当前上下文的 Matrix2D 对象
       *
       * Matrix2D - 矩阵
       *   identity() - 获取单位矩阵
       *   invert() - 获取当前矩阵的逆矩阵
       *   translate() - 位移
       *   scale() - 缩放
       *   rotate() - 旋转（参数按顺序分别为: 旋转的弧度, 旋转中心点的 x, y）
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.lineWidth = 2
          this.context.strokeStyle = Color.Red
          this.context.strokeRect(0, 0, 50, 50)

          this.context.strokeStyle = Color.Green
          this.context.translate(0, 60)
          this.context.scale(2, 2)
          this.context.rotate(5 * Math.PI / 180)
          this.context.strokeRect(0, 0, 50, 50)

          this.context.strokeStyle = Color.Blue
          this.context.transform(2 ,0, 0, 2, 0, 60)
          this.context.strokeRect(0, 0, 50, 50)

          this.context.strokeStyle = Color.Orange
          this.context.setTransform(2 ,0, 0, 2, 200, 0)
          this.context.strokeRect(0, 0, 50, 50)

          this.context.fillStyle = Color.Pink
          let matrix: Matrix2D = new Matrix2D().identity()
          matrix = matrix.identity()
          matrix.rotate(5 * Math.PI / 180, 25, 25)
          matrix.translate(0, 400)
          matrix.scale(2, 2)
          this.context.setTransform(matrix)
          this.context.fillRect(0, 0, 50, 50)
        })
    }
  }
}

// 透明
@Component
struct MySample4 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   globalAlpha - 不透明度
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.fillRect(0, 0, 100, 100)
          this.context.globalAlpha = 0.3
          this.context.fillRect(0, 100, 100, 100)
        })
    }
  }
}

// 阴影
@Component
struct MySample5 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   shadowBlur - 阴影的模糊级别，值越大越模糊
       *   shadowColor - 阴影的颜色
       *   shadowOffsetX - 阴影的 x 轴方向的偏移距离
       *   shadowOffsetY - 阴影的 y 轴方向的偏移距离
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.shadowBlur = 30
          this.context.shadowColor = "#ff0000"
          this.context.shadowOffsetX = 20
          this.context.shadowOffsetY = 20
          this.context.fillStyle = Color.Green
          this.context.fillRect(50, 50, 100, 100)
        })
    }
  }
}