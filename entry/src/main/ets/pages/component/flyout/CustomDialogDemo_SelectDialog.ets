/*
 * CustomDialog 之 SelectDialog（列表弹框）
 * 可以显示一个带文本和单选框的列表，一个标题，一个文本内容，一个按钮
 *
 * 关于 CustomDialog 的基础请参见 CustomDialogDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar'
import { SelectDialog } from '@kit.ArkUI'

@Entry
@Component
struct CustomDialogDemo_SelectDialog {

  @State message: string = ""

  /*
   * CustomDialog 之 SelectDialog（列表弹框）
   *   title - 标题
   *   content - 文本内容
   *   selectedIndex - 列表选中项的索引位置
   *   confirm - 按钮
   *     value - 按钮上显示的文字
   *     action - 按钮被点击后的回调
   *     background, fontColor - 按钮背景颜色和按钮文字颜色
   *     buttonStyle, role - 按钮样式和按钮角色（参见 component/button/ButtonDemo.ets 中的说明）
   *   radioContent - 选项列表（SheetInfo 对象的集合）
   *     icon - 当前项的图标
   *     title - 当前项的文本
   *     action - 当前项点击后的回调
   *   theme, themeColorMode - 用于指定弹框的主题和深色浅色模式（可以参见 CustomDialogDemo_LoadingDialog.ets 中的说明）
   */
  dialogController: CustomDialogController = new CustomDialogController({
    builder: SelectDialog({
      title: 'title',
      content: 'content',
      selectedIndex: 1,
      confirm: {
        value: 'confirm',
        background: Color.Orange,
        fontColor: Color.White,
        action: () => {
          this.message = 'confirm clicked'
        },
      },
      radioContent: [
        {
          icon: $r('app.media.app_icon'),
          title: 'aaa',
          action: () => {
            this.message = 'aaa'
          }
        },
        {
          icon: $r('app.media.app_icon'),
          title: 'bbb',
          action: () => {
            this.message = 'bbb'
          }
        },
        {
          icon: $r('app.media.app_icon'),
          title: 'ccc',
          action: () => {
            this.message = 'ccc'
          }
        },
      ]
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