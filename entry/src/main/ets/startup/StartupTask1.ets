/*
 * StartupTask - 启动任务中的一个自定义任务
 */

import { StartupTask, common } from '@kit.AbilityKit';
import { MyLog } from '../pages/TitleBar';

@Sendable
export default class StartupTask1 extends StartupTask {
  constructor() {
    super();
  }

  // 自定义任务开始执行，在此处写任务的具体逻辑
  async init(context: common.AbilityStageContext) {
    MyLog.d(`StartupTask1 init`)

    // 睡 2 秒
    // 我这里测试发现，当这里执行异步任务时
    //   如果当前任务执行在 mainThread（在 startup_config.json 中配置的），则一切正常
    //   如果当前任务执行在 taskPool（在 startup_config.json 中配置的），则无法获知当前任务执行完成，最后会在 StartupConfigEntry 中得到启动任务超时的回调
    await new Promise<void>((r) => { setTimeout(r, 2000) })

    // 返回执行结果，可以是任意对象，或者不返回
    return 'StartupTask1_Completed';
  }

  // 当前任务的某一个依赖任务执行完成后的回调
  onDependencyCompleted(dependence: string, result: Object): void {
    // dependence - 执行完的依赖任务的名称
    // result - 执行完的依赖任务的返回结果（即依赖任务在 init 中 return 的结果）
    MyLog.d(`StartupTask1 onDependencyCompleted dependence:${dependence}, result:${JSON.stringify(result)}`)
  }
}