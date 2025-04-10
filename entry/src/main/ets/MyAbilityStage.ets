/*
 * AbilityStage - 每个 HAP 都会对应一个 AbilityStage
 *   AbilityStage 是 HAP 的容器，当需要加载 HAP 的入口 UIAbility 实例时，会先创建 AbilityStage 实例
 * 需要在 module.json5 中的 module 的 srcEntry 中配置对应的 AbilityStage 的代码的地址
 */

import { AbilityConstant, AbilityStage, Configuration, Want } from '@kit.AbilityKit';
import { MyLog } from './utils/MyLog';

export default class MyAbilityStage extends AbilityStage {

  // 创建完成时的回调（注：加载 HAP 的入口 UIAbility 实例之前会先创建 AbilityStage 实例）
  onCreate() {
    MyLog.d('AbilityStage onCreate');
  }

  // 当 UIAbility 以 specified 的方式启动时，就会走到 HAP 的对应的 AbilityStage 中的 onAcceptWant() 回调
  onAcceptWant(want: Want): string {
    MyLog.d('AbilityStage onAcceptWant');

    // 返回 specified 标识
    //   如果相同 specified 标识的 UIAbility 已存在，则热启动它（启动已存在的实例）
    //   如果相同 specified 标识的 UIAbility 不存在，则冷启动它（创建新的实例，并启动）
    return `${want.parameters?.specifiedKey ?? ""}`
  }

  // 内存占用级别发生变化时的回调
  // MEMORY_LEVEL_MODERATE - 内存占用适中
  // MEMORY_LEVEL_LOW - 内存占用低
  // MEMORY_LEVEL_CRITICAL - 内存占用高
  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
  }

  // 全局的环境配置发生变化时的回调（比如系统语言，深色浅色模式等）
  onConfigurationUpdate(newConfig: Configuration): void {
  }
}