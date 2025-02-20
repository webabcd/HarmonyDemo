/*
 * 长时任务（应用退到后台之后，允许特定任务长时间运行）
 *
 * 应用退到后台之后，特定任务（比如数据上传下载，音视频播放，录音录屏，定位，蓝牙传输等）可以长时间运行
 * 启动长时任务后，通知栏会显示一个与此任务关联的通知，删除这个通知则会自动停止长时任务
 *
 * 1、需要在 src/main/module.json5 中添加长时任务权限，类似如下
 * {
 *   "module": {
 *     "requestPermissions":[
 *       {
 *         "name": "ohos.permission.KEEP_BACKGROUND_RUNNING", // 请求长时任务的权限
 *         "reason": "$string:hello_webabcd", // 申请此权限的原因
 *         "usedScene": {
 *           "abilities": [ ],
 *           "when":"always" // inuse（使用时允许使用此权限），always（始终允许使用此权限）
 *         }
 *       },
 *     ]
 *   }
 * }
 * 2、需要在 src/main/module.json5 中配置长时任务类型，类似如下
 * {
 *   "module": {
 *     "abilities": [
 *       {
 *         "backgroundModes": [ // 长时任务的类型
 *           "dataTransfer", // 数据上传下载
 *           // "audioPlayback", // 音频、视频播放
 *           // "audioRecording", // 录音、录屏
 *           // "location", // 定位
 *           // "bluetoothInteraction", // 蓝牙传输
 *         ]
 *       }
 *     ]
 *   }
 * }
 */

import { TitleBar } from '../TitleBar';
import { common, WantAgent, wantAgent } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct ContinuousTaskDemo {

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
  @State bundleName: string = ""
  @State moduleName: string = ""
  @State abilityName: string = ""

  // 长任务关联的通知 ID
  notificationId: number = 0

  //启动长时任务
  startBackgroundRunning() {
    let context: Context = getContext(this);
    this.bundleName = (context as common.UIAbilityContext).abilityInfo.bundleName
    this.moduleName = (context as common.UIAbilityContext).currentHapModuleInfo.name
    this.abilityName = (context as common.UIAbilityContext).abilityInfo.name

    this.message += `bundleName:${this.bundleName}, moduleName:${this.moduleName}, abilityName:${this.abilityName}\n`

    /*
     * wantAgent.getWantAgent() - 创建 WantAgent 对象（传入 WantAgentInfo 类型的参数）
     *
     * WantAgent - 封装了 Want，以便将来需要的时候执行这个 Want
     *
     * WantAgentInfo - 定义 WantAgent 的相关信息
     *   wants - 相关的 Want 对象列表，目前仅第一个有效
     *   requestCode - 标识
     *   actionType - 点击通知后的动作类型
     *     wantAgent.OperationType.START_ABILITY - 拉起 ability
     *
     * Want - 点击通知后，拉起的 ability 的相关信息
     *   bundleName - bundle 名称
     *   moduleName - module 名称
     *   abilityName - ability 名称
     *   parameters - 传递给拉起的 ability 的数据
     *     冷启动时，通过 UIAbility 的 onCreate() 的 want.parameters 获取
     *     热启动时，通过 UIAbility 的 onNewWant() 的 want.parameters 获取
     */

    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: this.bundleName,
          moduleName: this.moduleName,
          abilityName: this.abilityName,
          parameters: {
            'myParameter':{'p1':'v1', 'p2':'v2'}
          }
        }
      ],
      requestCode: 0,
      actionType: wantAgent.OperationType.START_ABILITY,
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
      /*
       * backgroundTaskManager.startBackgroundRunning() - 启动长时任务
       *   context - 上下文
       *   bgModes - 长时任务的类型
       *     dataTransfer - 数据上传下载
       *     audioPlayback - 音频、视频播放
       *     audioRecording - 录音、录屏
       *     location - 定位
       *     bluetoothInteraction - 蓝牙传输
       *   wantAgent - 通知对象（用于定义点击通知后如何跳转）
       *   返回值是一个 ContinuousTaskNotification 对象
       *     notificationId - 长任务关联的通知 ID
       */
      backgroundTaskManager.startBackgroundRunning(context, ["dataTransfer"], wantAgentObj)
        .then((res: backgroundTaskManager.ContinuousTaskNotification) => {
          this.message += `startBackgroundRunning 成功，关联的通知ID:${res.notificationId}\n`;
          this.notificationId = res.notificationId
        }).catch((err: BusinessError) => {
          this.message += `startBackgroundRunning errCode:${err.code}, errMessage:${err.message}\n`
        });
    });
  }

  // 开始任务
  // 模拟数据下载任务
  async startTask() {
    for (let i = 1; i <= 10; i++) {
      await new Promise<string>(r => setTimeout(r, 1000));
      if (i > 5) {
        this.updateNotification(i * 10)
      }
    }
  }

  // 更新通知
  updateNotification(progressValue: number) {
    // 通知模版
    let downLoadTemplate: notificationManager.NotificationTemplate = {
      name: 'downloadTemplate', // 仅支持 downloadTemplate 下载模版
      data: {
        title: '文件下载', // 标题
        fileName: 'xxx.mp4', // 文件名
        progressValue: progressValue, // 下载进度（0 - 100 之间）
      }
    };

    // 通知对象
    let request: notificationManager.NotificationRequest = {
      // dataTransfer 类型的长时任务的绑定的通知要写死这个
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
        systemLiveView: { typeCode: 8, title: "title",  text: "text", } // 当前场景下 title 和 text 都是无效的，但是不能设置为空
      },
      notificationSlotType: notificationManager.SlotType.LIVE_VIEW, // dataTransfer 类型的长时任务的绑定的通知要写死这个
      id: this.notificationId, // 启动长时任务时，返回的其关联的通知 ID
      template: downLoadTemplate // 通知模版
    };

    // 发布通知
    notificationManager.publish(request).then(() => {
      this.message += `通知成功 notificationId:${request.id}, progressValue:${progressValue}\n`
    }).catch((err: BusinessError) => {
      this.message += `通知失败 errCode:${err.code}, errMessage:${err.message}\n`
    });
  }

  // 停止长时任务
  stopBackgroundRunning() {
    /*
     * backgroundTaskManager.stopBackgroundRunning() - 停止长时任务
     *   context - 上下文
     */
    backgroundTaskManager.stopBackgroundRunning(getContext()).then(() => {
      this.message += "stopBackgroundRunning 成功\n"
    }).catch((err: BusinessError) => {
      this.message += `stopBackgroundRunning errCode:${err.code}, errMessage:${err.message}\n`
    });
  }

  build() {
    Column({ space: 10 }) {
      Button("启动长时任务，并执行一个自定义的下载任务").onClick(() => {
        this.startBackgroundRunning()
        this.startTask()
      })

      Button("停止长时任务").onClick(() => {
        this.stopBackgroundRunning()
      })

      Text(this.message)
    }
  }
}