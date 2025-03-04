/*
 * HSP（Harmony Shared Package）
 *   不支持独立发布
 *   不支持 UIAbility 组件，也不支持 ExtensionAbility 组件
 *   在运行时按需加载
 */

import { TitleBar } from '../TitleBar';
import { hello as hsp1_hello } from 'hsp1';
import { hello as hsp2_hello } from 'hsp2';
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
 *
 * {
 *   "buildOption": {
 *     "arkOptions": {
 *       "integratedHsp": true
 *     }
 *   }
 * }
 *
 * 点击右上方的运行工具栏的左侧的圆形的名为 Product 的按钮，然后将 Build Mode 设置为 release（参见本目录的 ide-release-setting.png 文件）
 * 选中 hsp 模块，然后在 Build 菜单中编译即可，编译后是 .tgz 文件
 */
@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Button("调用 hsp 中的接口").onClick(() => {
        this.message = hsp1_hello("webabcd")
      })

      Button("调用 hsp 中的接口").onClick(() => {
        this.message = hsp2_hello("webabcd")
      })

      Button("").onClick(() => {
        router.pushUrl({
          url: '@bundle:com.webabcd.harmonydemo/hsp1/ets/pages/Index'
        })
      })

      Button("").onClick(() => {
        router.pushUrl({
          url: '@bundle:com.webabcd.harmonydemo/hsp2/ets/pages/Index'
        })
      })

      Button("通过命名路由跳转到 har 包的指定的页面").onClick(() => {
        this.getUIContext().getRouter().pushNamedRoute({
          name: 'myRouteName1',
          params: {

          }
        })
      })

      Button("通过命名路由跳转到 har 包的指定的页面").onClick(() => {
        this.getUIContext().getRouter().pushNamedRoute({
          name: 'myRouteName2',
          params: {

          }
        })
      })
    }
  }
}
