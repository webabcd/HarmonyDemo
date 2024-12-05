/*
 * List - 分组列表
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
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('ListScroller 相关').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

interface Node {
  title: string;
  items: string[];
}

// 分组列表的数据源
let nodeList: Node[] = [
  {
    title: 'node 0',
    items: ['item 0', 'item 1', 'item 2', 'item 3']
  },
  {
    title: 'node 1',
    items: ['item 0', 'item 1', 'item 2', 'item 3']
  },
  {
    title: 'node 2',
    items: ['item 0', 'item 1', 'item 2', 'item 3']
  },
  {
    title: 'node 3',
    items: ['item 0', 'item 1', 'item 2', 'item 3']
  },
  {
    title: 'node 4',
    items: ['item 0', 'item 1', 'item 2', 'item 3']
  }
]

// 分组列表的每个组的 header
@Builder function myHeader(text: string) {
  Text(text)
    .fontSize(24)
    .backgroundColor(Color.Orange)
    .fontColor(Color.White)
    .width("100%")
    .padding(10)
}

// 分组列表的每个组的 footer
@Builder function myFooter(num: number) {
  Text(`共 ${num} 条数据`)
    .fontSize(16)
    .backgroundColor(Color.Green)
    .fontColor(Color.White)
    .width("100%")
    .padding(10)
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Stack() {
      /*
       * List - 列表分组
       *   space - 每个组之间的间距
       *   initialIndex - 初始时，定位到指定索引位置的组
       *   sticky() - header 和 footer 是否固定
       *     StickyStyle.Header - 固定 header，即某组在滚动到顶端后，此组的 item 滑动中，组的 header 是固定在顶端的
       *     StickyStyle.Footer - 固定 Footer，即某组在滚动到底端后，此组的 item 滑动中，组的 Footer 是固定在底端的
       *     StickyStyle.Header | StickyStyle.Footer - 就是同时启用上面两个效果
       *     StickyStyle.None - 不固定 header 也不固定 footer
       *   onScrollVisibleContentChange() - 组或项滚入或滚出可视区时的回调
       *     start - 可视区内第一个组或项的信息（一个 VisibleListContentInfo 对象）
       *       index - 可视区内第一个组的索引位置
       *       itemIndexInGroup - 可视区内第一个项，在其所在组的索引位置
       *       itemGroupArea - 可视区内顶端显示的内容的类型（ListItemGroupArea 枚举）
       *         IN_LIST_ITEM_AREA - 当前顶端显示的是 item
       *         IN_HEADER_AREA - 当前顶端显示的是 header
       *         IN_FOOTER_AREA - 当前顶端显示的是 footer
       *     end - 可视区内最后一个组或项的信息（一个 VisibleListContentInfo 对象）
       *       index - 可视区内最后一个组的索引位置
       *       itemIndexInGroup - 可视区内最后一个项，在其所在组的索引位置
       *       itemGroupArea - 可视区内底端显示的内容的类型（ListItemGroupArea 枚举）
       *         IN_LIST_ITEM_AREA - 当前底端显示的是 item
       *         IN_HEADER_AREA - 当前底端显示的是 header
       *         IN_FOOTER_AREA - 当前底端显示的是 footer
       *
       * ListItemGroup - list 内的每个 itemGroup
       *   header - 自定义的每个组的 header 组件
       *   footer - 自定义的每个组的 footer 组件
       *   space - 每个组内的 item 之间的间距
       *   style - 默认样式（ListItemGroupStyle.NONE 或 ListItemGroupStyle.CARD）
       *   divider() - 每个组内的 item 之间的分隔线
       *     strokeWidth - 分隔线的画笔宽度
       *     color - 颜色
       *     startMargin - 左侧外边距
       *     endMargin - 右侧外边距
       *   childrenMainSize() - 指定组内每个 item 的主轴方向上的不同的大小
       *     当组内每个 item 在轴方向上的大小不一致时，需要额外通过此方式指定他们的大小，这样在调用 scrollToIndex(), scrollTo(), currentOffset() 等时才不会有问题
       *     注：具体用法与 List 的 childrenMainSize() 是一样的，可以参见 ListDemo.ets 中的说明
       *
       * ListItem - itemGroup 内的每个 item
       */
      List({
        space: 20,
        initialIndex: 1
      }) {
        ForEach(nodeList, (item: Node) => {
          ListItemGroup({
            header: myHeader(item.title),
            footer: myFooter(item.items.length),
            space: 10,
            style: ListItemGroupStyle.NONE
          }) {
            ForEach(item.items, (item: string) => {
              ListItem() {
                Text(item)
                  .width("100%")
                  .height(100)
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
                  .backgroundColor(Color.White)
                  .fontColor(Color.Black)
              }
            })
          }
          .divider({
            strokeWidth: 1,
            color: Color.Blue,
            startMargin: 0,
            endMargin: 0
          })
          // .childrenMainSize() // 关于 childrenMainSize() 请参见 ListDemo.ets 中的说明
        })
      }
      .width('90%')
      .scrollBar(BarState.Off)
      .sticky(StickyStyle.Header | StickyStyle.Footer)
      .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
        this.message = `onScrollVisibleContentChange\n`
        this.message += `group start index:${start.index}, group end index:${end.index}\n`
        this.message += `item start index:${start.itemIndexInGroup}, item end index:${end.itemIndexInGroup}\n`
        this.message += `item start area:${start.itemGroupArea}, item end area:${end.itemGroupArea}`
      })

      Text(this.message).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
    .alignContent(Alignment.Center)
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  /*
   * ListScroller 是一个 controller，是用于和 List 交互的，声明式编程通常都会用这种方式
   * ListScroller 继承自 Scroller（请参见 /component/layout/ScrollDemo.ets 中的说明）
   */
  listScroller: ListScroller = new ListScroller()

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * List - 列表分组
       *   scroller - 指定 List 需要绑定的 ListScroller
       */
      List({
        space: 20,
        scroller: this.listScroller,
      }) {
        ForEach(nodeList, (item: Node) => {
          ListItemGroup({
            header: myHeader(item.title),
            footer: myFooter(item.items.length),
            space: 10,
            style: ListItemGroupStyle.NONE,
          }) {
            ForEach(item.items, (item: string) => {
              ListItem() {
                Text(item)
                  .width("100%")
                  .height(100)
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
                  .backgroundColor(Color.White)
                  .fontColor(Color.Black)
              }
            })
          }
        })
      }
      .width('100%')
      .scrollBar(BarState.Off)

      Column({space:10}) {

        /*
         * ListScroller - 用于和绑定的 List 之间的交互（继承自 Scroller）
         *   scrollToIndex() - 滚动到指定索引位置的组（仅 Grid, List, WaterFlow 有效）
         *     value - 需要滚动到的组的索引位置
         *     smooth - 是否平滑滚动
         *     align - 滚动到的组与可视区的对齐方式（ScrollAlign 枚举）
         *       START - 组与可视区的顶端对齐
         *       CENTER - 组与可视区的中间对齐
         *       END - 组与可视区的底端对齐
         *     options - 选项
         *       extraOffset - 在当前位置上的偏移距离
         *   getItemRect() - 获取指定索引位置的组的位置和大小（仅 Grid, List, WaterFlow 有效）
         *     x, y, width, height
         *     注：指定的组必须要显示在可视区才能获取到正确的值，否则返回的都是 0
         */

        Button('scrollToIndex')
          .onClick(() => {
            this.listScroller.scrollToIndex(
              1,
              true,
              ScrollAlign.START,
              {
                extraOffset: LengthMetrics.vp(0)
              })
          })
        Button('getItemRect(1)')
          .onClick(() => {
            const itemRect = this.listScroller.getItemRect(1)
            this.message =
              `getItemRect(1) x:${itemRect.x}, y:${itemRect.y}, width:${itemRect.width}, height:${itemRect.height}`
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