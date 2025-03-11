/*
 * Sheet - 半模态弹出框
 * 半模态弹出框是从屏幕底部或某个地方滑出的面板，可以允许用户与父页面交互
 */

import { RadioBar, TitleBar } from '../../TitleBar'
import { LengthMetrics } from '@kit.ArkUI'

@Entry
@Component
struct SheetDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('三档高度').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('样式').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('允许与父页面交互').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('是否避开非安全区域').align(Alignment.Top)
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

  build() {
    Column({ space: 10 }) {

      /*
       * bindSheet() - 为组件绑定一个半模态弹出框
       *   isShow - 是否显示半模态弹出框
       *   builder - 指定一个自定义组件（弹窗的内容）
       *   options - 选项（一个 SheetOptions 对象）
       *     width - 弹窗的宽度
       *     height - 弹窗的高度，除了指定一个具体的高度值外，还可以设置为一个 SheetSize 枚举
       *       MEDIUM - 占屏幕高度的一半
       *       LARGE - 占屏幕高度的大部分
       *       FIT_CONTENT - 自适应内容的高度
       *     backgroundColor - 弹窗的背景色
       *     onWillAppear() - 弹窗将要挂载到组件树上时的回调
       *     onWillDisappear() - 弹窗将要从组件树上卸载时的回调
       *     onAppear() - 弹窗挂载到组件树上时的回调
       *     onDisAppear() - 弹窗从组件树上卸载时的回调
       *     onWillDismiss() - 通过用户行为关闭弹出框之前的回调（回调参数是一个 DismissSheetAction 对象）
       *       reason - 弹窗将要关闭的原因
       *         PRESS_BACK - 点击返回按钮，手机侧边左滑/右滑，键盘 esc 键
       *         TOUCH_OUTSIDE - 点击非弹框区域
       *         CLOSE_BUTTON - 点击关闭按钮
       *         SLIDE_DOWN - 半模态转场时通过下拉关闭
       *       dismiss() - 确认关闭弹窗，调用 dismiss() 后才会关闭弹窗
       *     shouldDismiss() - 弹窗关闭之前的回调（回调参数是一个 SheetDismiss 对象）
       *       dismiss() - 确认关闭弹窗，调用 dismiss() 后才会关闭弹窗
       */
      Button("打开半模态弹出框").onClick(() => {
        this.isShow = true
      })
        .bindSheet
        (
          $$this.isShow,
          this.myBuilder(),
          {
            width: null,
            height: SheetSize.MEDIUM,
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
            onWillDismiss: (dismissSheetAction: DismissSheetAction) => {
              this.message += `onWillDismiss: ${dismissSheetAction.reason}\n`
              // 将 isShow 设置为 false 即可关闭弹窗
              // 调用 DismissSheetAction 的 dismiss() 也可关闭弹窗
              dismissSheetAction.dismiss()

            },
            shouldDismiss: (sheetDismiss: SheetDismiss) => {
              this.message += `shouldDismiss\n`
              // 调用 SheetDismiss 的 dismiss() 即可关闭弹窗
              sheetDismiss.dismiss()
            },
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

  @State scrollSizeMode: ScrollSizeMode = ScrollSizeMode.FOLLOW_DETENT
  valueList =  ["FOLLOW_DETENT", "CONTINUOUS"]

  build() {
    Column({ space: 10 }) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.scrollSizeMode = ScrollSizeMode[this.valueList[selectedIndex]]
      }})

      /*
       * bindSheet() - 为组件绑定一个半模态弹出框
       *   options - 选项（一个 SheetOptions 对象）
       *     detents - 一个数组，可以设置 3 个高度，除了指定一个具体的高度值外，还可以设置为一个 SheetSize 枚举
       *       MEDIUM - 占屏幕高度的一半
       *       LARGE - 占屏幕高度的大部分
       *       FIT_CONTENT - 自适应内容的高度
       *       数组的第一个值为打开弹窗后的初始高度，之后通过拖动可以让弹窗的高度在指定的 3 个值间调整
       *     backgroundColor - 弹窗的背景色
       *     dragBar - 是否在弹窗顶部显示控制条（用于告知用户，弹窗的高度可以手动调整）
       *     onHeightDidChange() - 弹窗的高度发生变化时的回调
       *     onDetentsDidChange() - 弹窗的高度在 detents 指定的 3 个档位之间变化时的回调
       *     scrollSizeMode() - 弹窗的高度在跟手变化的时候，弹窗的内容（包括布局）的更新方式（ScrollSizeMode 枚举）
       *       FOLLOW_DETENT - 弹窗的高度在跟手变化结束后，再更新弹窗的内容（包括布局）
       *       CONTINUOUS - 弹窗的高度在跟手变化的过程中，持续更新弹窗的内容（包括布局）
       */
      Button("打开半模态弹出框（三档高度可调）").onClick(() => {
        this.isShow = true
      })
        .bindSheet
        (
          $$this.isShow,
          this.myBuilder(),
          {
            // 弹窗的初始高度为 SheetSize.MEDIUM，之后可以通过拖动让其高度在 SheetSize.MEDIUM, SheetSize.LARGE, 100 之间调整
            detents: [SheetSize.MEDIUM, SheetSize.LARGE, 100],
            backgroundColor: Color.Yellow,
            dragBar: true,
            onHeightDidChange: (height: number) => {
              // this.message += `onHeightDidChange height: ${height}\n`
            },
            onDetentsDidChange: (height: number) => {
              this.message += `onDetentsDidChange height: ${height}\n`
            },
            scrollSizeMode: this.scrollSizeMode
          }
        )

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

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

  @State sheetType: SheetType = SheetType.BOTTOM
  valueList =  ["BOTTOM", "CENTER", "POPUP"]

  build() {
    Column({ space: 10 }) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.sheetType = SheetType[this.valueList[selectedIndex]]
      }})

      /*
       * bindSheet() - 为组件绑定一个半模态弹出框
       *   options - 选项（一个 SheetOptions 对象）
       *     width - 弹窗的宽度
       *     backgroundColor, backgroundBlurStyle, shadow - 背景颜色，背景的模糊效果，阴影效果
       *     borderWidth, borderColor, borderStyle - 边框相关设置
       *     title - 在左上角显示的标题
       *       title, subtitle
       *     showClose - 是否在右上角显示关闭按钮
       *     maskColor - 遮罩层颜色
       *     preferType - 弹出方式（SheetType 枚举）
       *       BOTTOM - 从底部弹出，且在底部显示，屏幕宽度 [0, 600vp) 时的默认值
       *       CENTER - 从底部弹出，且在中心显示，屏幕宽度 [600vp, 840vp) 时的默认值，且仅屏幕宽度在 [600vp, +∞) 时有效
       *       POPUP - 从绑定的组件的附近弹出，且在绑定的组件的附近显示，屏幕宽度 [840vp, +∞) 时的默认值，且仅屏幕宽度在 [840vp, +∞] 时有效，且无遮罩效果，且可以与父页面交互
       *     onTypeDidChange() - 弹出方式发生变化时的回调（回调参数是一个 SheetType 枚举）
       *     onWillSpringBackWhenDismiss() - 弹窗关闭时的回调（回调参数是一个 SpringBackAction 对象），在此处可以指定弹窗关闭时的回弹效果
       */
      Button("打开半模态弹出框（设置弹窗样式）").onClick(() => {
        this.isShow = true
      })
        .bindSheet
        (
          $$this.isShow,
          this.myBuilder(),
          {
            height: 300,
            backgroundColor: Color.Yellow,
            blurStyle: BlurStyle.Thick,
            shadow: ShadowStyle.OUTER_DEFAULT_MD,
            borderWidth: {
              top: LengthMetrics.vp(10),
              start: LengthMetrics.vp(10),
              end: LengthMetrics.vp(10)
            },
            borderColor: {
              top: Color.Red,
              start: Color.Green,
              end: Color.Blue
            },
            borderStyle: BorderStyle.Solid,
            title: {
              title: "title",
              subtitle: "subtitle"
            },
            showClose: true,
            maskColor: 0x33ff0000,
            preferType: this.sheetType,
            onTypeDidChange: (sheetType: SheetType) => {
              this.message += `onTypeDidChange sheetType: ${sheetType}\n`
            },
            onWillSpringBackWhenDismiss: ((SpringBackAction: SpringBackAction) => {
              /*
               * SpringBackAction
               *   springBack() - 让弹窗关闭时具有回弹效果
               */
              SpringBackAction.springBack()
            }),
          }
        )

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message:string = ""

  @State isShow: boolean = false
  @State enableOutsideInteractive: boolean = false

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

  build() {
    Column({ space: 10 }) {

      Button(`enableOutsideInteractive:${this.enableOutsideInteractive}`).onClick(() => {
        this.enableOutsideInteractive = !this.enableOutsideInteractive
      })

      /*
       * bindSheet() - 为组件绑定一个半模态弹出框
       *   options - 选项（一个 SheetOptions 对象）
       *     enableOutsideInteractive - 是否允许与父页面交互（注：当允许与父页面交互时，则无遮罩效果）
       */
      Button("打开半模态弹出框").onClick(() => {
        this.isShow = true
      })
        .bindSheet
        (
          $$this.isShow,
          this.myBuilder(),
          {
            height: 300,
            backgroundColor: Color.Yellow,
            enableOutsideInteractive: this.enableOutsideInteractive,
          }
        )

      Text(this.message)
    }
  }
}

@Component
struct MySample5 {

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

  @State sheetMode: SheetMode = SheetMode.OVERLAY
  valueList =  ["OVERLAY", "EMBEDDED"]

  build() {
    Column({ space: 10 }) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.sheetMode = SheetMode[this.valueList[selectedIndex]]
      }})

      /*
       * bindSheet() - 为组件绑定一个半模态弹出框
       *   options - 选项（一个 SheetOptions 对象）
       *     mode - 避开非安全区域的方式（SheetMode 枚举）
       *       OVERLAY - 不会避开非安全区域
       *       EMBEDDED - 会避开非安全区域
       */
      Button("打开半模态弹出框").onClick(() => {
        this.isShow = true
      })
        .bindSheet
        (
          $$this.isShow,
          this.myBuilder(),
          {
            height: 300,
            backgroundColor: Color.Yellow,
            mode: this.sheetMode
          }
        )

      Text(this.message)
    }
  }
}