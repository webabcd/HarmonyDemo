/*
 * Refresh - 下拉刷新容器（让任意子组件支持下拉刷新操作）
 */

import { TitleBar } from '../../TitleBar';
import { ComponentContent } from '@kit.ArkUI';

@Entry
@Component
struct RefreshDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过 ComponentContent 自定义').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('通过 CustomBuilder 自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State message2: string = ""

  @State isRefreshing: boolean = false

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * Refresh - 下拉刷新容器（让任意子组件支持下拉刷新操作）
       *   refreshing - 是否处于刷新状态中（支持 $$ 数据的双向同步）
       *   promptText - 自定义文本
       *   refreshOffset() - 触发下拉刷新的最小下拉距离，下拉距离超过此值时松开手指就会触发 onRefreshing 事件
       *   pullToRefresh() - 是否需要触发 onRefreshing 事件
       *   pullDownRatio() - 下拉时的跟手系数（0 - 1 之间）
       *     0 完全不跟手
       *     1 完全跟手
       *     undefined 这是默认值，跟手系数会自动计算，下拉距离越大，跟手系数越小
       *   backgroundColor() - 背景颜色
       *   onStateChange() - 刷新状态变化时的回调（会返回一个 RefreshStatus 枚举值）
       *     Inactive - 未下拉
       *     Drag -	下拉中，下拉距离小于 refreshOffset() 值
       *     OverDrag - 下拉中，下拉距离大于 refreshOffset() 值
       *     Refresh - 刷新中，触发了 onRefreshing 回调且 Refresh 组件的高度回弹至 refreshOffset() 值
       *     Done - 结束，即 onRefreshing 回调执行完成且 Refresh 组件的高度回弹至 0
       *   onOffsetChange() - 下拉距离变化时的回调
       *   onRefreshing() - 进入刷新状态时的回调（在此处写具体的数据刷新逻辑）
       */
      Refresh({
        refreshing: $$this.isRefreshing,
        promptText: "loading"
      }) {
        Text(this.message).fontSize(32).fontColor(Color.White)
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Orange)
      }
      .refreshOffset(64)
      .pullToRefresh(true)
      .pullDownRatio(undefined)
      .onStateChange((refreshStatus: RefreshStatus) => {
        this.message += `onStateChange:${refreshStatus}\n`
      })
      .onOffsetChange((value: number) => {
        this.message2 = `onOffsetChange:${value}`
      })
      .onRefreshing(() => {
        this.message += 'onRefreshing start\n'
        // 在此处写具体的数据刷新逻辑
        setTimeout(() => {
          this.isRefreshing = false
          this.message += 'onRefreshing end\n'
        }, 2000)
      })
      .backgroundColor(Color.Red)

      Text(this.message2).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue).margin({top:30})
    }
  }
}

// 自定义的下拉刷新容器
@Builder function myRefreshingContent(refreshStatus: RefreshStatus) {
  Stack() {
    Row() {
      LoadingProgress().height(32).color(Color.White)
      Text("refreshStatus:" + refreshStatus).fontSize(16).fontColor(Color.White).margin({ left: 20 })
    }
    .alignItems(VerticalAlign.Center)
  }
  .constraintSize({ minHeight: 32 })
  .width("100%")
}
@Component
struct MySample2 {

  @State isRefreshing: boolean = false
  private myComponentContent?: ComponentContent<Object> = undefined

  aboutToAppear(): void {
    /*
     * ComponentContent - 用于封装组件
     */
    this.myComponentContent = new ComponentContent(
      this.getUIContext(),                // UIContext
      wrapBuilder(myRefreshingContent),   // 封装组件
      RefreshStatus.Inactive)             // 传递给封装组件的参数
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * Refresh - 下拉刷新容器（让任意子组件支持下拉刷新操作）
       *   refreshingContent - 自定义下拉刷新容器（指定一个 ComponentContent 类型的对象）
       */
      Refresh({
        refreshing: $$this.isRefreshing,
        refreshingContent: this.myComponentContent
      }) {
        Text('Text').fontSize(32).fontColor(Color.White)
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Orange)
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        // 通过 ComponentContent 的 update() 更新封装组件的参数
        this.myComponentContent?.update(refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 2000)
      })
      .backgroundColor(Color.Red)
    }
  }
}

@Component
struct MySample3 {

  @State isRefreshing: boolean = false
  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  // 自定义的下拉刷新容器
  @Builder myRefreshingComponent() {
    Stack() {
      Row() {
        LoadingProgress().height(32).color(Color.White)
        Text("loading").fontSize(16).fontColor(Color.White).margin({ left: 20 })
      }
      .alignItems(VerticalAlign.Center)
    }
    .constraintSize({ minHeight: 32 })
    .width("100%")
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * Refresh - 下拉刷新容器（让任意子组件支持下拉刷新操作）
       *   builder - 自定义下拉刷新容器（指定一个 @Builder 装饰的函数）
       */
      Refresh({
        refreshing: $$this.isRefreshing,
        builder: this.myRefreshingComponent
      }) {
        Text('Text').fontSize(32).fontColor(Color.White)
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Orange)
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 2000)
      })
      .backgroundColor(Color.Red)
    }
  }
}
