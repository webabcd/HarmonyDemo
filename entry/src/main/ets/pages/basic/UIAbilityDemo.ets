/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 * 一个应用可以包含一个或多个 UIAbility，每个 UIAbility 实例都会在最近任务列表中显示为一个对应的任务窗口
 * 一个 UIAbility 可以包含多个页面
 *
 * 关于 UIAbility 的相关配置，请参见 module.json5 配置文件中的 abilities 标签
 * 关于 UIAbility 的实现及其生命周期，请参见 /ets/entryability/EntryAbility.ets 中的相关说明
 *
 * 在单 UIAbility 内共享数据可以使用 LocalStorage，请参见 /state/LocalStorageDemo.ets 中的相关说明
 * 在多 UIAbility 中共享数据可以使用 AppStorage，请参见 /state/AppStorageDemo.ets 中的相关说明
 *
 * 打开新的 UIAbility 并接收返回结果，请参见本例和 UIAbilityDemo2.ets 中的相关说明
 * 在一个 UIAbility 内做事件的发布和订阅，请参见 UIAbilityDemo2.ets 中的相关说明
 */

import { TitleBar } from '../TitleBar';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct UIAbilityDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Button("杀死当前 UIAbility").onClick(() => {
        /*
         * getContext(this) - 获取上下文对象
         * UIAbilityContext - 上下文对象
         *   terminateSelf() - 杀死当前 UIAbility
         *
         * 注：
         * 当调用 terminateSelf() 杀死当前 UIAbility 后，在最近任务列表中仍会保留其快照
         * 如果不需要这个快照，则需要将 module.json5 中的 abilities 的 removeMissionAfterTerminate 设置为 true
         */
        let context = getContext(this) as common.UIAbilityContext;
        context.terminateSelf()
      })

      Button("打开当前 hap 包内的指定的 UIAbility").onClick(() => {
        let context = getContext(this) as common.UIAbilityContext;
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          deviceId: '', // 空代表本设备
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 ability 的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryAbility2', // 需要打开的 ability 的名称（此名称是在 module.json5 中配置的）
          parameters: { // 传参
            'k1': 'v1',
            'k2': 'v2',
          }
        };
        // context.startAbility() - 拉起指定的 ability
        context.startAbility(want).then(() => {
          this.message = `startAbility 成功`
        }).catch((err: BusinessError) => {
          this.message = `startAbility 失败, errCode:${err.code}, errMessage:${err.message}`
        });
      })

      Button("打开当前 hap 包内的指定的 UIAbility 并获取返回结果").onClick(() => {// UIAbilityContext
        let context = getContext(this) as common.UIAbilityContext;
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          deviceId: '', // 空代表本设备
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 ability 的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryAbility2', // 需要打开的 ability 的名称（此名称是在 module.json5 中配置的）
          parameters: { // 传参
            'k1': 'v1',
            'k2': 'v2',
          }
        };
        // context.startAbilityForResult() - 拉起指定的 ability 并获取返回结果
        context.startAbilityForResult(want).then((data:common.AbilityResult) => {
          /*
           * AbilityResult - 拉起的 ability 的返回结果
           *   resultCode - 返回的 code
           *   want.parameters - 返回的数据
           */
          this.message = `startAbility 成功 code:${data.resultCode}, k3:${data.want?.parameters?.k3}, k4:${data.want?.parameters?.k4}`
        }).catch((err: BusinessError) => {
          this.message = `startAbility 失败, errCode:${err.code}, errMessage:${err.message}`
        });
      })
    }
  }
}
