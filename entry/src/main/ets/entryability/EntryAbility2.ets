/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 * UIAbility 的相关配置，请参见 module.json5 配置文件中的 abilities 标签
 */

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { MyLog } from '../utils/MyLog';

export default class EntryAbility2 extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d(`ability onCreate, parameters:${JSON.stringify((want.parameters))}`);

    /*
     * context.eventHub - 用于在当前 UIAbility 内做事件的发布和订阅
     *   emit() - 发布指定的事件，允许传递多个参数
     */
    setInterval(() => {
      this.context.eventHub.emit("my_event", "timestamp", new Date().getTime())
    }, 1000)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d(`ability onNewWant, parameters:${JSON.stringify((want.parameters))}`);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/basic/UIAbilityDemo2');
  }
}
