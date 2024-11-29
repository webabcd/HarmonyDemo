/*
 * CustomDialog 之 TipsDialog（图文弹框）
 * 可以显示一个图片，一个标题，一个文本内容，一个带文字的复选框，两个按钮
 *
 * 关于 CustomDialog 的基础请参见 CustomDialogDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar'
import { TipsDialog } from '@kit.ArkUI'

@Entry
@Component
struct CustomDialogDemo_TipsDialog {

  @State message: string = ""

  /*
   * CustomDialog 之 TipsDialog（图文弹框）
   *   imageRes - 图片
   *   imageSize - 图片尺寸（width, height）
   *   title - 标题
   *   content - 文本内容
   *   checkTips - 复选框旁边的文字
   *   isChecked - 复选框是否被选中
   *   onCheckedChange - 复选框被点击后的回调
   *     isChecked - 复选框是否被选中
   *   primaryButton, secondaryButton - 两个按钮
   *     value - 按钮上显示的文字
   *     action - 按钮被点击后的回调
   *     background, fontColor - 按钮背景颜色和按钮文字颜色
   *     buttonStyle, role - 按钮样式和按钮角色（参见 component/button/ButtonDemo.ets 中的说明）
   *   theme, themeColorMode - 用于指定弹框的主题和深色浅色模式（可以参见 CustomDialogDemo_LoadingDialog.ets 中的说明）
   */
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.app_icon'),
      imageSize: { width:100, height:100 },
      title: 'title',
      content: 'content',
      checkTips: 'checkTips',
      isChecked: true,
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
      onCheckedChange: (isChecked: boolean) => {
        this.message = `onCheckedChange isChecked:${isChecked}`
      }
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