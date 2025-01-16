/*
 * Tabs - 页签导航
 * 包括页签栏和内容区
 *
 * 注：Tabs 的子组件通过 TabContent 定义页签内容，详见 TabContentDemo.ets 中的说明
 */

import { TitleBar, RadioBar, MyLog } from '../../TitleBar';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct TabsDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础1').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('基础2').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('基础3').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('切换动画').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('预加载').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State currentIndex: number = 0
  @State vertical: boolean = false
  @State message: string = ""

  /*
   * TabsController - 用于和绑定的 Tabs 之间的交互
   *   changeIndex() - 切换到指定索引位置的页签
   */
  private controller: TabsController = new TabsController()

  @Builder tabBarBuilder(index: number, name: string) {
    Column() {
      Text(name).fontSize(24)
        .fontColor(this.currentIndex === index ? Color.Black : Color.White)

      Divider().strokeWidth(2)
        .color(this.currentIndex === index ? Color.Black : Color.White)
        .opacity(this.currentIndex === index ? 1 : 0)
    }
    .backgroundColor(Color.Orange)
  }

  /*
   * Tabs - 页签导航
   *   barPosition - 页签栏的位置
   *     BarPosition.Start - 在顶部或左侧
   *     BarPosition.End - 在底部或右侧
   *   index - 当前选中的页签的索引位置
   *   controller - 绑定的 TabsController 对象
   *   vertical() - 页签栏和内容区是垂直排列还是水平排列
   *   scrollable() - 是否允许在内容区通过滑动手势切换页签
   *   barMode() - 页签栏的布局模式（BarMode 枚举）
   *     Fixed - 页签栏不可滚动，每个页签的宽度会被平均分配
   *     Scrollable - 每个页签的宽度由其内容决定，如果显示不下则页签栏可滚动
   *   barWidth(), barHeight(), barBackgroundColor(), barBackgroundBlurStyle() - 页签栏的宽度，高度，背景色，模糊效果
   *   divider() - 页签栏与内容区之间的分隔线
   *     strokeWidth, color, startMargin, endMargin
   *     注：如果需要隐藏分隔线的话，就 divider(null) 即可
   *   animationDuration() - 页签切换动画的时长
   *   onChange() - 页签切换后的回调
   *   onTabBarClick() - 页签点击后的回调
   *   onContentWillChange() - 切换页签前的回调，可用于页签的切换拦截
   *     currentIndex - 切换前的页签的索引位置
   *     comingIndex - 切换后的页签的索引位置
   *     return true - 允许切换到新页签
   *     return false - 阻止切换到新页签
   *   onGestureSwipe() - 在内容区通过滑动手势切换时的回调
   *     index - 切换前的页签的索引位置
   *     event - 事件参数（一个 TabsAnimationEvent 对象）
   *       currentOffset - 切换前的内容区的内容的当前的偏移距离
   */
  build() {
    Column({space:10}) {

      Text(this.message)

      Button(`vertical:${this.vertical}`).onClick(() => {
        this.vertical = !this.vertical
      })

      Button(`controller.changeIndex(1)`).onClick(() => {
        // 通过 TabsController 切换到指定索引位置的页签
        this.controller.changeIndex(1)
      })

      Tabs({
        barPosition: BarPosition.Start,
        index: this.currentIndex,
        controller: this.controller
      }) {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar(this.tabBarBuilder(0, 'red'))

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar(this.tabBarBuilder(1, 'green'))

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar(this.tabBarBuilder(2, 'blue'))
      }
      .vertical(this.vertical)
      .scrollable(true)
      .barMode(BarMode.Fixed)
      .barWidth(this.vertical ? "64vp" : '100%')
      .barHeight(this.vertical ? "100%" : '64vp')
      .barBackgroundColor(Color.Yellow)
      .barBackgroundBlurStyle(BlurStyle.Thin)
      // .divider(null)
      .divider({
        strokeWidth: 5,
        color: Color.Pink,
        startMargin: 0,
        endMargin: 0
      })
      .animationDuration(1000)
      .onChange((index: number) => {
        this.message = `onChange:${index}`
        this.currentIndex = index
      })
      .onTabBarClick((index: number) => {
        this.message = `onTabBarClick:${index}`
      })
      // 页签的切换拦截
      .onContentWillChange((currentIndex: number, comingIndex: number) => {
        this.message = `onContentWillChange currentIndex:${currentIndex}, comingIndex:${comingIndex}`
        return true
      })
      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        this.message = `onGestureSwipe index:${index}, event:${JSON.stringify(event)}`
      })
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample2 {

  @State barOverlap: boolean = false

  build() {
    Column({space:10}) {

      Button(`barOverlap:${this.barOverlap}`).onClick(() => {
        this.barOverlap = !this.barOverlap
      })

      /*
       * Tabs - 页签导航
       *   barMode() - 页签栏的布局模式
       *     value - BarMode 枚举
       *       Fixed - 页签栏不可滚动，每个页签的宽度会被平均分配
       *       Scrollable - 每个页签的宽度由其内容决定，如果显示不下则页签栏可滚动
       *     options - 选项（一个 ScrollableBarModeOptions 对象）
       *       margin - 左右的外边距（仅 BarMode.Scrollable 时有效）
       *       nonScrollableLayoutStyle - 当页签栏不需要滚动时，每个页签的排列方式（仅 BarMode.Scrollable 时有效）
       *         LayoutStyle.ALWAYS_CENTER - 紧凑居中
       *         LayoutStyle.ALWAYS_AVERAGE_SPLIT - 平均分配
       *         LayoutStyle.SPACE_BETWEEN_OR_CENTER
       *           所有页签的内容的宽度大于页签栏的宽度的一半时，则紧凑居中
       *           所有页签的内容的宽度小于页签栏的宽度的一半时，则在居中的页签栏的一半的宽度内排列且每个页签的间距相同
       *   barOverlap() - 页签栏是否要覆盖在内容区之上
       *   fadingEdge() - 页签栏可滚动时，两端是否启用渐隐效果（仅在 barOverlap(true) 时有效）
       *   edgeEffect() - 页签栏可滚动时，边缘的回弹效果（EdgeEffect 枚举）
       *     Spring - 弹性效果
       *     Fade - 圆弧阴影效果
       *     None - 无效果
       */
      Tabs() {
        TabContent() {
          Column() {
            Text("111")
            Text("222")
            Text("333")
            Text("444")
            Text("555")
            Text("666")
            Text("777")
            Text("888")
            Text("999")
          }.width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar("aaaaaaaaaaaaaaaaaaaa")

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar("bbbbbbbbbbbbbbbbbbbb")

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar("cccccccccccccccccccc")
      }
      .backgroundColor(Color.Yellow)
      .barMode(BarMode.Scrollable, {
        margin: 10,
        nonScrollableLayoutStyle: LayoutStyle.ALWAYS_AVERAGE_SPLIT
      })
      .edgeEffect(EdgeEffect.Spring)
      .barOverlap(this.barOverlap)
      .fadingEdge(true)
      .barWidth('100%')
      .barHeight(64)
    }
  }
}

@Component
struct MySample3 {

  @State barGridAlign_margin: number = 0
  @State barGridAlign_gutter: number = 0
  @State barGridAlign_columns: number = 2

  build() {
    Column({space:10}) {

      Button(`barGridAlign_margin:${this.barGridAlign_margin}`).onClick(() => {
        this.barGridAlign_margin += 10
      })

      Button(`barGridAlign_gutter:${this.barGridAlign_gutter}`).onClick(() => {
        this.barGridAlign_gutter += 10
      })

      Button(`barGridAlign_columns:${this.barGridAlign_columns}`).onClick(() => {
        this.barGridAlign_columns += 2
      })

      /*
       * Tabs - 页签导航
       *   barGridAlign() - 栅格化页签栏（一个 BarGridColumnOptions 对象）
       *     margin - 栅格化后 column 的边距
       *     gutter - 栅格化后 column 的间距
       *     sm, md, lg - 栅格化后，小中大屏的 column 的数量
       */
      Tabs() {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar({
          icon: $r("app.media.app_icon"),
          text: "aaa"
        })

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar({
          icon: $r("app.media.app_icon"),
          text: "bbb"
        })

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar({
          icon: $r("app.media.app_icon"),
          text: "ccc"
        })
      }
      .barWidth('100%')
      .barHeight(64)
      .barGridAlign({
        margin: this.barGridAlign_margin,
        gutter: this.barGridAlign_gutter,
        sm: this.barGridAlign_columns,
        md: this.barGridAlign_columns,
        lg: this.barGridAlign_columns,
      })
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  @State currentIndex: number = 0
  @State opacityList: number[] = [1.0, 1.0, 1.0]
  @State scaleList: number[] = [1.0, 1.0, 1.0]

  private customContentTransition: (from: number, to: number) => TabContentAnimatedTransition = (from: number, to: number) => {
    return {
      timeout: 1000,
      transition: (proxy: TabContentTransitionProxy) => {
        this.scaleList[from] = 1.0
        this.scaleList[to] = 0.5
        this.opacityList[from] = 1.0
        this.opacityList[to] = 0.5
        animateTo({
          duration: 1000,
          onFinish: () => {
            proxy.finishTransition()
          }
        }, () => {
          this.scaleList[from] = 0.5
          this.scaleList[to] = 1.0
          this.opacityList[from] = 0.5
          this.opacityList[to] = 1.0
        })
      }
    } as TabContentAnimatedTransition
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * Tabs - 页签导航
       *   customContentTransition() - 自定义内容区的切换动画
       *     from - 切换前的页签的索引位置
       *     to - 切换后的页签的索引位置
       *     返回值是一个 TabContentAnimatedTransition 对象
       *       timeout - 自定义切换动画的超时时间
       *       transition - 自定义切换动画启动时的回调（回调参数是一个 TabContentTransitionProxy 对象）
       *         from - 切换前的页签的索引位置
       *         to - 切换后的页签的索引位置
       *         finishTransition - 告知 Tabs 组件，自定义切换动画已结束
       *   onAnimationStart() - 动画启动时的回调
       *     index - 切换前的页签的索引位置
       *     targetIndex - 切换后的页签的索引位置
       *     event - 事件参数（一个 TabsAnimationEvent 对象）
       *       currentOffset - 切换前的内容区的内容的当前的偏移距离
       *   onAnimationEnd() - 动画结束时的回调
       *     index - 切换后的页签的索引位置
       *     event - 事件参数（一个 TabsAnimationEvent 对象）
       *       currentOffset - 切换前的内容区的内容的当前的偏移距离
       */
      Tabs({
        index: this.currentIndex
      }) {
        TabContent() {
          Column().width('100%').height('100%')
            .backgroundColor(Color.Red)
            .opacity(this.opacityList[0])
            .scale({ x: this.scaleList[0], y: this.scaleList[0] })
        }.tabBar("red")

        TabContent() {
          Column().width('100%').height('100%')
            .backgroundColor(Color.Green)
            .opacity(this.opacityList[1])
            .scale({ x: this.scaleList[1], y: this.scaleList[1] })
        }.tabBar("green")

        TabContent() {
          Column().width('100%').height('100%')
            .backgroundColor(Color.Blue)
            .opacity(this.opacityList[2])
            .scale({ x: this.scaleList[2], y: this.scaleList[2] })
        }.tabBar("blue")
      }
      .customContentTransition(this.customContentTransition)
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        this.message = `onAnimationStart index:${index}, targetIndex:${targetIndex}, event:${JSON.stringify(event)}`
        this.currentIndex = targetIndex
      })
      .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
        this.message = `onAnimationEnd index:${index}, event:${JSON.stringify(event)}`
      })
    }
  }
}

@Component
struct MySample5 {

  @State currentIndex: number = 0

  /*
   * TabsController - 用于和绑定的 Tabs 之间的交互
   *   changeIndex() - 切换到指定索引位置的页签
   *   preloadItems() - 预加载指定索引位置的页签
   */
  private controller: TabsController = new TabsController()

  build() {
    Column({space:10}) {

      Button('preloadItems([2, 3])').onClick(() => {
        this.controller.preloadItems([2, 3])
          .then(() => {
            MyLog.d('preloadItems 成功')
          })
          .catch((error: BusinessError) => {
            MyLog.d(`preloadItems 失败 code:${error.code}, message:${error.message}`)
          })
      })

      /*
       * Tabs - 页签导航
       *   controller - 绑定的 TabsController 对象
       */
      Tabs({
        index: this.currentIndex,
        controller: this.controller
      }) {
        TabContent() {
          MyComponent({ text: "red" }).backgroundColor(Color.Red)
        }.tabBar("red")

        TabContent() {
          MyComponent({ text: "green" }).backgroundColor(Color.Green)
        }.tabBar("green")

        TabContent() {
          MyComponent({ text: "blue" }).backgroundColor(Color.Blue)
        }.tabBar("blue")

        TabContent() {
          MyComponent({ text: "orange" }).backgroundColor(Color.Orange)
        }.tabBar("orange")
      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}
@Component
struct MyComponent {
  private text: string = ""

  aboutToAppear(): void {
    console.info('aboutToAppear:' + this.text)
  }

  aboutToDisappear(): void {
    console.info('aboutToDisappear:' + this.text)
  }

  build() {
    Column() {
      Text(this.text).fontColor(Color.White).fontSize(64)
    }.width('100%').height('100%')
  }
}