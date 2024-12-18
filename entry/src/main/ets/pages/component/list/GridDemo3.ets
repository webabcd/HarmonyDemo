/*
 * Grid - 网格（滚动，多选，拖动排序，双指缩放并修改列数）
 *
 * 注：
 * 1、Grid 是一个可滚动组件，相关特性请参见 /component/layout/ScrollDemo.ets 中的说明
 * 2、Grid 的下拉刷新和上拉加载可以参考 /component/list/ListDemo4.ets 中的说明
 * 3、Grid 结合 ForEach 的应用可以参考 /component/list/ListDemo5.ets 中的说明（但是不支持通过 ForEach 的 onMove() 拖动排序）
 * 4、Grid 结合 LazyForEach 的应用可以参考 /component/list/ListDemo6.ets 中的说明
 * 5、Grid 结合 Repeat 的应用可以参考 /component/list/ListDemo7.ets 中的说明
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct GridDemo3 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('滚动').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('多选').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('拖动排序').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('双指缩放并修改列数').align(Alignment.Top)
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
  @State message: string = ""
  scroller: Scroller = new Scroller()

  build() {
    Column({space:10}) {
      /*
       * Grid - 网格
       *   第 1 个参数用于指定 Grid 需要绑定的 Scroller
       *   onScrollBarUpdate() - 当前可视区的第一个 item 发生变化时的回调，在此回调中需要自定义滚动条的位置和长度并返回（这个回调是）
       *     index - 当前可视区的第一个 item 的索引位置
       *     offset - 当前可视区的第一个 item 相对于 grid 的上边缘的偏移距离
       *     返回值是一个 ComputedBarAttribute 对象，用于描述滚动条的位置和长度
       *       totalOffset - 当前滚动条的偏移距离
       *       totalLength - 当前滚动条的长度
       *
       * 注：关于 Grid 和 Scroller 的更多的关于滚动的特性请参见 /component/layout/ScrollDemo.ets 中的说明
       */
      Grid(this.scroller) {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).width('100%').height(80).textAlign(TextAlign.Center).fontColor(Color.White)
          }.backgroundColor(Color.Orange)
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(200)
      .onScrollBarUpdate((index: number, offset: number) => {
        this.message = `onScrollBarUpdate index:${index}, offset:${offset}`
        return { totalOffset: (index / 3) * (80 + 10) - offset, totalLength: 50 }
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']
  @State editFlag: boolean = false

  build() {
    Column({space:10}) {
      Button('切换编辑模式')
        .onClick(() => {
          this.editFlag = !this.editFlag
        })

      /*
       * Grid - 网格
       * 本例用于演示，如何通过自己写代码的方式实现切换到所谓的编辑模式，以及在编辑模式下显示多选框
       *
       * 注：我这里测试发现 GridItem 的 selectable(), selected(), onSelect() 和 Grid 的 multiSelectable() 均无效
       */
      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Row() {
              Text(item).height(80)
                .layoutWeight(1)
                .fontSize(48).fontColor(Color.White).textAlign(TextAlign.Center)
                .stateStyles({
                  // 普通状态的样式
                  normal: {
                    .backgroundColor(Color.Orange).borderRadius(20)
                  },
                  // 手指按下时的样式
                  pressed: {
                    .backgroundColor(Color.Blue).borderRadius(5)
                  },
                })

              if (this.editFlag) {
                Blank(10)
                Checkbox().width(24).height(24).margin({right:5})
              }
            }

          }.backgroundColor(Color.Orange)
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(300)
    }
  }
}

@Component
struct MySample3 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']
  @State message: string = ""

  @State draggingItemText: string = ''
  // 自定义拖动过程中的 item 组件
  @Builder draggingItem() {
    Column() {
      Text(this.draggingItemText).fontSize(16).textAlign(TextAlign.Center)
        .backgroundColor(Color.Blue).fontColor(Color.White)
        .width(80).height(80)
    }
  }

  // 交换数据（this.array 是 @State 装饰的，更新后会刷新绑定的组件）
  exchangeData(index1: number, index2: number) {
    let temp = this.array[index1];
    this.array[index1] = this.array[index2];
    this.array[index2] = temp;
  }

  build() {
    Column({space:10}) {

      /*
       * Grid - 网格
       *   editMode() - 是否启用内置的 item 的拖动功能
       *   onItemDragStart() - 拖动开始时
       *     event - 拖动点的坐标（x, y）
       *     itemIndex - 拖动的 item 的索引位置
       *     返回值为自定义的拖动过程中的 item 组件
       *   onItemDragMove() - 拖动移动时
       *     event - 拖动点的坐标（x, y）
       *     itemIndex - 拖动的 item 的原先所在的网格的索引位置
       *     insertIndex - 拖动的 item 的当前所在的网格的索引位置
       *   onItemDragEnter() - 进入某个网格时
       *     event - 拖动点的坐标（x, y）
       *   onItemDragLeave() - 离开某个网格时
       *     event - 拖动点的坐标（x, y）
       *     itemIndex - 拖动的 item 的离开的网格的索引位置
       *   onItemDrop() - 释放时
       *     event - 拖动点的坐标（x, y）
       *     itemIndex - 拖动的 item 的原先所在的网格的索引位置
       *     insertIndex - 拖动的 item 的当前所在的网格的索引位置
       *     isSuccess - 是否成功释放了（isSuccess 等于 false 时，说明 drop 的位置在 grid 的外部）
       *
       * 注：本例演示的是 Grid 的自带的拖动排序效果，如果需要自定义排序效果可以参考 /component/list/ListDemo3.ets 中的说明
       */
      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).width('100%').height(80).textAlign(TextAlign.Center).fontColor(Color.White)
          }.backgroundColor(Color.Orange)
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height(300)
      .editMode(true)
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
        this.message = `onItemDragStart x:${event.x}, y:${event.y}, itemIndex:${itemIndex}`
        this.draggingItemText = this.array[itemIndex]
        // 返回自定义的拖动过程中的 item 组件
        return this.draggingItem()
      })
      .onItemDragMove((event: ItemDragInfo, itemIndex: number, insertIndex: number) => {
        this.message = `onItemDragMove x:${event.x}, y:${event.y}, itemIndex:${itemIndex}, insertIndex:${insertIndex}`
      })
      .onItemDragEnter((event: ItemDragInfo) => {
        this.message = `onItemDragEnter x:${event.x}, y:${event.y}`
      })
      .onItemDragLeave((event: ItemDragInfo, itemIndex: number) => {
        this.message = `onItemDragLeave x:${event.x}, y:${event.y}, itemIndex:${itemIndex}`
      })
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
        this.message = `onItemDrop x:${event.x}, y:${event.y}, itemIndex:${itemIndex}, insertIndex:${insertIndex}, isSuccess:${isSuccess}`
        // isSuccess 等于 false 时，说明 drop 的位置在 grid 的外部
        if (!isSuccess) {
          return
        }
        // 交换数据（this.array 是 @State 装饰的，更新后会刷新绑定的组件）
        this.exchangeData(itemIndex, insertIndex)
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State array: String[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']
  @State columns: number = 2

  build() {
    Column() {
      Grid() {
        ForEach(this.array, (item: string) => {
          GridItem() {
            Text(item).fontSize(24).width('100%').height(80).textAlign(TextAlign.Center).fontColor(Color.White)
          }.backgroundColor(Color.Orange)
        }, (item: string) => item)
      }
      // 列数
      .columnsTemplate('1fr '.repeat(this.columns))
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Yellow)
      .height('100%')
      // 修改列数时，增加 item 的重新排位时的动画效果
      .animation({
        duration: 300,
        curve: Curve.Smooth
      })
      .priorityGesture(
        // 双指缩放手势
        PinchGesture()
          .onActionEnd((event: GestureEvent) => {
            // 放大则减少列数，缩小则增加列数
            if (event.scale > 2) {
              this.columns--
            } else if (event.scale < 0.5) {
              this.columns++
            }
            // 最小列数为 1，最大列数为 4
            this.columns = Math.min(4, Math.max(1, this.columns));
          })
      )
    }
  }
}
