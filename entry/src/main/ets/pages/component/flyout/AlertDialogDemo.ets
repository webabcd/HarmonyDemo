/*
 * AlertDialog - 警告弹框
 *
 * AlertDialog.show() - 弹出警告弹框，建议使用 this.getUIContext().showAlertDialog()
 *   支持的参数类型有以下 3 种
 *     AlertDialogParamWithConfirm - 有 1 个按钮
 *     AlertDialogParamWithButtons - 有 2 个按钮
 *     AlertDialogParamWithOptions - 有 n 个按钮
 *   注：以上 3 种类型均继承自 AlertDialogParam
 */

import { TitleBar } from '../../TitleBar'


@Entry
@Component
struct AlertDialogDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('AlertDialogParam').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('AlertDialogParamWithConfirm').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('AlertDialogParamWithButtons').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('AlertDialogParamWithOptions').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      Button('button')
        .onClick(() => {
          /*
           * AlertDialog.show() - 弹出警告弹框，建议使用 this.getUIContext().showAlertDialog()
           * 以 AlertDialogParam 为例
           *   title, subtitle, message - 标题，子标题，内容
           *   alignment - 显示位置（DialogAlignment 枚举）
           *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
           *   offset - 相对原有位置的偏移量
           *     dx, dy - 水平方向和垂直方向的偏移量
           *   borderWidth, borderColor, borderStyle - 边框相关设置
           *   backgroundColor, backgroundBlurStyle, shadow - 背景颜色，模糊效果，阴影效果
           *   cornerRadius - 圆角半径
           *   gridCount - 占用的网格数（默认值为 4），会影响弹框的宽度，高度是自适应的
           *   width, height - 指定弹框的宽和高，指定之后则 gridCount 就无效了
           *   isModal - 是否是模态窗口（模态窗口有遮罩层，非模态窗口无遮罩层）
           *   maskRect - 模态窗口时，遮罩层的位置和大小
           *   textStyle - 可以指定弹框内容文本的断行方式
           *   showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 所属窗口之外）
           *   autoCancel - 点击非弹框区域时是否自动隐藏
           *   onWillDismiss - 通过用户行为关闭弹窗之前的回调（回调参数是一个 DismissDialogAction 接口）
           *     reason - 弹窗将要关闭的原因
           *       PRESS_BACK - 点击返回按钮，手机侧边左滑/右滑，键盘 esc 键
           *       TOUCH_OUTSIDE - 点击非弹框区域
           *       CLOSE_BUTTON - 点击关闭按钮
           *       SLIDE_DOWN - 半模态转场时通过下拉关闭
           *     dismiss() - 确认关闭弹窗（如果设置了 onWillDismiss 回调，则只有调用 dismiss() 后才会关闭弹窗）
           *   cancel - 弹窗关闭之后的回调
           */
          this.getUIContext().showAlertDialog({
            title: 'title',
            subtitle: 'subtitle',
            message: 'messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage',
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -20 },
            gridCount: 4,
            // width: 300,
            // height: 200,
            cornerRadius: 10,
            borderWidth: 2,
            borderColor: Color.Blue,
            borderStyle: BorderStyle.Solid,
            backgroundColor: Color.Orange,
            backgroundBlurStyle: BlurStyle.Thin,
            shadow: ShadowStyle.OUTER_DEFAULT_MD,
            isModal: true,
            maskRect: {x:0, y:0, width:'100%', height:'100%'},
            textStyle: { wordBreak: WordBreak.BREAK_ALL },
            showInSubWindow: false,
            autoCancel: true,
            onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
              this.message += `dismiss reason: ${dismissDialogAction.reason}\n`
              dismissDialogAction.dismiss()
            },
            cancel: () => {
              this.message += 'cancel\n'
            },
          })
        })
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      Button('button')
        .onClick(() => {
          /*
           * AlertDialog.show() - 弹出警告弹框，建议使用 this.getUIContext().showAlertDialog()
           * 以 AlertDialogParamWithConfirm 为例（继承自 AlertDialogParam，关于 AlertDialogParam 的说明请参见本文件的第一个示例）
           *   confirm - 按钮
           *     value - 按钮上显示的文字
           *     enabled - 是否可用
           *     defaultFocus - 是否默认焦点
           *     style - 按钮样式（DialogButtonStyle.DEFAULT 或 DialogButtonStyle.HIGHLIGHT）
           *     fontColor - 按钮上文字的颜色
           *     backgroundColor - 按钮的背景色
           *     action - 点击按钮后的回调
           */
          this.getUIContext().showAlertDialog({
            title: 'title',
            message: 'message',
            confirm: {
              value: 'confirm',
              enabled: true,
              defaultFocus: true,
              style: DialogButtonStyle.DEFAULT,
              fontColor: Color.White,
              backgroundColor: Color.Blue,
              action: () => {
                this.message = "primaryButton clicked"
              }
            },
          })
        })
    }
  }
}

@Component
struct MySample3 {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      Button('button')
        .onClick(() => {
          /*
           * AlertDialog.show() - 弹出警告弹框，建议使用 this.getUIContext().showAlertDialog()
           * 以 AlertDialogParamWithButtons 为例（继承自 AlertDialogParam，关于 AlertDialogParam 的说明请参见本文件的第一个示例）
           *   primaryButton, secondaryButton - 第 1 个按钮和第 2 个按钮
           *     value - 按钮上显示的文字
           *     enabled - 是否可用
           *     defaultFocus - 是否默认焦点
           *     style - 按钮样式（DialogButtonStyle.DEFAULT 或 DialogButtonStyle.HIGHLIGHT）
           *     fontColor - 按钮上文字的颜色
           *     backgroundColor - 按钮的背景色
           *     action - 点击按钮后的回调
           */
          this.getUIContext().showAlertDialog({
            title: 'title',
            message: 'message',
            primaryButton: {
              value: 'cancel',
              enabled: true,
              defaultFocus: false,
              style: DialogButtonStyle.DEFAULT,
              fontColor: Color.White,
              backgroundColor: Color.Blue,
              action: () => {
                this.message = "primaryButton clicked"
              }
            },
            secondaryButton: {
              value: 'ok',
              enabled: true,
              defaultFocus: true,
              style: DialogButtonStyle.HIGHLIGHT,
              fontColor: Color.White,
              backgroundColor: Color.Orange,
              action: () => {
                this.message = "secondaryButton clicked"
              }
            },
          })
        })
    }
  }
}

@Component
struct MySample4 {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      Button('button')
        .onClick(() => {
          /*
           * AlertDialog.show() - 弹出警告弹框，建议使用 this.getUIContext().showAlertDialog()
           * 以 AlertDialogParamWithOptions 为例（继承自 AlertDialogParam，关于 AlertDialogParam 的说明请参见本文件的第一个示例）
           *   buttonDirection - 多个按钮的排列方向（DialogButtonDirection.HORIZONTAL 或 DialogButtonDirection.VERTICAL）
           *   buttons - 按钮集合
           *     value - 按钮上显示的文字
           *     enabled - 是否可用
           *     defaultFocus - 是否默认焦点
           *     style - 按钮样式（DialogButtonStyle.DEFAULT 或 DialogButtonStyle.HIGHLIGHT）
           *     fontColor - 按钮上文字的颜色
           *     backgroundColor - 按钮的背景色
           *     action - 点击按钮后的回调
           */
          this.getUIContext().showAlertDialog({
            title: 'title',
            message: 'message',
            buttonDirection: DialogButtonDirection.VERTICAL,
            buttons: [
              {
                value: 'button1',
                enabled: true,
                defaultFocus: false,
                style: DialogButtonStyle.DEFAULT,
                fontColor: Color.White,
                backgroundColor: Color.Red,
                action: () => {
                  this.message = "button1 clicked"
                }
              },
              {
                value: 'button2',
                enabled: true,
                defaultFocus: false,
                style: DialogButtonStyle.DEFAULT,
                fontColor: Color.White,
                backgroundColor: Color.Green,
                action: () => {
                  this.message = "button2 clicked"
                }
              },
              {
                value: 'button3',
                enabled: true,
                defaultFocus: true,
                style: DialogButtonStyle.HIGHLIGHT,
                fontColor: Color.White,
                backgroundColor: Color.Blue,
                action: () => {
                  this.message = "button3 clicked"
                }
              },
            ],
          })
        })
    }
  }
}
