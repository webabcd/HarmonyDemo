/*
 *
 * 配置module.json5文件
 */

import { MyLog, TitleBar } from '../TitleBar';
import { common, OpenLinkOptions, Want } from '@kit.AbilityKit';
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
        TabContent() { MySample1() }.tabBar('openLink').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('startAbility').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('startAbility').align(Alignment.Top)
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

      Button('111').onClick(() => {
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
struct MySample2 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      Button('222').onClick(() => {
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
struct MySample3 {

  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

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
            return true;
          }
          // 返回true表示阻止此次加载，否则允许此次加载
          return false;
        })
    }
  }
}