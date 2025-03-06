/*
 * UIAbility 的启动类型 - 共有 3 种（singleton, multiton 或 standard, specified）
 * 需要在 module.json5 配置文件中，通过 abilities 的 launchType 标签指定 UIAbility 的启动类型
 *
 * singleton - 单实例方式，每次打开时如果发现已存在则复用之，即最近任务列表中只会有一个这种类型的实例
 * multiton 或 standard - 多实例方式，每次打开都创建一个新的实例，即最近任务列表中可能会有多个这种类型的实例
 * specified - 指定实例模式，每次打开时，如果发现指定 specified 标识的 UIAbility 已存在则复用之，否则就新建实例
 *   在 module 对应的 AbilityStage 中的 onAcceptWant() 中返回 specified 标识
 *   关于 module 对应的 AbilityStage 请参见 /entry/src/main/ets/entryability/MyAbilityStage.ets 中的代码
 */

import { TitleBar } from '../TitleBar';
import { common, Want } from '@kit.AbilityKit';

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

  context = getContext(this) as common.UIAbilityContext;
  @State message: string = ""

  aboutToAppear(): void {
    this.message = `${LocalStorage.getShared().get("param")}`
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Button("以 singleton 的方式启动一个 UIAbility").onClick(async () => {
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 ability 的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryAbility_singleton', // 需要打开的 ability 的名称（此名称是在 module.json5 中配置的）
        };
        // context.startAbility() - 拉起指定的 ability
        await this.context.startAbility(want)
      })

      Button("以 multiton 的方式启动一个 UIAbility").onClick(async () => {
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 ability 的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryAbility_multiton', // 需要打开的 ability 的名称（此名称是在 module.json5 中配置的）
        };
        // context.startAbility() - 拉起指定的 ability
        await this.context.startAbility(want)
      })

      Button("以 specified 的方式（标识为 abc）启动一个 UIAbility").onClick(async () => {
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 ability 的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryAbility_specified', // 需要打开的 ability 的名称（此名称是在 module.json5 中配置的）
          parameters: {
            specifiedKey: "abc" // 传参，用于在 module 对应的 AbilityStage 中的 onAcceptWant() 中确定如何返回 specified 标识
          }
        };
        // context.startAbility() - 拉起指定的 ability
        await this.context.startAbility(want)
      })

      Button("以 specified 的方式（标识为 xyz）启动一个 UIAbility").onClick(async () => {
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 ability 的 bundle 的名称
          abilityName: 'com.webabcd.harmonydemo.EntryAbility_specified', // 需要打开的 ability 的名称（此名称是在 module.json5 中配置的）
          parameters: {
            specifiedKey: "xyz" // 传参，用于在 module 对应的 AbilityStage 中的 onAcceptWant() 中确定如何返回 specified 标识
          }
        };
        // context.startAbility() - 拉起指定的 ability
        await this.context.startAbility(want)
      })
    }
  }
}
