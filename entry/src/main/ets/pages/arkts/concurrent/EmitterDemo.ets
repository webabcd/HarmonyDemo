/*
 * emitter - 用于同一进程内不同线程间或同一线程内发送和订阅事件
 *   可用于线程间通信
 *   可用于不同页面之间的通信
 *
 * emitter - 通知的发布与订阅
 *   once() - 订阅通知（只接收一次）
 *   on() - 订阅通知（一直接收直到取消订阅为止）
 *     event - 需要订阅的通知的标识（一个 InnerEvent 对象）
 *     callback - 接收到通知后的回调（回调参数是一个 EventData 对象）
 *   emit() - 发布通知
 *     event - 需要发布的通知的标识（一个 InnerEvent 对象）
 *     EventData - 需要发布的通知的数据（一个 EventData 对象）
 *   off() - 取消订阅
 * InnerEvent - 订阅或发布的通知的标识
 *   eventId - 标识
 *   priority - 优先级（EventPriority 枚举）
 *     优先级从高到低分别为 IMMEDIATE, HIGH, LOW, IDLE
 * EventData - 发布的或接收到的通知的数据
 *   data - 自定义的 key/value 数据
 */

import { MyLog, TitleBar } from '../../TitleBar';
import { taskpool } from '@kit.ArkTS';
import { emitter } from '@kit.BasicServicesKit';

@Concurrent
async function fun(): Promise<void> {
  let count = 0
  while (count < 10) {
    await new Promise<void>((r) => {
      setTimeout(r, 1000)
    })

    let event: emitter.InnerEvent = {
      eventId: 1, // 通知的标识
      priority: emitter.EventPriority.IMMEDIATE // 优先级
    };

    // 发布的通知的数据
    let eventData: emitter.EventData = {
      data: {
        mykey: 'myvalue',
        count: count
      }
    };

    // 发布指定的通知
    emitter.emit(event, eventData);

    count ++
  }
}
async function sample(): Promise<void> {
  try {
    let task: taskpool.Task = new taskpool.Task(fun)
    await taskpool.execute(task)
  } catch (e) {
    MyLog.d(`error: ${JSON.stringify(e)}`)
  }
}

@Entry
@Component
struct EmitterDemo {

  @State message:string = ""

  aboutToAppear(): void {

    let event: emitter.InnerEvent = {
      eventId: 1, // 通知的标识
      priority: emitter.EventPriority.IMMEDIATE // 优先级
    };

    // 订阅通知的回调
    let callback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
      this.message += `${eventData.data?.["mykey"]}, ${eventData.data?.["count"]}\n`
    }

    // 订阅指定的通知
    emitter.on(event, callback);
  }

  aboutToDisappear(): void {
    // 取消指定标识的订阅
    emitter.off(1)
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Button("启动一个线程")
        .onClick(async () => {
          this.message += `开始\n`
          await sample()
          this.message += `结束\n`
        })
    }
  }
}