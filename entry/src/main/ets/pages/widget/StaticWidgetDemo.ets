/*
 * 静态卡片
 *
 * 静态卡片仅支持 UI 组件布局
 * 动态卡片除了支持 UI 组件布局外，还支持组件的通用事件方法以及自定义动画效果，可以用于需要交互的场景
 *
 *
 * 1、需要在 src/main/module.json5 中添加卡片类型的 extension ability，类似如下
 * {
 *   "module": {
 *     "extensionAbilities": [
 *       {
 *         "name": "com.webabcd.harmonydemo.EntryFormAbility", // 自定义标识
 *         "srcEntry": "./ets/entryformability/EntryFormAbility.ets", // 卡片对应的 extension ability 的代码地址
 *         "label": "$string:EntryAbility_label",
 *         "description": "$string:EntryAbility_desc",
 *         "type": "form", // 当前的 ExtensionAbility 的类型为卡片
 *         "metadata": [
 *           {
 *             "name": "ohos.extension.form", // 卡片的 metadata 的 name 必须是 ohos.extension.form
 *             "resource": "$profile:form_config" // 卡片的相关配置，详见 src/main/resources/profile/form_config.json 中的配置
 *           }
 *         ]
 *       }
 *     ],
 *   }
 * }
 *
 * 2、卡片的相关配置，在 src/main/resources/profile/form_config.json 文件中，说明如下
 * "forms": [
 *   {
 *     "name": "static widget", // 卡片的自定义标识
 *     "displayName": "$string:staticWidget_display_name", // 添加卡片时，在卡片的预览中显示的名称
 *     "description": "$string:staticWidget_desc", // 添加卡片时，在卡片的预览中显示的描述
 *     "src": "./ets/widget/pages/StaticWidgetCard.ets", // 卡片的具体实现的代码地址
 *     "uiSyntax": "arkts", // 通过 ArkTS 实现卡片
 *     "window": {
 *       "designWidth": 720, // 设计的基准宽度，与 lpx 相关，缺省值为 720
 *       "autoDesignWidth": true // 是否根据屏幕的像素密度自动计算 designWidth 的值，此值配置为 true 时则会忽略 designWidth 配置的值，缺省值为 false
 *     },
 *     "colorMode": "auto", // 卡片的深色浅色模式（auto, dark, light）
 *     "isDynamic": false, // 是否是动态卡片
 *     "isDefault": true, // 是否是默认卡片，每一个卡片类型的 extension ability 只能有一个默认卡片
 *     "updateEnabled": true, // 是否允许刷新
 *     "scheduledUpdateTime": "10:30", // 定点刷新（仅 updateDuration 配置为 0 时 scheduledUpdateTime 才会生效）
 *     "updateDuration": 1, // 周期刷新（单位为 30 分钟，比如配置为 2 则为每 60 分钟刷新一次，配置为 0 则禁用 updateDuration 刷新）
 *     "supportDimensions": [ // 卡片支持的外观规格（1*2, 2*2, 2*4, 4*4, 6*4）
 *       "2*2",
 *       "4*4"
 *     ],
 *     "defaultDimension": "2*2" // 卡片默认的外观规格
 *   }
 * ]
 *
 * 3、卡片对应的 extension ability 的代码详见 /entryformability/EntryFormAbility.ets 中的说明
 *
 * 4、卡片的具体实现详见 /widget/pages/StaticWidgetCard.ets 中的说明
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct StaticWidgetDemo {

  @State message: string = "静态卡片，具体实现请参见：\n" +
    "src/main/module.json5\n" +
    "src/main/resources/profile/form_config.json\n" +
    "/entryformability/EntryFormAbility.ets\n" +
    "/widget/pages/StaticWidgetCard.ets"

  build() {
    Column({space:10}) {
      TitleBar()
      Text(this.message)
    }
  }
}
