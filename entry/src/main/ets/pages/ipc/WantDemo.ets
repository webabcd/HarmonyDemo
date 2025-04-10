/*
 * Want - 用于应用间跳转
 */

import { TitleBar } from '../TitleBar';
import { BusinessError } from '@kit.BasicServicesKit';
import { common, Want } from '@kit.AbilityKit';
import { Helper } from '../../utils/Helper';

@Entry
@Component
struct WantDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('打开指定的 app').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('打开设置页').align(Alignment.Top)
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
    Column({space:10}) {

      Text(this.message)

      /*
       * UIAbilityContext
       *   startAbility() - 拉起指定 want 的 app
       *
       * Want - 需要拉起的 ability 的相关信息
       *   bundleName - bundle 的名称
       *   moduleName - module 的名称
       *   abilityName - ability 的名称
       *   parameters - 传参，目标 app 可以从 want 中获取
       *
       * 注：本例演示的目标应用请参见 harmonydemo2 项目
       */
      Button('通过 want 拉起 app 的方式 1').onClick(() => {
        let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        let want: Want = {
          bundleName: 'com.webabcd.harmonydemo2',
          abilityName: 'com.webabcd.harmonydemo2.EntryAbility',
          parameters: { // 传参
            'k1': 'v1',
            'k2': `${Helper.getTimestampString()}`,
          }
        };
        context.startAbility(want).then(() => {
          this.message = 'startAbility 成功';
        }).catch((err: BusinessError) => {
          this.message = `startAbility 失败 errCode:${err.code}, errMessage:${err.message}`;
        });
      })

      /*
       * UIAbilityContext
       *   startAbility() - 拉起指定 want 的 app
       *
       * Want - 需要拉起的 ability 的相关信息
       *   uri - deep linking 或 app linking 地址
       *   parameters - 传参，目标 app 可以从 want 中获取
       *
       * 注：关于 deep linking 请参见 DeepLinkingDemo.ets 中的说明，关于 app linking 请参见 AppLinkingDemo.ets 中的说明
       */
      Button('通过 want 拉起 app 的方式 2').onClick(() => {
        let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        let want: Want = {
          uri: "webabcd://a.b.c/api?p1=xyz",
          parameters: { // 传参
            'k1': 'v1',
            'k2': `${Helper.getTimestampString()}`,
          }
        };
        context.startAbility(want).then(() => {
          this.message = 'startAbility 成功';
        }).catch((err: BusinessError) => {
          this.message = `startAbility 失败 errCode:${err.code}, errMessage:${err.message}`;
        });
      })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      Button("打开设置 app").onClick(() => {
        let context = getContext(this) as common.UIAbilityContext;

        // 跳转到设置 app 的 Want 对象
        let want: Want = {
          bundleName: 'com.huawei.hmos.settings', // 设置 app 的 bundleName
          abilityName: 'com.huawei.hmos.settings.MainAbility', // 设置 app 的 abilityName
        };

        context.startAbility(want).then(() => { }).catch((err: BusinessError) => { });
      })

      Button("打开设置 app 的 wifi 设置页").onClick(() => {
        let context = getContext(this) as common.UIAbilityContext;

        let want: Want = {
          /*
           * uri - 需要跳转到的系统设置页面的名称
           *   application_info_entry - 系统的设置页首页
           *   systemui_notification_settings - 系统的通知设置页
           *   wifi_entry - 系统的 wifi 设置页
           * 注：找到想要的系统设置页面的名称的方法如下
           * 1、在 HiLog 中过滤 SettingsHome 相关的日志
           * 2、打开设置 app 并进入到想要的设置页面
           * 3、比如 wifi 设置页面，则可以在日志中找到 my router: wifi_entry
           */
          uri: 'wifi_entry'
        };

        context.startAbility(want).then(() => { }).catch((err: BusinessError) => { });
      })

      Button("打开设置 app 的当前应用的设置页").onClick(() => {
        let context = getContext(this) as common.UIAbilityContext;

        // 此 Want 可以跳转到设置 app 的当前应用的设置页
        let want: Want = {
          uri: "application_info_entry", // 系统的设置页首页
          parameters: {
            pushParams: context.abilityInfo.bundleName // 当前应用的包名
          }
        };

        context.startAbility(want).then(() => { }).catch((err: BusinessError) => { });
      })
    }
  }
}