/*
 * TransientTask - 短时任务
 *
 * 一般来说，应用退到后台之后，过一小段时间就会被挂起
 * 短时任务可以让应用退到后台之后，短时间内不会被挂起
 * 短时任务单次配额 3 分钟（低电量时 1 分钟），单日配额总计 10 分钟
 * 通过 requestSuspendDelay() 申请短时任务后，不再需要时一定要通过 cancelSuspendDelay() 取消短时任务，避免浪费配额
 * 注：这里的 suspend delay 指的是应用延迟挂起的意思
 */

import { MyLog, TitleBar } from '../TitleBar';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct TransientTaskDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  taskFlag: boolean = true // 任务标记，如果是 false 则代表需要强制退出任务
  taskStatus: boolean = true // 任务状态，如果是 true 则代表任务已经退出了

  // 申请的短时任务 ID
  taskId: number = 0;

  async requestSuspendDelay() {
    /*
     * backgroundTaskManager.requestSuspendDelay() - 申请短时任务
     *   reason - 申请原因
     *   callback - 短时任务即将超时的回调（一般会在超时前 6 秒回调）
     *   返回值是一个 DelaySuspendInfo 对象
     * DelaySuspendInfo - 短时任务信息
     *   requestId - 短时任务 ID
     *   actualDelayTime - 申请到的短时任务的最大可执行时间（单位：毫秒）
     * backgroundTaskManager.cancelSuspendDelay() - 取消指定的短时任务
     *   requestId - 短时任务 ID
     */
    let myReason = 'test requestSuspendDelay';
    let delayInfo = backgroundTaskManager.requestSuspendDelay(myReason, async () => {
      // 短时任务即将超时（一般会在超时前 6 秒回调）
      // 在这里做自定义任务的停止和清理等工作，然后手动取消短时任务
      this.message += `任务id:${this.taskId}, 短时任务即将超时\n`;
      await this.stopTask();
      backgroundTaskManager.cancelSuspendDelay(this.taskId);
    })
    this.taskId = delayInfo.requestId;
    let taskSuspendDelayTime = delayInfo.actualDelayTime;

    this.message += `任务id:${this.taskId}, 任务剩余时间:${taskSuspendDelayTime}\n`
  }

  // 开始任务
  async startTask() {
    this.taskStatus = false
    let start: number = new Date().getTime();
    for (let i: number = 0; i < 500000000; i++) {
      Math.random() * Math.random() * Math.random() * Math.random() * Math.random();
      if (i % 500000 == 0) {
        await new Promise<string>(r => setTimeout(r, 1));
        MyLog.d(`循环次数:${i}`)
      }
      if (!this.taskFlag) {
        MyLog.d(`强制退出任务`)
        break
      }
    }
    let end: number = new Date().getTime();
    MyLog.d(`任务总耗时:${end - start}`)
    this.taskStatus = true
  }

  // 停止任务
  async stopTask() {
    this.taskFlag = false
    while (this.taskStatus == false) {
      await new Promise<string>(r => setTimeout(r, 1));
    }
  }

  getRemainingDelayTime() {
    /*
     * backgroundTaskManager.getRemainingDelayTime() - 获取指定的短时任务的剩余的可执行时间
     *   requestId - 短时任务 ID
     *   返回值为任务的剩余的可执行时间（单位：毫秒）
     */
    backgroundTaskManager.getRemainingDelayTime(this.taskId).then((taskSuspendDelayTime: number) => {
      this.message += `任务id:${this.taskId}, 任务剩余时间:${taskSuspendDelayTime}\n`
    }).catch((err: BusinessError) => {
      this.message += `getRemainingDelayTime errCode:${err.code}, errMessage:${err.message}\n`
    })
  }

  cancelSuspendDelay() {
    /*
     * backgroundTaskManager.cancelSuspendDelay() - 取消指定的短时任务
     *   requestId - 短时任务 ID
     */
    backgroundTaskManager.cancelSuspendDelay(this.taskId);
    this.message += `任务id:${this.taskId}, 取消了\n`
  }

  build() {
    Column({space:10}) {
      Button("申请短时任务，并执行一个自定义任务，执行完毕后取消短时任务").onClick(async () => {
        this.requestSuspendDelay()
        await this.startTask()
        this.cancelSuspendDelay()
      })

      Button("获取当前短时任务的剩余时间").onClick(() => {
        this.getRemainingDelayTime()
      })

      Button("取消当前短时任务，并终止一个自定义任务").onClick(async () => {
        this.cancelSuspendDelay()
        await this.stopTask()
      })

      Text(this.message)
    }
  }
}
