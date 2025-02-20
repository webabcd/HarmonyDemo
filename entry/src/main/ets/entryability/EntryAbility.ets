import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { MyLog } from '../utils/MyLog';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d('Ability onCreate');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d(`Ability onNewWant, parameters:${JSON.stringify((want.parameters))}`);
  }

  onDestroy(): void {
    MyLog.d('Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    MyLog.d('Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    MyLog.d('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    MyLog.d('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    MyLog.d('Ability onBackground');
  }
}
