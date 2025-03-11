/*
 * Modal - 全模态弹出框
 * 全模态弹出框是一个强制用户响应的弹窗，其完全阻断了用户与父页面的交互，直到用户关闭它
 */

import { RadioBar, TitleBar } from '../../TitleBar'

@Entry
@Component
struct ModalDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('定义动画').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message:string = ""

  @State isShow: boolean = false

  // 自定义弹窗内容
  @Builder myBuilder() {
    Column() {
      Button("关闭").onClick(() => {
        this.isShow = false;
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @State modalTransition: ModalTransition = ModalTransition.NONE
  valueList =  ["NONE", "DEFAULT", "ALPHA"]

  build() {
    Column({ space: 10 }) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.modalTransition = ModalTransition[this.valueList[selectedIndex]]
      }})

      /*
       * bindContentCover() - 为组件绑定一个全模态弹出框
       *   isShow - 是否显示全模态弹出框
       *   builder - 指定一个自定义组件（弹窗的内容）
       *   options - 选项（一个 ContentCoverOptions 对象）
       *     modalTransition - 打开弹窗时的过渡动画（ModalTransition 枚举）
       *       NONE - 无
       *       DEFAULT - 上下切换动画
       *       ALPHA - 透明度变化动画
       *     backgroundColor - 弹窗的背景色
       *     onWillAppear() - 弹窗将要挂载到组件树上时的回调
       *     onWillDisappear() - 弹窗将要从组件树上卸载时的回调
       *     onAppear() - 弹窗挂载到组件树上时的回调
       *     onDisAppear() - 弹窗从组件树上卸载时的回调
       *     onWillDismiss() - 弹窗显示后，用户点击返回按钮时的回调
       */
      Button("打开全模态弹出框").onClick(() => {
        this.isShow = true
      })
        .bindContentCover
        (
          this.isShow,
          this.myBuilder(),
          {
            modalTransition: this.modalTransition,
            backgroundColor: Color.Yellow,
            onWillAppear: () => {
              this.message += "onWillAppear\n"
            },
            onAppear: () => {
              this.message += "onAppear\n"
            },
            onWillDisappear: () => {
              this.message += "onWillDisappear\n"
            },
            onDisappear: () => {
              this.message += "onDisappear\n"
            },
            onWillDismiss: () => {
              this.message += "onWillDismiss\n"
              // 弹窗显示后，用户点击返回按钮时，如果需要关闭弹窗则手动将 isShow 设置为 false 即可
              this.isShow = false
            }
          }
        )

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""

  @State isShow: boolean = false

  @Builder myBuilder() {
    Column() {
      Button("关闭").onClick(() => {
        this.isShow = false;
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column({ space: 10 }) {

      /*
       * bindContentCover() - 为组件绑定一个全模态弹出框
       *   options - 选项（一个 ContentCoverOptions 对象）
       *     transition - 自定义打开弹窗时的过渡动画（详见 /animation/TransitionDemo.ets 中的说明）
       */
      Button("打开全模态弹出框（自定义动画）").onClick(() => {
        this.isShow = true
      })
        .bindContentCover
        (
          this.isShow,
          this.myBuilder(),
          {
            modalTransition: ModalTransition.NONE,
            backgroundColor: Color.Yellow,
            transition: TransitionEffect.asymmetric(
              // 弹窗出现时的过渡动画效果
              TransitionEffect.SLIDE.animation({ duration: 1000 }),
              // 弹窗消失时的过渡动画效果
              TransitionEffect.OPACITY.animation({ duration: 1000 })
            ),
          }
        )

      Text(this.message)
    }
  }
}
