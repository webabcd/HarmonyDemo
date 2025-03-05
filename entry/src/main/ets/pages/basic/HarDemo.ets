/*
 * HAR（Harmony Archive）
 *   支持独立发布（比如要发布你自己实现的第三方库时，就可以将其封装为一个 har 包）
 *   支持 UIAbility 组件，但是不支持 ExtensionAbility 组件
 *   不支持在 main_pages.json 中声明页面，也就是说无法通过页面地址跳转到 har 包内的页面，但是可以通过命名路由的方式跳转到 har 包内的页面
 *   在编译时与应用程序链接，代码直接嵌入到应用二进制文件中
 */

import { TitleBar } from '../TitleBar';
import { MainPage as har1_MainPage, hello as har1_hello } from 'har1' // 源码方式引用本地的 har 模块的示例
import { MainPage as har2_MainPage, hello as har2_hello } from 'har2' // 文件方式引用指定的 har 文件时示例
import { DialogHelper } from '@pura/harmony-dialog' // 引用第三方 har 包的示例
import { router } from '@kit.ArkUI';

@Entry
@Component
struct HarDemo {

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
 * HAR（Harmony Archive）是静态共享包
 * 右键单击全局项目，然后 New -> Module... -> Static Library 即可创建新 har 包
 * 在 har 项目中的 oh-package.json5 的 main 指定的文件中，配置需要导出的功能
 * 如需编译打包，则选中 har 模块，然后在 Build 菜单中编译即可，编译后是 .har 文件
 *
 * 源码方式引用本地的 har 模块时，如果需要在 entry 模块中引用，则在 entry/oh-package.json5 中做类似如下的配置
 * {
 *   "dependencies": {
 *     "har1": "../har1"
 *   }
 * }
 * 然后执行 ohpm install 后即可
 * 导入的方法类似如下 import { MainPage as har1_MainPage } from 'har1'
 *
 * 文件方式引用指定的 har 文件时，如果需要在 entry 模块中引用，则在 entry/oh-package.json5 中做类似如下的配置
 * {
 *   "dependencies": {
 *     "har2": "../library/har2.har"
 *   }
 * }
 * 然后执行 ohpm install 后即可（如果文件更新了则需要再执行 ohpm install）
 * 导入的方法类似如下 import { MainPage as har2_MainPage } from 'har2'
 *
 * 引用第三方 har 包时，先在 https://ohpm.openharmony.cn/ 中找到需要的第三方包
 * 如果需要在全局项目中引用，则在全局目录下执行类似如下的命令即可 ohpm i @pura/harmony-dialog
 * 然后会发现，在全局项目中的 oh-package.json5 中多了类似如下的配置
 * {
 *   "dependencies": {
 *     "@pura/harmony-dialog": "^1.1.3"
 *   }
 * }
 */
@Component
struct MySample1 {

  @State message: string = ""

  aboutToAppear(): void {
    // 调用 har 包中的接口
    this.message += `${har1_hello("webabcd")}\n` // 参见 har1/src/main/ets/utils/Helper.ets
    this.message += `${har2_hello("webabcd")}\n` // 参见 har2/src/main/ets/utils/Helper.ets
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      // 显示 har 包中的页面
      har1_MainPage({param1: "value1"}).height(120) // 参见 har1/src/main/ets/components/MainPage.ets
      har2_MainPage({param1: "value1"}).height(120) // 参见 har2/src/main/ets/components/MainPage.ets

      // 跳转到 har 包中的指定的页面
      Button("通过命名路由跳转到 har 包的指定的页面").onClick(() => {
        router.pushNamedRoute({
          name: 'routeName1', // 命名路由的名称，参见 har1/src/main/ets/components/MyPage.ets
          params: { // 传参
            param1: "value1",
          }
        })
      })
      Button("通过命名路由跳转到 har 包的指定的页面").onClick(() => {
        router.pushNamedRoute({
          name: 'routeName2', // 命名路由的名称，参见 har2/src/main/ets/components/MyPage.ets
          params: { // 传参
            param1: "value1",
          }
        })
      })

      Button("第三方库测试").onClick(() => {
        DialogHelper.showToast('第三方库测试');
      })
    }
  }
}
