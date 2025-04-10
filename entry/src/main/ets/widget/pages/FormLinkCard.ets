/*
 * FormLink - 为静态卡片提供与应用交互的能力
 */

import { Helper } from '../../utils/Helper'

@Entry
@Component
struct FormLinkCard {

  @LocalStorageProp('content') content: string = ''

  /*
   * FormLink - 为静态卡片提供与应用交互的能力
   *   bundleName - bundle 的名称
   *   moduleName - module 的名称
   *   abilityName - ability 的名称
   *   uri - deep linking 或 app linking 地址
   *   params - 需要传递的数据
   *   action - 交互方式
   *     router - 拉起目标应用
   *       在目标应用的 onCreate() 或 onNewWant() 中通过 Want 获取卡片传递给应用的数据
   *       在目标应用中通过 formProvider.updateForm() 将数据传递给卡片
   *     message - 触发 FormExtensionAbility 的 onFormEvent 回调
   *       在 FormExtensionAbility 的 onFormEvent 回调中通过 message 参数获取卡片传递过来的数据
   *       在 FormExtensionAbility 的 onFormEvent 回调中通过 formProvider.updateForm() 将数据传递给卡片
   *     call - 拉起目标应用，只能是冷启动的方式，且不会出现在最近任务列表中
   *       在目标应用的 onCreate() 中通过 Want 获取卡片传递给应用的数据
   *       如果目标应用已经启动了，则可以通过 Caller/Callee 的方式将数据从卡片传递给应用
   *       在 params 中必须要传递名为 method 的参数，其用于作为 Caller/Callee 之间约定的消息通知字符串
   *       在目标应用中通过 this.callee.on() 监听指定的消息通知字符串，如果监听到，则可以获取卡片传递给目标应用的数据
   *       在目标应用中通过 formProvider.updateForm() 将数据传递给卡片
   *       目标应用必须具有 ohos.permission.KEEP_BACKGROUND_RUNNING 权限（参见 module.json5 中的相关说明）
   */

  build() {
    Column() {
      // 通过 router 和 deep linking 的方式拉起指定的应用（目标应用为 /harmonydemo2 项目）
      // 关于 deep linking 和 app linking 请参见 /ipc/DeepLinkingDemo.ets 和 /ipc/AppLinkingDemo.ets 中的说明
      FormLink({
        action: 'router',
        uri: "webabcd://a.b.c/api?p1=xyz",
        params: {
          'k1': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column().backgroundColor(Color.Red).width('100%').height('100%')
      }
      .width('100%').layoutWeight(1)

      // 通过 router 和 abilityName 的方式拉起指定的应用
      // params 中的数据可以在目标应用的 onCreate() 或 onNewWant() 中通过 Want 获取到，详见 /entryability/EntryAbility.ets 中的说明
      // 目标应用中通过 formProvider.updateForm() 将数据传递给卡片，详见 /entryability/EntryAbility.ets 中的说明
      FormLink({
        action: 'router',
        bundleName: 'com.webabcd.harmonydemo',
        moduleName: 'entry',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility',
        params: {
          'k1': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column().backgroundColor(Color.Green).width('100%').height('100%')
      }
      .width('100%').layoutWeight(1)

      // 通过 message 的方式触发 FormExtensionAbility 的 onFormEvent 回调
      // params 中的数据可以在 onFormEvent 回调中获取到，详见 /entryformability/EntryFormAbility.ets 中的说明
      // 在 onFormEvent 回调中通过 formProvider.updateForm() 将数据传递给卡片，详见 /entryformability/EntryFormAbility.ets 中的说明
      FormLink({
        action: 'message',
        params: {
          'k1': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column() {
          Text(this.content).fontColor(Color.White)
        }.backgroundColor(Color.Blue).width('100%').height('100%').justifyContent(FlexAlign.Center)
      }
      .width('100%').layoutWeight(1)

      // 通过 call 和 abilityName 的方式拉起指定的应用（params 中必须要包含名为 method 的参数）
      // 目标应用未启动时，则会拉起目标应用，但是目标应用不会出现在最近任务列表中，此时 params 中的数据可以在目标应用的 onCreate() 中通过 Want 获取到，详见 /entryability/EntryAbility.ets 中的说明
      // 目标应用已启动时，则通过 Caller/Callee 的方式将数据从卡片传递给应用（前提是目标应用注册了监听，详见 /entryability/EntryAbility.ets 中的说明）
      // 目标应用中通过 formProvider.updateForm() 将数据传递给卡片，详见 /entryability/EntryAbility.ets 中的说明
      // 目标应用必须具有 ohos.permission.KEEP_BACKGROUND_RUNNING 权限
      FormLink({
        action: 'call',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility',
        params: {
          'method': 'myMethod', // 如需 call 方式生效，则必须要有 method 参数，其会作为 Caller/Callee 之间约定的消息通知字符串
          'k1': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column().backgroundColor(Color.Orange).width('100%').height('100%')
      }
      .width('100%').layoutWeight(1)
    }
    .width('100%')
  }
}