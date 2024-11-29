/*
 * CustomDialog 之 LoadingDialog（加载弹框）
 * 可以显示一个文本内容和一个加载框
 *
 * 关于 CustomDialog 的基础请参见 CustomDialogDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar'
import { CustomColors, LoadingDialog } from '@kit.ArkUI'

@Entry
@Component
struct CustomDialogDemo_LoadingDialog {

  /*
   * CustomDialog 之 LoadingDialog（加载弹框）
   *   content - 文本内容
   *   theme, themeColorMode - 用于指定弹框的主题和深色浅色模式
   *
   * 注：关于主题和深色浅色模式可以参见 /ui/ThemeDemo.ets 中的说明
   */
  dialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: 'content',
    }),
  })

  // 深色模式的加载弹框
  dialogController2: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: 'content',
      themeColorMode: ThemeColorMode.DARK
    }),
  })

  // 自定义主题的加载弹框
  dialogController3: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: 'content',
      theme: new MyCustomTheme()
    }),
  })

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button("click me")
        .onClick(() => {
          this.dialogController.open()
        })

      Button("click me")
        .onClick(() => {
          this.dialogController2.open()
        })

      Button("click me")
        .onClick(() => {
          this.dialogController3.open()
        })
    }
  }
}

// 用于修改 CustomDialog 之 LoadingDialog 的颜色的自定义主题
class MyCustomColors implements CustomColors {
  fontPrimary = Color.Blue
  iconSecondary = Color.Red
}
class MyCustomTheme implements CustomTheme {
  colors: MyCustomColors = new MyCustomColors()
}

