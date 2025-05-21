import { worker, ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@kit.ArkTS';

// 创建一个用于当前工作线程与宿主线程之间通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 接收到宿主线程传递过来的消息后的回调
workerPort.onmessage = async (e: MessageEvents) => {

  console.info('workerPort onmessage');

  await new Promise<void>((r) => { setTimeout(r, 1000) })

  // e.data 就是工作线程传递过来的消息
  let message = e.data as string

  // 传递指定的消息给宿主线程
  workerPort.postMessage(`receive:${e.data}, send:worker to main`)

  // 销毁当前工作线程
  workerPort.close();
}

// 接收到宿主线程传递过来的无法被反序列化的消息后的回调
workerPort.onmessageerror = (event: MessageEvents) => {
  console.info('workerPort onmessageerror');
};

// 发生异常时的回调
workerPort.onerror = (event: ErrorEvent) => {
  console.info('workerPort onerror: ', event.message);
};