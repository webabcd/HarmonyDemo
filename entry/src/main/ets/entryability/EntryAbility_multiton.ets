/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 * UIAbility 的相关配置，请参见 module.json5 配置文件中的 abilities 标签
 *
 * 本例用于演示 multiton 方式启动的 UIAbility
 */

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility2 extends UIAbility {

  param = ""
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.param = `abilityName:${want.abilityName ?? ""}`
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    let record: Record<string, string> = { 'param': this.param };
    windowStage.loadContent('pages/basic/LaunchTypeDemo', new LocalStorage(record));
  }
}