/*
 * Deep Linking 跳转，如果匹配到多个应用则会弹出应用选择框
 *
 * 注：本例演示的 deep linking 的目标应用请参见 harmonydemo2 项目
 *
 * 在 deep linking 的目标应用的 module.json5 中做类似如下的配置
 * {
 *   "module": {
 *     "abilities": [
 *       {
 *         "skills": [
 *           // 作为 deep linking 的目标应用，需要做类似如下的配置
 *           {
 *             // actions 不能为空，随便配置一个值就好
 *             "actions": [
 *               "action.app.scheme.webabcd"
 *             ],
 *             // 配置 deep linking 的地址，本例为 webabcd://a.b.c
 *             "uris": [
 *               {
 *                 // deep linking 的协议名
 *                 "scheme": "webabcd",
 *                 // deep linking 的域名
 *                 "host": "a.b.c",
 *               }
 *             ]
 *           }
 *         ]
 *      }
 *     ]
 *   }
 * }
 *
 * 在 deep linking 的调用方的 module.json5 中做类似如下的配置（用于让调用方判断设备中是否存在支持指定协议的应用）
 * {
 *   "module": {
 *     "querySchemes": [ // 当前应用可以通过 canOpenLink() 判断当前设备中是否存在支持指定协议（这个协议必须在 querySchemes 中配置，最多 50 个）的应用
 *       "webabcd"
 *     ]
 *   }
 * }
 */

import { MyLog, TitleBar } from '../TitleBar';
import { bundleManager, common, OpenLinkOptions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Helper } from '../../utils/Helper';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct DeepLinkingDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('判断是否存在支持指定协议的应用').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过 openLink 跳转').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('通过 startAbility 跳转').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('通过 webview 跳转').align(Alignment.Top)
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
       * bundleManager.canOpenLink() - 用于判断是否存在支持指定 deep linking 地址的应用
       */
      Button('是否存在支持 appscheme:// 协议的应用').onClick(() => {
        try {
          let link = 'appscheme://xxx.yyy.zzz/home';
          let canOpenLink = bundleManager.canOpenLink(link);
          this.message = `是否存在支持 appscheme:// 协议的应用：${canOpenLink}`
        } catch (err) {
          let error = err as BusinessError
          this.message = `不存在支持 appscheme:// 协议的应用：${error.message}`
        }
      })

      Button('是否存在支持 webabcd:// 协议的应用').onClick(() => {
        try {
          let link = 'webabcd://a.b.c/api';
          let canOpenLink = bundleManager.canOpenLink(link);
          this.message = `是否存在支持 webabcd:// 协议的应用：${canOpenLink}`
        } catch (err) {
          let error = err as BusinessError
          this.message = `不存在支持 webabcd:// 协议的应用：${error.message}`
        }
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

      /*
       * UIAbilityContext
       *   openLink() - 拉起指定 deep linking 地址的 app
       *     link - deep linking 地址
       *     options - 选项（一个 OpenLinkOptions 对象）
       *       appLinkingOnly - 是否仅以 app linking 的方式打开
       *         true - 有 app linking 匹配的应用则打开，没有则抛出异常
       *         false - 优先尝试以 app linking 的方式打开应用，然后再以 deep linking 的方式打开应用
       *       parameters - 传参，目标 app 可以从 want 中获取
       */
      Button('通过 openLink 拉起 app').onClick(() => {
        let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

        let link: string = "webabcd://a.b.c/api?p1=xyz";
        let openLinkOptions: OpenLinkOptions = {
          appLinkingOnly: false,
          parameters: { // 传参
            'k1': 'v1',
            'k2': `${Helper.getTimestampString()}`,
          }
        };

        context.openLink(link, openLinkOptions).then(() => {
          MyLog.d('openLink 成功');
        }).catch((err: BusinessError) => {
          MyLog.d(`openLink 失败 errCode:${err.code}, errMessage:${err.message}`);
        });
      })
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * UIAbilityContext
       *   startAbility() - 拉起指定 want 的 app
       *
       * Want - 需要拉起的 ability 的相关信息
       *   uri - deep linking 地址
       *   parameters - 传参，目标 app 可以从 want 中获取
       */
      Button('通过 startAbility 拉起 app').onClick(() => {
        let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        let want: Want = {
          uri: "webabcd://a.b.c/api?p1=xyz",
          parameters: { // 传参
            'k1': 'v1',
            'k2': `${Helper.getTimestampString()}`,
          }
        };

        context.startAbility(want).then(() => {
          MyLog.d('startAbility 成功');
        }).catch((err: BusinessError) => {
          MyLog.d(`startAbility 失败 errCode:${err.code}, errMessage:${err.message}`);
        });
      })
    }
  }
}

@Component
struct MySample4 {

  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

      /*
       * 通过 webview 显示 html，然后拦截跳转请求，如果发现是 deep linking 连接，则通过 openLink() 做 deep linking 跳转
       */
      Web({ src: $rawfile('DeepLinking.html'), controller: this.controller })
        .onLoadIntercept((event) => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          const url: string = event.data.getRequestUrl();
          if (url.startsWith("webabcd://")) {
            context.openLink(url).then(() => {
              MyLog.d('startAbility 成功');
            }).catch((err: BusinessError) => {
              MyLog.d(`startAbility 失败 errCode:${err.code}, errMessage:${err.message}`);
            });
            // 阻止此次跳转
            return true;
          }
          // 允许此次跳转
          return false;
        })
    }
  }
}