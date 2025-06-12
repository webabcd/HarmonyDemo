/**
 * commonEventManager - 用于进程间通信，以及订阅系统事件
 *
 * 可以用于监听系统事件，或者监听任意应用发布的公共事件，也可以发布自定义的公共事件
 * 监听流程是：先创建订阅者（包括需要订阅的事件等），然后再监听订阅者
 */

import { MyLog, TitleBar } from '../TitleBar'
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit'
import { Helper } from '../../utils/Helper'

@Entry
@Component
struct CommonEventManagerDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        // 监听系统事件（以监听电量的变化为例）
        TabContent() { MySample1() }.tabBar('监听系统事件').align(Alignment.Top)
        // 发布和监听公共事件（可以用于进程间通信）
        TabContent() { MySample2() }.tabBar('发布和监听公共事件').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  subscriber: commonEventManager.CommonEventSubscriber | undefined

  aboutToAppear(): void {

    /*
     * CommonEventSubscribeInfo - 订阅信息
     *   events - 需要订阅的事件的名称
     *     比如 commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED 是电池状态发生变化时的事件
     *     其他事件参见 https://developer.huawei.com/consumer/cn/doc/harmonyos-references/commoneventmanager-definitions#common_event_battery_changed
     * commonEventManager.createSubscriber() - 通过指定的 CommonEventSubscribeInfo 对象创建订阅者（回调参数是一个 CommonEventSubscriber 对象）
     * commonEventManager.subscribe() - 订阅指定的 CommonEventSubscriber 对象的事件（接收到事件后会回调，回调参数是一个 CommonEventData 对象）
     * CommonEventData - 事件对象
     *   event - 事件的名称
     *   parameters - 事件的数据
     * commonEventManager.unsubscribe() - 取消指定的 CommonEventSubscriber 对象的订阅
     */

    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      // 电池状态发生变化时的事件
      // 运行本例时，可以监听到电池状态的变化（比如电量的变化等）
      events: [commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED],
    };

    // 创建订阅者
    commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
      if (err) {
        this.message = `commonEventManager.createSubscriber errCode:${err.code}, errMessage:${err.message}`
        return;
      }

      this.subscriber = data;
      // 监听订阅者
      commonEventManager.subscribe(this.subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          this.message = `commonEventManager.subscribe errCode:${err.code}, errMessage:${err.message}`
          return;
        }

        if (data.event == commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED) {
          this.message = `当前电量：${data.parameters?.["soc"]}` // 获取当前电池的电量
        }
      })
    })
  }

  aboutToDisappear(): void {
    if (this.subscriber) {
      // 取消监听订阅者
      commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {

      })
    }
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  subscriber: commonEventManager.CommonEventSubscriber | undefined

  aboutToAppear(): void {

    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      // 监听任意应用发布的名为 my_event 的公共事件
      // 注：如果需要限制发布者的包名，可以通过设置 publisherBundleName 字段实现
      events: ['my_event'],
    };

    commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
      this.subscriber = data;
      commonEventManager.subscribe(this.subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
        this.message = `event:${data.event}\n` // 事件的名称
        this.message += `code:${data.code}\n` // 事件的 code
        this.message += `data:${data.data}\n` // 事件的 data
        this.message += `parameters(key1):${data.parameters?.["key1"]}\n` // 事件的 parameters
        this.message += `parameters(timestamp):${data.parameters?.["timestamp"]}\n` // 事件的 parameters
      })
    })
  }

  aboutToDisappear(): void {
    if (this.subscriber) {
      // 取消监听订阅者
      commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {

      })
    }
  }

  build() {
    Column({ space: 10 }) {

      Button('发布一个公共事件').onClick(() => {
        /*
         * CommonEventPublishData - 需要发布的公共事件的数据
         *   code - 事件的 code
         *   data - 事件的 data
         *   parameters - 事件的 parameters
         * commonEventManager.publish() - 发布指定的公共事件
         *   event - 发布的公共事件的名称
         *   options - 发布的 CommonEventPublishData 对象
         */
        let options: commonEventManager.CommonEventPublishData = {
          code: 123, // 公共事件的初始代码
          data: 'my_data', // 公共事件的初始数据
          parameters: {
            key1: 'value1',
            timestamp: Helper.getTimestampString(),
          }
        };

        commonEventManager.publish('my_event', options, (err: BusinessError) => {
          if (err) {
            this.message = `commonEventManager.publish errCode:${err.code}, errMessage:${err.message}`
          }
        });
      })

      Text(this.message)
    }
  }
}
