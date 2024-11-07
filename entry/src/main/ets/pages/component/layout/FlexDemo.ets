/*
 * Flex - 垂直布局或水平布局
 *   direction - 布局的方向
 *   space - 子组件的间距
 *   justifyContent - 每个子组件的主轴方向上的排列方式
 *   alignItems - 每个子组件的交叉轴方向上的对齐方式
 *   wrap - 当多个子组件所需要的主轴空间超过了 Flex 的主轴的大小，且 Flex 的交叉轴有额外的空间时，是否需要 wrap
 *   alignContent - 当 Flex 内的多个组件 wrap 的时候，指定他们在交叉轴上的排列方式
 *   layoutWeight() - 主轴方向上占用空间的权重
 */

import { TitleBar, RadioBar } from '../../TitleBar';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
struct FlexDemo {

  build() {
    Column() {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('垂直布局').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('水平布局').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('wrap').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('权重').align(Alignment.Top)
      }
    }
  }
}

@Component
struct MySample1 {
  build() {
    // direction - 布局的方向（FlexDirection 枚举）
    //   Row, Column, RowReverse, ColumnReverse
    // space - 子组件的间距（FlexSpaceOptions 接口）
    //   main - 主轴方向上的子组件的间距
    //   cross - 交叉轴方向上的子组件的间距
    //
    // 注：不指定 Flex 的宽高的话，则其主轴方向会撑满父容器，交叉轴方向会跟随其子组件们的尺寸
    Flex({
      direction: FlexDirection.Column,
      space: {
        main: LengthMetrics.vp(30),
      }
    }) {
      Text('1')
      Text('2')
      Text('3')
    }
    .backgroundColor(Color.Orange)
  }
}

@Component
struct MySample2 {
  build() {
    Flex({
      // 垂直布局时
      //   justifyContent - Flex 内的每个组件的垂直排列方式（可参见 ColumnDemo.ets 中的相关说明）
      //   alignItems - Flex 内的每个组件的水平对齐方式（可参见 ColumnDemo.ets 中的相关说明）
      direction: FlexDirection.Column,
      space: {
        main: LengthMetrics.vp(10),
      },
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.End,
    }) {
      Column().width(100).height(50).backgroundColor(Color.Blue)
      Column().width(100).height(50).backgroundColor(Color.Blue)
      Column().width(100).height(50).backgroundColor(Color.Blue)
    }
    .width(200)
    .backgroundColor(Color.Orange)
  }
}

@Component
struct MySample3 {
  build() {
    Flex({
      // 水平布局时
      //   justifyContent - Flex 内的每个组件的水平排列方式（可参见 RowDemo.ets 中的相关说明）
      //   alignItems - Flex 内的每个组件的垂直对齐方式（可参见 RowDemo.ets 中的相关说明）
      direction: FlexDirection.Row,
      space: {
        main: LengthMetrics.vp(10),
      },
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.End,
    }) {
      Column().width(50).height(100).backgroundColor(Color.Blue)
      Column().width(50).height(100).backgroundColor(Color.Blue)
      Column().width(50).height(100).backgroundColor(Color.Blue)
    }
    .height(200)
    .backgroundColor(Color.Orange)
  }
}

@Component
struct MySample4 {
  @State flexWrap: FlexWrap = FlexWrap.NoWrap
  flexWrap_valueList =  ["NoWrap", "Wrap", "WrapReverse"]

  @State flexAlign: FlexAlign = FlexAlign.Start
  flexAlign_valueList =  ["Start", "Center", "End", "SpaceBetween", "SpaceAround", "SpaceEvenly"]

  build() {
    Column({space: 20}) {
      RadioBar({valueList: this.flexWrap_valueList, groupName: 'group1', onChange: (selectedIndex: number) => {
        this.flexWrap = FlexWrap[this.flexWrap_valueList[selectedIndex]]
      }})

      RadioBar({valueList: this.flexAlign_valueList, groupName: 'group2', onChange: (selectedIndex: number) => {
        this.flexAlign = FlexAlign[this.flexAlign_valueList[selectedIndex]]
      }})

      // space - 子组件的间距（FlexSpaceOptions 接口）
      //   main - 主轴方向上的间距
      //   cross - 交叉轴方向上的间距（当 Flex 内的多个组件 wrap 的时候，就会有交叉轴的排列，此值就会生效）
      // wrap - 当 Flex 内的多个组件所需要的主轴空间超过了 Flex 的主轴的大小，且 Flex 的交叉轴有额外的空间时（FlexWrap 枚举）
      //   NoWrap - 不允许 wrap
      //   Wrap - 允许 wrap
      // alignContent - 当 Flex 内的多个组件 wrap 的时候，此值用于指定他们在交叉轴上的排列方式（FlexAlign 枚举，可以参见 ColumnDemo.ets 或 RowDemo.ets 中的相关说明）
      Flex({
        space: {
          main: LengthMetrics.vp(10),
          cross: LengthMetrics.vp(10),
        },
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceEvenly,
        alignItems: ItemAlign.End,
        wrap: this.flexWrap,
        alignContent: this.flexAlign,
      }) {
        Column().width('40%').height(20).backgroundColor(Color.Blue)
        Column().width('40%').height(20).backgroundColor(Color.Blue)
        Column().width('40%').height(20).backgroundColor(Color.Blue)
      }
      .width(200)
      .height(100)
      .backgroundColor(Color.Orange)
    }
  }
}

@Component
struct MySample5 {
  build() {
    Column() {

      /*
       * layoutWeight() - 主轴方向上占用空间的权重
       */

      Flex({direction: FlexDirection.Column}) {
        Column().width('100%').backgroundColor(Color.Red)
          .height(40)

        Column().width('100%').backgroundColor(Color.Green)
          .layoutWeight(3)

        Column().width('100%').backgroundColor(Color.Blue)
          .layoutWeight(1)

        Column().width('100%').backgroundColor(Color.Orange)
          .layoutWeight(2)
      }
      .width('100%')
      .layoutWeight(1)

      Flex({direction: FlexDirection.Row}) {
        Column().height('100%').backgroundColor(Color.Red)
          .width(40)

        Column().height('100%').backgroundColor(Color.Green)
          .layoutWeight(3)

        Column().height('100%').backgroundColor(Color.Blue)
          .layoutWeight(1)

        Column().height('100%').backgroundColor(Color.Yellow)
          .layoutWeight(2)
      }
      .width('100%')
      .layoutWeight(1)
    }
  }
}