/*
 * Grid - 网格布局
 *
 * 注：Grid 是一个可滚动组件，相关特性请参见 /component/layout/ScrollDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct GridDemo2 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        // 通过 onGetRectByIndex 布局
        TabContent() { MySample1() }.tabBar('布局1').align(Alignment.Top)
        // 通过 irregularIndexes 布局
        TabContent() { MySample2() }.tabBar('布局2').align(Alignment.Top)
        // 通过 irregularIndexes 和 onGetIrregularSizeByIndex 布局
        TabContent() { MySample3() }.tabBar('布局3').align(Alignment.Top)
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
    Column() {
      /*
       * Grid - 网格，第 2 个参数用于指定布局逻辑（一个 GridLayoutOptions 对象）
       *   regularSize - 每个网格的标准尺寸，只能设置为 [1, 1] 代表占用 1 行 1 列
       *   onGetRectByIndex - 返回指定索引位置的 item 的显示位置和占用空间
       *     比如返回 [0, 1, 2, 3] 代表显示位置为第 0 行 1 列的网格，占用空间为 2 行 3 列的网格
       *
       * GridItem - grid 内的每个 item
       */
      Grid(undefined, {
        regularSize: [1, 1],
        onGetRectByIndex: (index: number) => {
          if (index == 0)
            // 索引位置为 0 的 item 的显示位置为第 0 行 0 列的网格，占用空间为 1 行 1 列的网格
            return [0, 0, 1, 1]
          else if (index == 1)
            // 索引位置为 1 的 item 的显示位置为第 0 行 1 列的网格，占用空间为 2 行 3 列的网格
            return [0, 1, 2, 3]
          else if (index == 2)
            // 索引位置为 2 的 item 的显示位置为第 1 行 0 列的网格，占用空间为 2 行 1 列的网格
            return [1, 0, 2, 1]
          else
            // 其他索引位置的 item 的占用空间为 1 行 1 列的网格，且从第 0 行 4 列起按顺序排列
            return [0, 4, 1, 1]
        }
      }) {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).width('100%').height("100%").textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample2 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column() {
      /*
       * Grid - 网格，第 2 个参数用于指定布局逻辑（一个 GridLayoutOptions 对象）
       *   regularSize - 每个网格的标准尺寸，只能设置为 [1, 1] 代表占用 1 行 1 列
       *   irregularIndexes - 指定需要占用整行空间的 item 的索引位置
       *
       * GridItem - grid 内的每个 item
       */
      Grid(undefined, {
        regularSize: [1, 1],
        // 索引位置为 0, 5, 10 的 item 需要占用整行空间
        irregularIndexes: [0, 5, 10],
      }) {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).width('100%').height(100).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample3 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column() {
      /*
       * Grid - 网格，第 2 个参数用于指定布局逻辑（一个 GridLayoutOptions 对象）
       *   regularSize - 每个网格的标准尺寸，只能设置为 [1, 1] 代表占用 1 行 1 列
       *   irregularIndexes - 指定需要自定义占用空间的 item 的索引位置，然后在 onGetIrregularSizeByIndex 中实现具体的逻辑
       *   onGetIrregularSizeByIndex - 返回指定索引位置的 item 的占用空间（只支持 irregularIndexes 中已设置的索引位置）
       *     比如返回 [1, 2] 代表占用空间为 1 行 2 列的网格
       *
       * GridItem - grid 内的每个 item
       */
      Grid(undefined, {
        regularSize: [1, 1],
        irregularIndexes: [0, 1, 3, 4],
        onGetIrregularSizeByIndex: (index: number) => {
          if (index == 0)
            // 索引位置为 0 的 item 的占用空间为 1 行 4 列的网格
            return [1, 4]
          else if (index == 1)
            // 索引位置为 1 的 item 的占用空间为 1 行 3 列的网格
            return [1, 3]
          else
            // 其他的 irregularIndexes 中指定的索引位置的 item 的占用空间为 1 行 2 列的网格
            return [1, 2]
        }
      }) {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).width('100%').height(100).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).fontColor(Color.White)
          }
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
    }
  }
}