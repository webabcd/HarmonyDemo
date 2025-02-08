/*
 * Row - 水平布局
 *   space - Row 内的每个组件之间的间距
 *   reverse() - 是否需要反转排列
 *   alignItems() - Row 内的每个组件的垂直对齐方式
 *   justifyContent() - Row 内的每个组件的水平排列方式
 *
  * Row 子组件
 *   flexBasis() - 水平方向上的尺寸（不支持半分比），相当于 width()
 *   alignSelf() - 垂直对齐方式，会覆盖 Row 的 alignItems()
 *   layoutWeight() - 水平方向上占用空间的权重
 *   flexGrow() - 水平方向上占用空间的权重，与 layoutWeight() 一样，但是必须要指定 Row 的 width() 才会生效
 *   flexShrink() - 水平方向上空间不够时的压缩的权重，必须要指定 Row 的 width() 才会生效
 *
 * 注：
 * 1、水平方向上的多个组件如果超过了 Column 的限制范围，是不会 wrap 的，如果需要 wrap 请参见 FlexDemo.ets 中的说明
 * 2、如果需要空白处自动填满，可以使用 Blank 组件，详见 component/display/BlankDemo.ets 中的说明
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct RowDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('垂直对齐方式').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('水平排列方式').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('权重').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('优先级').align(Alignment.Top)
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
    Column() {
      // space - Row 内的每个组件之间的间距
      Row({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }
      .width(300).height(100).backgroundColor(Color.Orange)

      // reverse() - 是否需要反转排列
      Row({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }
      .width(300).height(100).backgroundColor(Color.Yellow)
      .reverse(true)

      // 子组件 flexBasis() - 水平方向上的尺寸（不支持半分比），相当于 width()
      // 注：不指定 Row 的宽高的话，则其宽高会跟随其子组件们的尺寸
      Row() {
        Text('1').flexBasis(100)
        Text('2')
        Text('3')
      }
      .backgroundColor(Color.Red)
    }
  }
}

@Component
struct MySample2 {

  @State verticalAlign: VerticalAlign = VerticalAlign.Top
  valueList =  ["Top", "Center", "Bottom"]

  build() {
    Column({space: 5}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.verticalAlign = VerticalAlign[this.valueList[selectedIndex]]
      }})

      // alignItems() - Row 内的每个组件的垂直对齐方式（VerticalAlign 枚举）
      //   Top, Center, Bottom
      // 子组件 alignSelf() - 垂直对齐方式（ItemAlign 枚举），会覆盖 Row 的 alignItems()
      //   Auto, Start, Center, End, Baseline, Stretch
      Row({space: 20}) {
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue).alignSelf(ItemAlign.End)
        Column().width(50).height(100).backgroundColor(Color.Blue).alignSelf(ItemAlign.Stretch)
      }
      .width('100%').height(400).backgroundColor(Color.Yellow)
      .alignItems(this.verticalAlign)
    }
    .width('100%').height('100%').alignItems(HorizontalAlign.Center)
  }
}

@Component
struct MySample3 {

  @State flexAlign: FlexAlign = FlexAlign.Start
  valueList =  ["Start", "Center", "End", "SpaceBetween", "SpaceAround", "SpaceEvenly"]

  build() {
    Column({space: 5}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.flexAlign = FlexAlign[this.valueList[selectedIndex]]
      }})

      // justifyContent() - Row 内的每个组件的水平排列方式（FlexAlign 枚举）
      //   Start - 整体居左
      //   Center - 整体居中
      //   End - 整体居右
      //   SpaceBetween - 每个组件中间的空白相同，两侧边缘与父组件之间无空白
      //   SpaceAround - 每个组件中间的空白相同，两侧边缘与父组件之间的空白为组件之间的空白的二分之一
      //   SpaceEvenly - 每个组件中间的空白相同，两侧边缘与父组件之间的空白与组件之间的空白相同
      Row() {
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
      }
      .width('100%').height(400).backgroundColor(Color.Yellow)
      .justifyContent(this.flexAlign)
    }
    .width('100%').height('100%').alignItems(HorizontalAlign.Center)
  }
}

@Component
struct MySample4 {
  build() {
    Column() {
      Row() {
        /*
         * 子组件 layoutWeight() - 水平方向上占用空间的权重
         */
        Column().height('100%').backgroundColor(Color.Red)
          .width(20)
        Column().height('100%').backgroundColor(Color.Green)
          .layoutWeight(3)
        Column().height('100%').backgroundColor(Color.Blue)
          .layoutWeight(1)
        Column().height('100%').backgroundColor(Color.Orange)
          .layoutWeight(2)
      }
      .height('33.3%')

      Row() {
        /*
         * 子组件 flexGrow() - 水平方向上占用空间的权重，与 layoutWeight() 一样
         *   但是必须要指定 Row 的 width() 才会生效
         */
        Column().height('100%').backgroundColor(Color.Red)
          .width(50)
        Column().height('100%').backgroundColor(Color.Green)
          .flexGrow(3)
        Column().height('100%').backgroundColor(Color.Blue)
          .flexGrow(1)
        Column().height('100%').backgroundColor(Color.Orange)
          .flexGrow(2)
      }
      .height('33.3%')
      .width('100%')

      Row() {
        /*
         * 子组件 flexShrink() - 水平方向上空间不够时的压缩的权重
         *   必须要指定 Row 的 width() 才会生效
         *
         * 以本例为例：
         * 红色占用空间为 100
         * 绿色占用空间为整个空间的 50%
         * 蓝色占用空间为，除了红色和绿色之外的空间的 50/130
         * 橙色占用空间为，除了红色和绿色之外的空间的 80/130
         */
        Column().height('100%').backgroundColor(Color.Red)
          .width(100)
          .flexShrink(0) // 不压缩
        Column().height('100%').backgroundColor(Color.Green)
          .width('50%')
          .flexShrink(0) // 不压缩
        Column().height('100%').backgroundColor(Color.Blue)
          .width('50%')
          .flexShrink(1) // 压缩权重 1
        Column().height('100%').backgroundColor(Color.Orange)
          .width('80%')
          .flexShrink(1) // 压缩权重 1
      }
      .height('33.3%')
      .width('100%')
    }
  }
}

@Component
struct MySample5 {
  build() {
    Column({space:50}) {

      /*
       * displayPriority() - 子组件是否显示的优先级（数字越大优先级越高）
       *   显示不下时，则隐藏低优先级的子组件
       *   同一优先级的子组件要显示就都显示，要隐藏就都隐藏
       */

      Row() {
        Column().width(50).height('100%').backgroundColor(Color.Red)
          .displayPriority(1)
        Column().width(50).height('100%').backgroundColor(Color.Green)
          .displayPriority(2)
        Column().width(50).height('100%').backgroundColor(Color.Blue)
          .displayPriority(3)
        Column().width(50).height('100%').backgroundColor(Color.Orange)
          .displayPriority(4)
      }
      .backgroundColor(Color.Yellow)
      .height(100)
      .width(180)

      Row() {
        Column().width(50).height('100%').backgroundColor(Color.Red)
          .displayPriority(1)
        Column().width(50).height('100%').backgroundColor(Color.Green)
          .displayPriority(2)
        Column().width(50).height('100%').backgroundColor(Color.Blue)
          .displayPriority(2)
        Column().width(50).height('100%').backgroundColor(Color.Orange)
          .displayPriority(1)
      }
      .backgroundColor(Color.Yellow)
      .height(100)
      .width(180)
    }
  }
}