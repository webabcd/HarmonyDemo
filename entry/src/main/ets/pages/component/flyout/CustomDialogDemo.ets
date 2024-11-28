/*
 * CustomDialog - 自定义弹框
 *
 * 自定义弹框需要通过 @CustomDialog 装饰
 * CustomDialogController - 用于管理自定义弹框
 *   builder - 通过 @CustomDialog 装饰的自定义弹框
 *   open() - 打开
 *   close() - 关闭
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct CustomDialogDemo {

  @State message: string = ""

  /*
   * CustomDialogController - 用于管理自定义弹框
   *   builder - 通过 @CustomDialog 装饰的自定义弹框
   *
   *   title, subtitle, message - 标题，子标题，内容
   *   alignment - 显示位置（DialogAlignment 枚举）
   *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
   *   offset - 相对原有位置的偏移量
   *     dx, dy - 水平方向和垂直方向的偏移量
   *   gridCount - 占用的网格数（默认值为 4），会影响弹框的宽度，高度是自适应的
   *   width, height - 指定弹框的宽和高，指定之后则 gridCount 就无效了
   *   borderWidth, borderColor, borderStyle - 边框相关设置
   *   backgroundColor, backgroundBlurStyle, shadow - 背景颜色，模糊效果，阴影效果
   *   cornerRadius - 圆角半径
   *   isModal - 是否是模态窗口（模态窗口有遮罩层，非模态窗口无遮罩层）
   *   maskRect - 模态窗口时，遮罩层的位置和大小
   *   textStyle - 可以指定弹框内容文本的断行方式
   *   showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 所属窗口之外）
   *   autoCancel - 点击非弹框区域时是否自动隐藏
   *   onWillDismiss - 通过用户行为关闭弹窗之前的回调（回调参数是一个 DismissDialogAction 对象）
   *     reason - 弹窗将要关闭的原因
   *       PRESS_BACK - 点击返回按钮，手机侧边左滑/右滑，键盘 esc 键
   *       TOUCH_OUTSIDE - 点击非弹框区域
   *       CLOSE_BUTTON - 点击关闭按钮
   *       SLIDE_DOWN - 半模态转场时通过下拉关闭
   *     dismiss() - 确认关闭弹窗（如果设置了 onWillDismiss 回调，则只有调用 dismiss() 后才会关闭弹窗）
   *   cancel - 弹窗关闭之后的回调
   *   keyboardAvoidMode - 软键盘弹出时，自动避让的模式（KeyboardAvoidMode 枚举）
   *     DEFAULT - 自动避让软键盘
   *     NONE - 不避让软键盘
   *   openAnimation - 打开时的动画参数（指定一个 AnimateParam 对象，详见 /animation/AnimationDemo.ets 中的说明）
   *   closeAnimation - 关闭时的动画参数（指定一个 AnimateParam 对象，详见 /animation/AnimationDemo.ets 中的说明）
   */
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: MyCustomDialog({
      button1Clicked: ()=> {
        this.message += "button1 clicked\n"
      },
      button2Clicked: ()=> {
        this.message += "button2 clicked\n"
      }
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    // width: 300,
    // height: 200,
    borderWidth: 2,
    borderColor: Color.Blue,
    borderStyle: BorderStyle.Solid,
    backgroundColor: Color.Orange,
    backgroundBlurStyle: BlurStyle.Thin,
    shadow: ShadowStyle.OUTER_DEFAULT_MD,
    cornerRadius: 10,
    isModal: true,
    maskRect: {x:0, y:0, width:'100%', height:'100%'},
    showInSubWindow: false,
    autoCancel: true,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      this.message += `dismiss reason: ${dismissDialogAction.reason}\n`
      dismissDialogAction.dismiss()
    },
    cancel: () => {
      this.message += 'cancel\n'
    },
    keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,
    openAnimation: {
      duration: 3000,
    },
    closeAnimation: {
      duration: 3000,
    },
  })

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button('click me')
        .onClick(() => {
          if (this.dialogController != null) {
            // 打开自定义弹框
            this.dialogController.open()
          }
        })
    }
  }
}

/*
 * 自定义弹框需要通过 @CustomDialog 装饰
 * CustomDialogController - 用于管理自定义弹框
 *   open() - 打开
 *   close() - 关闭
 */
@CustomDialog
struct MyCustomDialog {
  controller?: CustomDialogController
  button1Clicked: () => void = () => {  }
  button2Clicked: () => void = () => {  }
  build() {
    Column() {
      Text('自定义弹窗').fontSize(36).height(100)
      Button('button1').margin(20)
        .onClick(() => {
          this.button1Clicked()
        })
      Button('button2').margin(20)
        .onClick(() => {
          this.button2Clicked()
        })
      Button('关闭').margin(20)
        .onClick(() => {
          if (this.controller != undefined) {
            // 关闭自定义弹框
            this.controller.close()
          }
        })
    }
  }
}