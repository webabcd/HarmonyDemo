/*
 * AddFormMenuItem - 在应用内添加卡片
 *   AddFormMenuItem 作为 Menu 的子组件，可以实现在应用内添加卡片
 *
 * 注：关于卡片的基础请参见 StaticWidgetDemo.ets 和 DynamicWidgetDemo.ets
 */

import { AddFormMenuItem } from '@kit.ArkUI';
import { formBindingData } from '@kit.FormKit';
import { Helper } from '../../utils/Helper';
import { TitleBar } from '../TitleBar';

@Entry
@Component
struct AddFormMenuItemDemo {

  @State message: string = '';
  private componentId: string = 'componentId_123';

  /*
   * AddFormMenuItem - 作为 Menu 的子组件，可以实现在应用内添加卡片（关于 Menu 请参见 /component/flyout/MenuDemo.ets 中的相关说明）
   *   want - 卡片的 Want 信息
   *   componentId - 触发了添加卡片行为的组件的 id，以便系统根据该组件的位置做一些添加卡片的动画效果
   *   options - 选项（一个 AddFormOptions 对象）
   *     formBindingData - 需要传递给卡片的数据
   *     callback - 添加卡片完成后的回调
   *       error - 异常信息，如果 error.code 为 0 则代表添加卡片成功
   *       formId - 添加的卡片的 id
   *     style - 菜单样式
   *       options - 一个 MenuItemOptions 对象（请参见 /component/flyout/MenuDemo.ets 中的相关说明）
   */
  @Builder myMenu() {
    Menu() {
      AddFormMenuItem(
        {
          bundleName: 'com.webabcd.harmonydemo', // 需要添加的卡片的所属的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryFormAbility', // 需要添加的卡片的所属的 extension ability 的名称
          parameters: {
            'ohos.extra.param.key.module_name': 'entry', // 需要添加的卡片的所属的 module 的名称
            'ohos.extra.param.key.form_name': 'static widget', // 需要添加的卡片的名称（本例是在 src/main/resources/profile/form_config.json 中配置的）
            'ohos.extra.param.key.form_dimension': 2, // 需要添加的卡片的规格（本例是在 src/main/resources/profile/form_config.json 中配置的）
            // 注：卡片的规格（1代表1*2, 2代表2*2, 3代表2*4, 4代表4*4, 7代表6*4）
          },
        },
        this.componentId,
        {
          formBindingData: formBindingData.createFormBindingData({
            'content': Helper.getTimestampString() // 卡片中可以通过 @LocalStorageProp('content') 引用此值
          }),
          callback: (error, formId) => {
            this.message = `添加卡片完成 error:${JSON.stringify(error)}, formId:${formId}`
          },
          style: {
             options: {
               startIcon: $r("app.media.ic_settings"),
               content: "添加卡片 1",
             }
          }
        }
      )

      AddFormMenuItem(
        {
          bundleName: 'com.webabcd.harmonydemo',
          abilityName: 'com.webabcd.harmonydemo.EntryFormAbility',
          parameters: {
            'ohos.extra.param.key.form_dimension': 4,
            'ohos.extra.param.key.form_name': 'static widget',
            'ohos.extra.param.key.module_name': 'entry'
          },
        },
        this.componentId,
        {
          formBindingData: formBindingData.createFormBindingData({
            'content': Helper.getTimestampString()
          }),
          callback: (error, formId) => {
            this.message = `添加卡片完成 error:${JSON.stringify(error)}, formId:${formId}`
          },
          style: {
            options: {
              startIcon: $r("app.media.ic_settings"),
              content: "添加卡片 2",
            }
          }
        }
      )
    }
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Text('长按我').backgroundColor(Color.Orange).fontColor(Color.White).textAlign(TextAlign.Center).width(200).height(100)
        .id(this.componentId)
        .bindContextMenu(this.myMenu, ResponseType.LongPress, {
          placement: Placement.BottomLeft
        })
    }
  }
}