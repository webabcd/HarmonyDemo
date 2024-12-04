/*
 * Divider - 分隔线
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct DividerDemo {

  build() {
    Column({space:10}) {
      TitleBar()

      /*
       * Divider - 分隔线
       *   strokeWidth() - 分隔线的画笔宽度
       *   color() - 颜色
       *   vertical - 是否是垂直分隔线
       *   lineCap() - 分隔线两端的处理方式（LineCapStyle 枚举）
       *     Butt - 无特殊处理
       *     Round - 有一个圆形的延伸
       *     Square - 有一个矩形的延伸
       */

      Divider().width(300)
        .strokeWidth(50)
        .color(Color.Red)
        .lineCap(LineCapStyle.Butt)

      Divider().width(300)
        .strokeWidth(50)
        .color(Color.Red)
        .lineCap(LineCapStyle.Round)

      Divider().width(300)
        .strokeWidth(50)
        .color(Color.Red)
        .lineCap(LineCapStyle.Square)

      Divider().height(100)
        .vertical(true)
        .strokeWidth(50)
        .color(Color.Red)
    }
  }
}