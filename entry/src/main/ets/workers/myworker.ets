import { worker, ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@kit.ArkTS';
import { MySendableObject } from '../pages/arkts/concurrent/WorkerDemo';
import { common, sendableContextManager } from '@kit.AbilityKit';

// 创建一个用于当前工作线程与宿主线程之间通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 接收到宿主线程传递过来的消息后的回调
workerPort.onmessage = async (e: MessageEvents) => {

  // e.data 就是工作线程传递过来的消息
  if (typeof e.data == 'string') {
    // 宿主线程传递过来的是一个 string 类型的数据
    let message = e.data as string
    console.info('workerPort onmessage: ', message);
  } else {
    // 宿主线程传递过来的是一个 @Sendable 对象
    let sendableObject: MySendableObject = e.data
    let sendableContext: sendableContextManager.SendableContext = sendableObject.getSendableContext()
    // 从 SendableContext 中解析出 context
    let context: common.Context = sendableContextManager.convertToContext(sendableContext) as common.Context;
    console.info('workerPort onmessage: ', sendableObject.getData(), context.applicationInfo.name);
  }

  await new Promise<void>((r) => { setTimeout(r, 1000) })

  // 传递指定的消息给宿主线程
  workerPort.postMessage(`worker to main`)

  // 销毁当前工作线程
  workerPort.close();
}

// 接收到宿主线程传递过来的无法被反序列化的消息后的回调
workerPort.onmessageerror = (event: MessageEvents) => {
  console.info('workerPort onmessageerror: ', event.data);
};

// 发生异常时的回调
workerPort.onerror = (event: ErrorEvent) => {
  console.info('workerPort onerror: ', event.message);
};