/*
 * ToolBar - 工具栏（最多显示 5 个选项，超过的会放到“更多”选项里）
 */

import { ToolBar, ToolBarOptions, ItemState } from '@kit.ArkUI'
import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct ToolBarDemo {

  @State toolBarList: ToolBarOptions = new ToolBarOptions()
  @State message: string = ''

  aboutToAppear() {
    this.toolBarList.push({
      content: '删除',
      icon: $r('sys.media.ohos_ic_public_remove'),
      state: ItemState.ENABLE,
      action: () => {
        this.message = '删除 clicked'
      },
    })
    this.toolBarList.push({
      content: '拷贝',
      icon: $r('sys.media.ohos_ic_public_copy'),
      state: ItemState.DISABLE,
      action: () => {
        this.message = '拷贝 clicked'
      },
    })
    this.toolBarList.push({
      content: '粘贴',
      icon: $r('sys.media.ohos_ic_public_paste'),
      state: ItemState.ACTIVATE,
      action: () => {
        this.message = '粘贴 clicked'
      },
    })
    this.toolBarList.push({
      content: '全选',
      icon: $r('sys.media.ohos_ic_public_select_all'),
      state: ItemState.ACTIVATE,
      action: () => {
        this.message = '全选 clicked'
      },
    })
    this.toolBarList.push({
      content: '分享',
      icon: $r('sys.media.ohos_ic_public_share'),
      action: () => {
        this.message = '分享 clicked'
      },
    })
    this.toolBarList.push({
      content: '播放',
      icon: $r('sys.media.ohos_ic_public_play'),
      action: () => {
        this.message = '播放 clicked'
      },
    })
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      /*
       * ToolBar - 工具栏（最多显示 5 个选项，超过的会放到“更多”选项里）
       *   activateIndex - 激活状态的选项的索引位置
       *     此位置的选项的 state 如果是 ItemState.ACTIVATE 的话就会高亮显示
       *   toolBarList - 选项列表（一个 ToolBarOption 对象集合）
       *     content - 选项文本
       *     icon - 选项图标
       *     action - 选项点击后的回调
       *     state - 选项的类型（ItemState 枚举）
       *       ENABLE - 可点击
       *       DISABLE - 不可点击
       *       ACTIVATE - 可点击，且点击后会高亮显示
       */
      ToolBar({
        activateIndex: 2,
        toolBarList: this.toolBarList,
      })
    }
  }
}