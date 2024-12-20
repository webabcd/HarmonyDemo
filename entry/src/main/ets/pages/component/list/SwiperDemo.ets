/*
 * Swiper - 组件轮播列表
 *
 * 注：
 * 1、Swiper 结合 ForEach 的应用可以参考 /component/list/ListDemo5.ets 中的说明（但是不支持通过 ForEach 的 onMove() 拖动排序）
 * 2、Swiper 结合 LazyForEach 的应用可以参考 /component/list/ListDemo6.ets 中的说明
 * 3、Swiper 结合 Repeat 的应用可以参考 /component/list/ListDemo7.ets 中的说明
 */

import { MyLog, TitleBar } from '../../TitleBar';

@Entry
@Component
struct SwiperDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础1').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('基础2').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('controller 和 event').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('自定义切换动画').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

class MyDataSource implements IDataSource {
  private array: string[] = [];
  constructor(array: string[]) {
    this.array = array
  }
  public totalCount(): number {
    return this.array.length;
  }
  public getData(index: number): string {
    return this.array[index];
  }
  registerDataChangeListener(listener: DataChangeListener): void { }
  unregisterDataChangeListener() { }
}

@Component
struct MySample1 {

  private array: MyDataSource = new MyDataSource(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']);

  build() {
    Column({ space: 10 }) {

      /*
       * Swiper - 组件轮播列表
       *   cachedCount() - 指定预挂载的 item 的数量（参见 /component/list/ListDemo6.ets 中的说明）
       *   vertical() - 是否在垂直方向上轮播
       *   index() - 当前显示的子组件的索引位置
       *   itemSpace() - 子组件之间的间距
       *   autoPlay() - 是否自动播放
       *   interval()- 翻页的间隔时间
       *   curve() - 组件之间切换时的动画曲线（参见 /animation/CurveDemo.ets 中的说明）
       *   duration() - 组件之间切换时的动画时长，必须指定 curve() 后才会生效
       *   loop() - 是否支持循环播放（即最右边时再往右则播最左边的，最左边的再往左则播最右边的）
       *   disableSwipe() - 是否禁用通过手势滑动切换
       *   edgeEffect() - 当禁用循环播放时，滚动到边缘后的效果
       *     edgeEffect - 效果（EdgeEffect 枚举）
       *       Spring - 弹性效果
       *       Fade - 圆弧阴影效果
       *       None - 无效果
       *   indicatorInteractive() - 是否可以通过导航小圆点翻页
       *   indicator() - 导航小圆点的样式
       *     一个 boolean 值，设置为 false 则不显示导航小圆点
       *     一个 DotIndicator 对象，指定导航小圆点的样式
       *       top(), right(), bottom(), left() - 小圆点的位置
       *       itemWidth(), itemHeight(), color() - 小圆点的宽高和颜色
       *       selectedItemWidth(), selectedItemHeight(), selectedColor() - 小圆点被选中时的宽高和颜色
       *       maxDisplayCount() - 显示的小圆点的最大数
       *       mask() - 是否为小圆点显示一个半透明背景
       *     一个 DigitIndicator 对象，导航小圆点改为导航页码，并指定其样式
       *       top(), right(), bottom(), left() - 页码的位置
       *       fontColor(), digitFont() - 页码的颜色和字体样式
       *       selectedFontColor(), selectedDigitFont() - 当前页码的颜色和字体样式
       *   displayArrow() - 导航箭头的样式
       *     value - 设置为 false 则隐藏，设置为 ArrowStyle 对象则设置箭头的样式
       *       showBackground - 是否显示箭头的圆形背景
       *       backgroundSize - 箭头圆形背景的大小
       *       backgroundColor - 箭头圆形背景的颜色
       *       arrowSize - 箭头的大小
       *       arrowColor - 箭头的颜色
       *       isSidebarMiddle - 箭头是否显示在中部的左右两侧（设置为 false 则显示在导航小圆点的两侧）
       *     isHoverShow - 是否只有鼠标悬停时才显示箭头（设置为 false 则一直会显示箭头）
       */

      Swiper() {
        LazyForEach(this.array, (item: string) => {
          Text(item).backgroundColor(Color.Orange).fontColor(Color.White)
            .fontSize(24).textAlign(TextAlign.Center).height(150).width('100%')
        }, (item: string) => item)
      }
      .cachedCount(2)
      .vertical(false)
      .itemSpace(0)
      .index(13)
      .autoPlay(true)
      .interval(3000)
      .curve(Curve.Linear)
      .duration(1000)
      .loop(true)
      .disableSwipe(false)
      .effectMode(EdgeEffect.Spring)
      .indicatorInteractive(true)
      .indicator(
        new DotIndicator()
          .itemWidth(14)
          .itemHeight(14)
          .selectedItemWidth(16)
          .selectedItemHeight(16)
          .color(Color.Red)
          .selectedColor(Color.Green)
          .maxDisplayCount(6)
          .mask(true)
      )
      .displayArrow({
        showBackground: true,
        backgroundSize: 24,
        backgroundColor: Color.White,
        arrowSize: 18,
        arrowColor: Color.Blue,
        isSidebarMiddle: true,
      }, false)

      Swiper() {
        LazyForEach(this.array, (item: string) => {
          Text(item).backgroundColor(Color.Orange).fontColor(Color.White)
            .fontSize(24).textAlign(TextAlign.Center).height(150).width('100%')
        }, (item: string) => item)
      }
      .indicatorInteractive(true)
      .indicator(
        new DigitIndicator()
          .left(0)
          .bottom(0)
          .fontColor(Color.Red)
          .digitFont({ size: 20, weight: FontWeight.Normal })
          .selectedFontColor(Color.Green)
          .selectedDigitFont({ size: 20, weight: FontWeight.Bold })
      )

      Swiper() {
        LazyForEach(this.array, (item: string) => {
          Text(item).backgroundColor(Color.Orange).fontColor(Color.White)
            .fontSize(24).textAlign(TextAlign.Center).height(150).width('100%')
        }, (item: string) => item)
      }
      .displayCount(5, true)
    }
  }
}

@Component
struct MySample2 {

  private array: MyDataSource = new MyDataSource(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']);

  build() {
    Column({ space: 10 }) {

      /*
       * Swiper - 组件轮播列表
       *   displayCount() - 每页显示的子组件数量，以及翻页模式
       *     value - 每页显示的子组件数量
       *     swipeByGroup - 翻页模式
       *       true - 按组翻页，每次翻页会翻 value 指定的数量
       *       false - 按组件翻页，每次翻页会翻一个组件
       *   prevMargin() - 当前主要显示的子组件的左侧子组件显示出来的宽度
       *   nextMargin() - 当前主要显示的子组件的右侧子组件显示出来的宽度
       *   nestedScroll() - 把 Swiper 放到一个可滚动组件内时的嵌套滚动逻辑（SwiperNestedScrollMode 枚举）
       *     SELF_ONLY - 在 Swiper 中滚的话只能滚 Swiper 自己
       *     SELF_FIRST - 在 Swiper 中滚的话，如果禁用了循环播放，且滚到边缘后，就会滚父组件
       */

      Swiper() {
        LazyForEach(this.array, (item: string) => {
          Text(item).backgroundColor(Math.floor(Math.random() * (0xffffff + 1))).fontColor(Color.White)
            .fontSize(24).textAlign(TextAlign.Center).height(150).width('100%')
        }, (item: string) => item)
      }
      .displayCount(5, true)

      Swiper() {
        LazyForEach(this.array, (item: string) => {
          Text(item).backgroundColor(Math.floor(Math.random() * (0xffffff + 1))).fontColor(Color.White)
            .fontSize(24).textAlign(TextAlign.Center).height(150).width('100%')
        }, (item: string) => item)
      }
      .nextMargin(50)
      .prevMargin(50)

      List({ space: 20 }) {
        ListItem() {
          Column().backgroundColor(Color.Red).width(300).height(150)
        }
        ListItem() {
          Swiper() {
            LazyForEach(this.array, (item: string) => {
              Text(item).backgroundColor(Math.floor(Math.random() * (0xffffff + 1))).fontColor(Color.White)
                .fontSize(24).textAlign(TextAlign.Center).height(150).width('100%')
            }, (item: string) => item)
          }
          .loop(false)
          .nestedScroll(SwiperNestedScrollMode.SELF_FIRST)
        }
        ListItem() {
          Column().backgroundColor(Color.Green).width(300).height(150)
        }
      }
      .listDirection(Axis.Horizontal)
    }
  }
}

@Component
struct MySample3 {

  // SwiperController - 用于和绑定的 Swiper 之间的交互
  private swiperController: SwiperController = new SwiperController()
  private array: MyDataSource = new MyDataSource(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']);
  @State message1: string = ""
  @State message2: string = ""
  @State message3: string = ""
  @State message4: string = ""

  build() {
    Column({ space: 5 }) {

      /*
       * Swiper - 组件轮播列表
       *   controller - 绑定的 SwiperController 对象
       *   onChange() - 当前显示的子组件的索引位置发生变化时的回调
       *   onGestureSwipe() - 跟手滑动时的回调
       *     index - 跟手的子组件的索引位置
       *     extraInfo.currentOffset - 跟手的子组件的偏移距离
       *   onAnimationStart() - 切换动画开始时的回调
       *     index - 当前显示的子组件的索引位置
       *     targetIndex - 切换动画的需要显示的目标子组件的索引位置
       *     extraInfo.currentOffset - 切换动画开始时，当前显示的子组件的偏移距离
       *     extraInfo.targetOffset - 切换动画开始时，切换动画的需要显示的目标子组件的偏移距离
       *     extraInfo.velocity - 手势触发切换动画时的离手速度
       *   onAnimationEnd() - 切换动画结束时的回调
       *     index - 当前显示的子组件的索引位置
       *   onContentDidScroll() - 页面滚动时的回调
       *     selectedIndex - 启动滚动的子组件的索引位置
       *     index - 可视区内的子组件的索引位置
       *     position - index 对应的子组件相对于 selectedIndex 对应的子组件的起始位置的移动比例
       *       比如 0 1 2 当前显示的是 1，那么 0 的位置就是 -1，1 的位置就是 0，2 的位置就是 1
       *       比如 0 1 2 当前显示的是 1.5，那么 1 的位置就是 -0.5，2 的位置就是 0.5
       *     mainAxisLength - index 对应的子组件的主轴方向上的长度
       */
      Swiper(this.swiperController) {
        LazyForEach(this.array, (item: string) => {
          Text(item).backgroundColor(Color.Orange).fontColor(Color.White)
            .fontSize(24).textAlign(TextAlign.Center).height(100).width('100%')
        }, (item: string) => item)
      }
      .onChange((index: number) => {
        this.message1 = `onChange index:${index}`
      })
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        this.message2 = `onGestureSwipe index:${index}, currentOffset:${extraInfo.currentOffset}`
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        this.message3 = `onAnimationStart index:${index}, targetIndex:${targetIndex}, currentOffset:${extraInfo.currentOffset}, targetOffset:${extraInfo.targetOffset}, velocity:${extraInfo.velocity}`
      })
      .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
        this.message4 = `onAnimationEnd index:${index}`
      })
      .onContentDidScroll((selectedIndex: number, index: number, position: number, mainAxisLength: number) => {
        MyLog.d(`onContentDidScroll index:${index}, selectedIndex:${selectedIndex}, position:${position}, mainAxisLength:${mainAxisLength}`)
      })
      .curve(Curve.Linear)
      .duration(5000).nextMargin(20)

      /*
       * SwiperController - 用于和绑定的 Swiper 之间的交互
       *   showNext() - 切换到下一页
       *   showPrevious() - 切换到上一页
       *   changeIndex() - 切换到指定页
       *   finishAnimation() - 立即停止切换动画
       */
      Button('showNext()').onClick(() => {
        this.swiperController.showNext()
      })
      Button('showPrevious()').onClick(() => {
        this.swiperController.showPrevious()
      })
      Button('changeIndex(3)').onClick(() => {
        this.swiperController.changeIndex(3)
      })
      Button('finishAnimation()').onClick(() => {
        this.swiperController.finishAnimation()
      })

      Text(this.message1)
      Text(this.message2)
      Text(this.message3)
      Text(this.message4)
    }
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
struct MySample4 {

  private array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19'];
  private colorList: number[] = []

  private MIN_SCALE: number = 0.75

  @State opacityList: number[] = []
  @State scaleList: number[] = []
  @State translateList: number[] = []
  @State zIndexList: number[] = []

  aboutToAppear(): void {
    for (let i = 0; i < this.array.length; i++) {
      this.colorList.push(Math.floor(Math.random() * (0xffffff + 1)))
      this.opacityList.push(1.0)
      this.scaleList.push(1.0)
      this.translateList.push(0.0)
      this.zIndexList.push(0)
    }
  }

  build() {
    Column({ space: 10 }) {
      /*
       * Swiper - 组件轮播列表
       *   customContentTransition() - 自定义切换动画
       *     timeout - 经测试，不知道是干啥用的
       *     transition - 通过回调的 SwiperContentTransitionProxy 自定义切换动画
       *       selectedIndex - 启动动画的子组件的索引位置
       *       index - 可视区内的子组件的索引位置
       *       position - index 对应的子组件相对于 selectedIndex 对应的子组件的起始位置的移动比例
       *         比如 0 1 2 当前显示的是 1，那么 0 的位置就是 -1，1 的位置就是 0，2 的位置就是 1
       *         比如 0 1 2 当前显示的是 1.5，那么 1 的位置就是 -0.5，2 的位置就是 0.5
       *       mainAxisLength - index 对应的子组件的主轴方向上的长度
       *       finishTransition() - 经测试，不知道是干啥用的
       */
      Swiper() {
        ForEach(this.array, (item: string, index: number) => {
          Text(item).backgroundColor(this.colorList[index]).fontColor(Color.White)
            .fontSize(48).textAlign(TextAlign.Center).height(300).width('100%')
            .opacity(this.opacityList[index])
            .scale({ x: this.scaleList[index], y: this.scaleList[index] })
            .translate({ x: this.translateList[index] })
            .zIndex(this.zIndexList[index])
        })
      }
      .customContentTransition({
        transition: (proxy: SwiperContentTransitionProxy) => {
          MyLog.d(`index:${proxy.index}, selectedIndex:${proxy.selectedIndex}, position:${proxy.position}, mainAxisLength:${proxy.mainAxisLength}`)
          if (proxy.position <= 0) {
            // 可视区内的左侧的子组件
            this.opacityList[proxy.index] = 1.0
            this.scaleList[proxy.index] = 1.0
            this.translateList[proxy.index] = 0.0
            this.zIndexList[proxy.index] = 0
          } else {
            // 可视区内的右侧的子组件，滚动到当前 position 时
            this.opacityList[proxy.index] = 1 - proxy.position
            this.scaleList[proxy.index] = this.MIN_SCALE + (1 - this.MIN_SCALE) * (1 - proxy.position)
            this.translateList[proxy.index] = - proxy.position * proxy.mainAxisLength + (1 - this.scaleList[proxy.index]) * proxy.mainAxisLength / 2.0
            this.zIndexList[proxy.index] = -1
          }
        }
      })
    }
    .alignItems(HorizontalAlign.Start)
  }
}