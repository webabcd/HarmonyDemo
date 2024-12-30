/*
 * EditableTitleBar - 编辑型标题栏
 */

import { EditableLeftIconType, EditableTitleBar, LengthMetrics, promptAction } from '@kit.ArkUI';
import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct EditableTitleBarDemo {

  build() {
    Column({space:10}) {

      /*
       * EditableTitleBar - 编辑型标题栏
       *   leftIconStyle - 左侧按钮的类型（EditableLeftIconType 枚举）
       *     Back - 返回按钮（点击后会自动返回上一页）
       *     Cancel - 取消按钮（点击后会触发 onCancel 回调）
       *   title - 标题
       *   subtitle - 子标题
       *   isSaveIconRequired - 是否显示右侧的保存按钮（点击后会触发 onSave 回调）
       *   imageItem - 左侧的菜单项（一个 EditableTitleBarItem 对象）
       *     value - 图标
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       *   menuItems - 右侧的菜单项集合（一个 EditableTitleBarMenuItem 对象数组），最多显示 2 项
       *     value - 图标
       *     isEnabled - 是否可用
       *     action - 点击后的回调
       *   contentMargin - 标题栏的内容的外边距
       *     start, end, top, bottom
       *   onCancel - 点击左侧的取消按钮后的回调
       *   onSave - 点击右侧的保存按钮后的回调
       *   options - 选项（EditableTitleBarOptions 枚举）
       *     backgroundColor, backgroundBlurStyle - 背景颜色，背景的模糊效果
       *     safeAreaTypes, safeAreaEdges - 安全区域相关（参见 /ui/SafeAreaDemo.ets 中的说明）
       */
      EditableTitleBar({
        leftIconStyle: EditableLeftIconType.Cancel,
        title: 'title',
        subtitle: 'subtitle',
        isSaveIconRequired: true,
        imageItem: {
          value: $r('app.media.app_icon'),
          isEnabled: true,
          action: () => { }
        },
        menuItems: [
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
        ],
        contentMargin: {
          start: LengthMetrics.vp(24),
          end: LengthMetrics.vp(24),
          top: LengthMetrics.vp(0),
          bottom: LengthMetrics.vp(0),
        },
        onCancel: () => { },
        onSave: () => { },
        options: {
          backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
          backgroundColor: Color.Orange,
          // 沉浸式效果（immersive）
          safeAreaTypes: [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD],
          safeAreaEdges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END]
        },
      })

      EditableTitleBar({
        leftIconStyle: EditableLeftIconType.Back,
        title: 'title',
      })

      TitleBar()
    }
  }
}