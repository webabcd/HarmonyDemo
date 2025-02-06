/*
 * 尺寸相关
 * width, height, aspectRatio, size, constraintSize, margin, padding, visibility
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CommonSizeDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

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