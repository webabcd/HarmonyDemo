/*
 * CustomDialog 之 AlertDialog（警告弹框）
 * 可以显示两个标题，一个文本内容，两个按钮
 *
 * 关于 CustomDialog 的基础请参见 CustomDialogDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar'
import { AlertDialog } from '@kit.ArkUI'

@Entry
@Component
struct CustomDialogDemo_AlertDialog {

  @State message: string = ""

  /*
   * CustomDialog 之 AlertDialog（警告弹框）
   *   primaryTitle - 标题1
   *   secondaryTitle - 标题2
   *   content - 文本内容
   *   primaryButton, secondaryButton - 两个按钮
   *     value - 按钮上显示的文字
   *     action - 按钮被点击后的回调
   *     background, fontColor - 按钮背景颜色和按钮文字颜色
   *     buttonStyle, role - 按钮样式和按钮角色（参见 component/button/ButtonDemo.ets 中的说明）
   *   theme, themeColorMode - 用于指定弹框的主题和深色浅色模式（可以参见 CustomDialogDemo_LoadingDialog.ets 中的说明）
   */
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: 'primaryTitle',
      secondaryTitle: 'secondaryTitle',
      content: 'content',
      primaryButton: {
        value: 'primaryButton',
        buttonStyle: ButtonStyleMode.NORMAL,
        action: () => {
          this.message = 'primaryButton clicked'
        },
      },
      secondaryButton: {
        value: 'secondaryButton',
        background: Color.Orange,
        fontColor: Color.White,
        action: () => {
          this.message = 'secondaryButton clicked'
        }
      },
    }),
  })

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button("click me")
        .onClick(() => {
          this.dialogController.open()
        })
    }
  }
}