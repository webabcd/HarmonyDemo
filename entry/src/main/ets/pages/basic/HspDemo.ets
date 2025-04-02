/*
 * HSP（Harmony Shared Package） - 动态共享包
 *   不支持独立发布
 *   支持 UIAbility 组件，但是不支持 ExtensionAbility 组件
 *   在运行时按需加载
 */

import { TitleBar } from '../TitleBar';
import { hello } from 'hsp1';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct HspDemo {

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
 * HSP（Harmony Shared Package）是动态共享包
 * 右键单击全局项目，然后 New -> Module... -> Shared Library 即可创建新 hsp 包
 * 在 hsp 项目中的 oh-package.json5 的 main 指定的文件中，配置需要导出的功能
 *
 * 源码方式引用本地的 hsp 模块时，如果需要在 entry 模块中引用，则在 entry/oh-package.json5 中做类似如下的配置
 * {
 *   "dependencies": {
 *     "hsp1": "../hsp1"
 *   }
 * }
 * 然后执行 ohpm install 后即可
 * 导入的方法类似如下 import { hello } from 'hsp1'
 */
@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Button("调用 hsp 中的接口").onClick(() => {
        this.message = hello("webabcd") // 参见 hsp1/src/main/ets/utils/Helper.ets
      })

      Button("通过命名路由跳转到 hsp 包的指定的页面").onClick(() => {
        router.pushNamedRoute({
          name: 'routeName1', // 命名路由的名称，参见 hsp1/src/main/ets/components/MyPage.ets
          params: { // 传参
            param1: "value1",
          }
        })
      })

      // 通过地址跳转到 hsp 包的指定的页面，具体的地址格式请参见下面的示例
      // 注：用这种方式导航的话，不要求目标页必须是 export 的
      Button("通过地址跳转到 hsp 包的指定的页面").onClick(() => {
        router.pushUrl({
          // 这里的 com.webabcd.harmonydemo 是 bundle 名称
          url: '@bundle:com.webabcd.harmonydemo/hsp1/ets/pages/Index', // 参见 hsp1/src/main/ets/pages/Index.ets
          params: { // 传参
            param1: "value1",
          }
        })
      })
    }
  }
}
