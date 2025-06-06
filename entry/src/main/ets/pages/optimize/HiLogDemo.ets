/**
 * hilog 日志
 * 在 DevEco Studio -> Log -> HiLog 中可以抓取 hilog 日志，也可以通过 hilog 命令抓取 hilog 日志
 * 每条 hilog 日志的最大长度为 4096 字节，超出则会被截断
 * 如果不想用 hilog 打印日志，也可以通过 console 打印日志
 *
 * 注：
 * 在 release 版本的 app 中默认不会打印 DEBUG 级别的日志
 * 如果需要在 release 版本的 app 中打印 DEBUG 级别的日志，可以执行命令 hdc shell hilog -b D
 */

import { TitleBar } from '../TitleBar'
import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct HiLogDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  private readonly DOMAIN: number = 0x0000;
  private readonly TAG: string = 'webabcd';

  aboutToAppear(): void {
    /*
     * 如果调用 hilog.debug(0x0000, 'webabcd', 'MyMessage');
     * 则会打印 09-29 13:58:31.703   2655-2655     A00000/webabcd                  com.webabcd.harmonydemo  D     MyMessage
     *   A00000/webabcd 中的 0000 是 DOMAIN（日志的来源域），本例中用的是 0x0000
     *   A00000/webabcd 中的 A 代表应用级别的日志（Application），如果是 C 开头则代表系统级别的日志（Core Components）
     *   A00000/webabcd 中的 webabcd 是 tag，本例中用的是 webabcd
     *   D 代表 debug 级别的日志
     * 日志级别从小到大排序为 DEBUG, INFO, WARN, ERROR, FATAL
     */
    hilog.debug(this.DOMAIN, this.TAG, "debug"); // debug
    hilog.info(this.DOMAIN, this.TAG, "info"); // info
    hilog.warn(this.DOMAIN, this.TAG, "warn"); // warn
    hilog.error(this.DOMAIN, this.TAG, "error"); // error
    hilog.fatal(this.DOMAIN, this.TAG, "fatal"); // fatal

    /*
     * 支持格式化
     *   %{public}d - 格式化数字类型，且显示
     *   %{public}s - 格式化字符串类型，且显示
     *   %{private}d - 格式化数字类型，但不显示
     *   %{private}s - 格式化字符串类型，但不显示
     *   %d - 同 %{private}d
     *   %s - 同 %{private}s
     */
    hilog.info(this.DOMAIN, this.TAG, "name:%{public}s, age:%{public}d", "webabcd", 44); // name:webabcd, age:44
    hilog.info(this.DOMAIN, this.TAG, "name:%{private}s, age:%{private}d", "webabcd", 44); // name:<private>, age:<private>
    hilog.info(this.DOMAIN, this.TAG, "name:%s, age:%d", "webabcd", 44); // name:<private>, age:<private>

    /*
     * hilog.isLoggable() - 用于判断当前是否支持指定 domain, tag, level 日志的打印
     */
    this.message = `debug: ${hilog.isLoggable(this.DOMAIN, this.TAG, hilog.LogLevel.DEBUG)}` // debug: true
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}
