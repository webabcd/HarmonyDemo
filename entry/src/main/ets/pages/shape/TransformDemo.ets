/*
 * Transform - 图形变换（transform, rotate, translate, scale, skew）
 *
 * 鸿蒙的 3D 变换的坐标系是右手坐标系
 * 自然地伸出右手的大拇指，食指和中指
 * 大拇指指向 x 轴的正方向（向右）
 * 食指指向 y 轴的正方向（向下）
 * 中指指向 z 轴的正方向（向内，即远离观察者的方向）
 */

import { TitleBar } from '../TitleBar'
import { matrix4 } from '@kit.ArkUI'

@Entry
@Component
struct TransformDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('rotate').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('translate').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('scale').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('transform').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {
  build() {
    Column({space:20}) {

      Column().width(100).height(100).backgroundColor(Color.Red)

      /*
       * rotate() - 旋转
       *   x, y, z - 用于指定围绕哪个轴旋转，取值为 0 或 1
       *     比如: x:0,y:1,z:0 就是围绕 y 轴旋转
       *   centerX, centerY, centerZ - 旋转的中心点坐标
       *   angle - 旋转的角度
       *     顺时针旋转（视线与轴的正方向一致）
       *   perspective - 观察者与 z 平面（即 3D 空间中的深度轴）之间的角度
       */
      Column().width(100).height(100).backgroundColor(Color.Red)
        .rotate({
          x: 0,
          y: 1,
          z: 0,
          centerX: '50%',
          centerY: '50%',
          centerZ: 0,
          angle: 30,
          perspective: 0,
        })
      Column().width(100).height(100).backgroundColor(Color.Red)
        .rotate({
          x: 0,
          y: 1,
          z: 0,
          centerX: '50%',
          centerY: '50%',
          centerZ: 0,
          angle: 45,
          perspective: 15,
        })
    }
  }
}

@Component
struct MySample2 {
  build() {
    Column({space:20}) {

      Column().width(100).height(100).backgroundColor(Color.Red)

      /*
       * translate() - 位移
       *   x, y, z - 位移距离
       */
      Column().width(100).height(100).backgroundColor(Color.Red)
        .translate({
          x: 10,
          y: 10,
          z: 0,
        })
    }
  }
}

@Component
struct MySample3 {
  build() {
    Column({space:20}) {

      Column().width(100).height(100).backgroundColor(Color.Red)

      /*
       * scale() - 缩放
       *   x, y, z - 缩放倍数
       *   centerX, centerY - 缩放的中心点坐标
       */
      Column().width(100).height(100).backgroundColor(Color.Red)
        .scale({
          x: 0.8,
          y: 0.5,
          z: 0,
          centerX: '50%',
          centerY: '50%',
        })
    }
  }
}

@Component
struct MySample4 {

  private matrix1 = matrix4.identity().translate({ x: 10, y: 10 })
  private matrix2 = matrix4.identity().scale({ x: 0.8, y: 0.8 })
  private matrix3 = matrix4.identity().rotate({ x: 0, y: 0, z: 1, angle: 30 })

  build() {
    Column({space:20}) {

      Column().width(100).height(100).backgroundColor(Color.Red)

      /*
       * transform() - 变换
       *   matrix4.identity() - 创建一个 Matrix4Transit 单位矩阵
       *     translate() - 位移
       *     scale() - 缩放
       *     rotate() - 旋转
       *     skew() - 扭曲
       *     combine() - 将两个矩阵效果结合起来，并返回新的矩阵对象
       *     copy() - 复制一份当前的矩阵对象
       */
      Column().width(100).height(100).backgroundColor(Color.Red)
        .transform(matrix4.identity()
          .translate({ x: 10, y: 10 })
          .scale({ x: 0.8, y: 0.8 })
          .rotate({ x: 0, y: 0, z: 1, angle: 30 })
        )

      Column().width(100).height(100).backgroundColor(Color.Red)
        .transform(matrix4.identity()
          // 指定扭曲度
          .skew(0.1, 0.1)
        )

      Column().width(100).height(100).backgroundColor(Color.Red)
        .transform(this.matrix1.combine(this.matrix2).combine(this.matrix3))
    }
  }
}