/*
 * PatternLock - 手势锁
 */

import { TitleBar } from '../../TitleBar';
import { LengthUnit } from '@kit.ArkUI';

@Entry
@Component
struct PatternLockDemo {

  @State message: string = 'please input password!'

  /*
   * PatternLockController - 用于和绑定的 PatternLock 之间的交互
   *   reset() - 重置
   *   setChallengeResult() - 设置手势结果（PatternLockChallengeResult 枚举）
   *     WRONG - 错误，连线会出现提示错误的效果
   *     CORRECT - 正确，连线会出现提示正确的效果
   */
  private patternLockController: PatternLockController = new PatternLockController()

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Button('reset').onClick(() => {
        // 重置手势锁
        this.patternLockController.reset()
        this.message = ''
      })

      /*
       * PatternLock - 手势锁
       *   controller - 绑定的 PatternLockController 对象
       *   sideLength() - 组件的宽高
       *   circleRadius() - 小圆点的半径
       *   pathStrokeWidth() - 连线的宽度
       *   backgroundColor() - 背景色
       *   pathColor() - 连线的颜色
       *   regularColor() - 小圆点的颜色
       *   selectedColor() - 被选中的小圆点的颜色
       *   activeColor() - 手势过程中，最近一次被选中的小圆点的颜色
       *   activateCircleStyle() - 被选中的小圆点的外围大圆的样式
       *     color - 颜色
       *     radius - 半径
       *     enableWaveEffect - 选中时是否启用一段波浪动画
       *   autoReset() - 完成手势后，再次在组件区域内按下时是否需要重置组件
       *   onDotConnect() - 选中小圆点时的回调
       *     index - 小圆点的索引位置
       *   onPatternComplete() - 手势完成后的回调
       *     input - 按照连线顺序的小圆点的索引位置的数组
       */
      PatternLock(this.patternLockController)
        .sideLength(300)
        .circleRadius(5)
        .pathStrokeWidth(10)
        .backgroundColor(Color.Gray)
        .pathColor(Color.Red)
        .regularColor(Color.Orange)
        .selectedColor(Color.Blue)
        .activeColor(Color.Green)
        .activateCircleStyle({
          color: Color.Yellow,
          radius: { value: 32, unit: LengthUnit.VP },
          enableWaveEffect: true
        })
        .autoReset(true)
        .onDotConnect((index: number) => {
          this.message = `onDotConnect:${index}`
        })
        .onPatternComplete((input: Array<number>) => {
          this.message = `onPatternComplete:${input.join(',')}`
          if (input.length < 3) {
            // 连线会出现提示错误的效果
            this.patternLockController.setChallengeResult(PatternLockChallengeResult.WRONG)
          } else {
            // 连线会出现提示正确的效果
            this.patternLockController.setChallengeResult(PatternLockChallengeResult.CORRECT)
          }
        })
    }
  }
}