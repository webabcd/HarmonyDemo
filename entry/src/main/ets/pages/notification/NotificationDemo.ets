/*
 * 通知（授权，文本，进度条，角标）
 */

import { TitleBar } from '../TitleBar'
import { BusinessError } from '@kit.BasicServicesKit'
import { notificationManager } from '@kit.NotificationKit'
import { common, Want } from '@kit.AbilityKit'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct NotificationDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('请求通知授权').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('普通文本通知').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('多行文本通知').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('下载进度条通知').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('应用图标的数字角标').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  /*
   * notificationManager.isNotificationEnabled() - 是否授权了通知
   * notificationManager.requestEnableNotification() - 请求通知授权
   *   错误代码 1600004 代表用户拒绝授权
   */

  // 请求通知授权
  requestEnableNotification() {
    let context = getContext(this) as common.UIAbilityContext;
    // 判断是否有通知授权
    notificationManager.isNotificationEnabled().then((isNotificationEnabled: boolean) => {
      this.message = `isNotificationEnabled: ${isNotificationEnabled}`;
      if (!isNotificationEnabled) {
        // 请求通知授权
        notificationManager.requestEnableNotification(context).then(() => {
          this.message = `requestEnableNotification 成功`;
        }).catch((err : BusinessError) => {
          if (1600004 == err.code) {
            // 用户拒绝授权
            this.message = `requestEnableNotification 被拒绝, errCode:${err.code}, errMessage:${err.message}`;
          } else {
            // 请求通知授权失败
            this.message = `requestEnableNotification 失败, errCode:${err.code}, errMessage:${err.message}`;
          }
          // 打开当前 app 的设置页
          this.startAbility_appSettings_withDialog()
        });
      }
    }).catch((err : BusinessError) => {
      this.message = `isNotificationEnabled 失败, errCode:${err.code}, errMessage:${err.message}`;
    });
  }

  // 打开当前 app 的设置页（先弹出提示用的对话框）
  startAbility_appSettings_withDialog() {
    promptAction.showDialog({
      title: '提示',
      message: '需要在设置页中允许通知',
      buttons: [
        { text: '好的', color: '#ff0000' },
      ],
    }, (err, data) => {
      if (err) {
        return;
      }
      this.startAbility_appSettings()
    });
  }

  // 打开当前 app 的设置页
  startAbility_appSettings() {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      uri: "application_info_entry",
      parameters: {
        pushParams: context.abilityInfo.bundleName
      }
    };
    context.startAbility(want).then(() => { }).catch((err: BusinessError) => { })
  }

  build() {
    Column({ space: 10 }) {
      Button("请求通知授权").onClick(() => {
        this.requestEnableNotification()
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
       * notificationManager.publish() - 发布指定的 notificationManager.NotificationRequest 对象
       *
       * notificationManager.NotificationRequest - 通知对象
       *   id - 通知的标识（如果当前 app 发布的标识相同的通知已存在，则更新）
       *   content - 通知的内容（一个 NotificationContent 对象）
       *     notificationContentType - 通知的类型
       *       NOTIFICATION_CONTENT_BASIC_TEXT - 普通文本，自动换行，最多 3 行，溢出部分用 ... 代替
       *     normal - 普通文本的内容
       *       title - 标题
       *       text - 详细内容
       */
      Button("普通文本通知").onClick(() => {
        let notificationId = Math.floor(Math.random() * 1000)
        let notificationRequest: notificationManager.NotificationRequest = {
          id: notificationId,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: `title ${notificationId}`,
              text: 'texttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttext',
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
struct MySample3 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      /*
       * notificationManager.publish() - 发布指定的 notificationManager.NotificationRequest 对象
       *
       * notificationManager.NotificationRequest - 通知对象
       *   id - 通知的标识（如果当前 app 发布的标识相同的通知已存在，则更新）
       *   content - 通知的内容（一个 NotificationContent 对象）
       *     notificationContentType - 通知的类型
       *       NOTIFICATION_CONTENT_MULTILINE - 多行文本，不会自动换行，最多 3 行，溢出部分用 ... 代替
       *     multiLine - 多行文本的内容
       *       longTitle - 标题
       *       lines - 每行的详细内容
       */
      Button("多行文本通知").onClick(() => {
        let notificationId = Math.floor(Math.random() * 1000)
        let notificationRequest: notificationManager.NotificationRequest = {
          id: notificationId,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE,
            multiLine: {
              title: 'title',
              text: 'text',
              briefText: 'briefText',
              longTitle: `longTitle ${notificationId}`,
              lines: [
                'line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1line1',
                'line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2line2',
                'line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3line3',
                'line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4line4'
              ],
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
struct MySample4 {

  @State message: string = ""

  intervalId: number = 0
  progressValue: number = 0

  aboutToAppear(): void {
    notificationManager.isSupportTemplate('downloadTemplate').then((IsSupported:boolean) => {
      this.message = `是否支持下载进度条类型的通知 ${IsSupported}`
    }).catch((err: BusinessError) => {

    });
  }

  build() {
    Column({ space: 10 }) {
      /*
       * notificationManager.publish() - 发布指定的 notificationManager.NotificationRequest 对象
       *
       * notificationManager.NotificationRequest - 通知对象
       *   id - 通知的标识（如果当前 app 发布的标识相同的通知已存在，则更新）
       *   content - 通知的内容，对于下载进度条通知来说，随便设置即可
       *   template - 模板
       *     name - 模板名称，下载进度条模板为 downloadTemplate
       *     data - 详细内容
       *       title - 标题
       *       fileName - 下载文件名
       *       progressValue - 下载进度（0 - 100 之间）
       */
      Button("下载进度条通知").onClick(() => {
        clearInterval(this.intervalId)
        this.intervalId = setInterval(() => {
          this.progressValue += 10
          if (this.progressValue > 100) {
            this.progressValue = 0
          }

          let notificationRequest: notificationManager.NotificationRequest = {
            id: 666,
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
              normal: { title: 'title', text: 'text', }
            },
            template: {
              name: 'downloadTemplate',
              data: {
                title: 'title 666',
                fileName: 'xxx.mp4',
                progressValue: this.progressValue
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
        }, 1000)
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      /*
       * notificationManager.setBadgeNumber() - 设置应用图标的数字角标
       *   badgeNumber - 角标显示的数字，超过 99 时会显示 99+
       *   callback - 设置后的回调
       */
      Button("应用图标的数字角标").onClick(() => {
        let setBadgeNumberCallback = (err: BusinessError): void => {
          if (err) {
            this.message = `设置角标 errCode:${err.code}, errMessage:${err.message}`
            return
          }
          this.message = `设置角标成功`
        }

        let badgeNumber = 123;
        notificationManager.setBadgeNumber(badgeNumber, setBadgeNumberCallback);
      })

      Text(this.message)
    }
  }
}