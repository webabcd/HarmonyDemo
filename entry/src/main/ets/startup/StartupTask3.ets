import { StartupTask, common } from '@kit.AbilityKit';
import { MyLog } from '../pages/TitleBar';

@Sendable
export default class StartupTask3 extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    MyLog.d(`StartupTask3 init`)

    await new Promise<void>((r) => { setTimeout(r, 2000) })

    return 'StartupTask3_Completed';
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    MyLog.d(`StartupTask3 onDependencyCompleted dependence:${dependence}, result:${JSON.stringify(result)}`)
  }
}