/*
 * 尺寸相关
 * width, height, size, constraintSize, margin, padding
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CommonSizeDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // width - 宽
      // height - 高
      Column()
        .width(100)
        .height(20)
        .backgroundColor(Color.Blue)

      // size - 宽和高（SizeOptions 接口）
      //   如果设置了 size 且设置了 width 和 height，则以 width 和 height 为准
      Column()
        .size({
          width: 100,
          height: 20,
        })
        .backgroundColor(Color.Blue)

      // constraintSize - 宽和高的约束（ConstraintSizeOptions 接口，可以指定最大宽高和最小宽高）
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

      // padding - 内边距（可以同时指定 4 个边距，也可以分别指定 top/right/bottom/left）
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

      // margin - 外边距（可以同时指定 4 个边距，也可以分别指定 top/right/bottom/left）
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
    }
  }
}