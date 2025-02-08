/*
 * 尺寸相关
 * width, height, aspectRatio, size, constraintSize, margin, padding, visibility, pixelRound
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CommonSizeDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('尺寸相关').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('像素级取整方式').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({ space: 10 }) {

      // width() - 宽
      // height() - 高
      Column()
        .width(100)
        .height(20)
        .backgroundColor(Color.Blue)

      // width() - 宽
      // aspectRatio() - 宽高比
      Column()
        .width(100)
        .aspectRatio(5)
        .backgroundColor(Color.Blue)

      // size() - 宽和高（一个 SizeOptions 对象）
      //   如果设置了 size 且设置了 width 和 height，则以 width 和 height 为准
      Column()
        .size({
          width: 100,
          height: 20,
        })
        .backgroundColor(Color.Blue)

      // constraintSize() - 宽和高的约束（一个 ConstraintSizeOptions 对象，可以指定最大宽高和最小宽高）
      Column()
        .width('100%')
        .height('100%')
        .constraintSize({
          maxWidth: 100,
          maxHeight: 20,
          minWidth: 0,
          minHeight: 0,
        })
        .backgroundColor(Color.Blue)

      // padding() - 内边距（可以指定一个内边距值，也可以分别指定 top/right/bottom/left）
      Column() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Red)
      }
      .padding(5)
      .width(100)
      .height(100)
      .backgroundColor(Color.Blue)

      // margin() - 外边距（可以指定一个外边距值，也可以分别指定 top/right/bottom/left）
      Column() {
        Column()
          .width(50)
          .height(50)
          .margin({
            top: 10,
          })
          .backgroundColor(Color.Red)
      }
      .width(100)
      .height(100)
      .backgroundColor(Color.Blue)

      // visibility() - 显示状态（Visibility 枚举）
      //   Visible - 显示
      //   Hidden - 隐藏（占位）
      //   None - 隐藏（不占位）
      Column().width(50).height(50).backgroundColor(Color.Red).visibility(Visibility.Hidden)
      Column().width(50).height(50).backgroundColor(Color.Green).visibility(Visibility.Visible)
      Column().width(50).height(50).backgroundColor(Color.Blue).visibility(Visibility.None)
      Column().width(50).height(50).backgroundColor(Color.Orange).visibility(Visibility.Visible)
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column({ space: 10 }) {
      Stack() {
        // 显示在屏幕上时，会对实际计算出的像素值做四舍五入
        Column().width('500.6px').height('500.6px').backgroundColor(Color.Red) // 显示在屏幕上的大小为 501 * 501
        Column().width('500.2px').height('500.2px').backgroundColor(Color.Blue) // 显示在屏幕上的大小为 500 * 500
      }

      /*
       * pixelRound() - 指定当前组件的像素级取整方式（可以分别指定 top, bottom, start, end 方向的取整方式）
       *   PixelRoundCalcPolicy.NO_FORCE_ROUND - 不处理
       *   PixelRoundCalcPolicy.FORCE_CEIL - 向上取整
       *   PixelRoundCalcPolicy.FORCE_FLOOR - 向下取整
       */

      Stack() {
        Column().width('500.6px').height('500.6px').backgroundColor(Color.Red)  // 显示在屏幕上的大小为 501 * 501
          .pixelRound({
            top:PixelRoundCalcPolicy.FORCE_CEIL,
            bottom:PixelRoundCalcPolicy.FORCE_CEIL,
            start:PixelRoundCalcPolicy.FORCE_CEIL,
            end:PixelRoundCalcPolicy.FORCE_CEIL,
          })
        Column().width('500.2px').height('500.2px').backgroundColor(Color.Blue)  // 显示在屏幕上的大小为 501 * 501
          .pixelRound({
            top:PixelRoundCalcPolicy.FORCE_CEIL,
            bottom:PixelRoundCalcPolicy.FORCE_CEIL,
            start:PixelRoundCalcPolicy.FORCE_CEIL,
            end:PixelRoundCalcPolicy.FORCE_CEIL,
          })
      }
    }
  }
}