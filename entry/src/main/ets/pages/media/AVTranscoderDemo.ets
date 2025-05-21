/*
 * AVTranscoder - 视频转码
 *
 * 先创建 worker 线程文件
 * 1、在 /src/main/ets/ 目录层级之下创建一个 .ets 文件，本例创建的文件是 /src/main/ets/workers/transcodeworker.ets
 * 2、编辑 build-profile.json5 文件，并添加类似如下的内容
 * {
 *   "apiType": "stageMode",
 *   "buildOption": {
 *     "sourceOption": {
 *       "workers": [
 *         './src/main/ets/workers/transcodeworker.ets'
 *       ]
 *     }
 *   }
 * }
 */

import { TitleBar } from '../TitleBar'
import { sendableContextManager } from '@kit.AbilityKit';
import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS';

@Entry
@Component
struct AVTranscoderDemo {

  build() {
    Column({ space: 10 }) {
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

  @State message:string = ""

  // 创建 worker 线程做转码
  async startWorker() {

    // 通过指定的 worker 线程文件创建工作线程对象（注：此处的文件路径要省略 src/main/）
    let threadWorker = new worker.ThreadWorker('entry/ets/workers/transcodeworker.ets');

    // 接收到工作线程传递过来的消息后的回调
    threadWorker.onmessage = (event: MessageEvents) => {
      // e.data 就是工作线程传递过来的消息
      this.message += `onmessage: ${event.data}\n`

      if (event.data == 'finish') {
        // 如果 worker 线程传来了 'finish' 则终止 worker 线程
        threadWorker.terminate();
      }
    }

    // 接收到工作线程传递过来的无法被反序列化的消息后的回调
    threadWorker.onmessageerror = (event: MessageEvents) => {
      this.message += `onmessageerror: ${event.data}\n`
    }

    // 工作线程运行中出现异常后的回调
    threadWorker.onerror = (err: ErrorEvent) => {
      this.message += `onerror: ${err.message}\n`
    }

    // 工作线程被销毁后的回调（code 为 0 代表正常退出，code 为 1 代表异常退出）
    threadWorker.onexit = (code: number) => {
      this.message += `onexit: ${code}\n`
    }

    // 向 worker 线程发送消息
    let context = this.getUIContext().getHostContext();
    if (context != undefined) {
      const sendableContext: sendableContextManager.SendableContext = sendableContextManager.convertFromContext(context);
      // 需要转码的文件的 rawfile 地址
      let sourceFilePath = "video/mp4.mp4"
      // 转码后的文件的沙箱地址
      let transcodedFilePath = context.getApplicationContext().filesDir + "/" + "mp4_transcoded.mp4";
      const sendableObject: MySendableObject = new MySendableObject(sendableContext, sourceFilePath, transcodedFilePath);
      threadWorker.postMessageWithSharedSendable(sendableObject);
    }
  }

  build() {
    Column({space:10}) {
      Text(this.message).fontSize(16)

      Button("click me").fontSize(16).onClick(async () => {
        await this.startWorker();
      })
    }
  }
}

// 用于在线程之间传递的 @Sendable 对象
@Sendable
export class MySendableObject {
  constructor(sendableContext: sendableContextManager.SendableContext, rawfilePath: string, transcodedFilePath: string) {
    this.sendableContext = sendableContext;
    this.rawfilePath = rawfilePath;
    this.transcodedFilePath = transcodedFilePath;
  }

  // 用于封装 context 对象
  private sendableContext: sendableContextManager.SendableContext;
  // 需要转码的文件的 rawfile 地址
  private rawfilePath: string;
  // 转码后的文件的沙箱地址
  private transcodedFilePath: string;

  public getSendableContext() {
    return this.sendableContext;
  }

  public getRawfilePath() {
    return this.rawfilePath;
  }

  public getTranscodedFilePath() {
    return this.transcodedFilePath;
  }
}