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

    let record: Record<string, number> = {
      'myNumber': 5000
    };
    let storage: LocalStorage = new LocalStorage(record);

    // 加载 app 的入口文件（必须是 @Entry 组件，必须在 /entry/src/main/resources/base/profile/main_pages.json 文件中声明）
    // 这里指定的 LocalStorage 对象的数据，会自动合并到 LocalStorage.getShared() 中
    windowStage.loadContent('pages/Index', storage, (err) => {
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
