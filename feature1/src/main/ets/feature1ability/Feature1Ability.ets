import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class Feature1Ability extends UIAbility {

  want: Want | undefined
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.want = want
  }

  onDestroy(): void {

  }

  onWindowStageCreate(windowStage: window.WindowStage): void {

    // 获取通过 Want 传递过来的数据
    let k1 = this.want?.parameters?.k1
    let k2 = this.want?.parameters?.k2

    // 通过 LocalStorage 将数据传递给页面
    let storage = LocalStorage.getShared()
    storage.setOrCreate("k1", k1)
    storage.setOrCreate("k2", k2)

    windowStage.loadContent('pages/Index', storage);
  }

  onWindowStageDestroy(): void {

  }

  onForeground(): void {

  }

  onBackground(): void {

  }
}
