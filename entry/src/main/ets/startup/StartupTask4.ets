import { StartupTask, common } from '@kit.AbilityKit';
import { MyLog } from '../pages/TitleBar';

@Sendable
export default class StartupTask4 extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    MyLog.d(`StartupTask4 init`)

    await new Promise<void>((r) => { setTimeout(r, 2000) })

    return 'StartupTask4_Completed';
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    MyLog.d(`StartupTask4 onDependencyCompleted dependence:${dependence}, result:${JSON.stringify(result)}`)
  }
}