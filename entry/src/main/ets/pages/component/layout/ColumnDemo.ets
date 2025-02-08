/*
 * Column - 垂直布局
 *   space - Column 内的每个组件之间的间距
 *   reverse() - 是否需要反转排列
 *   alignItems() - Column 内的每个组件的水平对齐方式
 *   justifyContent() - Column 内的每个组件的垂直排列方式
 *
 * Column 子组件
 *   flexBasis() - 垂直方向上的尺寸（不支持半分比），相当于 height()
 *   alignSelf() - 水平对齐方式，会覆盖 Column 的 alignItems()
 *   layoutWeight() - 垂直方向上占用空间的权重
 *   flexGrow() - 垂直方向上占用空间的权重，与 layoutWeight() 一样，但是必须要指定 Column 的 height() 才会生效
 *   flexShrink() - 垂直方向上空间不够时的压缩的权重，必须要指定 Column 的 height() 才会生效
 *
 * 注：
 * 1、垂直方向上的多个组件如果超过了 Column 的限制范围，是不会 wrap 的，如果需要 wrap 请参见 FlexDemo.ets 中的说明
 * 2、如果需要空白处自动填满，可以使用 Blank 组件，详见 BlankDemo.ets 中的说明
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct ColumnDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('水平对齐方式').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('垂直排列方式').align(Alignment.Top)
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
      // space - Column 内的每个组件之间的间距
      Column({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }
      .width(300).height(200).backgroundColor(Color.Orange)

      // reverse() - 是否需要反转排列
      Column({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }
      .width(300).height(200).backgroundColor(Color.Yellow)
      .reverse(true)

      // 子组件 flexBasis() - 垂直方向上的尺寸（不支持半分比），相当于 height()
      // 注：不指定 Column 的宽高的话，则其宽高会跟随其子组件们的尺寸
      Column() {
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

  @State horizontalAlign: HorizontalAlign = HorizontalAlign.Start
  valueList =  ["Start", "Center", "End"]

  build() {
    // alignItems() - Column 内的每个组件的水平对齐方式（HorizontalAlign 枚举）
    //   Start, Center, End
    // 子组件 alignSelf() - 水平对齐方式（ItemAlign 枚举），会覆盖 Column 的 alignItems()
    //   Auto, Start, Center, End, Baseline, Stretch
    Column({space: 5}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.horizontalAlign = HorizontalAlign[this.valueList[selectedIndex]]
      }})

      Column().width('80%').height(50).backgroundColor(Color.Blue)
      Column().width('80%').height(50).backgroundColor(Color.Blue)
      Column().width('80%').height(50).backgroundColor(Color.Blue)
      Column().width('80%').height(50).backgroundColor(Color.Blue).alignSelf(ItemAlign.End)
      Column().width('80%').height(50).backgroundColor(Color.Blue).alignSelf(ItemAlign.Stretch)
    }.width('100%').backgroundColor(Color.Orange)
    .alignItems(this.horizontalAlign)
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

      // justifyContent() - Column 内的每个组件的垂直排列方式（FlexAlign 枚举）
      //   Start - 整体居顶部
      //   Center - 整体居中
      //   End - 整体居底部
      //   SpaceBetween - 每个组件中间的空白相同，两侧边缘与父组件之间无空白
      //   SpaceAround - 每个组件中间的空白相同，两侧边缘与父组件之间的空白为组件之间的空白的二分之一
      //   SpaceEvenly - 每个组件中间的空白相同，两侧边缘与父组件之间的空白与组件之间的空白相同
      Column() {
        Column().width('80%').height(50).backgroundColor(Color.Blue)
        Column().width('80%').height(50).backgroundColor(Color.Blue)
        Column().width('80%').height(50).backgroundColor(Color.Blue)
      }
      .width('100%').height(400).backgroundColor(Color.Orange)
      .justifyContent(this.flexAlign)
    }.width('100%').height('100%')
  }
}

@Component
struct MySample4 {
  build() {
    Row() {

      Column() {
        /*
         * 子组件 layoutWeight() - 垂直方向上占用空间的权重
         */
        Column().width('100%').backgroundColor(Color.Red)
          .height(50)
        Column().width('100%').backgroundColor(Color.Green)
          .layoutWeight(3)
        Column().width('100%').backgroundColor(Color.Blue)
          .layoutWeight(1)
        Column().width('100%').backgroundColor(Color.Orange)
          .layoutWeight(2)
      }
      .width('33.3%')

      Column() {
        /*
         * 子组件 flexGrow() - 垂直方向上占用空间的权重，与 layoutWeight() 一样
         *   但是必须要指定 Column 的 height() 才会生效
         */
        Column().width('100%').backgroundColor(Color.Red)
          .height(100)
        Column().width('100%').backgroundColor(Color.Green)
          .flexGrow(3)
        Column().width('100%').backgroundColor(Color.Blue)
          .flexGrow(1)
        Column().width('100%').backgroundColor(Color.Orange)
          .flexGrow(2)
      }
      .width('33.3%')
      .height('100%')

      Column() {
        /*
         * 子组件 flexShrink() - 垂直方向上空间不够时的压缩的权重
         *   必须要指定 Column 的 height() 才会生效
         *
         * 以本例为例：
         * 红色占用空间为 200
         * 绿色占用空间为整个空间的 50%
         * 蓝色占用空间为，除了红色和绿色之外的空间的 50/130
         * 橙色占用空间为，除了红色和绿色之外的空间的 80/130
         */
        Column().width('100%').backgroundColor(Color.Red)
          .height(200)
          .flexShrink(0) // 不压缩
        Column().width('100%').backgroundColor(Color.Green)
          .height('50%')
          .flexShrink(0) // 不压缩
        Column().width('100%').backgroundColor(Color.Blue)
          .height('50%')
          .flexShrink(1) // 压缩权重 1
        Column().width('100%').backgroundColor(Color.Orange)
          .height('80%')
          .flexShrink(1) // 压缩权重 1
      }
      .width('33.3%')
      .height('100%')
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

      Column() {
        Column().width('100%').height(50).backgroundColor(Color.Red)
          .displayPriority(1)
        Column().width('100%').height(50).backgroundColor(Color.Green)
          .displayPriority(2)
        Column().width('100%').height(50).backgroundColor(Color.Blue)
          .displayPriority(3)
        Column().width('100%').height(50).backgroundColor(Color.Orange)
          .displayPriority(4)
      }
      .backgroundColor(Color.Yellow)
      .height(180)

      Column() {
        Column().width('100%').height(50).backgroundColor(Color.Red)
          .displayPriority(1)
        Column().width('100%').height(50).backgroundColor(Color.Green)
          .displayPriority(2)
        Column().width('100%').height(50).backgroundColor(Color.Blue)
          .displayPriority(2)
        Column().width('100%').height(50).backgroundColor(Color.Orange)
          .displayPriority(1)
      }
      .backgroundColor(Color.Yellow)
      .height(180)
    }
  }
}