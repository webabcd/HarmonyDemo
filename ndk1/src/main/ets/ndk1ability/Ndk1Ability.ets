import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class Ndk1Ability extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index');
  }
};
