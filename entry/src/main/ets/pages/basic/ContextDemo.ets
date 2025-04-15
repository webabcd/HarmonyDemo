/*
 * Context - 上下文
 *   applicationInfo - 获取当前的 app 信息
 *   resourceManager - 资源管理对象，参见 /resource/ResourceDemo.ets 中的相关说明
 *   eventHub - 用于在当前 UIAbility 内做事件的发布和订阅，参见 /basic/UIAbilityDemo2.ets 和 /entryability/EntryAbility2.ets 中的相关说明
 *   可以获取相关的沙箱目录，参见 /storage/AppFileDemo.ets 中的相关说明
 *
 * AbilityStageContext - AbilityStage 的上下文，继承自 Context
 *   在 AbilityStage 内，可以通过 this.context 获取 AbilityStageContext 对象，请参见 /entry/src/main/ets/MyAbilityStage.ets 中的相关说明
 *
 * UIAbilityContext - UIAbility 的上下文，继承自 Context
 *   可以打开一个新的 ability，杀死当前 ability，将当前 ability 移入后台等，请参见 /basic/UIAbilityDemo.ets, /ipc/DeepLinkingDemo.ets, /ipc/WantDemo.ets 中的相关说明
 *   currentHapModuleInfo - 当前 hap 的信息
 *   abilityInfo - 当前 ability 的信息
 *   config - 当前的环境配置信息
 *   windowStage - 当前的窗口管理器，请参见 /ui/DisplayWindowDemo.ets 中的相关说明
 *
 * ExtensionContext - ExtensionAbility 的上下文，继承自 Context
 *   以 FormExtensionContext 为例，在 FormExtensionAbility 内，可以通过 this.context 获取 FormExtensionContext 对象，请参见 /entryformability/EntryFormAbility.ets 中的相关说明
 *
 * ApplicationContext - 应用级别的上下文，继承自 Context
 *   可以监听应用的声明周期，监听环境信息的变化
 *   可以杀死全部 UIAbility，可以重启指定的 UIAbility
 *   可以设置当前的深色浅色模式，可以设置当前的语言
 *
 * UIContext - UI 相关的上下文
 */

import { MyLog, TitleBar } from '../TitleBar';
import UIAbility from '@ohos.app.ability.UIAbility';
import { componentUtils, window } from '@kit.ArkUI';
import EnvironmentCallback from '@ohos.app.ability.EnvironmentCallback';
import { AbilityConstant, Configuration, common } from '@kit.AbilityKit';
import AbilityLifecycleCallback from '@ohos.app.ability.AbilityLifecycleCallback';
import Want from '@ohos.app.ability.Want';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';

@Entry
@Component
struct ContextDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('Context').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('AbilityStageContext').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('UIAbilityContext').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('ExtensionContext').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('ApplicationContext').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('UIContext').align(Alignment.Top)
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

  aboutToAppear(): void {
    /*
     * 在页面内，可以通过 getContext(this) 获取 Context 对象
     */
    let context = getContext(this)
    this.message = `app name: ${context.applicationInfo.name}\n`
    this.message += `app codePath: ${context.applicationInfo.codePath}\n`
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = "UIAbilityContext 是 UIAbility 的上下文，在 AbilityStage 内，可以通过 this.context 获取 AbilityStageContext 对象，请参见 /entry/src/main/ets/MyAbilityStage.ets 中的相关说明"

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  /*
   * 在 UIAbility 内，可以通过 this.context 获取 UIAbilityContext 对象
   * 在页面内，可以通过 getContext(this) as common.UIAbilityContext 获取 UIAbilityContext 对象
   */
  context = getContext(this) as common.UIAbilityContext
  @State message: string = ""

  aboutToAppear(): void {
    // 通过 currentHapModuleInfo 获取当前 hap 的信息
    let currentHapModuleInfo = this.context.currentHapModuleInfo
    this.message = `hap name: ${currentHapModuleInfo.name}\n`

    // 通过 abilityInfo 获取当前 ability 的信息
    let abilityInfo = this.context.abilityInfo
    this.message += `bundle name: ${abilityInfo.bundleName}\n` // 包名
    this.message += `module name: ${abilityInfo.moduleName}\n` // 模块名
    this.message += `ability name: ${abilityInfo.name}\n` // ability 名称
    this.message += `ability orientation: ${abilityInfo.orientation}\n` // 页面方向

    // 通过 config 获取当前的环境配置信息
    let config = this.context.config
    this.message += `language: ${config.language}\n` // 比如 zh-Hans-CN
    this.message += `direction: ${config.direction}\n` // DIRECTION_NOT_SET, DIRECTION_VERTICAL, DIRECTION_HORIZONTAL
    this.message += `colorMode: ${config.colorMode}\n` // COLOR_MODE_NOT_SET, COLOR_MODE_DARK, COLOR_MODE_LIGHT

    // 通过 windowStage 获取当前的窗口管理器，请参见 /ui/DisplayWindowDemo.ets 中的相关说明
    let windowStage = this.context.windowStage
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = "ExtensionContext 是 ExtensionAbility 的上下文，以 FormExtensionContext 为例，在 FormExtensionAbility 内，可以通过 this.context 获取 FormExtensionContext 对象，请参见 /entryformability/EntryFormAbility.ets 中的相关说明"

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}

@Component
struct MySample5 {

  lifecycleId: number = -1
  environmentId: number = -1
  @State message: string = ""

  aboutToAppear(): void {

    /*
     * AbilityLifecycleCallback - 应用级的生命周期的回调
     *   onAbilityCreate() - 当 UIAbility 创建时
     *   onWindowStageCreate() - 当窗口创建时
     *   onWindowStageActive() - 当窗口处于活动状态时
     *   onWindowStageInactive() - 当窗口处于非活动状态时
     *   onWindowStageDestroy() - 当窗口被销毁时
     *   onAbilityDestroy() - 当 UIAbility 被销毁时
     *   onAbilityForeground() - 当 UIAbility 从后台转到前台时
     *   onAbilityBackground() - 当 UIAbility 从前台转到后台时
     *   onAbilityContinue() - 当 UIAbility 迁移时（当 ability 从一个设备迁移到另一个设备时）
     */
    let abilityLifecycleCallback: AbilityLifecycleCallback = {
      onAbilityCreate(ability:UIAbility) {
        MyLog.d(`AbilityLifecycleCallback onAbilityCreate`)
      },
      onWindowStageCreate(ability:UIAbility, windowStage:window.WindowStage) {
        MyLog.d(`AbilityLifecycleCallback onWindowStageCreate`)
      },
      onWindowStageActive(ability, windowStage) {
        MyLog.d(`AbilityLifecycleCallback onWindowStageActive`)
      },
      onWindowStageInactive(ability, windowStage) {
        MyLog.d(`AbilityLifecycleCallback onWindowStageInactive`)
      },
      onWindowStageDestroy(ability, windowStage) {
        MyLog.d(`AbilityLifecycleCallback onWindowStageDestroy`)
      },
      onAbilityDestroy(ability) {
        MyLog.d(`AbilityLifecycleCallback onAbilityDestroy`)
      },
      onAbilityForeground(ability) {
        MyLog.d(`AbilityLifecycleCallback onAbilityForeground`)
      },
      onAbilityBackground(ability) {
        MyLog.d(`AbilityLifecycleCallback onAbilityBackground`)
      },
      onAbilityContinue(ability) {
        MyLog.d(`AbilityLifecycleCallback onAbilityContinue`)
      }
    }

    /*
     * EnvironmentCallback - 环境信息变化时的回调
     *   onConfigurationUpdated() - 环境配置发生变化时的回调（比如系统语言，深色浅色模式等）
     *   onMemoryLevel() - 内存占用级别发生变化时的回调
     */
    let environmentCallback: EnvironmentCallback = {
      onConfigurationUpdated(config:Configuration) {
        MyLog.d(`EnvironmentCallback onConfigurationUpdated`)
      },
      onMemoryLevel(level:AbilityConstant.MemoryLevel) {
        MyLog.d(`EnvironmentCallback onMemoryLevel`)
      }
    }

    /*
     * 在页面内，可以通过 getContext(this) 获取 Context 对象
     * 然后可以通过 Context 对象的 getApplicationContext() 获取 ApplicationContext 对象
     *
     * ApplicationContext - 应用级别的上下文
     *   on('abilityLifecycle') - 监听生命周期的相关事件
     *     返回值为监听 id，之后可以通过 off('abilityLifecycle', 监听 id) 取消指定的监听
     *   on('environment') - 监听环境信息的变化
     *     返回值为监听 id，之后可以通过 off('environment', 监听 id) 取消指定的监听
     */
    let applicationContext = getContext(this).getApplicationContext()
    try {
      this.lifecycleId = applicationContext.on('abilityLifecycle', abilityLifecycleCallback)
      this.environmentId = applicationContext.on('environment', environmentCallback);
    } catch (error) {

    }
    MyLog.d(`registerAbilityLifecycleCallback lifecycleId: ${this.lifecycleId}`)
  }

  aboutToDisappear(): void {
    // 取消相关的事件监听
    let applicationContext = getContext(this).getApplicationContext()
    applicationContext.off('abilityLifecycle', this.lifecycleId)
    applicationContext.off('environment', this.environmentId)
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * ApplicationContext - 应用级别的上下文
       *   killAllProcesses() - 杀死全部 UIAbility
       *     注：杀死全部后，如果某个 UIAbility 不需要在最近任务列表中显示一个快照，则需要将 module.json5 中的 abilities 的 removeMissionAfterTerminate 设置为 true
       *   restartApp() - 重启指定 Want 的 UIAbility
       *   setColorMode() - 设置当前的深色浅色模式（ConfigurationConstant.ColorMode 枚举）
       *     COLOR_MODE_NOT_SET, COLOR_MODE_DARK, COLOR_MODE_LIGHT
       *   setLanguage() - 设置当前的语言
       */

      Button('杀死全部 UIAbility').onClick(() => {
        (getContext(this) as common.UIAbilityContext).getApplicationContext().killAllProcesses()
      })

      Button('重启指定 Want 的 UIAbility').onClick(() => {
        let want: Want = {
          abilityName: 'com.webabcd.harmonydemo.EntryAbility'
        };
        (getContext(this) as common.UIAbilityContext).getApplicationContext().restartApp(want)
      })

      Button('设置当前的深色浅色模式为 COLOR_MODE_DARK').onClick(() => {
        (getContext(this) as common.UIAbilityContext).getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
      })

      Button('设置当前的语言为 en').onClick(() => {
        (getContext(this) as common.UIAbilityContext).getApplicationContext().setLanguage('en')
      })
    }
  }
}

@Component
struct MySample6 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * UIContext - UI 相关的上下文
       *   功能很多，以下简单举几个例子
       */

      Button('弹出对话框').onClick(() => {
        let uiContext = this.getUIContext()
        uiContext.showAlertDialog({
          title: 'title',
          message: 'message',
        })
      })

      Button('弹出 toast').onClick(() => {
        let uiContext = this.getUIContext()
        let myPromptAction = uiContext.getPromptAction()
        myPromptAction.showToast({
          message: 'hello webabcd',
          duration: 3000
        })
      })

      Button('获取组件信息').id("myButton").onClick(() => {
        let uiContext = this.getUIContext()
        let info: componentUtils.ComponentInfo = componentUtils.getRectangleById('myButton');
        this.message += `size width:${uiContext.px2vp(info.size.width).toFixed(0)}, height:${uiContext.px2vp(info.size.height).toFixed(0)}\n`
      })

      Button('获取当前 router 对象，并返回上一页').onClick(() => {
        let uiContext = this.getUIContext()
        let myRouter = uiContext.getRouter()
        myRouter.back()
      })

      Button('计算指定的单行文本的宽度').onClick(() => {
        let uiContext = this.getUIContext()
        let textWidth: number = uiContext.getMeasureUtils().measureText({
          textContent: "Hello World",
          fontSize: '50vp'
        })
        this.message = `textWidth: ${textWidth}`
      })
    }
  }
}
