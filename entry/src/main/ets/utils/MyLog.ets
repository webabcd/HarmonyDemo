/**
 * 如果调用 MyLog.d("MyMessage");
 * 则会打印 09-29 13:58:31.703   2655-2655     A00000/webabcd                  com.webabcd.harmonydemo  D     MyMessage
 *   A00000/webabcd 中的 0000 是 DOMAIN（日志的来源域），本例中用的是 0x0000
 *   A00000/webabcd 中的 A 代表应用级别的日志（Application），如果是 C 开头则代表系统级别的日志（Core Components）
 *   A00000/webabcd 中的 webabcd 是 tag，本例中用的是 webabcd
 *   D 代表 debug 级别的日志
 *
 * 日志级别从小到大排序为 DEBUG, INFO, WARN, ERROR, FATAL
 *
 * 注：
 * 在 release 版本的 app 中默认不会打印 DEBUG 级别的日志
 * 如果需要在 release 版本的 app 中打印 DEBUG 级别的日志，可以执行命令 hdc shell hilog -b D
 */

import hilog from '@ohos.hilog';

export class MyLog {
  private static readonly DOMAIN: number = 0x0000;
  private static readonly TAG: string = 'webabcd';

  public static d(message: string): void {
    hilog.debug(MyLog.DOMAIN, MyLog.TAG, message);
  }

  public static i(message: string): void {
    hilog.info(MyLog.DOMAIN, MyLog.TAG, message);
  }

  public static w(message: string): void {
    hilog.warn(MyLog.DOMAIN, MyLog.TAG, message);
  }

  public static e(message: string): void {
    hilog.error(MyLog.DOMAIN, MyLog.TAG, message);
  }

  public static f(message: string): void {
    hilog.fatal(MyLog.DOMAIN, MyLog.TAG, message);
  }
}