/*
 * 边框相关
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct BorderDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Column().width(200).height(100).backgroundColor(Color.Blue)
        // border() - 边框（注：边框是绘制在组件内部的）
        //   width - 可以同时指定 4 个边的宽度，也可以分别指定 top/right/bottom/left 的宽度
        //   color - 颜色
        //   radius - 圆角半径
        //   style - 样式（Solid 实线，Dashed 虚线，Dotted 点状线）
        .border({
          width: {
            top: 1,
            right: 2,
            bottom: 3,
            left: 4
          },
          color: Color.Red,
          radius: 5,
          style: BorderStyle.Solid,
        })

      // borderWidth(), borderColor(), borderRadius(), borderStyle() - 与 border() 中的相关属性的作用是一样的，设置了这个则会覆盖 border() 中的相关属性的值
      // BorderStyle.Dotted - 点状线边框
      Column().width(200).height(100).backgroundColor(Color.Blue)
        .borderWidth(5)
        .borderColor(Color.Red)
        .borderRadius(5)
        .borderStyle(BorderStyle.Dotted)

      // BorderStyle.Dashed - 虚线边框
      // dashWidth - 虚线的宽度
      // dashGap - 虚线的空白处的长度
      Column().width(200).height(100).backgroundColor(Color.Blue)
        .border({
          dashWidth: {
            top: 20,
            right:20,
          },
          dashGap: {
            top: 1,
            right: 10,
          },
        })
        .borderWidth(5)
        .borderColor(Color.Red)
        .borderRadius(5)
        .borderStyle(BorderStyle.Dashed)

      // 通过 borderRadius() 实现圆角矩形
      Column().width(200).height(100).backgroundColor(Color.Blue)
        .borderRadius(20)
    }
  }
}