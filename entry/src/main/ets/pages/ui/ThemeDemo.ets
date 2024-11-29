/*
 * 主题相关
 * 相关自定义主题的定义在 MyTheme.ets
 */

import { TitleBar } from '../TitleBar';
import { ThemeControl, Colors } from '@kit.ArkUI';
import { myAppTheme, myAppTheme2 } from './MyTheme';

// 设置当前的默认主题（需要在页面实例化之前执行）
ThemeControl.setDefaultTheme(myAppTheme)

@Entry
@Component
struct ThemeDemo {

  @State brandColor: ResourceColor = ''

  // 加载主题时的回调
  // 其会在 build() 之前执行，在此处可以获取当前上下文的 Theme 对象
  onWillApplyTheme(theme: Theme) {
    // 获取当前主题的指定的颜色
    // 可用的主题颜色以及默认主题颜色请参见 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/ui/theme_skinning.md
    this.brandColor = theme.colors.brand;
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button('button') // 默认背景色来自当前主题的 brand 颜色
      Checkbox() // 选中时的默认背景色来自当前主题的 brand 颜色
      Slider() // 已加载部分的颜色来自当前主题的 brand 颜色
      Divider() // 颜色来自当前主题的 compDivider 颜色

      // 使用当前主题的 brand 颜色
      Text("Text").backgroundColor(this.brandColor)
      // 使用系统默认主题的 brand 颜色
      Text("Text").backgroundColor($r('sys.color.brand'))

      /*
       * WithTheme() - 在指定的区域内使用指定的自定义主题
       *   theme - 指定的自定义主题
       *   colorMode - 深色浅色模式（ThemeColorMode 枚举）
       *     SYSTEM - 跟随系统的深色浅色模式
       *     LIGHT - 浅色模式
       *     DARK - 深色模式
       *
       * 注：如果想要深色模式生效，则需要添加文件 resources/dark/element/dark.json 并在其中定义深色模式的相关颜色，比如
       * {
       *   "color": [
       *     {
       *       "name": "color_demo",
       *       "value": "#00FF00"
       *     }
       *   ]
       * }
       */
      WithTheme({
        theme: myAppTheme2,
      }) {
        Column() {
          Button('button')
          Divider().strokeWidth(5)
        }
      }

      WithTheme({
        theme: myAppTheme2,
        colorMode: ThemeColorMode.LIGHT,
      }) {
        Column() {
          // 使用自定义的浅色模式的相关颜色（来自 resources/base/element/color.json）
          Text("Text").backgroundColor($r('app.color.color_demo'))
        }
      }

      // 注：Previewer 不支持深色模式，需要用模拟器或真机
      WithTheme({
        theme: myAppTheme2,
        colorMode: ThemeColorMode.DARK,
      }) {
        Column() {
          // 使用自定义的深色模式的相关颜色（来自 resources/dark/element/dark.json）
          Text("Text").backgroundColor($r('app.color.color_demo'))
        }
      }
    }
  }
}