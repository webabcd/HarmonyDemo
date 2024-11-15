/*
 * 图形绘制 - 包括 Circle, Ellipse, Line, Polyline, Polygon, Path, Rect, Shape
 */

import { RadioBar, TitleBar } from '../TitleBar';

@Entry
@Component
struct ShapeDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('Circle').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('Ellipse').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('Line').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('Polyline').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('Polygon').align(Alignment.Top)
        TabContent() { MySample7() }.tabBar('Rect').align(Alignment.Top)
        TabContent() { MySample8() }.tabBar('Path').align(Alignment.Top)
        TabContent() { MySample9() }.tabBar('Shape').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State lineJoinStyle: LineJoinStyle = LineJoinStyle.Miter
  lineJoinStyle_valueList =  ["Miter", "Round", "Bevel"]

  @State lineCapStyle: LineCapStyle = LineCapStyle.Butt
  lineCapStyle_valueList =  ["Butt", "Round", "Square"]

  build() {
    Column({ space: 20 }) {
      /*
       * 图形绘制 - 包括 Circle, Ellipse, Line, Polyline, Polygon, Path, Rect, Shape
       * 以下是对这些组件的通用的属性方法的说明
       *   stroke() - 画笔颜色
       *   strokeWidth() - 画笔宽度
       *   strokeOpacity() - 画笔颜色的不透明度
       *   fill() - 填充颜色
       *   fillOpacity() - 填充颜色的不透明度
       *   antiAlias() - 是否抗锯齿
       *   strokeDashArray() - 指定一个用于描述虚线的 [实线长, 虚线长, 实线长, 虚线长...] 数组
       *   strokeDashOffset() - 指定绘制的虚线的起始点的偏移量
       *   strokeLineJoin() - 画笔拐角处的处理方式，比如三角形的三个顶点（LineJoinStyle 枚举）
       *     Miter - 尖角处理
       *     Round - 圆角处理
       *     Bevel - 斜切处理
       *   strokeMiterLimit() - 当 strokeLineJoin(LineJoinStyle.Miter) 时，线段连接处的那个“尖”的极限长度
       *   strokeLineCap() - 画笔两端的处理方式（LineCapStyle 枚举）
       *     Butt - 无特殊处理
       *     Round - 有一个圆形的延伸
       *     Square - 有一个矩形的延伸
       */
      Rect().width(200).height(50)
        .stroke(Color.Red)
        // 注：
        // 按照这个画笔的宽度描边后，绘制出的边框一半在组件内，一半在组件外
        // 对本例来说就是，描边后组件的整体宽高为 210 * 60
        .strokeWidth(10)
        .strokeOpacity(0.7)
        .fill(Color.Blue)
        .fillOpacity(0.7)
        .antiAlias(true)

      Rect().width(200).height(50)
        .strokeWidth(10)
        .stroke(Color.Red)
        .strokeDashArray([30, 10])
        .strokeDashOffset(0)
      Rect().width(200).height(50)
        .strokeWidth(10)
        .stroke(Color.Red)
        .strokeDashArray([30, 10])
        .strokeDashOffset(20)

      RadioBar({valueList: this.lineJoinStyle_valueList, groupName:"lineJoinStyle", onChange: (selectedIndex: number) => {
        this.lineJoinStyle = LineJoinStyle[this.lineJoinStyle_valueList[selectedIndex]]
      }})
      Rect().width(200).height(50)
        .strokeWidth(10)
        .stroke(Color.Red)
        .strokeLineJoin(this.lineJoinStyle)

      // 这个锐角的尖部不够尖
      Polyline().width(200).height(40)
        .strokeWidth(10)
        .stroke(Color.Red)
        .points([[0, 0], [200, 20], [0, 40]])
        .strokeLineJoin(this.lineJoinStyle)
        .strokeMiterLimit(0)
        .backgroundColor(Color.Blue)
      // 这个锐角的尖部足够尖
      Polyline().width(200).height(40)
        .strokeWidth(10)
        .stroke(Color.Red)
        .points([[0, 0], [200, 20], [0, 40]])
        .strokeLineJoin(this.lineJoinStyle)
        .strokeMiterLimit(1000)
        .backgroundColor(Color.Blue)

      RadioBar({valueList: this.lineCapStyle_valueList, groupName:"lineCapStyle", onChange: (selectedIndex: number) => {
        this.lineCapStyle = LineCapStyle[this.lineCapStyle_valueList[selectedIndex]]
      }})
      Line().width(200).height(50)
        .strokeWidth(20)
        .stroke(Color.Red)
        .startPoint([0, 0])
        .endPoint([200, 50])
        .strokeLineCap(this.lineCapStyle)
        .backgroundColor(Color.Blue)
    }
  }
}

@Component
struct MySample2 {
  build() {
    Column({ space: 10 }) {
      /*
       * Circle - 圆形
       *   width, height - 圆形的直径
       */
      Circle({ width: 200, height: 200 })
        .stroke(Color.Red)
        .strokeWidth(5)
        .fill(Color.Blue)
    }
  }
}

@Component
struct MySample3 {
  build() {
    Column({ space: 10 }) {
      /*
       * Ellipse - 椭圆
       *   width, height - 椭圆的宽和高
       */
      Ellipse({ width: 200, height: 100 })
        .stroke(Color.Red)
        .strokeWidth(5)
        .fill(Color.Blue)
    }
  }
}

@Component
struct MySample4 {
  build() {
    Column({ space: 10 }) {
      /*
       * Line - 直线
       *   startPoint(), endPoint() - 直线的起点坐标和终点坐标
       */
      Line({ width: 200, height: 50 })
        .strokeWidth(10)
        .stroke(Color.Red)
        .startPoint([0, 0])
        .endPoint([200, 50])
        .backgroundColor(Color.Blue)
    }
  }
}

@Component
struct MySample5 {
  build() {
    Column({ space: 10 }) {
      /*
       * Polyline - 折线
       *   points() - 折线的 n 个点的坐标
       */
      Polyline({ width: 200, height: 100 })
        .strokeWidth(10)
        .stroke(Color.Red)
        .points([[0, 0], [200, 50], [0, 100]])
        .backgroundColor(Color.Blue)
    }
  }
}

@Component
struct MySample6 {
  build() {
    Column({ space: 10 }) {
      /*
       * Polygon - 多边形
       *   points() - 多边形的 n 个点的坐标
       */
      Polygon({ width: 200, height: 100 })
        .strokeWidth(10)
        .stroke(Color.Red)
        .points([[0, 0], [200, 50], [0, 100]])
        .backgroundColor(Color.Blue)
    }
  }
}

@Component
struct MySample7 {
  build() {
    Column({ space: 10 }) {
      /*
       * Rect - 矩形
       *   width, height - 矩形的宽和高
       *   radius() - 圆角半径
       *   radiusWidth(), radiusHeight() - 分别指定圆角的宽度和高度
       */

      Rect({ width: 200, height: 80 })
        .radius(10)
        .fill(Color.Red)

      Rect({ width: 200, height: 80 })
        .radiusWidth(50)
        .radiusHeight(10)
        .fill(Color.Red)
    }
  }
}

@Component
struct MySample8 {
  build() {
    Column({ space: 10 }) {
      /*
       * Path - 路径
       *   commands() - 路径绘制的命令，单位是 px
       */
      Path({ width: 200, height: 200 })
        // 这个命令与 svg(Scalable Vector Graphics) 的 path 是一样的
        .commands('M100 15 L123.51 80.71 L195 85 L139.29 134.29 L141.42 195 L100 150 L58.58 195 L60.71 134.29 L25 85 L86.49 80.71 Z')
        .stroke(Color.Red)
        .strokeWidth(5)
    }
  }
}

@Component
struct MySample9 {
  build() {
    Column({ space: 50 }) {
      /*
       * Shape - 作为 Circle, Ellipse, Line, Polyline, Polygon, Path, Rect 的父组件
       *   在 Shape 组件指定的 stroke(), strokeWidth()... 之类的属性方法都会作用与 Shape 内的所有子组件
       *   viewPort() - 绘制区域，子组件会在此区域内绘制
       */

      Shape() {
        Rect().width(200).height(50)
        Ellipse().width(200).height(50).offset({ x: 0, y: 60 })
      }
      .width(300)
      .height(200)
      .strokeWidth(10)
      .stroke(Color.Red)
      .backgroundColor(Color.Blue)

      Shape() {
        Rect().width(200).height(50)
        Ellipse().width(200).height(50).offset({ x: 0, y: 60 })
      }
      .width(300)
      .height(200)
      .strokeWidth(10)
      .stroke(Color.Red)
      .backgroundColor(Color.Blue)
      .viewPort({ x: -20, y: 0, width: 300, height: 160 })
    }
  }
}