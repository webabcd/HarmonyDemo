/*
 * Grid - 网格基础
 *
 * 注：Grid 是一个可滚动组件，相关特性请参见 /component/layout/ScrollDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct GridDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        // 通过 layoutDirection, maxCount, minCount, cellLength 布局（当 rowsTemplate 和 columnsTemplate 都不设置时才会生效）
        // 不可滚动
        TabContent() { MySample1() }.tabBar('基础1').align(Alignment.Top)
        // 通过 rowsTemplate 和 columnsTemplate 布局
        // 不可滚动
        TabContent() { MySample2() }.tabBar('基础2').align(Alignment.Top)
        // 通过 rowsTemplate 或 columnsTemplate 布局
        // 可滚动
        TabContent() { MySample3() }.tabBar('基础3').align(Alignment.Top)
        // 在每个 item 的高度不一致的场景下，通过 alignItems 设置高度的对齐逻辑
        TabContent() { MySample4() }.tabBar('基础4').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column({space:10}) {

      /*
       * 本例用于演示如何通过 layoutDirection, maxCount, minCount, cellLength 布局，不可滚动
       *
       * Grid - 网格
       *   layoutDirection() - 每个 item 排列的主轴方向（GridDirection 枚举）
       *     Row - 每个 item 水平方向从左到右排列，填满后则换行
       *     Column, RowReverse, ColumnReverse
       *   maxCount() - 主轴方向上的最大 item 数
       *   minCount() - 主轴方向上的最小 item 数
       *   cellLength() - 每个 item 交叉轴上的长度
       *   columnsGap() - 列间距
       *   rowsGap() - 行间距
       * 注：只有在 rowsTemplate 和 columnsTemplate 都不设置时，layoutDirection, maxCount, minCount, cellLength 才会生效
       *
       * GridItem - grid 内的每个 item
       */
      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(16).width(80).height(40).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .layoutDirection(GridDirection.Row)
      .maxCount(20)
      .minCount(2)
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(150)

      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(16).width(80).height(40).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .layoutDirection(GridDirection.Row)
      .cellLength(60)
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(150)
    }
  }
}

@Component
struct MySample2 {

  @State array: string[][] = [['0', '1', '2'], ['0', '1', '2'], ['0', '1', '2'], ['0', '1', '2'], ['0', '1', '2']]

  build() {
    Column() {

      /*
       * 本例用于演示如何通过 rowsTemplate 和 columnsTemplate 布局，不可滚动
       *
       * Grid - 网格
       *   columnsTemplate() - 列宽
       *     比如 '1fr 1fr 3fr' 就是分 3 列，第1列占1/5，第2列占1/5，第3列占3/5
       *     比如 'repeat(auto-fill, 120)' 就是设置固定列宽为 120，然后自动计算列数
       *     比如 'repeat(auto-fit, 120)' 就是设置最小列宽为 120，然后自动计算列数和实际列宽（会保证 item 与 grid 的左右边缘对齐）
       *     比如 'repeat(auto-stretch, 120)' 就是设置固定列宽为 120，并以 columnsGap 为最小列间距，然后自动计算列数和实际列间距（会保证 item 与 grid 的左右边缘对齐）
       *   rowsTemplate() - 行高
       *     与 columnsTemplate() 类似
       *   columnsGap() - 列间距
       *   rowsGap() - 行间距
       *
       * GridItem - grid 内的每个 item
       */
      Grid() {
        ForEach(this.array, (arr: string[]) => {
          ForEach(arr, (item: string) => {
            GridItem() {
              Text(item).fontSize(16).width('100%').height('100%').textAlign(TextAlign.Center)
                .backgroundColor(Color.Orange).fontColor(Color.White)
            }
          }, (item: string) => item)
        }, (arr: string[], index: number) => index.toString())
      }
      .columnsTemplate('1fr 2fr 1fr')
      .rowsTemplate('1fr 1fr 2fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height('100%')
    }
  }
}

@Component
struct MySample3 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column({space:10}) {

      /*
       * 本例用于演示如何通过只使用 columnsTemplate（不使用 rowsTemplate）布局，可滚动
       * 只使用 rowsTemplate 布局也是类似的
       *
       * Grid - 网格
       *   columnsTemplate() - 列宽
       *     比如 '1fr 1fr 3fr' 就是分 3 列，第1列占1/5，第2列占1/5，第3列占3/5
       *     比如 'repeat(auto-fill, 120)' 就是设置固定列宽为 120，然后自动计算列数
       *     比如 'repeat(auto-fit, 120)' 就是设置最小列宽为 120，然后自动计算列数和实际列宽（会保证 item 与 grid 的左右边缘对齐）
       *     比如 'repeat(auto-stretch, 120)' 就是设置固定列宽为 120，并以 columnsGap 为最小列间距，然后自动计算列数和实际列间距（会保证 item 与 grid 的左右边缘对齐）
       *   rowsTemplate() - 行高
       *     与 columnsTemplate() 类似
       *   columnsGap() - 列间距
       *   rowsGap() - 行间距
       *
       * GridItem - grid 内的每个 item
       */
      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(16).width('100%').height(40).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .columnsTemplate('repeat(auto-fill, 120)')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(100)

      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(16).width('100%').height(40).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .columnsTemplate('repeat(auto-fit, 120)')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(100)

      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(16).width('100%').height(40).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .columnsTemplate('repeat(auto-stretch, 120)')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(100)
    }
  }
}

@Component
struct MySample4 {

  @State array: string[] = ['0\n0\n0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column({space:20}) {

      /*
       * 本例用于演示如何在每个 item 的高度不一致的场景下，通过 alignItems 设置高度的对齐逻辑
       *
       * Grid - 网格
       *   alignItems() - 每个 item 的高度的对齐逻辑（GridItemAlignment 枚举）
       *     DEFAULT - 默认逻辑，即 item 是多高就是多高
       *     STRETCH - 以当前行最高的 item 的高度，作为当前行所有 item 的高度
       *
       * GridItem - grid 内的每个 item
       */
      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).textAlign(TextAlign.Center).fontColor(Color.White)
          }.backgroundColor(Color.Orange)
        }, (item: string) => item)
      }
      .columnsTemplate('repeat(auto-fit, 120)')
      .columnsGap(10)
      .rowsGap(10)
      .alignItems(GridItemAlignment.DEFAULT)
      .backgroundColor(Color.Yellow)
      .height(200)

      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).textAlign(TextAlign.Center).fontColor(Color.White)
          }.backgroundColor(Color.Orange)
        }, (item: string) => item)
      }
      .columnsTemplate('repeat(auto-fit, 120)')
      .columnsGap(10)
      .rowsGap(10)
      .alignItems(GridItemAlignment.STRETCH)
      .backgroundColor(Color.Yellow)
      .height(200)
    }
  }
}