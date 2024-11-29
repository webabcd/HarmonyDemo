/*
 * CustomDialog 之 CustomContentDialog（自定义内容弹框）
 * 可以显示两个标题，一个自定义内容，多个按钮
 *
 * 关于 CustomDialog 的基础请参见 CustomDialogDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar'
import { CustomContentDialog, LengthMetrics } from '@kit.ArkUI'

@Entry
@Component
struct CustomDialogDemo_CustomContentDialog {

  @State message: string = ""

  /*
   * CustomDialog 之 CustomContentDialog（自定义内容弹框）
   *   primaryTitle - 标题1
   *   secondaryTitle - 标题2
   *   contentBuilder - 指定一个 @Builder 装饰的自定义内容
   *   contentAreaPadding - 自定义内容所属区域的内边距
   *   buttons - 按钮集合（ButtonOptions 对象集合）
   *     value - 按钮上显示的文字
   *     action - 按钮被点击后的回调
   *     background, fontColor - 按钮背景颜色和按钮文字颜色
   *     buttonStyle, role - 按钮样式和按钮角色（参见 component/button/ButtonDemo.ets 中的说明）
   *   theme, themeColorMode - 用于指定弹框的主题和深色浅色模式（可以参见 CustomDialogDemo_LoadingDialog.ets 中的说明）
   */
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: 'primaryTitle',
      secondaryTitle: 'secondaryTitle',
      contentBuilder: () => {
        this.buildContent();
      },
      contentAreaPadding: { top:20, left:20 },
      buttons: [
        {
          value: 'button1',
          background: Color.Orange,
          fontColor: Color.White,
          action: () => {
            this.message = 'button1 clicked'
          }
        },
        {
          value: 'button2',
          action: () => {
            this.message = 'button2 clicked'
          }
        },
        {
          value: 'button3',
          action: () => {
            this.message = 'button3 clicked'
          }
        }
      ]
    }),
  })

  @Builder buildContent(): void {
    Column() {
      Text('自定义内容').fontColor(Color.White)
    }
    .backgroundColor(Color.Orange)
  }

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