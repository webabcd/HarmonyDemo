import { StartupTask, common } from '@kit.AbilityKit';
import { MyLog } from '../pages/TitleBar';

@Sendable
export default class StartupTask2 extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    MyLog.d(`StartupTask2 init`)

    await new Promise<void>((r) => { setTimeout(r, 2000) })

    return 'StartupTask2_Completed';
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    MyLog.d(`StartupTask2 onDependencyCompleted dependence:${dependence}, result:${JSON.stringify(result)}`)
  }
}