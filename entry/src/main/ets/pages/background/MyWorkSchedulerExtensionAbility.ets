import { WorkSchedulerExtensionAbility, workScheduler } from '@kit.BackgroundTasksKit';
import { MyLog } from '../TitleBar';

// 继承 WorkSchedulerExtensionAbility 实现自定义的延迟任务
export default class MyWorkSchedulerExtensionAbility extends WorkSchedulerExtensionAbility {
  // 延迟任务开始时的回调
  onWorkStart(workInfo: workScheduler.WorkInfo) {
    MyLog.d(`onWorkStart: ${JSON.stringify(workInfo)}`);
  }

  // 延迟任务结束时的回调
  onWorkStop(workInfo: workScheduler.WorkInfo) {
    MyLog.d(`onWorkStop: ${JSON.stringify(workInfo)}`);
  }
}