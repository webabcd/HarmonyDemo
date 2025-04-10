/*
 * 动态卡片
 *
 * 静态卡片仅支持 UI 组件布局
 * 动态卡片除了支持 UI 组件布局外，还支持组件的通用事件方法以及自定义动画效果，可以用于需要交互的场景
 *
 *
 * 1、需要在 src/main/module.json5 中添加卡片类型的 extension ability
 * 2、卡片的相关配置，在 src/main/resources/profile/form_config.json
 * 3、卡片对应的 extension ability 的代码详见 /entryformability/EntryFormAbility.ets
 * 4、卡片的具体实现详见 /widget/pages/DynamicWidgetCard.ets
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct DynamicWidgetDemo {

  @State message: string = "动态卡片，具体实现请参见：\n" +
    "src/main/module.json5\n" +
    "src/main/resources/profile/form_config.json\n" +
    "/entryformability/EntryFormAbility.ets\n" +
    "/widget/pages/DynamicWidgetCard.ets"

  build() {
    Column({space:10}) {
      TitleBar()
      Text(this.message)
    }
  }
}
