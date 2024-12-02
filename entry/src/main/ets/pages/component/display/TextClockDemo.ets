/*
 * TextClock - 系统时间实时显示框
 *
 * TextClock 的 format() 的详细说明
 *   y：年（yyyy表示完整年份，yy表示年份后两位）
 *   M：月
 *   d：日
 *   E：星期（比如：EEEE对应"星期六"，E或EE或EEE对应"周六"）
 *   H：小时（24小时制）
 *   h：小时（12小时制）
 *   m：分钟
 *   s：秒
 *   SS：厘秒(S个数<3，全部按厘秒处理)
 *   SSS：毫秒(S个数>=3，全部按毫秒处理)
 *   aa：上午/下午
 * 相关示例如下
 *   输入格式                                 显示效果
 *   yyyy年M月d日 EEEE                       2023年2月4日 星期六
 *   yyyy年MM月dd日                          2023年02月04日
 *   yy年MM月dd日 E                          23年02月04日 周六
 *   HH:mm:ss                               17:00:04
 *   aa hh:mm:ss                            上午 5:00:04
 *   hh:mm:ss                               5:00:04
 *   mm:ss.SS                               00:04.91
 *   mm:ss.SSS                              00:04.536
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct TextClockDemo {

  @State message: string = ''

  /*
   * TextClockController - 用于和绑定的 TextClock 之间的交互
   *   start() - 实时显示
   *   stop() - 停止实时显示
   */
  controller: TextClockController = new TextClockController()

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * TextClock - 系统时间实时显示框
       *   controller - 绑定的 TextClockController 对象
       *   timeZoneOffset - 时区偏移量
       *   format() - 显示时间的格式（参见上面的说明）
       *   fontSize(), fontColor(), fontStyle(), fontWeight(), fontFamily - 字体的相关设置
       *   textShadow() - 文字阴影（ShadowOptions 对象或者 ShadowOptions 对象集合）
       *     radius - 阴影的模糊半径
       *     color - 阴影的颜色
       *     offsetX - 阴影的 x 轴偏移量
       *     offsetY - 阴影的 y 轴偏移量
       *   onDateChange() - 时间变化时的回调
       *     value - 当前时间戳，距 1970-1-1 的秒数
       */
      TextClock({
        timeZoneOffset: -8,
        controller: this.controller,
      })
        .format('aa hh:mm:ss')
        .fontSize(36)
        .fontColor(Color.Orange)
        .fontStyle(FontStyle.Normal)
        .fontWeight(400)
        .fontFamily("HarmonyOS Sans")
        .onDateChange((value: number) => {
          this.message = `onDateChange ${value}`
        })

      TextClock({ timeZoneOffset: -8, controller: this.controller })
        .fontSize(36)
        .format('HH:mm:ss')

      TextClock({ timeZoneOffset: -8, controller: this.controller })
        .fontSize(36)
        .textShadow([
          { radius: 10, color: Color.Red, offsetX: 5, offsetY: 5 },
          { radius: 10, color: Color.Green, offsetX: 10, offsetY: 10 },
          { radius: 10, color: Color.Blue, offsetX: 15, offsetY: 15 },
        ])

      TextClock({ timeZoneOffset: -8, controller: this.controller })
        .format('aa hh:mm:ss')
        .fontSize(30)
        // 通过 contentModifier() 实现自定义 TextClock（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyTextClockModifier(false))

      Button("start")
        .onClick(() => {
          // 启动文本时钟
          this.controller.start()
        })
      Button("stop")
        .onClick(() => {
          // 停止文本时钟
          this.controller.stop()
        })
    }
  }
}

// 实现 ContentModifier 接口
class MyTextClockModifier implements ContentModifier<TextClockConfiguration> {

  // 自定义属性
  useMilitaryTime:boolean = true
  // 构造函数
  constructor(useMilitaryTime:boolean) {
    this.useMilitaryTime = useMilitaryTime
  }

  // 返回指定的自定义 TextClock
  applyContent(): WrappedBuilder<[TextClockConfiguration]> {
    return wrapBuilder(buildTextClock)
  }
}

// 自定义 TextClock
@Builder function buildTextClock(config: TextClockConfiguration) {
  /*
   * TextClockConfiguration - 自定义 TextClock 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   timeZoneOffset - 时区偏移量
   *   started - 是否是实时显示
   *   timeValue - 当前时间戳，距 1970-1-1 的秒数
   */
  Column() {
    TimePicker({
      selected: (new Date(config.timeValue * 1000)),
      format: TimePickerFormat.HOUR_MINUTE_SECOND
    })
      .useMilitaryTime((config.contentModifier as MyTextClockModifier).useMilitaryTime)
  }
}