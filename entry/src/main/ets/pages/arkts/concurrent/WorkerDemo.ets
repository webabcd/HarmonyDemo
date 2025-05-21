/*
 * Worker - 工作线程
 *   需要手动管理
 *   线程之间的通信是基于消息传递的，传递的消息必须是可序列化的
 *
 * 自动创建 worker 线程文件的方法：打开 DevEco Studio 然后依次点击 File -> New -> Worker
 * 手动创建 worker 线程文件的方法：
 * 1、在 /src/main/ets/ 目录层级之下创建一个 .ets 文件，本例创建的文件是 /src/main/ets/workers/myworker.ets
 * 2、编辑 build-profile.json5 文件，并添加类似如下的内容
 * {
 *   "apiType": "stageMode",
 *   "buildOption": {
 *     "sourceOption": {
 *       "workers": [
 *         './src/main/ets/workers/myworker.ets'
 *       ]
 *     }
 *   }
 * }
 *
 *
 * 注：
 * 1、无法用 Previewer 测试 Worker，需要用模拟器或真机
 * 2、关于 Promise 和 async/await 请参见 arkts/advanced/Promise.ets, arkts/advanced/AsyncAwait.ets 中的相关说明
 */

import { TitleBar } from '../../TitleBar';
import { worker, MessageEvents, ErrorEvent } from '@kit.ArkTS';
import { sendableContextManager } from '@kit.AbilityKit';

@Entry
@Component
struct WorkerDemo {

  @State message:string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button("click me")
        .fontSize(16)
        .onClick(() => {

          this.message += `start\n`

          // 通过指定的 worker 线程文件创建工作线程对象（注：此处的文件路径要省略 src/main/）
          let threadWorker = new worker.ThreadWorker('entry/ets/workers/myworker.ets');

          // 接收到工作线程传递过来的消息后的回调
          threadWorker.onmessage = (e: MessageEvents) => {
            // e.data 就是工作线程传递过来的消息
            this.message += `onmessage:${e.data}\n`
          }

          // 工作线程被销毁后的回调（code 为 0 代表正常退出，code 为 1 代表异常退出）
          threadWorker.onexit = (code: number) => {
            this.message += `onexit:${code}\n`
          }

          // 工作线程运行中出现异常后的回调
          threadWorker.onerror = (err: ErrorEvent) => {
            this.message += `onerror:${err.message}\n`
          }

          // postMessage() - 传递指定的消息给工作线程
          threadWorker.postMessage("main to worker（postMessage）");

          // postMessageWithSharedSendable() - 传递指定的 @Sendable 对象给工作线程
          let context = this.getUIContext().getHostContext()
          if (context) {
            // 将 context 封装为 SendableContext（在工作线程中可以从 SendableContext 中解析出 context）
            const sendableContext: sendableContextManager.SendableContext = sendableContextManager.convertFromContext(context)
            const sendableObject: MySendableObject = new MySendableObject(sendableContext, "main to worker（postMessageWithSharedSendable）");
            threadWorker.postMessageWithSharedSendable(sendableObject);
          }
        })
    }
  }
}

// 用于在线程之间传递的 @Sendable 对象
@Sendable
export class MySendableObject {
  constructor(sendableContext: sendableContextManager.SendableContext, data: string = '') {
    this.sendableContext = sendableContext;
    this.data = data;
  }

  // 用于封装 context 对象
  private sendableContext: sendableContextManager.SendableContext;
  // 需要在线程之间传递的数据
  private data: string;

  public getSendableContext() {
    return this.sendableContext;
  }

  public getData() {
    return this.data;
  }
}