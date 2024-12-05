/*
 * List - 列表基础
 *
 * 注：List 是一个可滚动组件，相关特性请参见 /component/layout/ScrollDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
struct ListDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础1').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('基础2').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('多行多列').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('ListScroller 相关').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * List - 列表
       *   space - 主轴方向上每个 item 之间的间隔距离
       *   initialIndex - 初始时，定位到指定索引位置的 item
       *   listDirection() - item 们的排列方向（Axis.Vertical 或 Axis.Horizontal）
       *   chainAnimation() - 拖动时是否启用链式联动效果
       *     手指拖动过程中，手指拖动的 ListItem 会驱动相邻的 ListItem 做弹簧联动效果（前提是必须是单列模式，且边缘效果为 EdgeEffect.Spring 时）
       *   onScrollIndex() - item 滚入或滚出可视区时，或者可视区中间显示的 item 发生变化时的回调
       *     start - 可视区内第一个 item 的索引位置
       *     end - 可视区内最后一个 item 的索引位置
       *     center - 可视区内中间 item 的索引位置
       *
       * ListItem() - list 内的每个 item
       */
      List({
        space: 20,
        initialIndex: 3,
      }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString()).width('100%').height(100)
              .fontSize(48).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin({ left: 20, right: 20 })
        })
      }
      .listDirection(Axis.Vertical)
      .chainAnimation(true)
      .edgeEffect(EdgeEffect.Spring)
      .onScrollIndex((start: number, end: number, center: number) => {
        this.message = `onScrollIndex start:${start}, end:${end}, center:${center}`
      })
      .width('100%')
      .height('100%')

      Text(this.message).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample2 {

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  // 实例化 ChildrenMainSize，并指定主轴方向上的默认大小
  childrenMainSize: ChildrenMainSize = new ChildrenMainSize(100)
  aboutToAppear(){
    // 位置 3, 4, 5, 6 的 item 的大小全部指定为 200
    this.childrenMainSize.splice(3, 4, [200, 200, 200, 200])
    // 位置 9 的 item 的大小指定为 200
    this.childrenMainSize.update(9, 200)
  }

  build() {
    Column() {
      /*
       * List - 列表
       *   divider() - 每个 item 之间的分隔线
       *     strokeWidth - 分隔线的画笔宽度
       *     color - 颜色
       *     startMargin - 左侧外边距
       *     endMargin - 右侧外边距
       *     注：当 chainAnimation(true) 时不会显示分隔线
       *   contentStartOffset() - 顶部 item 与顶部边缘之间的间距
       *   contentEndOffset() - 底部 item 与底部边缘之间的间距
       *   childrenMainSize() - 指定每个 item 的主轴方向上的不同的大小
       *     value - 主轴方向上的默认大小
       *     splice(), update() - 更新不同位置的 item 的主轴方向上的大小
       *     注：当每个 item 在轴方向上的大小不一致时，需要额外通过此方式指定他们的大小，这样在调用 scrollToIndex(), scrollTo(), currentOffset() 等时才不会有问题
       */
      List({ space: 20 }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString()).width('100%')
              .fontSize(48).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).borderRadius(20)
              .height((item >= 3 && item < 7) || (item == 9) ? 200 : 100)
          }
          .margin({ left: 20, right: 20 })
        })
      }
      .divider({
        strokeWidth: 2,
        color: Color.Red,
        startMargin: 20,
        endMargin: 20
      })
      .contentStartOffset(50)
      .contentEndOffset(50)
      .childrenMainSize(this.childrenMainSize)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample3 {

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]

  build() {
    Column({ space:20 }) {
      /*
       * List - 列表
       *   lanes() - 多行多列的配置，以下以 listDirection(Axis.Vertical) 为例
       *     value - 列数
       *       可以指定一个整数，用于指定列数
       *       可以指定一个 LengthConstrain 对象，用于动态计算列数
       *         minLength - 最小列宽
       *         maxLength - 最大列宽
       *     gutter - 列间距
       *   alignListItem() - 水平方向上的对齐方式（ListItemAlign 枚举），当 lanes() 指定为 LengthConstrain 对象时有效
       *     Start, Center, End
       */
      List({ space: 20 }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString())
              .width('100%').height(100).fontSize(24).textAlign(TextAlign.Center)
          }
          .border({ width: 2, color: Color.Green })
        })
      }
      .height(300)
      .width("80%")
      .borderWidth(2)
      .borderColor(Color.Red)
      .scrollBar(BarState.Off)
      .lanes(3, 10)

      List({ space: 20 }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString())
              .width('100%').height(100).fontSize(24).textAlign(TextAlign.Center)
          }
          .border({ width: 2, color: Color.Green })
        })
      }
      .height(300)
      .width("80%")
      .borderWidth(2)
      .borderColor(Color.Red)
      .scrollBar(BarState.Off)
      .lanes({
        minLength: 50,
        maxLength: 50,
      }, 10)
      .alignListItem(ListItemAlign.End)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  /*
   * ListScroller 是一个 controller，是用于和 List 交互的，声明式编程通常都会用这种方式
   * ListScroller 继承自 Scroller（请参见 /component/layout/ScrollDemo.ets 中的说明）
   */
  listScroller: ListScroller = new ListScroller()
  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * List - 列表
       *   scroller - 指定 List 需要绑定的 ListScroller
       */
      List({ scroller: this.listScroller }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString()).width('100%').height(200)
              .fontSize(48).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin(10)
        })
      }
      .width('100%')
      .height('100%')

      Column({space:10}) {

        /*
         * ListScroller - 用于和绑定的 List 之间的交互（继承自 Scroller）
         *   scrollToIndex() - 滚动到指定索引位置的 item（仅 Grid, List, WaterFlow 有效）
         *     value - 需要滚动到的 item 的索引位置
         *     smooth - 是否平滑滚动
         *     align - 滚动到的 item 与可视区的对齐方式（ScrollAlign 枚举）
         *       START - item 与可视区的顶端对齐
         *       CENTER - item 与可视区的中间对齐
         *       END - item 与可视区的底端对齐
         *     options - 选项
         *       extraOffset - 在当前位置上的偏移距离
         *   getItemRect() - 获取指定索引位置的 item 的位置和大小（仅 Grid, List, WaterFlow 有效）
         *     x, y, width, height
         *     注：指定的 item 必须要完整地显示在可视区才能获取到正确的值，否则返回的都是 0
         */

        Button('scrollToIndex')
          .onClick(() => {
            this.listScroller.scrollToIndex(
              5,
              true,
              ScrollAlign.START,
              {
                extraOffset: LengthMetrics.vp(0)
              })
          })
        Button('getItemRect(3)')
          .onClick(() => {
            const itemRect = this.listScroller.getItemRect(3)
            this.message = `getItemRect(3) x:${itemRect.x}, y:${itemRect.y}, width:${itemRect.width}, height:${itemRect.height}`
          })

        Text(this.message).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue)
      }
      .hitTestBehavior(HitTestMode.None)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}