/**
 * HiAppEvent（事件日志）
 *
 * 在应用内，需要时可以写入事件日志，此时可以在应用中的需要的地方监听到写入的事件日志
 * 在应用内，可以监听到系统写入的事件日志，比如崩溃、卡死等
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
        // 本例用于演示如何在应用内写入和监听自定义的事件日志
        TabContent() { MySample1() }.tabBar('应用的事件日志').align(Alignment.Top)
        // 本例用于演示如何监听崩溃和卡死日志，其他的如内存泄漏，滑动丢帧，cpu 高负载等日志请参见文档
        TabContent() { MySample2() }.tabBar('系统的事件日志').align(Alignment.Top)
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
     *   triggerCondition - 触发 onTrigger() 回调的前提条件
     *     row - 事件日志池里的日志的最少的条数
     *     size - 事件日志池里的日志的最小的字节数
     *     timeOut - 事件日志池里的日志的最小的存在的时长（单位：30秒）
     *   onTrigger() - 监听到指定日志后的回调（需要结合 triggerCondition）
     *     curRow - 此次回调中的日志的条数
     *     curSize - 此次回调中的日志的字节数
     *     holder - 日志持有者
     *       takeNext() - 取日志，返回一个 AppEventPackage 对象，无日志可取则返回 null
     *         appEventInfos - 日志集合，一个 AppEventInfo 数组（这里的 AppEventInfo 数据就是 hiAppEvent.write() 时写入的 AppEventInfo 数据）
     *   onReceive() - 监听到指定日志后的回调（不需要结合 triggerCondition），如果设置了 onReceive() 则 onTrigger() 会失效
     *     注：关于 onReceive() 的说明和示例请参见 MySample2
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
      },
      onReceive: (domain: string, appEventGroups: Array<hiAppEvent.AppEventGroup>) => {
        this.message += `onReceive domain:${domain}\n`
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
         *     FAULT(1), STATISTIC(2), SECURITY(3), BEHAVIOR(4)
         *   name - 事件名称
         *   params - 事件参数，一个 object 对象
         * hiAppEvent.write() - 写入指定的事件日志
         */
        let appEventInfo: hiAppEvent.AppEventInfo = {
          domain: "my_button",
          name: "my_click",
          eventType: hiAppEvent.EventType.BEHAVIOR,
          params: { name: "webabcd", age: 44 },
        };
        await hiAppEvent.write(appEventInfo)
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""
  watcher: hiAppEvent.Watcher | undefined

  aboutToAppear(): void {
    /*
     * Watcher - 监听器对象，用于配置需要监听的事件日志
     *   注：关于 Watcher 的说明和示例请参见 MySample1
     *   onReceive() - 监听到指定日志后的回调（不需要结合 triggerCondition），如果设置了 onReceive() 则 onTrigger() 会失效
     *     domain - 事件领域，可以将其理解为事件所属的某个业务
     *     appEventGroups - 事件组（一个 AppEventGroup 对象）
     *       name - 事件名称
     *       appEventInfos - 日志集合，一个 AppEventInfo 数组
     * AppEventInfo - 事件日志
     *   domain - 事件领域，可以将其理解为事件所属的某个业务
     *   eventType - 事件类型（EventType 枚举）
     *     FAULT(1), STATISTIC(2), SECURITY(3), BEHAVIOR(4)
     *   name - 事件名称
     *   params - 事件参数
     *     time - 事件的触发的时间，单位：毫秒
     *     crash_type - 崩溃类型（JsError 或 NativeCrash）
     *     foreground - 事件触发时是否处于前台状态
     *     bundle_version - 应用版本
     *     bundle_name - 应用名称
     *     pid - 进程 id
     *     uid - 用户 id
     *     uuid - 故障的特征码，用于标识特征相同的故障
     *     exception - 异常信息
     *     hilog - 事件触发当下的最近的 100 条 hilog 日志
     *     threads - 线程调用栈信息
     *     external_log - 故障日志文件的路径
     *     log_over_limit - 所有的故障日志文件的总大小是否超过了 5MB 的上限，如果超过了则会导致故障日志写入失败，所以处理完 external_log 日志后要及时清理
     * hiAppEvent.addWatcher() - 监听指定的监听器
     * hiAppEvent.removeWatcher() - 取消监听指定的监听器
     */
    this.watcher = {
      name: "watcher2",
      appEventFilters: [
        {
          // 监听系统日志
          domain: hiAppEvent.domain.OS,
          // 监听崩溃和卡死日志，其他的如内存泄漏，滑动丢帧，cpu 高负载等日志请参见文档
          names: [hiAppEvent.event.APP_CRASH, hiAppEvent.event.APP_FREEZE]
        }
      ],
      onReceive: (domain: string, appEventGroups: Array<hiAppEvent.AppEventGroup>) => {
        this.message += `onReceive domain:${domain}\n\n`
        for (const appEventGroup of appEventGroups) {
          this.message += `appEventGroup.name:${appEventGroup.name}\n\n`
          for (const appEventInfo of appEventGroup.appEventInfos) {
            this.message += `appEventInfo.domain:${appEventInfo.domain}\n\n`
            this.message += `appEventInfo.name:${appEventInfo.name}\n\n`
            this.message += `appEventInfo.eventType:${appEventInfo.eventType}\n\n`
            this.message += `appEventInfo.params.time:${appEventInfo.params['time']}\n\n`
            this.message += `appEventInfo.params.crash_type:${appEventInfo.params['crash_type']}\n\n`
            this.message += `appEventInfo.params.foreground:${appEventInfo.params['foreground']}\n\n`
            this.message += `appEventInfo.params.bundle_version:${appEventInfo.params['bundle_version']}\n\n`
            this.message += `appEventInfo.params.bundle_name:${appEventInfo.params['bundle_name']}\n\n`
            this.message += `appEventInfo.params.pid:${appEventInfo.params['pid']}\n\n`
            this.message += `appEventInfo.params.uid:${appEventInfo.params['uid']}\n\n`
            this.message += `appEventInfo.params.uuid:${appEventInfo.params['uuid']}\n\n`
            this.message += `appEventInfo.params.exception:${JSON.stringify(appEventInfo.params['exception'])}\n\n`
            this.message += `appEventInfo.params.hilog:${appEventInfo.params['hilog']}\n\n`
            this.message += `appEventInfo.params.threads:${JSON.stringify(appEventInfo.params['threads'])}\n\n`
            this.message += `appEventInfo.params.external_log:${appEventInfo.params['external_log']}\n\n`
            this.message += `appEventInfo.params.log_over_limit:${appEventInfo.params['log_over_limit']}\n\n`
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

      Button("模拟崩溃").onClick(()=>{
        let result: object = JSON.parse("");
      })

      Button("模拟卡死").onClick(()=>{
        setTimeout(() => {
          while (true) {

          }
        }, 0)
      })

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}
