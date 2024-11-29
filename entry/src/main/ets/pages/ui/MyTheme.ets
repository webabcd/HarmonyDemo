/*
 * 本例用于演示自定义主题
 * 引用了此文件的代码在 ThemeDemo.ets
 */

import { CustomColors, CustomTheme } from '@kit.ArkUI'

// 自定义主题的颜色
// 可用的主题颜色以及默认主题颜色请参见 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/ui/theme_skinning.md
export class AppColors implements CustomColors {
  brand: ResourceColor = Color.Orange
  compDivider: ResourceColor = Color.Red
}
// 自定义主题
export class AppTheme implements CustomTheme {
  public colors: AppColors = new AppColors()
}
// 导出自定义主题
export let myAppTheme: CustomTheme = new AppTheme()

export class AppColors2 implements CustomColors {
  brand: ResourceColor = Color.Green
  compDivider: ResourceColor = Color.Blue
}
export class AppTheme2 implements CustomTheme {
  public colors: AppColors2 = new AppColors2()
}
export let myAppTheme2: CustomTheme = new AppTheme2()