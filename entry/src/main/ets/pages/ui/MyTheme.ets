/*
 * 本例用于演示自定义主题
 * 引用了此文件的代码在 ThemeDemo.ets
 */

import { CustomColors, CustomTheme } from '@kit.ArkUI'

// 自定义主题的颜色
// 可用的主题颜色以及默认主题颜色请参见 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/ui/theme_skinning.md
export class MyCustomColors implements CustomColors {
  brand: ResourceColor = Color.Orange // brand 对应系统默认主题的 sys.color.brand
  compDivider: ResourceColor = Color.Red // compDivider 对应系统默认主题的 sys.color.comp_divider
}
// 自定义主题
export class MyCustomTheme implements CustomTheme {
  colors: MyCustomColors = new MyCustomColors()
}
// 导出自定义主题
export let myCustomTheme: CustomTheme = new MyCustomTheme()

export class MyCustomColors2 implements CustomColors {
  brand: ResourceColor = Color.Green
  compDivider: ResourceColor = Color.Blue
}
export class MyCustomTheme2 implements CustomTheme {
  colors: MyCustomColors2 = new MyCustomColors2()
}
export let myCustomTheme2: CustomTheme = new MyCustomTheme2()