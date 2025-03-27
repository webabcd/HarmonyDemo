/*
 * App Linking 跳转
 * App Linking 在 Deep Linking 的基础上，增加了 https 校验，可以验证 App Linking 地址中域名的合法性
 * App Linking 要求同一地址必须支持网页和应用两种呈现方式，打开 App Linking 地址时有应用则启动应用，无应用则启动浏览器显示网页
 *
 * 注：本例演示的 app linking 的目标应用请参见 harmonydemo2 项目
 *
 * 1、在 app linking 的目标应用的 module.json5 中做类似如下的配置
 * {
 *   "module": {
 *     "abilities": [
 *       {
 *         "skills": [
 *           // 作为 app linking 的目标应用，需要做类似如下的配置
 *           {
 *             // entities 必须配置为 entity.system.browsable
 *             "entities": [
 *               "entity.system.browsable"
 *             ],
 *             // actions 必须配置为 ohos.want.action.viewData
 *             "actions": [
 *               "ohos.want.action.viewData"
 *             ],
 *             // 配置 app linking 的地址，本例为 https://x.y.z
 *             "uris": [
 *               {
 *                 // app linking 的协议名，必须配置为 https
 *                 "scheme": "https",
 *                 // app linking 的域名
 *                 "host": "x.y.z",
 *                 // app linking 的 path，这是可选的，当需要一套域名匹配不同的应用时，则可以通过 path 区分
 *                 "path": ""
 *               }
 *             ],
 *             // domainVerify 必须配置为 true
 *             "domainVerify": true
 *           }
 *         ]
 *       }
 *     ]
 *   }
 * }
 *
 * 2、在 https 域名的固定目录下放置配置文件
 * 地址类似 https://x.y.z/.well-known/applinking.json
 * 配置文件 applinking.json 类似如下（其中的 appIdentifier 是云端为 app 分配的唯一 id）
 * {
 *   "applinking": {
 *     "apps": [
 *       {
 *         "appIdentifier": "1234"
 *       }
 *     ]
 *   }
 * }
 */

import { TitleBar } from '../TitleBar';
import { common, OpenLinkOptions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Helper } from '../../utils/Helper';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct AppLinkingDemo {

  build() {
    Column({space:10}) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('通过 openLink 跳转').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过 startAbility 跳转').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('通过 webview 跳转').align(Alignment.Top)
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
       *   openLink() - 拉起指定 app linking 地址的 app
       *     link - app linking 地址
       *     options - 选项（一个 OpenLinkOptions 对象）
       *       appLinkingOnly - 是否仅以 app linking 的方式打开
       *         true - 仅以 app linking 的方式打开
       *         false - 优先尝试以 app linking 的方式打，然后再以 deep linking 的方式打开
       *       parameters - 传参，目标 app 可以从 want 中获取
       */
      Button('通过 openLink 拉起 app').onClick(() => {
        let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

        let link: string = "https://x.y.z/api?p1=xyz";
        let openLinkOptions: OpenLinkOptions = {
          appLinkingOnly: false,
          parameters: { // 传参
            'k1': 'v1',
            'k2': `${Helper.getTimestampString()}`,
          }
        };

        context.openLink(link, openLinkOptions).then(() => {
          this.message = 'openLink 成功';
        }).catch((err: BusinessError) => {
          this.message = `openLink 失败 errCode:${err.code}, errMessage:${err.message}`;
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

      /*
       * UIAbilityContext
       *   startAbility() - 拉起指定 want 的 app
       *
       * Want - 需要拉起的 ability 的相关信息
       *   uri - app linking 地址
       *   parameters - 传参，目标 app 可以从 want 中获取
       */
      Button('通过 startAbility 拉起 app').onClick(() => {
        let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        let want: Want = {
          uri: "https://x.y.z/api?p1=xyz",
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
struct MySample3 {

  @State message: string = ""
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * 通过 webview 显示 html，然后拦截跳转请求，如果发现是 app linking 连接，则通过 openLink() 做 app linking 跳转
       */
      Web({ src: $rawfile('AppLinking.html'), controller: this.controller })
        .onLoadIntercept((event) => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          const url: string = event.data.getRequestUrl();
          if (url.startsWith("https://x.y.z")) {
            context.openLink(url).then(() => {
              this.message = 'startAbility 成功';
            }).catch((err: BusinessError) => {
              this.message = `startAbility 失败 errCode:${err.code}, errMessage:${err.message}`;
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