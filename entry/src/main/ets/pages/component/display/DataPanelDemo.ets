/*
 * DataPanel - 数据面板（可以展示多条数据的占比情况）
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct DataPanelDemo {

  build() {
    Column({space:10}) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({ space: 10 }) {

      /*
       * DataPanel - 数据面板（可以展示多条数据的占比情况）
       *   max - 数据的总值
       *   values - 数据值列表，最多 9 个
       *   type - 面板类型（DataPanelType 枚举）
       *     Circle - 环形数据面板
       *     Line - 条形数据面板
       *   strokeWidth() - 环形数据面板时，画笔的宽度
       *   valueColors() - 数据值列表对应的颜色列表
       *   trackShadow() - 阴影效果
       *     radius - 阴影的模糊半径
       *     colors - 数据值列表对应的阴影颜色列表
       *     offsetX - 阴影的 x 轴偏移量
       *     offsetY - 阴影的 y 轴偏移量
       *   trackBackgroundColor() - 环形或条形的底色
       */

      DataPanel({
        values: [30, 10, 5, 10],
        max: 100,
        type: DataPanelType.Circle,
      })
        .strokeWidth(10)
        .width(150)
        .height(150)

      DataPanel({
        values: [30, 10, 5, 10],
        max: 100,
        type: DataPanelType.Circle,
      })
        .strokeWidth(10)
        .valueColors([Color.Red, Color.Green, Color.Blue, Color.Orange])
        .trackBackgroundColor(Color.Black)
        .trackShadow({
          radius: 5,
          colors: [Color.Red, Color.Green, Color.Blue, Color.Orange],
          offsetX: 15,
          offsetY: 15
        })
        .width(150)
        .height(150)

      DataPanel({
        values: [10, 10, 10, 10, 10, 10],
        max: 100,
        type: DataPanelType.Line }
      )
        .width(300)
        .height(20)
    }
  }
}

@Component
struct MySample2 {
  build() {
    Column() {
      DataPanel({
        values: [112.1, 24.67, 48.7, 5.6],
        max: 300,
        type: DataPanelType.Circle
      })
        // 通过 contentModifier() 实现自定义 DataPanel（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyDataPanelModifier())
    }
  }
}

// 实现 ContentModifier 接口
class MyDataPanelModifier implements ContentModifier<DataPanelConfiguration> {
  constructor() { }
  // 返回指定的自定义 DataPanel
  applyContent () : WrappedBuilder<[DataPanelConfiguration]> {
    return wrapBuilder(buildDataPanel)
  }
}

// 自定义 DataPanel
@Builder function buildDataPanel(config: DataPanelConfiguration) {
  Column() {
    ForEach(config.values, (item: number, index: number) => {
      ChildItem({
        item: item,
        index: index,
        max: config.maxValue,
        colorArray: [Color.Red, Color.Green, Color.Blue, Color.Orange]
      })
    })
  }
  .alignItems(HorizontalAlign.Start)
}

@Component
struct ChildItem {
  item: number = 0
  index: number = 0
  max: number = 0
  colorArray: Array<Color> = []

  build() {
    Row() {
      Rect()
        .height(30)
        .width(this.item * 600 / this.max)
        .foregroundColor(this.colorArray[this.index])
        .radius(5)
        .align(Alignment.Start)

      Text(" " + this.item)
        .fontSize(16)
    }
    .margin(5)
  }
}