/**
 * 事件日志
 *
 * 事件日志是应用级的，需要时可以写入或监听事件日志
 * 系统遇到崩溃、卡死等情况时会写入事件日志，需要时可以监听它
 */

import { TitleBar } from '../TitleBar'
import { hiAppEvent } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct HiAppEventDemo {

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

  @State message: string = ""
  watcher: hiAppEvent.Watcher | undefined

  aboutToAppear(): void {
    /*
     * Watcher - 监听器对象，用于配置需要监听的事件日志
     *   name - 监听器的标识
     *   appEventFilters - 监听指定的日志
     *     domain - 需要监听的事件日志的事件领域
     *     eventTypes - 需要监听的事件日志的事件类型
     *     names - 需要监听的事件日志的事件名称
     *   triggerCondition - 监听到 appEventFilters 所指定的日志的前提条件
     *     row - 事件日志池里的日志的最少的条数
     *     size - 事件日志池里的日志的最小的字节数
     *     timeOut - 事件日志池里的日志的最小的存在的时长（单位：30秒）
     *   onTrigger() - 监听到指定日志后的回调
     *     curRow - 此次回调中的日志的条数
     *     curSize - 此次回调中的日志的字节数
     *     holder - 日志持有者
     *       takeNext() - 取日志，返回一个 AppEventPackage 对象，无日志可取则返回 null
     *         appEventInfos - 日志集合，一个 AppEventInfo 数组（这里的 AppEventInfo 数据就是 hiAppEvent.write() 时写入的 AppEventInfo 数据）
     * hiAppEvent.addWatcher() - 监听指定的监听器
     * hiAppEvent.removeWatcher() - 取消监听指定的监听器
     */
    this.watcher = {
      name: "watcher1",
      appEventFilters: [
        {
          domain: "my_button",
          eventTypes: [hiAppEvent.EventType.BEHAVIOR],
          names: ["my_click"]
        }
      ],
      triggerCondition: {
        row: 1
      },
      onTrigger: (curRow: number, curSize: number, holder: hiAppEvent.AppEventPackageHolder) => {
        this.message += `onTrigger curRow:${curRow}, curSize:${curSize}\n`

        let appEventPackage: hiAppEvent.AppEventPackage | null = null;
        while ((appEventPackage = holder.takeNext()) != null) {
          for (const appEventInfo of appEventPackage.appEventInfos) {
            this.message += `domain:${appEventInfo.domain}\n`
            this.message += `eventType:${appEventInfo.eventType}\n`
            this.message += `name:${appEventInfo.name}\n`
            this.message += `params:${JSON.stringify(appEventInfo.params)}\n`
          }
        }
      }
    };

    hiAppEvent.addWatcher(this.watcher);
  }

  aboutToDisappear(): void {
    if (this.watcher) {
      hiAppEvent.removeWatcher(this.watcher);
    }
  }

  build() {
    Column({ space: 10 }) {

      Button("写入事件日志").onClick(async () => {
        /*
         * AppEventInfo - 需要写入的事件日志
         *   domain - 事件领域，可以将其理解为事件所属的某个业务
         *   eventType - 事件类型（EventType 枚举）
         *     FAULT, STATISTIC, SECURITY, BEHAVIOR
         *   name - 事件名称
         *   params - 事件参数，一个 object 对象
         * hiAppEvent.write() - 写入指定的事件日志
         */
        let eventInfo: hiAppEvent.AppEventInfo = {
          domain: "my_button",
          name: "my_click",
          eventType: hiAppEvent.EventType.BEHAVIOR,
          params: { name: "webabcd", age: 44 },
        };
        await hiAppEvent.write(eventInfo)
      })

      Text(this.message)
    }
  }
}
