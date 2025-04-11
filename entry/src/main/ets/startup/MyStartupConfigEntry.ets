/*
 * StartupConfigEntry - 启动任务的配置
 *   用于设置启动任务的超时时间，并可以监听启动任务的执行情况
 */

import { StartupConfig, StartupConfigEntry, StartupListener } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { MyLog } from '../utils/MyLog';

export default class MyStartupConfigEntry extends StartupConfigEntry {
  onConfig() {
    let onCompletedCallback = (error: BusinessError<void>) => {
      if (error) {
        // 启动任务超时或异常
        MyLog.d(`StartupConfigEntry onCompletedCallback errCode:${error.code}, errMessage:${error.message}`)
      } else {
        // 启动任务执行完成
        MyLog.d(`StartupConfigEntry onCompletedCallback 成功`)
      }
    };
    let startupListener: StartupListener = {
      'onCompleted': onCompletedCallback, // 启动任务有结果后（超时或异常或完成）的回调
    };
    let config: StartupConfig = {
      'timeoutMs': 10_000, // 启动任务的超时时间（单位：毫秒）
      'startupListener': startupListener // 启动任务的监听器
    };
    return config;
  }
}