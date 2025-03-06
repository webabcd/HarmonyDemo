/*
 * AbilityStage - 每个 HAP 都会对应一个 AbilityStage
 * 需要在 module.json5 中的 module 的 srcEntry 中配置对应的 AbilityStage 的代码的地址
 */

import { AbilityStage, Want } from '@kit.AbilityKit';

export default class MyAbilityStage extends AbilityStage {

  // 创建完成时的回调（注：加载 HAP 的主 UIAbility 实例之前会先创建 AbilityStage 实例）
  onCreate() {

  }

  // 当 UIAbility 以 specified 的方式启动时，就会走到 HAP 的对应的 AbilityStage 中的 onAcceptWant() 回调
  onAcceptWant(want: Want): string {
    // 返回 specified 标识
    //   如果相同 specified 标识的 UIAbility 已存在，则热启动它（启动已存在的实例）
    //   如果相同 specified 标识的 UIAbility 不存在，则冷启动它（创建新的实例，并启动）
    return `${want.parameters?.specifiedKey ?? ""}`
  }
}