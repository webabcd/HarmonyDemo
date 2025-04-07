import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { systemShare } from '@kit.ShareKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default class Feature1Ability extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.parseWantParameter(want)
    this.parseWantShare(want)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.parseWantParameter(want)
    this.parseWantShare(want)
  }

  // 解析 Want 中的参数，并保存在 AppStorage 中
  parseWantParameter(want: Want) {
    let k1 = ""
    let k2 = ""
    if (want.parameters?.k1) {
      k1 = want.parameters.k1.toString()
    }
    if (want.parameters?.k2) {
      k2 = want.parameters.k2.toString()
    }
    AppStorage.setOrCreate("k1", k1)
    AppStorage.setOrCreate("k2", k2)
    AppStorage.setOrCreate("uri", want.uri ?? "")
  }

  // 解析 Want 中的分享数据，并保存在 AppStorage 中
  parseWantShare(want: Want) {
    /*
     * systemShare.getSharedData() - 获取分享过来的数据（需要在 module.json5 做相关的配置）
     * SharedData - 分享数据（请参见 /HarmonyDemo/entry/src/main/ets/pages/ipc/ShareDemo 中的相关说明）
     *   getRecords() - 获取分享数据中的所有记录
     * SharedRecord - 分享数据中的某条记录
     */
    systemShare.getSharedData(want).then((data: systemShare.SharedData) => {
      data.getRecords().forEach((record: systemShare.SharedRecord) => {
        let title = record.title
        let description = record.description
        let content = record.content
        let uri = record.uri
        AppStorage.setOrCreate("share_data", `title:${title}, description:${description}, content:${content}, uri:${uri}`)
        AppStorage.setOrCreate("share_uri", `${uri}`)
      });
    }).catch((error: BusinessError) => {

    });
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {

    });
  }
}
