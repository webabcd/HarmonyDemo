/*
 * HAP（Harmony Ability Package） - 应用安装和运行的基本单元
 *
 * AbilityStage 是 HAP 的容器，当需要加载 HAP 的入口 UIAbility 实例时，会先创建 AbilityStage 实例
 * 每个 HAP 都会对应一个 AbilityStage，需要在 module.json5 中的 module 的 srcEntry 中配置对应的 AbilityStage 的代码的地址
 * 当前 HAP 对应的 AbilityStage 请参见 /entry/src/main/ets/MyAbilityStage.ets 中的代码
 */

import { TitleBar } from '../TitleBar';
import { common, Want } from '@kit.AbilityKit';
import { Helper } from '../../utils/Helper';

@Entry
@Component
struct HapDemo {

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

/*
 * HAP（Harmony Ability Package）是应用安装和运行的基本单元，其有两种类型，分别为 entry 模块和 feature 模块
 *   entry - 主模块，作为应用的入口，基础功能都应该放在这里，每个应用只能有一个 entry 模块
 *   feature - 特性模块，应用的扩展能力可以放在这里，其可以根据用户的需求和设备类型进行选择性安装，每个应用可以包含多个 feature 模块
 * 每个 hap 可以包含多个 UIAbility，每个 UIAbility 可以包含多个页面
 * 每个 hap 可以包含多个 ExtensionAbility，比如 FormExtensionAbility, WorkSchedulerExtensionAbility 等
 * 右键单击全局项目，然后 New -> Module... -> Empty Ability 即可创建新的模块，一个项目包含的模块和模块的地址是在项目的 build-profile.json5 中配置的
 * 如需调试，则先选择需要运行的模块，然后点击运行即可（注：当 feature 更新后，需要先运行它，这样才能从 entry 跳转到更新后的 feature）
 * 如需编译打包，则在 Build 菜单中，可以编译每个 hap 包（编译后每个 hap 模块都会生成一个对应的 .hap 文件），也可以把所有 .hap 和 .hsp 打包为一个 app（编译后是一个 .app 文件，用于分发和上架）
 * 一个应用中的所有 .hap 和 .hsp 文件合在一起称为 bundle，在 AppScope 中的 app.json5 配置的 bundleName 为其唯一标识
 */
@Component
struct MySample1 {

  context = getContext() as common.UIAbilityContext;

  build() {
    Column({ space: 10 }) {

      // 打开的 feature ability 的代码请参见 /feature1/src/main/ets/feature1ability/Feature1Ability.ets 和 /feature1/src/main/ets/pages/Index.ets
      Button("打开指定的 feature ability").onClick(() => {
        // Want - 需要拉起的 ability 的相关信息
        let want: Want = {
          deviceId: '', // 空代表本设备
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 feature ability 的 bundle 的名称
          moduleName: 'feature1', // 需要打开的 feature ability 的 module 的名称
          abilityName: 'com.webabcd.harmonydemo.Feature1Ability', // 需要打开的 feature ability 的名称（此名称是在 module.json5 中配置的）
          parameters: { // 传参
            'k1': 'v1',
            'k2': `${Helper.getTimestampString()}`,
          }
        };
        // context.startAbility() - 拉起指定的 ability
        this.context.startAbility(want);
      })
    }
  }
}