/*
 * 程序架构
 */

import { TitleBar } from '../TitleBar';
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct StructureDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('xxx').align(Alignment.Top)
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
 * 每个 hap 都推荐采用一个 UIAbility 加多个页面的方式开发
 * 如果一个应用包含多个 hap 且都运行了，则他们都会显示在系统的最近应用列表中，即每个 hap 都是最近应用列表中的一个窗口
 * 右键单击项目，然后 New -> Module... 即可创建新的模块，一个项目包含的模块和模块的地址是在项目的 build-profile.json5 中配置的
 */
@Component
struct MySample1 {

  context = getContext() as common.UIAbilityContext;

  build() {
    Column({ space: 10 }) {

      Button("打开指定的 feature ability").onClick(() => {
        let want: Want = {
          deviceId: '', // 空代表本设备
          bundleName: 'com.webabcd.harmonydemo', // 需要打开的 feature ability 的 bundle 的名称
          moduleName: 'feature1', // 需要打开的 feature ability 的 module 的名称
          abilityName: 'com.webabcd.harmonydemo.Feature1Ability' // 需要打开的 feature ability 的 ability 的名称
        };
        this.context.startAbility(want);
      })
    }
  }
}
