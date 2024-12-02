/*
 * TextTimer - 计时器框
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct TextTimerDemo {

  @State message: string = ''

  /*
   * TextTimerController - 用于和绑定的 TextTimer 之间的交互
   *   start() - 开始
   *   pause() - 暂停
   *   reset() - 重置
   */
  controller: TextTimerController = new TextTimerController()
  controller2: TextTimerController = new TextTimerController()
  controller3: TextTimerController = new TextTimerController()
  controller4: TextTimerController = new TextTimerController()

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * TextTimer - 计时器框
       *   controller - 绑定的 TextTimerController 对象
       *   isCountDown - 是否是倒计时
       *   count - 当倒计时时，计时器的初始的毫秒数
       *   format() - 显示时间的格式（参见 TextClockDemo.ets 中的说明）
       *   fontSize(), fontColor(), fontStyle(), fontWeight(), fontFamily - 字体的相关设置
       *   textShadow() - 文字阴影（ShadowOptions 对象或者 ShadowOptions 对象集合）
       *     radius - 阴影的模糊半径
       *     color - 阴影的颜色
       *     offsetX - 阴影的 x 轴偏移量
       *     offsetY - 阴影的 y 轴偏移量
       *   onTimer() - 时间变化时的回调
       *     utc - 当前时间戳，距 1970-1-1 的秒数
       *     elapsedTime - 计时器经过的时间，单位为 format() 指定的格式的最小单位
       */
      TextTimer({
        isCountDown: true,
        count: 30000,
        controller: this.controller
      })
        .format('mm:ss.SSS')
        .fontSize(36)
        .fontColor(Color.Orange)
        .fontStyle(FontStyle.Normal)
        .fontWeight(400)
        .fontFamily("HarmonyOS Sans")
        .onTimer((utc: number, elapsedTime: number) => {
          this.message = `utc:${utc}, elapsedTime:${elapsedTime}`
        })

      TextTimer({
        isCountDown: false,
        controller: this.controller2
      })

      TextTimer({
        isCountDown: true,
        count: 30000,
        controller: this.controller3
      })
        .fontSize(36)
        .textShadow([
          { radius: 10, color: Color.Red, offsetX: 5, offsetY: 5 },
          { radius: 10, color: Color.Green, offsetX: 10, offsetY: 10 },
          { radius: 10, color: Color.Blue, offsetX: 15, offsetY: 15 },
        ])

      TextTimer({
        isCountDown: false,
        controller: this.controller4
      })
        .format("ss")
        // 通过 contentModifier() 实现自定义 TextTimer（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyTextTimerModifier(Color.Orange))

      Button("start").onClick(() => {
        // 启动计时器
        this.controller.start()
        this.controller2.start()
        this.controller3.start()
        this.controller4.start()
      })
      Button("pause").onClick(() => {
        // 暂停计时器
        this.controller.pause()
        this.controller2.pause()
        this.controller3.pause()
        this.controller4.pause()
      })
      Button("reset").onClick(() => {
        // 重置计时器
        this.controller.reset()
        this.controller2.reset()
        this.controller3.reset()
        this.controller4.reset()
      })
    }
  }
}

// 实现 ContentModifier 接口
class MyTextTimerModifier implements ContentModifier<TextTimerConfiguration> {

  // 自定义属性
  color: Color = Color.White
  // 构造函数
  constructor(color:Color) {
    this.color = color
  }

  // 返回指定的自定义 TextTimer
  applyContent(): WrappedBuilder<[TextTimerConfiguration]> {
    return wrapBuilder(buildTextTimer)
  }
}

// 自定义 TextTimer
@Builder function buildTextTimer(config: TextTimerConfiguration) {
  /*
   * TextClockConfiguration - 自定义 TextClock 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   isCountDown - 是否是倒计时
   *   count - 当倒计时时，计时器的初始的毫秒数
   *   started - 计时器是否已经开始了
   *   elapsedTime - 计时器经过的时间，单位为 format() 指定的格式的最小单位
   */
  Stack({ alignContent: Alignment.Center }) {
    Circle({ width: 150, height: 150 }).fill((config.contentModifier as MyTextTimerModifier).color)
    Text(`${config.elapsedTime}`).fontColor(Color.White).fontSize(48)
  }
}