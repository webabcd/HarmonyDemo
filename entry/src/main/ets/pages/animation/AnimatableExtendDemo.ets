/*
 * @AnimatableExtend - 用于为指定的组件自定义可动画的属性方法
 * AnimatableArithmetic<T> - 用于让指定的数据类型支持动画算法
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct AnimatableExtendDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('@AnimatableExtend').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('AnimatableArithmetic<T>').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

/*
 * @AnimatableExtend - 用于为指定的组件自定义可动画的属性方法
 *   仅支持在全局定义
 *   函数的参数类型仅支持 number 或 AnimatableArithmetic<T> 对象
 */
// 为 Column 组件定义一个名为 animatableWidthHeight() 的属性方法，此属性方法是可动画的，即可以通过 animation() 实现属性动画
// animatableWidthHeight() 接收一个 number 类型的参数，且函数体内只能调用 Column 的属性方法
@AnimatableExtend(Column)
function animatableWidthHeight(value: number) {
  .width(value)
  .height(value)
}
@Component
struct MySample1 {
  @State width_height: number = 100;

  build() {
    Column({space:10}) {
      Button("click me")
        .onClick(() => {
          this.width_height = this.width_height == 100 ? 200 : 100;
        })

      Column().backgroundColor(Color.Orange)
        // 使用通过 @AnimatableExtend 装饰的自定义的可动画的属性方法
        .animatableWidthHeight(this.width_height)
        .animation({ duration: 2000, curve: Curve.Ease })
    }
  }
}

/*
 * AnimatableArithmetic<T> - 用于让指定的数据类型支持动画算法
 *   需要实现 plus(), subtract(), multiply(), equals()
 */
class Point implements AnimatableArithmetic<Point> {
  x: number
  y: number

  constructor(x: number, y: number) {
    this.x = x
    this.y = y
  }
  plus(p: Point): Point {
    return new Point(this.x + p.x, this.y + p.y)
  }
  subtract(p: Point): Point {
    return new Point(this.x - p.x, this.y - p.y)
  }
  multiply(scale: number): Point {
    return new Point(this.x * scale, this.y * scale)
  }
  equals(p: Point): boolean {
    return this.x == p.x && this.y == p.y
  }
}
/*
 * @AnimatableExtend - 用于为指定的组件自定义可动画的属性方法
 *   仅支持在全局定义
 *   函数的参数类型仅支持 number 或 AnimatableArithmetic<T> 对象
 */
// 为 Line 组件定义一个名为 animatableEndPoint() 的属性方法，此属性方法是可动画的，即可以通过 animation() 实现属性动画
// animatableEndPoint() 接收一个 Point 类型（其实现了 AnimatableArithmetic<T> 接口）的参数，且函数体内只能调用 Line 的属性方法
@AnimatableExtend(Line) function animatableEndPoint(point: Point) {
  .endPoint([point.x, point.y])
}
@Component
struct MySample2 {

  @State endPoint:Point = new Point(260, 20)

  build() {
    Column({space:10}) {
      Button("click me")
        .onClick(() => {
          this.endPoint = this.endPoint.x == 260 ? new Point(20, 260) : new Point(260, 20);
        })

      Line({ width: 300, height: 300 })
        .strokeWidth(5)
        .stroke(Color.Red)
        .startPoint([20, 20])
        // 使用通过 @AnimatableExtend 装饰的自定义的可动画的属性方法
        .animatableEndPoint(this.endPoint)
        .animation({ duration: 2000, curve: Curve.Ease })
    }
  }
}