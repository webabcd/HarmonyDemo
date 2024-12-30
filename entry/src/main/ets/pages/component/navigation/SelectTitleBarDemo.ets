/*
 * SelectTitleBar - 带下拉标题栏
 */

import { SelectTitleBar, SymbolGlyphModifier } from '@kit.ArkUI'
import { TitleBar } from '../../TitleBar';

// 对应 SelectTitleBarMenuItem
interface MenuItem {
  value: Resource;
  isEnabled?: boolean;
  action?: () => void
}

@Entry
@Component
struct SelectTitleBarDemo {

  symbolModifier: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.ohos_wifi'))
    .fontColor([Color.Green])
    .symbolEffect(
      new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE),
      true
    )

  // 左侧下拉菜单的选项集合
  options:Array<SelectOption> = [
    { value: 'aaa', icon: $r("app.media.app_icon") },
    { value: 'bbb', icon: $r("app.media.app_icon") },
    { value: 'ccc', icon: $r("app.media.app_icon") },
    { value: 'ddd', symbolIcon: this.symbolModifier }
  ]

  // 右侧的菜单项集合
  menuItems:Array<MenuItem> = [
    {
      value:$r('app.media.app_icon'),
      isEnabled:true,
      action:() => { }
    },
    {
      value:$r('app.media.app_icon'),
      isEnabled:true,
      action:() => { }
    },
    {
      value:$r('app.media.app_icon'),
      isEnabled:true,
      action:() => { }
    },
    {
      value:$r('app.media.app_icon'),
      isEnabled:true,
      action:() => { }
    },
  ]

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * SelectTitleBar - 带下拉标题栏
       *   subtitle - 子标题
       *   options - 左侧下拉菜单的选项集合（SelectOption 对象集合）
       *     value - 选项文本
       *     icon - 选项图标
       *     symbolIcon - 选项图标（如果同时设置了 icon 和 symbolIcon，则以 symbolIcon 为准）
       *       关于 SymbolGlyph 请参见 /component/text/SymbolGlyphDemo.ets 中的说明
       *   selected - 左侧下拉菜单的当前选中项的索引位置
       *   onSelected - 左侧下拉菜单的选项被选中后的回调
       *   menuItems - 右侧的菜单项集合（一个 SelectTitleBarMenuItem 对象数组），最多显示 3 项，超过的会放到右侧的“更多”里
       *     value - 图标
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       *   hidesBackButton - 是否隐藏左侧的返回按钮
       *   badgeValue - 下拉菜单右侧的数字标记（超过 99 则显示 99+）
       */
      SelectTitleBar({
        subtitle: "subtitle",
        options: this.options,
        selected: 1,
        onSelected: (index: number) => { },
        menuItems: this.menuItems,
        hidesBackButton: false
      })

      SelectTitleBar({
        options: this.options,
        selected: 0,
        hidesBackButton: true,
        badgeValue: 99,
      })
    }
  }
}