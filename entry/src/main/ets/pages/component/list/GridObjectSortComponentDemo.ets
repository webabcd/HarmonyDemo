/*
 * GridObjectSortComponent - 图标网格，支持增加、删除和排序
 *
 * 多个图文图标（也可以只有文字）的网格，有已添加区域和未添加区域，支持编辑模式和非编辑模式的切换
 * 在编辑模式下支持图标从未添加区域到已添加区域，以及图标从已添加区域到未添加区域，以及图标排序
 */

import { TitleBar } from '../../TitleBar'
import { GridObjectSortComponent, GridObjectSortComponentItem, GridObjectSortComponentOptions,
  GridObjectSortComponentType } from '@kit.ArkUI'

@Entry
@Component
struct GridObjectSortComponentDemo {

  /*
   * 用于 GridObjectSortComponent 的 options 参数
   *   type - 图标类型（GridObjectSortComponentType 枚举）
   *     IMAGE_TEXT - 图标和文本
   *     TEXT - 仅文本
   *   imageSize - 图标尺寸
   *   normalTitle - 非编辑模式时的标题
   *   editTitle - 编辑模式时的标题
   *   showAreaTitle - 已添加区域的标题
   *   addAreaTitle - 未添加区域的标题
   */
  @State options: GridObjectSortComponentOptions = {
    type: GridObjectSortComponentType.TEXT,
    imageSize: 48,
    normalTitle: 'normalTitle',
    editTitle: 'editTitle',
    showAreaTitle: 'showAreaTitle',
    addAreaTitle: 'addAreaTitle'
  }

  /*
   * 用于 GridObjectSortComponent 的 dataList 参数
   *   id - 标识
   *   url - 图标
   *   text - 文本
   *   selected - 是否被添加到已添加区域
   *   order - 排序
   */
  @State dataList: GridObjectSortComponentItem[] = [
    {
      id: 0,
      url: $r('app.media.app_icon'),
      text: 'item1',
      selected: true,
      order: 3
    },
    {
      id: 1,
      url: $r('app.media.app_icon'),
      text: 'item2',
      selected: true,
      order: 2
    },
    {
      id: 2,
      url: $r('app.media.app_icon'),
      text: 'item3',
      selected: true,
      order: 1
    },
    {
      id: 3,
      url: $r('app.media.app_icon'),
      text: 'item4',
      selected: true,
      order: 4
    },
    {
      id: 4,
      url: $r('app.media.app_icon'),
      text: 'item5',
      selected: false,
      order: 9
    },
    {
      id: 5,
      url: $r('app.media.app_icon'),
      text: 'item6',
      selected: true,
      order: 6
    },
    {
      id: 6,
      url: $r('app.media.app_icon'),
      text: 'item7',
      selected: true,
      order: 7
    },
    {
      id: 7,
      url: $r('app.media.app_icon'),
      text: 'item8',
      selected: true,
      order: 9
    },
    {
      id: 8,
      url: $r('app.media.app_icon'),
      text: 'item9',
      selected: false,
      order: 4
    },
  ]

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      /*
       * GridObjectSortComponent - 图标网格，支持增加、删除和排序
       *   options - 选项（一个 GridObjectSortComponentOptions 对象，详见上面的说明）
       *   dataList - 数据（一个 GridObjectSortComponentItem 对象的数组，详见上面的说明）
       *   onSave() - 编辑模式下，点击对钩时的回调
       *     select - 已添加区域的 item 的数组
       *     unselect - 未添加区域的 item 的数组
       *   onCancel() - 编辑模式下，点击叉子时的回调
       */
      GridObjectSortComponent({
        options: this.options,
        dataList: this.dataList,
        onSave: (select: Array<GridObjectSortComponentItem>, unselect: Array<GridObjectSortComponentItem>) => {
          this.message = `onSave select:${select.map(p => p.id).join(',')}, unselect:${unselect.map(p => p.id).join(',')}`
        },
        onCancel: () =>{
          this.message = "onCancel"
        }
      })
    }
  }
}