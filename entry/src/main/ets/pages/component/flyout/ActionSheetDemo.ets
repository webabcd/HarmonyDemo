/*
 * ActionSheet - 列表弹框
 *
 * ActionSheet.show() - 弹出列表弹框，建议使用 this.getUIContext().showActionSheet()
 */

import { TitleBar } from '../../TitleBar'


@Entry
@Component
struct ActionSheetDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button('click me')
        .onClick(() => {
          /*
           * ActionSheet.show() - 弹出列表弹框，建议使用 this.getUIContext().showActionSheet()
           *   title, subtitle, message - 标题，子标题，内容
           *   alignment - 显示位置（DialogAlignment 枚举）
           *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
           *   offset - 相对原有位置的偏移量
           *     dx, dy - 水平方向和垂直方向的偏移量
           *   width, height - 指定弹框的宽和高
           *   borderWidth, borderColor, borderStyle - 边框相关设置
           *   backgroundColor, backgroundBlurStyle, shadow - 背景颜色，背景的模糊效果，阴影效果
           *   cornerRadius - 圆角半径
           *   isModal - 是否是模态窗口（模态窗口有遮罩层，非模态窗口无遮罩层）
           *   maskRect - 模态窗口时，遮罩层的位置和大小
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
           *   confirm - 按钮
           *     value - 按钮上显示的文字
           *     enabled - 是否可用
           *     defaultFocus - 是否默认焦点
           *     style - 按钮样式（DialogButtonStyle.DEFAULT 或 DialogButtonStyle.HIGHLIGHT）
           *     action - 点击按钮后的回调
           *   sheets - 列表（SheetInfo 对象的集合）
           *     icon - 当前项的图标
           *     title - 当前项的文本
           *     action - 当前项点击后的回调
           */
          this.getUIContext().showActionSheet({
            title: 'title',
            subtitle: 'subtitle',
            message: 'message',
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -20 },
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
            confirm: {
              value: 'confirm',
              enabled: true,
              defaultFocus: true,
              style: DialogButtonStyle.HIGHLIGHT,
              action: () => {
                this.message = 'confirm clicked'
              }
            },
            sheets: [
              {
                icon: $r('app.media.app_icon'),
                title: 'aaa',
                action: () => {
                  this.message = 'aaa clicked'
                }
              },
              {
                icon: $r('app.media.app_icon'),
                title: 'bbb',
                action: () => {
                  this.message = 'bbb clicked'
                }
              },
              {
                icon: $r('app.media.app_icon'),
                title: 'ccc',
                action: () => {
                  this.message = 'ccc clicked'
                }
              }
            ]
          })
        })
    }
  }
}