/*
 * RelativeContainer - 相对布局，通过约束做组件的布局
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct RelativeContainerDemoDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('与指定 id 的组件约束').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('与指定的 guideLine 约束').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('与指定的 barrier 约束').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('链式约束').align(Alignment.Top)
      }
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {
  build() {
    // alignRules() - RelativeContainer 内的子组件通过 alignRules() 指定各自的约束规则
    //   可以指定 top/right/bottom/left/center 相对于指定 id 的组件的约束（注："__container__" 代表父组件）
    //   当约束的周围有空余空间时，组件会在约束范围内居中，这个位置可以通过 bias 的 horizontal 和 vertical 调整（默认值是 0.5，必须要大于等于 0）
    RelativeContainer() {
      Row(){Text('row1')}.justifyContent(FlexAlign.Center).width(100).height(100).backgroundColor(Color.Orange)
      .id("row1")
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        left: {anchor: "__container__", align: HorizontalAlign.Start}
      })

      Row(){Text('row2')}.justifyContent(FlexAlign.Center).width(100).height(100).backgroundColor(Color.Orange)
      .id("row2")
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        bottom: {anchor: "__container__", align: VerticalAlign.Bottom},
        right: {anchor: "__container__", align: HorizontalAlign.End},
        // 显示在约束范围内的垂直方向上的 70% 的位置上（默认值为 0.5 也就是会在约束范围内居中）
        bias : {vertical : 0.7}
      })

      Row(){Text('row3')}.justifyContent(FlexAlign.Center).height(100).backgroundColor(Color.Orange)
      .id("row3")
      .alignRules({
        top: {anchor: "row1", align: VerticalAlign.Bottom},
        left: {anchor: "row1", align: HorizontalAlign.End},
        right: {anchor: "row2", align: HorizontalAlign.Start},
      })

    }
    .width(300).height(300)
    .backgroundColor(Color.Blue)
  }
}

@Component
struct MySample2 {
  build() {
    // guideLine 参考线
    // guideLine() - 在 RelativeContainer 内画参考线，然后子组件通过 alignRules() 与指定的参考线做约束规则
    RelativeContainer() {
      Row().width(100).height(100).backgroundColor(Color.Orange)
        .alignRules({
          left: {anchor: "guideLine1", align: HorizontalAlign.Start},
          top: {anchor: "guideLine2", align: VerticalAlign.Top}
        })
    }
    .width(300).height(300)
    .backgroundColor(Color.Blue)
    .guideLine([
      // 画一条垂直参考线，距左侧 20vp
      {id:"guideLine1", direction: Axis.Vertical, position:{start:20}},
      // 画一条水平参考线，距顶部 50vp
      {id:"guideLine2", direction: Axis.Horizontal, position:{start:50}}
    ])
  }
}

@Component
struct MySample3 {
  build() {
    // barrier 屏障
    // barrier() - 在 RelativeContainer 内以指定 id 的多个组件的组合体的边界做屏障，然后子组件通过 alignRules() 与指定的屏障做约束规则
    RelativeContainer() {
      Row(){Text('row1')}.justifyContent(FlexAlign.Center).width(100).height(100).backgroundColor(Color.Orange)
      .id("row1")

      Row(){Text('row2')}.justifyContent(FlexAlign.Center).width(100).height(100).backgroundColor(Color.Orange)
      .alignRules({
        middle: {anchor: "row1", align: HorizontalAlign.End},
        top: {anchor: "row1", align: VerticalAlign.Bottom}
      })
      .id("row2")

      Row(){Text('row3')}.justifyContent(FlexAlign.Center).width(100).height(100).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "barrier1", align: HorizontalAlign.End},
        top: {anchor: "row1", align: VerticalAlign.Top}
      })
      .id("row3")

      Row(){Text('row4')}.justifyContent(FlexAlign.Center).width(50).height(50).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row1", align: HorizontalAlign.Start},
        top: {anchor: "barrier2", align: VerticalAlign.Bottom}
      })
      .id("row4")
    }
    .width(300).height(300)
    .backgroundColor(Color.Blue)
    .barrier([
      // 以 row1, row2 的组合体的右侧边界作为屏障
      {id: "barrier1", direction: BarrierDirection.RIGHT, referencedId:["row1", "row2"]},
      // 以 row1, row2 的组合体的下部边界作为屏障
      {id: "barrier2", direction: BarrierDirection.BOTTOM, referencedId:["row1", "row2"]}
    ])
  }
}

@Component
struct MySample4 {
  build() {
    // chainMode() - RelativeContainer 内的子组件通过 chainMode() 指定某个方向上的多个子组件的链式排列的模式
    //   Axis - 方向
    //     Vertical, Horizontal
    //   ChainStyle - 链式排列的模式
    //     SPREAD - 链中的各个组件在约束锚点间均匀分布
    //     SPREAD_INSIDE - 链中的各个组件在约束锚点间均匀分布，但是首节点的起始部分和尾节点的结束部分与容器的边缘对齐
    //     PACKED - 链中的各个组件之间无间隙
    // 注：RelativeContainer 内的某个子组件指定了 chainMode() 则这个子组件就是链头，此链的方向由 Axis 决定，此链的排列模式由 ChainStyle 决定
    RelativeContainer() {
      Row(){Text('row1')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "__container__", align: HorizontalAlign.Start},
        right: {anchor: "row2", align : HorizontalAlign.Start},
        top: {anchor: "__container__", align: VerticalAlign.Top}
      })
      .id("row1")
      .chainMode(Axis.Horizontal, ChainStyle.SPREAD)

      Row(){Text('row2')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row1", align: HorizontalAlign.End},
        right: {anchor: "row3", align : HorizontalAlign.Start},
        top: {anchor: "row1", align: VerticalAlign.Top}
      })
      .id("row2")

      Row(){Text('row3')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row2", align: HorizontalAlign.End},
        right: {anchor: "__container__", align : HorizontalAlign.End},
        top: {anchor: "row1", align: VerticalAlign.Top}
      })
      .id("row3")

      Row(){Text('row4')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "__container__", align: HorizontalAlign.Start},
        right: {anchor: "row5", align : HorizontalAlign.Start},
        center: {anchor: "__container__", align: VerticalAlign.Center}
      })
      .id("row4")
      .chainMode(Axis.Horizontal, ChainStyle.SPREAD_INSIDE)

      Row(){Text('row5')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row4", align: HorizontalAlign.End},
        right: {anchor: "row6", align : HorizontalAlign.Start},
        top: {anchor: "row4", align: VerticalAlign.Top}
      })
      .id("row5")

      Row(){Text('row6')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row5", align: HorizontalAlign.End},
        right: {anchor: "__container__", align : HorizontalAlign.End},
        top: {anchor: "row4", align: VerticalAlign.Top}
      })
      .id("row6")

      Row(){Text('row7')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "__container__", align: HorizontalAlign.Start},
        right: {anchor: "row8", align : HorizontalAlign.Start},
        bottom: {anchor: "__container__", align: VerticalAlign.Bottom}
      })
      .id("row7")
      .chainMode(Axis.Horizontal, ChainStyle.PACKED)

      Row(){Text('row8')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row7", align: HorizontalAlign.End},
        right: {anchor: "row9", align : HorizontalAlign.Start},
        top: {anchor: "row7", align: VerticalAlign.Top}
      })
      .id("row8")

      Row(){Text('row9')}.justifyContent(FlexAlign.Center).width(80).height(80).backgroundColor(Color.Orange)
      .alignRules({
        left: {anchor: "row8", align: HorizontalAlign.End},
        right: {anchor: "__container__", align : HorizontalAlign.End},
        top: {anchor: "row7", align: VerticalAlign.Top}
      })
      .id("row9")
    }
    .width(300).height(300)
    .backgroundColor(Color.Blue)
  }
}