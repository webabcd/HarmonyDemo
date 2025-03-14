/*
 * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口（效率比 DrawingRenderingContext 低）
 *
 * 本例用于演示通过 CanvasRenderingContext2D 绘制时，如何实现图像滤镜，叠加绘制，图层，清除指定的区域，画布转图片，上下文的保存和加载
 */

import { MyLog, TitleBar } from '../TitleBar';
import { LengthMetricsUnit } from '@kit.ArkUI';

@Entry
@Component
struct CanvasRenderingContext2DDemo3 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('图像滤镜').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('叠加绘制').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('图层').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('清除指定的区域').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('画布转图片').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('上下文的保存和加载').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

// 图像滤镜
@Component
struct MySample1 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  private imageBitmap = new ImageBitmap("resources/base/media/son.jpg", LengthMetricsUnit.DEFAULT)

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   filter - 指定图像的滤镜
       *     none - 无滤镜
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.filter = 'none';
          this.context.drawImage(this.imageBitmap, 0, 0, 100, 100);

          this.context.filter = 'grayscale(50%)'; // 灰度效果
          this.context.drawImage(this.imageBitmap, 100, 0, 100, 100);

          this.context.filter = 'sepia(60%)'; // 深褐色效果
          this.context.drawImage(this.imageBitmap, 200, 0, 100, 100);

          this.context.filter = 'saturate(30%)'; // 饱和度效果
          this.context.drawImage(this.imageBitmap, 0, 100, 100, 100);

          this.context.filter = 'hue-rotate(90deg)'; // 色相旋转效果
          this.context.drawImage(this.imageBitmap, 100, 100, 100, 100);

          this.context.filter = 'invert(100%)'; // 颜色反转效果
          this.context.drawImage(this.imageBitmap, 200, 100, 100, 100);

          this.context.filter = 'opacity(25%)'; // 不透透明度效果
          this.context.drawImage(this.imageBitmap, 0, 200, 100, 100);

          this.context.filter = 'brightness(0.4)'; // 亮度效果
          this.context.drawImage(this.imageBitmap, 100, 200, 100, 100);

          this.context.filter = 'contrast(200%)'; // 对比度效果
          this.context.drawImage(this.imageBitmap, 200, 200, 100, 100);

          this.context.filter = 'blur(5px)'; // 模糊效果
          this.context.drawImage(this.imageBitmap, 0, 300, 100, 100);

          this.context.filter = 'opacity(50%) contrast(200%) grayscale(50%)'; // 复合效果
          this.context.drawImage(this.imageBitmap, 100, 300, 100, 100);
        })
    }
  }
}

// 叠加绘制
@Component
struct MySample2 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   globalCompositeOperation - 叠加绘制的方式（默认值为 source-over）
       *     source-over - 在现有内容的前面绘制新内容
       *     destination-over - 在现有内容的后面绘制新内容
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.fillRect(20, 20, 100, 100)

          this.context.globalCompositeOperation = 'source-over'
          this.context.fillStyle = Color.Green
          this.context.fillRect(20, 20, 40, 40)

          this.context.globalCompositeOperation = 'destination-over'
          this.context.fillStyle = Color.Blue
          this.context.fillRect(50, 50, 100, 100)
        })
    }
  }
}

// 图层
@Component
struct MySample3 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   saveLayer() - 新建图层
       *   restoreLayer() - 将当前图层的内容绘制到画布上
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.fillRect(0, 0, 100, 400)

          this.context.globalCompositeOperation = 'source-over'
          this.context.saveLayer() // 在当前内容的上方新建一个图层

          this.context.fillStyle = Color.Green
          this.context.fillRect(0, 0, 200, 300)
          this.context.restoreLayer() // 绘制当前图层

          this.context.globalCompositeOperation = 'destination-over'
          this.context.saveLayer() // 在当前内容的下方新建一个图层

          this.context.globalCompositeOperation = 'source-over'
          this.context.fillStyle = Color.Blue
          this.context.fillRect(0, 0, 300, 200)
          this.context.fillStyle = Color.Orange
          this.context.fillRect(0, 0, 400, 100)
          this.context.restoreLayer() // 绘制当前图层
        })
    }
  }
}

// 清除指定的区域
@Component
struct MySample4 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      Button("reset").onClick(() => {
        this.context.reset()
      })

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   reset() - 清除全部内容
       *   clearRect() - 清除画布上指定的矩形区域中的内容
       *   clip() - 指定一个 Path2D 对象
       *     在 clip() 之后绘制内容时，只有在 clip() 区域内的会被显示，在 clip() 区域外的会被清除
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.strokeStyle = Color.Red
          this.context.lineWidth = 20

          this.context.strokeRect(20, 20, 200, 200)
          this.context.clearRect(0, 0, 300, 100)

          let path2D: Path2D = new Path2D()
          path2D.moveTo(0, 280)
          path2D.lineTo(300, 280)
          path2D.lineTo(300, 380)
          path2D.lineTo(0, 380)
          path2D.closePath()
          this.context.clip(path2D)
          this.context.strokeRect(20, 300, 200, 200)
        })
    }
  }
}

// 画布转图片
@Component
struct MySample5 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  @State imageBase64: string = ""

  build() {
    Column({ space: 10 }) {

      Image(this.imageBase64).width(200).height(200)

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   toDataURL() - 将画布内容转为 base64 方式的图片
       *     type - 图片格式
       *       image/png, image/jpeg, image/webp
       *     quality - 图片质量
       *       0 - 1 之间，仅 image/jpeg, image/webp 时有效
       */
      Canvas(this.context).width('200').height('200').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.fillRect(50, 50, 100, 100)

          this.imageBase64 = this.context.toDataURL("image/jpeg", 0.92)
        })
    }
  }
}

// 上下文的保存和加载
@Component
struct MySample6 {

  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  build() {
    Column({ space: 10 }) {

      /*
       * CanvasRenderingContext2D - 按照 W3C 标准封装了本地绘图接口
       *   save() - 保存当前的上下文
       *   restore() - 加载之前保存的上下文
       */
      Canvas(this.context).width('100%').height('100%').backgroundColor(Color.Yellow)
        .onReady(() => {

          this.context.fillStyle = Color.Red
          this.context.save() // 保存当前的上下文

          this.context.fillStyle = Color.Green
          this.context.fillRect(0, 0, 100, 100) // 绿色矩形

          this.context.restore() // 加载之前保存的上下文（即 fillStyle = Color.Red）
          this.context.fillRect(200, 200, 100, 100) // 红色矩形
        })
    }
  }
}
