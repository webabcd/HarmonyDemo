/*
 * List - 编辑列表
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct ListDemo3 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('多选').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('排序').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('横滑，删除，添加').align(Alignment.Top)
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
  @State editFlag: boolean = false

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * List - 编辑列表
       * 本例用于演示，如何通过自己写代码的方式实现切换到所谓的编辑模式，以及在编辑模式下显示多选框
       *
       * 注：我这里测试发现 ListItem 的 selectable(), selected(), onSelect() 和 List 的 multiSelectable() 均无效
       */
      List({ space: 20 }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Row() {
              Text(item.toString()).height(100)
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
                Checkbox().width(24).height(24)
              }
            }
          }
        })
      }
      .width('100%')
      .height('100%')

      Button('切换编辑模式')
        .onClick(() => {
          this.editFlag = !this.editFlag
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample2 {

  @State private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  @State dragItem: number = -1 // 拖动中的 item 的索引位置
  @State offsetY: number = 0 // 拖动中的 item 的位移距离
  @State prevOffsetY: number = 0

  private itemHeight: number = 120 // 每个 item 的高度

  // 指定的 item 的缩放倍数
  itemScale(item: number): number {
    if (this.dragItem == -1) {
      return 1
    }

    if (this.dragItem == item) {
      return 1.1
    } else {
      return 0.9
    }
  }

  // 排序数据
  itemMove(index: number, newIndex: number): void {
    let tmp = this.array.splice(index, 1)
    this.array.splice(newIndex, 0, tmp[0])
  }

  build() {
    Stack() {
      /*
       * List - 编辑列表
       * 本例用于演示，如何通过自己写代码的方式实现 ListItem 的拖动排序
       *
       * 注：我这里测试发现 List 的 onItemDragStart(), onItemDragEnter(), onItemDragMove(), onItemDragLeave(), onItemDrop() 均无效
       */
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString()).height(100).width('100%')
              .fontSize(48).fontColor(Color.White).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin({ left: 20, right: 20 })
          .zIndex(this.dragItem == item ? 1 : 0)
          .scale({ x: this.itemScale(item), y: this.itemScale(item) })
          .translate(this.dragItem == item ? { y: this.offsetY } : { y: 0 })
          .gesture(
            GestureGroup(GestureMode.Sequence,
              LongPressGesture({ repeat: true })
                .onAction((event: GestureEvent) => {
                  animateTo({ curve: Curve.Ease, duration: 500 }, () => {
                    this.dragItem = item
                  })
                })
                .onActionEnd(() => {
                  animateTo({ curve: Curve.Ease, duration: 500 }, () => {
                    this.dragItem = -1
                  })
                }),
              PanGesture({ fingers: 1 })
                .onActionStart(() => {
                  this.dragItem = item
                  this.prevOffsetY = 0
                })
                .onActionUpdate((event: GestureEvent) => {
                  let index = this.array.indexOf(item)

                  // 计算拖动中的 ListItem 的位移距离
                  this.offsetY = event.offsetY - this.prevOffsetY

                  // 排序数据
                  if (this.offsetY > this.itemHeight / 2) {
                    animateTo({ curve: Curve.Ease }, () => {
                      this.offsetY -= this.itemHeight
                      this.prevOffsetY += this.itemHeight
                      this.itemMove(index, index + 1)
                    })
                  } else if (this.offsetY < -this.itemHeight / 2) {
                    animateTo({ curve: Curve.Ease }, () => {
                      this.offsetY += this.itemHeight
                      this.prevOffsetY -= this.itemHeight
                      this.itemMove(index, index - 1)
                    })
                  }
                })
                .onActionEnd((event: GestureEvent) => {
                  animateTo({ curve: Curve.Ease, duration: 500 }, () => {
                    this.dragItem = -1
                    this.offsetY = 0
                  })
                }))
              .onCancel(() => {
                animateTo({ curve: Curve.Ease, duration: 500 }, () => {
                  this.dragItem = -1
                  this.offsetY = 0
                })
              })
          )
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample3 {

  @State message: string = ""
  @State message2: string = ""
  @State array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  private listScroller: ListScroller = new ListScroller()

  // 横滑后 item 左侧的组件
  @Builder itemStart() {
    Checkbox().width(24).height(24).margin(10)
  }

  // 横滑后 item 右侧的组件
  @Builder itemEnd(item: number) {
    Row() {
      Button("删除").margin(2).onClick(() => {
        let index = this.array.indexOf(item)
        this.array.splice(index, 1)
      })
      Button("取消").margin(2).onClick(() => {
        // 关闭所有 item 的横滑状态
        this.listScroller.closeAllSwipeActions()
      })
    }
    .padding(10)
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * List - 编辑列表
       * 本例用于演示，横滑显示 item 的操作按钮，左滑删除 item，添加新的 item
       *
       * ListItem - list 内的每个 item
       *   swipeAction() - 横滑操作
       *     start, end - 横滑后 item 左侧的组件和右侧的组件（可以指定一个 @Builder 装饰的函数，或者一个 SwipeActionItem 对象）
       *       builder - 需要显示的自定义组件
       *       actionAreaDistance - 左滑时，完整显示了 end 组件后，再至少滑动 actionAreaDistance（默认值为 56）指定的距离且抬起手指后，则触发 onAction 回调
       *       onAction - 左滑删除手势完成后的回调
       *       onEnterActionArea - 横滑时，进入左滑删除区域时的回调
       *       onExitActionArea - 横滑时，离开左滑删除区域时的回调
       *       onStateChange - 横滑后，且抬起手指后，当前状态发生变化后的回调（SwipeActionState 枚举）
       *         COLLAPSED - 当前 item 处于普通状态
       *         EXPANDED - 当前 item 处于显示了左侧组件或右侧组件的状态
       *         ACTIONING - 当前 item 处于触发了左滑删除手势的状态
       *     edgeEffect - 横滑后的回弹效果（SwipeEdgeEffect.None 或 SwipeEdgeEffect.Spring）
       *     onOffsetChange - 横滑时 item 的偏移量发生变化时的回调
       *       offset - 当前 item 的偏移量
       * ListScroller - 用于和绑定的 List 之间的交互（继承自 Scroller）
       */
      List({ space: 20, scroller: this.listScroller }) {
        ForEach(this.array, (item: number) => {
          ListItem() {
            Text(item.toString()).height(100).width('100%')
              .fontSize(48).fontColor(Color.White).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin({ left: 20, right: 20 })
          // ListItem 添加和删除时的动画效果
          .transition(
              TransitionEffect.OPACITY.animation({ duration: 1000 })
          )
          .swipeAction({
            end: {
              builder: () => { this.itemEnd(item) },
              actionAreaDistance: 56,
              onAction: () => {
                // 删除当前 item
                let index = this.array.indexOf(item)
                this.array.splice(index, 1)
              },
              onEnterActionArea: () => {
                this.message = 'onEnterActionArea'
              },
              onExitActionArea: () => {
                this.message = 'onExitActionArea'
              },
              onStateChange: (state:SwipeActionState) => {
                this.message = `state:${SwipeActionState[state]}`
              },
            },
            start: this.itemStart,
            edgeEffect: SwipeEdgeEffect.Spring,
            onOffsetChange: (offset: number) => {
              this.message2 = `onOffsetChange:${offset}`
            }
          })
        })
      }
      Column({space:10}) {
        Button('在位置 0 处添加一项')
          .onClick(() => {
            this.array.unshift(Math.floor(Math.random() * Math.floor(1000)))
          })

        Text(this.message).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue)
        Text(this.message2).fontSize(16).fontColor(Color.White).backgroundColor(Color.Blue)
      }
      .hitTestBehavior(HitTestMode.None)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Yellow)
  }
}