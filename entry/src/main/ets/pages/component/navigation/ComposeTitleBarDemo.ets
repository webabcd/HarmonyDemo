/*
 * ComposeTitleBar - 主标题栏
 * 自带返回按钮，支持标题、子标题、左侧一个图标按钮和右侧多个图标按钮
 */

import { ComposeTitleBar } from '@kit.ArkUI';
import { TitleBar } from '../../TitleBar';

// 对应 ComposeTitleBarMenuItem
interface MenuItem {
  value: Resource;
  isEnabled?: boolean;
  action?: () => void
}

@Entry
@Component
struct ComposeTitleBarDemo {

  // 右侧的菜单项集合
  menuItems: Array<MenuItem> = [
    {
      value: $r('app.media.app_icon'),
      isEnabled: true,
      action: () => { }
    },
    {
      value: $r('app.media.app_icon'),
      isEnabled: true,
      action: () => { }
    },
    {
      value: $r('app.media.app_icon'),
      isEnabled: true,
      action: () => { }
    },
    {
      value: $r('app.media.app_icon'),
      isEnabled: true,
      action: () => { }
    },
  ]

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * ComposeTitleBar - 主标题栏
       *   title - 标题
       *   subtitle - 子标题
       *   menuItems - 右侧的菜单项集合（一个 ComposeTitleBarMenuItem 对象数组），最多显示 3 项，超过的会放到右侧的“更多”里
       *     value - 图标
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       *   item - 左侧的菜单项（一个 ComposeTitleBarMenuItem 对象）
       *     value - 图标
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       */
      ComposeTitleBar({
        title: "title",
        subtitle: "subtitle",
        menuItems: this.menuItems,
      })

      ComposeTitleBar({
        title: "title",
        subtitle: "subtitle",
        menuItems: this.menuItems,
        item: {
          value: $r('app.media.app_icon'),
          isEnabled: true,
          action: () => { }
        }
      })
    }
  }
}