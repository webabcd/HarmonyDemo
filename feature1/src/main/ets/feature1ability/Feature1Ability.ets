import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class Feature1Ability extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.parseWantParameter(want)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.parseWantParameter(want)
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
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {

    });
  }
}
