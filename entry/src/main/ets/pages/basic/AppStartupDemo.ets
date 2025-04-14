/*
 * AppStartup - 启动任务
 *
 * 主要用于 app 启动时，执行一些自定义任务
 * 启动任务可以包含多个自定义任务，且支持设置自定义任务的依赖关系
 * 多个自定义任务会并行执行，如果需要串行执行，则可以通过设置自定义任务的依赖关系实现
 * 在启动屏，可以等待启动任务执行完成后再继续，也可以不等待
 * 启动任务可以在 app 启动时自动执行，也可以之后通过手动执行
 *
 * 1、在 module.json5 中指定启动任务的配置文件
 * {
 *   "module": {
 *     "appStartup": "$profile:startup_config", // 启动任务的配置文件
 *   }
 * }
 *
 * 2、启动任务的配置文件 resources/base/profile/startup_config.json 说明如下
 * {
 *   "configEntry": "./ets/startup/MyStartupConfigEntry.ets", // 启动任务的配置的代码地址（用于设置启动任务的超时时间，并可以监听启动任务的执行情况）
 *   "startupTasks": [                                        // 启动任务包含的自定义任务列表
 *     {
 *       "name": "StartupTask1",                              // 任务名称
 *       "srcEntry": "./ets/startup/StartupTask1.ets",        // 任务的代码地址
 *       "dependencies": [                                    // 此任务的依赖任务的名称列表（依赖任务完成后，才会执行此任务）
 *         "StartupTask2",
 *         "StartupTask3"
 *       ],
 *       "runOnThread": "mainThread",                         // 此任务执行在 mainThread 或 taskPool
 *       "waitOnMainThread": false                            // 当任务执行在 mainThread 时，此字段用于指定是否需要在主线程等待此任务执行完成
 *     },
 *     ...
 *     {
 *       "name": "StartupTask4",
 *       "srcEntry": "./ets/startup/StartupTask4.ets",
 *       "runOnThread": "mainThread",
 *       "waitOnMainThread": false,
 *       "excludeFromAutoStart": true                         // false 代表此任务在 app 启动时自动执行（默认值），true 代表此任务需要通过手动执行
 *     }
 *   ]
 * }
 */

import { TitleBar } from '../TitleBar';
import { startupManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct AppStartupDemo {

  @State message: string = "启动任务，具体实现请参见：\n" +
    "src/main/resources/base/profile/startup_config.json\n" +
    "src/main/ets/startup/MyStartupConfigEntry.ets\n" +
    "src/main/ets/startup/StartupTask1.ets\n" +
    "src/main/ets/startup/StartupTask2.ets\n" +
    "src/main/ets/startup/StartupTask3.ets\n" +
    "src/main/ets/startup/StartupTask4.ets"

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      /*
       * startupManager.run() - 手动执行启动任务中的指定名称的自定义任务
       * startupManager.isStartupTaskInitialized() - 判断指定名称的自定义任务是否执行完成
       */

      Button('手动启动 StartupTask4').onClick(() => {
        let startupTasks = ["StartupTask4"];
        startupManager.run(startupTasks).then(() => {
          this.message = `任务 StartupTask4 开始执行`
        }).catch((error: BusinessError) => {
          this.message = `任务 StartupTask4 执行失败 errCode:${error.code}, errMessage:${error.message}`
        })
      })

      Button('判断 StartupTask4 是否执行完成').onClick(() => {
        let startupTask = "StartupTask4";
        let initialized = startupManager.isStartupTaskInitialized(startupTask)
        this.message = `任务 StartupTask4 的执行结果: ${initialized}`
      })
    }
  }
}