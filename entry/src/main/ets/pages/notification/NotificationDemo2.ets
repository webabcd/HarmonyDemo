/*
 * 通知（更新，删除，跳转，渠道）
 */

import { TitleBar } from '../TitleBar'
import { BusinessError } from '@kit.BasicServicesKit'
import { notificationManager } from '@kit.NotificationKit'
import { WantAgent, wantAgent } from '@kit.AbilityKit'
import { Helper } from '../../utils/Helper'

@Entry
@Component
struct NotificationDemo2 {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('更新').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('删除').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('跳转').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('渠道').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      /*
       * notificationManager.NotificationRequest - 通知对象
       *   id - 通知的标识（如果当前 app 发布的标识相同的通知已存在，则更新）
       */
      Button("更新 id 为 123 的通知").onClick(() => {
        let notificationRequest: notificationManager.NotificationRequest = {
          id: 123,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: `title 123`,
              text: `text ${Helper.getTimestampString()}`,
            }
          }
        }
        notificationManager.publish(notificationRequest, (err: BusinessError) => {
          if (err) {
            this.message = `发布通知失败 errCode:${err.code}, errMessage:${err.message}`
            return
          }
          this.message = `发布通知成功`
        })
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      /*
       * notificationManager.cancel() - 删除当前 app 发布的指定 id 的通知
       * notificationManager.cancelAll() - 删除当前 app 发布的全部通知
       */
      Button("删除 id 为 123 的通知").onClick(() => {
        notificationManager.cancel(123, (err: BusinessError) => {
          if (err) {
            this.message = `删除通知失败 errCode:${err.code}, errMessage:${err.message}`
            return
          }
          this.message = `删除通知成功`
        });
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

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
       * Want - 点击通知后，拉起的 ability 的相关信息（关于 Want 的更多信息请参见 /ipc/WantDemo.ets 中的相关说明）
       *   bundleName - bundle 名称
       *   moduleName - module 名称
       *   abilityName - ability 名称
       *   parameters - 传递给拉起的 ability 的数据
       *     冷启动时，通过 UIAbility 的 onCreate() 的 want.parameters 获取
       *     热启动时，通过 UIAbility 的 onNewWant() 的 want.parameters 获取
       *
       * notificationManager.NotificationRequest - 通知对象
       *   wantAgent - 通知关联的 WantAgent 对象
       */
      Button("点击通知后跳转到指定的应用").onClick(() => {
        // 建 wantAgentInfo 对象
        let wantAgentInfo:wantAgent.WantAgentInfo = {
          wants: [
            {
              bundleName: 'com.webabcd.harmonydemo',
              abilityName: 'com.webabcd.harmonydemo.EntryAbility',
              parameters: { // 传参
                'k1': 'v1',
                'k2': 'v2',
              }
            }
          ],
          requestCode: 0,
          actionType: wantAgent.OperationType.START_ABILITY,
        }

        // 创建 WantAgent 对象（异步的，通过回调返回创建的 WantAgent 对象）
        wantAgent.getWantAgent(wantAgentInfo, (err: BusinessError, data:WantAgent) => {
          if (err) {
            this.message = `创建 WantAgent 失败 errCode:${err.code}, errMessage:${err.message}`
            return;
          }

          let notificationRequest: notificationManager.NotificationRequest = {
            id: 456,
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
              normal: {
                title: `title 456`,
                text: `text`,
              }
            },
            wantAgent: data,
          }
          notificationManager.publish(notificationRequest, (err: BusinessError) => {
            if (err) {
              this.message = `发布通知失败 errCode:${err.code}, errMessage:${err.message}`
              return
            }
            this.message = `发布通知成功`
          })
        });
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      /*
       * 通知支持多种渠道（slot）类型，不同的渠道类型有不同的通知提醒方式
       *
       * notificationManager.NotificationRequest - 通知对象
       *   notificationSlotType - 通知渠道的类型（SlotType 枚举）
       *     UNKNOWN_TYPE - 未知（仅在通知中心显示）
       *     OTHER_TYPES - 其他（仅在通知中心显示）
       *     SOCIAL_COMMUNICATION - 社交通信（显示在通知中心和状态栏，支持弹出横幅，支持响铃和震动，支持锁屏通知）
       *     SERVICE_INFORMATION - 服务信息（显示在通知中心和状态栏，支持弹出横幅，支持响铃和震动，支持锁屏通知）
       *     CONTENT_INFORMATION - 内容信息（仅在通知中心显示）
       *     CUSTOMER_SERVICE - 客户服务（显示在通知中心和状态栏，支持响铃和震动）
       *
       * 注：如要支持弹出横幅，响铃震动，锁屏通知等，则除了指定合适的渠道类型外，还需要保证在系统的通知设置页中开启了当前 app 的相关权限
       */
      Button("通知渠道").onClick(() => {
        let notificationRequest: notificationManager.NotificationRequest = {
          id: 789,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: `title 123`,
              text: `text`,
            }
          },
          // SERVICE_INFORMATION 类型可以支持弹出横幅通知（注：前提是在系统的通知设置页中开启了当前 app 的横幅通知权限）
          notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION
        }
        notificationManager.publish(notificationRequest, (err: BusinessError) => {
          if (err) {
            this.message = `发布通知失败 errCode:${err.code}, errMessage:${err.message}`
            return
          }
          this.message = `发布通知成功`
        })
      })

      Text(this.message)
    }
  }
}