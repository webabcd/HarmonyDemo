/*
 * 延迟任务（由系统决策，在合适的时候执行）
 *
 * 延迟任务是由系统统一决策并调用，系统会根据应用的活跃程度决定多长时间执行一次（最快 2 个小时）
 * 延迟任务每次执行时，最多运行 2 分钟
 * 延迟任务支持在 app 死掉后执行
 *
 * 1、继承 WorkSchedulerExtensionAbility 实现自定义的延迟任务（参见 MyWorkSchedulerExtensionAbility.ets）
 * 2、需要在 src/main/module.json5 中添加指定的延迟任务，类似如下
 * {
 *   "module": {
 *     "extensionAbilities": [
 *       {
 *         "name": "com.webabcd.harmonydemo.MyWorkSchedulerExtensionAbility", // 自定义标识
 *         "srcEntry": "./ets/pages/background/MyWorkSchedulerExtensionAbility.ets", // 延迟任务对应的代码的地址
 *         "type": "workScheduler" // 当前的 ExtensionAbility 的类型为延迟任务
 *       }
 *     ],
 *   }
 * }
 */

import { TitleBar } from '../TitleBar';
import { workScheduler } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct DeferredTaskDemo {

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
  myWorkInfo: workScheduler.WorkInfo | undefined = undefined

  // 申请延迟任务
  startWork() {
    this.myWorkInfo = {
      workId: 1,
      // 网络连接到 wifi 时才会执行
      // 注：还有一些其他限制条件，比如是否在充电、电量多少、存储状态等，必须至少设置一个限制条件
      networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
      bundleName: 'com.webabcd.harmonydemo', // bundle 名称
      abilityName: 'com.webabcd.harmonydemo.MyWorkSchedulerExtensionAbility', // ability 名称（即在 src/main/module.json5 配置的延迟任务的自定义标识）
      isRepeat: true, // 是否是重复任务（最快 2 个小时重复执行一次，每次最多运行 2 分钟）
    }

    try {
      // 申请延迟任务
      workScheduler.startWork(this.myWorkInfo);
      this.message = `startWork 成功`;
    } catch (error) {
      let err = error as BusinessError;
      this.message =`startWork 失败, errCode:${err.code}, errMessage:${err.message}`;
    }
  }

  // 取消延迟任务
  stopWork() {
    try {
      // 取消延迟任务
      workScheduler.stopWork(this.myWorkInfo);
      this.message = `stopWork 成功`;
    } catch (error) {
      let err = error as BusinessError;
      this.message =`stopWork 失败, errCode:${err.code}, errMessage:${err.message}`;
    }
  }

  build() {
    Column({ space: 10 }) {
      Button("申请延迟任务").onClick(() => {
        this.startWork()
      })

      Button("取消延迟任务").onClick(() => {
        this.stopWork()
      })

      Text(this.message)
    }
  }
}