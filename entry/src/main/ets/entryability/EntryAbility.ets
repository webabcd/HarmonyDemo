/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 * UIAbility 的相关配置，请参见 module.json5 配置文件中的 abilities 标签
 */

import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { MyLog } from '../utils/MyLog';

export default class EntryAbility extends UIAbility {

  // UIAbility 实例创建完成时（冷启动）
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d('ability onCreate');
  }

  // 当 UIAbility 已经启动了，之后再次启动时（热启动）
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d(`ability onNewWant, parameters:${JSON.stringify((want.parameters))}`);
  }

  // UIAbility 实例销毁时
  onDestroy(): void {
    MyLog.d('ability onDestroy');
  }

  // UIAbility 的窗口创建完成时
  // 在这里需要通过 windowStage.loadContent() 加载当前 UIAbility 的首页
  onWindowStageCreate(windowStage: window.WindowStage): void {
    MyLog.d('ability onWindowStageCreate');

    let record: Record<string, number> = {
      'myNumber': 5000
    };
    let storage: LocalStorage = new LocalStorage(record);

    // 加载当前 UIAbility 的首页
    //   必须是 @Entry 组件
    //   必须在 main_pages.json 文件（在 module.json5 中通过 "pages":"$profile:main_pages" 指定的）中声明
    // 这里指定的 LocalStorage 对象的数据，会自动合并到当前 UIAbility 的 LocalStorage.getShared() 中
    windowStage.loadContent('pages/Index', storage, (err) => {
      if (err.code) {
        MyLog.d(`windowStage.loadContent() failed, ${JSON.stringify(err)}`)
        return;
      }
      MyLog.d(`windowStage.loadContent() succeeded`)
    });
  }

  // UIAbility 的窗口销毁之前
  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    MyLog.d('ability onWindowStageWillDestroy');
  }

  // UIAbility 的窗口销毁时
  onWindowStageDestroy(): void {
    MyLog.d('ability onWindowStageDestroy');
  }

  // 切换到前台时
  onForeground(): void {
    MyLog.d('ability onForeground');
  }

  // 切换到后台时
  onBackground(): void {
    MyLog.d('ability onBackground');
  }

  // 内存占用级别发生变化时的回调
  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    // MEMORY_LEVEL_MODERATE - 内存占用适中
    // MEMORY_LEVEL_LOW - 内存占用低
    // MEMORY_LEVEL_CRITICAL - 内存占用高
    MyLog.d(`ability onMemoryLevel ${level}`);
  }

  // 全局的环境配置发生变化时的回调（比如系统语言，深色浅色模式等）
  onConfigurationUpdate(newConfig: Configuration): void {
    MyLog.d(`ability onConfigurationUpdate ${JSON.stringify(newConfig)}`);
  }
}
