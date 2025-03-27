/*
 * 提醒任务（提供倒计时提醒或闹钟提醒或日历提醒）
 *
 * 提醒任务支持在 app 死掉后执行
 *
 * 1、需要在 src/main/module.json5 中添加提醒任务权限，类似如下
 * {
 *   "module": {
 *     "requestPermissions":[
 *       {
 *         "name": "ohos.permission.PUBLISH_AGENT_REMINDER", // 请求提醒任务的权限
 *         "reason": "$string:hello_webabcd", // 申请此权限的原因
 *         "usedScene": {
 *           "abilities": [ ],
 *           "when":"always" // inuse（使用时允许使用此权限），always（始终允许使用此权限）
 *         }
 *       },
 *     ]
 *   }
 * }
 * 2、需要通过 notificationManager.requestEnableNotification() 请求通知授权
 */

import {  TitleBar } from '../TitleBar';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationManager } from '@kit.NotificationKit';
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct ReminderTaskDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('请求通知授权').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('倒计时提醒').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('闹钟提醒').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('日历提醒').align(Alignment.Top)
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
          if(1600004 == err.code){
            // 用户拒绝授权
            this.message = `requestEnableNotification 被拒绝, errCode:${err.code}, errMessage:${err.message}`;
          } else {
            // 请求通知授权失败
            this.message = `requestEnableNotification 失败, errCode:${err.code}, errMessage:${err.message}`;
          }
          // 打开系统的通知设置页
          this.startAbility_notification_settings()
        });
      }
    }).catch((err : BusinessError) => {
      this.message = `isNotificationEnabled 失败, errCode:${err.code}, errMessage:${err.message}`;
    });
  }

  // 打开系统的通知设置页
  startAbility_notification_settings() {
    let context = getContext(this) as common.UIAbilityContext;

    let want: Want = {
      /*
       * uri - 需要跳转到的系统设置页面的名称
       *   systemui_notification_settings - 系统的通知设置页
       *   wifi_entry - 系统的 wifi 设置页
       * 注：找到想要的系统设置页面的名称的方法如下
       * 1、在 HiLog 中过滤 SettingsHome 相关的日志
       * 2、打开设置 app 并进入到想要的设置页面
       * 3、比如 wifi 设置页面，则可以在日志中找到 my router: wifi_entry
       */
      uri: 'systemui_notification_settings'
    };

    /*
    // 跳转到设置 app 的 Want 对象
    let want: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
    };
    */

    context.startAbility(want).then(() => {

    }).catch((err: BusinessError) => {

    });
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
  // 提醒 ID
  reminderId: number = 0

  // 发布一个倒计时提醒（倒计时结束后会弹出一个通知）
  publishReminder() {
    // 构造一个 ReminderRequestTimer 类型的倒计时提醒
    let reminderRequestTimer: reminderAgentManager.ReminderRequestTimer = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER, // 倒计时提醒
      triggerTimeInSeconds: 10, // 倒计时的起始秒数
      actionButton: [ // 通知上显示的按钮的标题和类型
        {
          title: '关闭',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        }
      ],
      wantAgent: { // 点击通知后，拉起的 ability 的相关信息
        pkgName: 'com.webabcd.harmonydemo',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility'
      },
      title: 'title', // 通知的标题
      content: 'content', // 通知的内容
      expiredContent: 'expiredContent', // 提醒过期后通知的内容（倒计时结束后弹出通知，会先显示 content 然后马上就会显示 expiredContent）
      notificationId: 1, // 通知 ID
    }

    // 发布指定的提醒，返回提醒 ID
    reminderAgentManager.publishReminder(reminderRequestTimer).then((reminderId: number) => {
      this.message = `publishReminder 成功, reminderId:${reminderId}`;
      this.reminderId = reminderId;
    }).catch((err: BusinessError) => {
      this.message = `publishReminder 失败, errCode:${err.code}, errMessage:${err.message}`;
    })
  }

  // 取消指定的提醒
  cancelReminder() {
    reminderAgentManager.cancelReminder(this.reminderId).then(() => {
      this.message = `cancelReminder 成功, reminderId:${this.reminderId}`;
    }).catch((err: BusinessError) => {
      this.message = `cancelReminder 失败, errCode:${err.code}, errMessage:${err.message}`;
    });
  }

  build() {
    Column({ space: 10 }) {
      Button("发布一个倒计时提醒").onClick(() => {
        this.publishReminder()
      })
      Button("取消指定的提醒").onClick(() => {
        this.cancelReminder()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""
  // 提醒 ID
  reminderId: number = 0

  // 发布一个闹钟提醒（到了指定的时间后会弹出一个通知）
  publishReminder() {
    let date = new Date()
    date.setMinutes(date.getMinutes() + 1)

    // 构造一个 ReminderRequestAlarm 类型的闹钟提醒
    let reminderRequestAlarm: reminderAgentManager.ReminderRequestAlarm = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM, // 提醒类型为闹钟类型
      hour: date.getHours(), // 闹钟的目标小时
      minute: date.getMinutes(), // 闹钟的目标分钟
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // 闹钟的目标星期（1 - 7 之间，1 代表星期一）
      actionButton: [ // 通知上显示的按钮的标题和类型
        {
          title: '关闭',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        },
        {
          title: '稍后',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
        },
      ],
      wantAgent: { // 点击通知后，拉起的 ability 的相关信息
        pkgName: 'com.webabcd.harmonydemo',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility'
      },
      ringDuration: 15, // 响铃时长（单位：秒）
      snoozeTimes: 2, // 稍后提醒的次数
      timeInterval: 5 * 60, // 稍后提醒的间隔（单位：秒）
      title: 'title', // 通知的标题
      content: 'content', // 通知的内容
      snoozeContent: 'snoozeContent', // 稍后提醒后通知的内容
      notificationId: 2, // 通知 ID
    }

    // 发布指定的提醒，返回提醒 ID
    reminderAgentManager.publishReminder(reminderRequestAlarm).then((reminderId: number) => {
      this.message = `publishReminder 成功, reminderId:${reminderId}`;
      this.reminderId = reminderId;
    }).catch((err: BusinessError) => {
      this.message = `publishReminder 失败, errCode:${err.code}, errMessage:${err.message}`;
    })
  }

  // 取消指定的提醒
  cancelReminder() {
    reminderAgentManager.cancelReminder(this.reminderId).then(() => {
      this.message = `cancelReminder 成功, reminderId:${this.reminderId}`;
    }).catch((err: BusinessError) => {
      this.message = `cancelReminder 失败, errCode:${err.code}, errMessage:${err.message}`;
    });
  }

  build() {
    Column({ space: 10 }) {
      Button("发布一个闹钟提醒").onClick(() => {
        this.publishReminder()
      })
      Button("取消指定的提醒").onClick(() => {
        this.cancelReminder()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""
  // 提醒 ID
  reminderId: number = 0

  // 发布一个日历提醒（到了指定的时间后会弹出一个通知）
  publishReminder() {
    let date = new Date()
    date.setMinutes(date.getMinutes() + 1)

    // 构造一个 ReminderRequestCalendar 类型的日历提醒
    let reminderRequestCalendar: reminderAgentManager.ReminderRequestCalendar = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR, // 提醒类型为日历类型
      dateTime: {
        // 日历的目标时间
        year: date.getFullYear(),
        month: date.getMonth() + 1,
        day: date.getDate(),
        hour: date.getHours(),
        minute: date.getMinutes(),
        second: date.getSeconds()
      },
      repeatMonths: [], // 重复提醒的月份
      repeatDays: [], // 重复提醒的日期
      daysOfWeek: [], // 重复提醒的星期（1 - 7 之间，1 代表星期一）
      actionButton: [ // 通知上显示的按钮的标题和类型
        {
          title: '关闭',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        },
        {
          title: '稍后',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
        },
      ],
      wantAgent: { // 点击通知后，拉起的 ability 的相关信息
        pkgName: 'com.webabcd.harmonydemo',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility'
      },
      ringDuration: 15, // 响铃时长（单位：秒）
      snoozeTimes: 2, // 稍后提醒的次数
      timeInterval: 5 * 60, // 稍后提醒的间隔（单位：秒）
      title: 'title', // 通知的标题
      content: 'content', // 通知的内容
      snoozeContent: 'snoozeContent', // 稍后提醒后通知的内容
      notificationId: 3, // 通知 ID
    }

    // 发布指定的提醒，返回提醒 ID
    reminderAgentManager.publishReminder(reminderRequestCalendar).then((reminderId: number) => {
      this.message = `publishReminder 成功, reminderId:${reminderId}`;
      this.reminderId = reminderId;
    }).catch((err: BusinessError) => {
      this.message = `publishReminder 失败, errCode:${err.code}, errMessage:${err.message}`;
    })
  }

  // 取消指定的提醒
  cancelReminder() {
    reminderAgentManager.cancelReminder(this.reminderId).then(() => {
      this.message = `cancelReminder 成功, reminderId:${this.reminderId}`;
    }).catch((err: BusinessError) => {
      this.message = `cancelReminder 失败, errCode:${err.code}, errMessage:${err.message}`;
    });
  }

  build() {
    Column({ space: 10 }) {
      Button("发布一个日历提醒").onClick(() => {
        this.publishReminder()
      })
      Button("取消指定的提醒").onClick(() => {
        this.cancelReminder()
      })

      Text(this.message)
    }
  }
}