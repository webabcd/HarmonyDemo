/*
 * Scroll - 可滚动容器
 */

import { MyLog, TitleBar } from '../../TitleBar';

@Entry
@Component
struct ScrollDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('嵌套 Scroll 的滚动逻辑').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('snap').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('paging').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('事件相关').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('Scroller 相关').align(Alignment.Top)
        TabContent() { MySample7() }.tabBar('自定义 ScrollBar').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    /*
     * Scroll - 可滚动容器
     *   enableScrollInteraction() - 是否支持手动滚动
     *   scrollable() - 滚动方向（ScrollDirection 枚举）
     *     Vertical, Horizontal, None
     *   scrollBar() - 滚动条状态（BarState 枚举）
     *     Off - 不显示
     *     On - 显示
     *     Auto - 触摸时显示（2 秒后消失）
     *   scrollBarColor() - 滚动条颜色
     *   scrollBarWidth() - 滚动条宽度
     *   initialOffset() - 滚动的初始偏移量
     *   friction() - 手动滑动时，滚动的摩擦系数，值越大越难滚
     *     非可穿戴设备默认值为 0.6，可穿戴设备默认值为 0.9
     *   edgeEffect() - 滚动到边缘时的效果
     *     edgeEffect - 效果（EdgeEffect 枚举）
     *       Spring - 弹性效果
     *       Fade - 圆弧阴影效果
     *       None - 无效果
     *     options - 选项
     *       alwaysEnabled - 当组件内容小于组件自身的大小时，是否开启 edgeEffect 效果
     */
    Scroll() {
      Column() {
        ForEach(this.array, (item: number) => {
          Text(item.toString()).width('80%').height(200)
            .fontSize(48).textAlign(TextAlign.Center).margin(10)
            .backgroundColor(Color.Orange).borderRadius(20)
        })
      }
    }
    .enableScrollInteraction(true)
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Blue)
    .scrollBarWidth(10)
    .initialOffset({
      xOffset: 0,
      yOffset: 100,
    })
    .friction(0.6)
    .edgeEffect(EdgeEffect.Spring, {
      alwaysEnabled: false
    })
    .width('100%')
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample2 {

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    /*
     * Scroll - 可滚动容器
     *   nestedScroll() - 嵌套 Scroll 时，在子 Scroll 指定父子的滚动逻辑
     *     scrollForward, scrollBackward - 通过手势往下滚动和往上滚动时的滚动逻辑（NestedScrollMode 枚举）
     *       SELF_ONLY - 只滚动自己，不滚动父 Scroll
     *       SELF_FIRST - 先滚动自己，滚动到边缘后，再滚动父 Scroll
     *       PARENT_FIRST - 先滚动父 Scroll，滚动到边缘后，再滚动自己
     *       PARALLEL - 自己和父 Scroll 一起滚动
     */
    Scroll() {
      Column() {
        Text("aaa").width("100%").height(200).textAlign(TextAlign.Center)
          .backgroundColor(Color.Red).fontColor(Color.White)

        Column() {
          Text("bbb").width("100%").height(50).textAlign(TextAlign.Center)
            .backgroundColor(Color.Green).fontColor(Color.White)

          Scroll() {
            Column() {
              ForEach(this.array, (item: number) => {
                Text(item.toString()).width('80%').height(200)
                  .fontSize(48).textAlign(TextAlign.Center).margin(10)
                  .backgroundColor(Color.Orange).borderRadius(20)
              })
            }
          }
          .scrollBar(BarState.Off)
          // 向下滚动时，先是父 Scroll 整体滚动，当文本框 aaa 滚出屏幕后，子 Scroll 继续滚动
          // 向上滚动时，先是子 Scroll 滚动，当滚动到子 Scroll 的边缘后，再父 Scroll 整体滚动
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
        }
        // 这里要指定一下高度
        // 父 Scroll 向下滚动时，文本框 aaa 滚出屏幕后，文本框 bbb 会固定在顶端，然后子 Scroll 继续滚动
        .height('100%')
      }
    }
    .scrollBar(BarState.Off)
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample3 {

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    /*
     * Scroll - 可滚动容器
     *   scrollSnap() - 滚动后的停靠逻辑（一个 ScrollSnapOptions 对象）
     *     snapPagination - 停靠点位置
     *       指定一个值，比如 100，则每隔 100 为一个停靠点
     *       指定一个数组，比如 [50, 88, 120]，则一共 3 个停靠点，分别为 50, 88, 120
     *     snapAlign - 当 snapPagination 指定为一个值时的停靠方式（ScrollSnapAlign 枚举）
     *       NONE - 无停靠效果
     *       START - 每个 item 的顶端与 Scroll 的顶端对齐
     *       CENTER - 每个 item 的中间与 Scroll 的中间对齐
     *       END - 每个 item 的底端与 Scroll 的底端对齐
     *     enableSnapToStart - 当 snapPagination 指定为一个数组时，允许 Scroll 在顶端与第一个停靠点之间自由滚动
     *     enableSnapToEnd - 当 snapPagination 指定为一个数组时，允许 Scroll 在底端与最后一个停靠点之间自由滚动
     */
    Scroll() {
      Column() {
        ForEach(this.array, (item: number) => {
          Text(item.toString()).width('80%').height(150)
            .fontSize(48).textAlign(TextAlign.Center).margin(10)
            .backgroundColor(Color.Orange).borderRadius(20)
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
    .edgeEffect(EdgeEffect.Fade)
    .scrollSnap({
      // 本例中，每个 item 是一个 Text，高度是 150，上 margin 是 10，下 margin 是 10，所以每个 item 的高度是 170
      snapPagination: 170,
      snapAlign: ScrollSnapAlign.CENTER,
      enableSnapToStart: true,
      enableSnapToEnd: true
    })
  }
}

@Component
struct MySample4 {

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    /*
     * Scroll - 可滚动容器
     *   enablePaging() - 是否支持翻页模式
     */
    Scroll() {
      Column() {
        ForEach(this.array, (item: number) => {
          Text(item.toString()).width('100%').height('100%')
            .fontSize(128).fontColor(Color.Orange).textAlign(TextAlign.Center)
            .backgroundColor(`#${item}${item}${item}${item}${item}${item}`)
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
    .edgeEffect(EdgeEffect.None)
    .enablePaging(true)
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {

      /*
       * Scroll - 可滚动容器
       *   onScrollStart - 滚动开始时的回调
       *   onScrollStop - 滚动结束时的回调
       *   onScrollFrameBegin - 滚动过程中，每一帧开始前的回调
       *     offset - 即将发生的滑动量
       *     scrollState - 当前滚动状态（ScrollState 枚举）
       *       Idle - 无滚动（onScrollFrameBegin 不会进入此状态）
       *       Scroll - 滚动中且手指触摸中
       *       Fling - 惯性滚动中，手指不在触摸中
       *     返回值 { offsetRemain: offset } 用于指定实际滚动量，允许在这里自定义实际滚动量
       *   onWillScroll - 滚动过程中的回调（在每一帧滚动之前）
       *     xOffset - 水平滚动量
       *     yOffset - 垂直滚动量
       *     scrollState - 当前滚动状态（ScrollState 枚举）
       *       Idle - 无滚动（onWillScroll 不会进入此状态）
       *       Scroll - 滚动中且手指触摸中
       *       Fling - 惯性滚动中，手指不在触摸中
       *     scrollSource - 产生滚动的原因
       *   onDidScroll - 滚动过程中的回调（在每一帧滚动之后）
       *     xOffset - 水平滚动量
       *     yOffset - 垂直滚动量
       *     scrollState - 当前滚动状态（ScrollState 枚举）
       *       Idle - 无滚动（onDidScroll 可能会进入此状态）
       *       Scroll - 滚动中且手指触摸中
       *       Fling - 惯性滚动中，手指不在触摸中
       *   onScrollEdge - 滚动到边缘时的回调
       *     side - 边缘类型（Edge 枚举）
       *       Top, Bottom, Start, End
       *   onReachStart - 滚动到顶部时的回调
       *   onReachEnd - 滚动到底部时的回调
       */
      Scroll() {
        Column() {
          ForEach(this.array, (item: number) => {
            Text(item.toString()).width('80%').height(200)
              .fontSize(48).textAlign(TextAlign.Center).margin(10)
              .backgroundColor(Color.Orange).borderRadius(20)
          })
        }
      }
      .onScrollFrameBegin((offset: number, scrollState: ScrollState) => {
        this.message = `onScrollFrameBegin offset:${offset}, scrollState:${scrollState}`
        MyLog.d(this.message)
        // 指定实际滚动量，允许在这里自定义实际滚动量
        return { offsetRemain: offset };
      })
      .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
        this.message = `onWillScroll xOffset:${xOffset}, yOffset:${yOffset}, scrollState:${scrollState}, scrollSource:${scrollSource}`
        MyLog.d(this.message)
      })
      .onDidScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
        this.message = `onDidScroll xOffset:${xOffset}, yOffset:${yOffset}, scrollState:${scrollState}`
        MyLog.d(this.message)
      })
      .onScrollStart(() => {
        this.message = `onScrollStart`
        MyLog.d(this.message)
      })
      .onScrollStop(() => {
        this.message = `onScrollStop`
        MyLog.d(this.message)
      })
      .onScrollEdge((side: Edge) => {
        this.message = `onScrollEdge side:${side}`
        MyLog.d(this.message)
      })
      .onReachStart(() => {
        this.message = `onReachStart`
        MyLog.d(this.message)
      })
      .onReachEnd(() => {
        this.message = `onReachEnd`
        MyLog.d(this.message)
      })
      .width('100%')
      .height('100%')

      Text(this.message).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
    .alignContent(Alignment.Center)
  }
}

@Component
struct MySample6 {

  @State message: string = ""

  /*
   * Scroller 是一个 controller，是用于和 Scroll 交互的，声明式编程通常都会用这种方式
   */
  scroller: Scroller = new Scroller()
  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 指定 Scroll 需要绑定的 Scroller
      Scroll(this.scroller) {
        Column() {
          ForEach(this.array, (item: number) => {
            Text(item.toString()).width('80%').height(200)
              .fontSize(48).textAlign(TextAlign.Center).margin(10)
              .backgroundColor(Color.Orange).borderRadius(20)
          })
        }
      }
      .width('100%')
      .height('100%')

      Column({space:10}) {

        /*
         * Scroller - 用于和绑定的 Scroll 之间的交互
         *   scrollBy() - 滚动到指定的位置（无动画）
         *   scrollEdge() - 滚动到指定的边缘位置（Edge 枚举），可以指定滚动速度（默认值是 0 会自动计算滚动速度）
         *     Top, Bottom, Start, End
         *   scrollPage() - 按页滚动
         *     next: true 则滚动到下一页
         *     next: false 则滚动到上一页
         *   scrollTo() - 滚动到指定的位置（有动画）
         *   scrollToIndex() - 滚动到指定索引位置的 item（仅 Grid, List, WaterFlow 有效）
         *   fling() - 指定初始加速度并滚动
         *     负数则往下滚动，正数则往上滚动
         *   currentOffset() - 获取当前的滚动位置
         *     xOffset, yOffset
         *   isAtEnd() - 是否滚动到底部了
         *   getItemRect() - 获取指定索引位置的 item 的位置和大小（仅 Grid, List, WaterFlow 有效）
         */

        Button('scrollBy 150')
          .onClick(() => {
            this.scroller.scrollBy(0, 150)
          })
        Button('scrollEdge top')
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Top, { velocity: 0 })
          })
        Button('scrollPage next')
          .onClick(() => {
            this.scroller.scrollPage({ next: true })
          })
        Button('scrollTo 500')
          .onClick(() => {
            this.scroller.scrollTo({
              xOffset: 0,
              yOffset: 500,
              animation: {
                duration: 1000,
                curve: Curve.Ease
              }
            })
          })
        Button('fling(-1000)')
          .onClick(() => {
            this.scroller.fling(-1000)
          })
        Button('currentOffset()')
          .onClick(() => {
            const currentOffset = this.scroller.currentOffset()
            this.message = `currentOffset() xOffset:${currentOffset.xOffset}, yOffset:${currentOffset.yOffset}`
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

@Component
struct MySample7 {

  scroller: Scroller = new Scroller()
  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Scroll(this.scroller) {
          Column() {
            ForEach(this.array, (item: number) => {
              Text(item.toString()).width('80%').height(200)
                .fontSize(48).textAlign(TextAlign.Center).margin(10)
                .backgroundColor(Color.Orange).borderRadius(20)
            })
          }
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')

        /*
         * ScrollBar - 自定义滚动条（List, Grid, Scroll 等可滚动组件均可使用此方法自定义滚动条）
         *   scroller - 需要绑定的 Scroller（关联的可滚动组件也要绑定同一个 Scroller）
         *   direction - 滚动方向（ScrollBarDirection 枚举）
         *     Vertical, Horizontal
         *   state - 滚动条状态（BarState 枚举）
         *     Off - 不显示
         *     On - 显示
         *     Auto - 触摸时显示（2 秒后消失）
         *   width() - 滚动条宽度
         *   backgroundColor() - 滚动条的轨道颜色
         *   子组件 - 自定义滚动条滑块
         */
        ScrollBar({
          scroller: this.scroller,
          direction: ScrollBarDirection.Vertical,
          state: BarState.On
        }) {
          Column()
            .width(20)
            .height(100)
            .borderRadius(10)
            .backgroundColor(Color.Blue)
        }
        .width(20)
        .backgroundColor(Color.Gray)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Yellow)
    }
  }
}