/*
 * 边框相关
 */

import { RadioBar, TitleBar } from '../TitleBar';

@Entry
@Component
struct BorderDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('border').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('borderImage').align(Alignment.Top)
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

@Component
struct MySample2 {

  @State myRepeat: RepeatMode = RepeatMode.Repeat
  valueList =  ["Repeat", "Stretch", "Round", "Space"]

  @State myFill: boolean = true

  build() {
    Column({ space: 10 }) {

      Button(`fill:${this.myFill}`).onClick(() => {
        this.myFill = !this.myFill
      })

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.myRepeat = RepeatMode[this.valueList[selectedIndex]]
      }})

      /*
       * borderImage() - 边框（图片边框，或线性渐变边框）
       *   source - 指定一个图片，或一个 LinearGradient 对象（可以参见 GradientDemo.ets 中的说明）
       *   width - 边框宽度
       *   outset - 边框向外延伸的距离
       *   fill - 中心是否需要填充
       *   slice - 图片被切割的尺寸
       *     top - 图片左上角或者右上角被切割的高
       *     bottom - 图片左下角或者右下角被切割的高
       *     left - 图片左上角或者左下角被切割的宽
       *     right - 图片右上角或者右下角被切割的宽
       *   repeat - 被切割的图片的重复方式（RepeatMode 枚举）
       *     Repeat - 重复，需要充满，超出的被剪裁
       *     Stretch - 拉伸，需要充满
       *     Round - 重复整数次，需要充满，允许压缩，不允许有空白间距
       *     Space - 重复整数次，需要充满，允许有空白间距，不允许压缩
       */

      Column().width(200).height(80)
        .borderImage({
          source: $r('app.media.son'),
          width: { top: 20, bottom: 20, left: 20, right: 20 },
          outset: { top: 0, bottom: 0, left: 0, right: 0 },
          fill: this.myFill,
          slice: { top: 10, bottom: 10, left: 10, right: 10 },
          repeat: this.myRepeat
        })

      Column().width(200).height(80)
        .borderImage({
          source: {
            angle: 90, // 从左到右线性渐变
            colors: [[Color.Red, 0.0], [Color.Green, 0.5], [Color.Blue, 1.0]]
          },
          width: 20,
          outset: 0,
          fill: false,
          slice: 10,
          repeat: RepeatMode.Stretch
        })
    }
  }
}