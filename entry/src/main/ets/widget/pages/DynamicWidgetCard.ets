/*
 * 卡片的具体实现（本例演示的是动态卡片）
 *
 * 静态卡片仅支持 UI 组件布局
 * 动态卡片除了支持 UI 组件布局外，还支持组件的通用事件方法以及自定义动画效果，可以用于需要交互的场景
 *
 * 注：
 * 请先参见静态卡片 StaticWidgetCard.ets 中的相关说明，动态卡片在静态卡片的基础上增加了对组件的通用事件方法以及自定义动画效果的支持
 * 动态卡片通过 postCardAction 实现类似 FormLink 的功能，可以参考 FormLinkCard.ets 中的相关说明
 */

import { Helper } from '../../utils/Helper'

@Entry
@Component
struct DynamicWidgetCard {

  @LocalStorageProp('content') content: string = ''

  @State rotateAngle: number = 0

  build() {
    Column() {
      // 动态卡片在静态卡片的基础上增加了对组件的通用事件方法以及自定义动画效果的支持
      Button(`click me ${this.content}`)
        .onClick(() => {
          this.rotateAngle = this.rotateAngle === 0 ? 360 : 0

          /*
           * postCardAction() - 在动态卡片中实现类似静态卡片中的 FormLink 的功能，从而为动态卡片提供与应用交互的能力
           *   action - 交互方式，可以参考 FormLinkCard.ets 中的相关说明
           *   abilityName - 需要拉起的 ability 的名称（只能拉起当前应用下的 ability）
           *   uri - deep linking 或 app linking 地址
           *   params - 需要传递的数据
           *
           * 注：本例不详演示 postCardAction() 了，请参考 FormLinkCard.ets 中的相关说明
           */
          postCardAction(this, {
            action: 'message',
            // abilityName: 'com.webabcd.harmonydemo.EntryAbility',
            // uri: "webabcd://a.b.c/api?p1=xyz",
            params: {
              'k1': 'v1',
              'k2': `${Helper.getTimestampString()}`,
            }
          });
        })
        .rotate({ angle: this.rotateAngle })
        .animation({ playMode: PlayMode.Normal} )
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}