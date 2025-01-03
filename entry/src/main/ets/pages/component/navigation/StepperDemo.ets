/*
 * Stepper - 引导页
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct StepperDemo {

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      /*
       * Stepper - 引导页
       *   index - 当前显示的页的索引位置
       *   onPrevious - 点击 StepperItem 的 prevLabel 时的回调
       *     index - 当前页的索引位置
       *     pendingIndex - 上一页的索引位置
       *   onNext - 点击 StepperItem 的 nextLabel 时的回调
       *     index - 当前页的索引位置
       *     pendingIndex - 下一页的索引位置
       *   onChange - 当前页发生变化时的回调
       *     prevIndex - 切换前的页的索引位置
       *     index - 切换后的页的索引位置
       *   onFinish - 点击最后的 StepperItem 的 nextLabel，且 status 为 ItemState.Normal 时的回调
       *   onSkip - 点击 StepperItem 的 nextLabel， 且 status 为 ItemState.Skip 时的回调
       *
       * StepperItem - 引导页中的每一页
       *   prevLabel() - 上一页按钮的文本内容
       *   nextLabel() - 下一页按钮的文本内容
       *   status() - 前的 StepperItem 的 nextLabel 的状态（ItemState 枚举）
       *     Normal - 正常按钮
       *     Disabled - 不可用按钮（不可点击）
       *     Waiting - 显示一个加载动画（不可点击）
       *     Skip - 跳过按钮（点击后会触发 Stepper 的 onSkip 回调）
       */
      Stepper({
        index: 1
      }) {
        StepperItem() {
          Text('page 1').fontSize(64).fontColor(Color.White)
        }
        .nextLabel('next')
        .status(ItemState.Skip)

        StepperItem() {
          Text('page 2').fontSize(64).fontColor(Color.White)
        }
        .nextLabel('next')
        .prevLabel('previous')
        .status(ItemState.Normal)

        StepperItem() {
          Text('page 3').fontSize(64).fontColor(Color.White)
        }
        .nextLabel('start')
        .prevLabel('previous')
        .status(ItemState.Normal)
      }
      .backgroundColor(Color.Orange)
      .onFinish(() => {
        this.message = `onFinish`
      })
      .onSkip(() => {
        this.message = `onSkip`
      })
      .onChange((prevIndex: number, index: number) => {
        this.message = `onChange prevIndex:${prevIndex}, index:${index}`
      })
      .onNext((index: number, pendingIndex: number) => {
        // this.message = `onNext index:${index}, pendingIndex:${pendingIndex}`
      })
      .onPrevious((index: number, pendingIndex: number) => {
        // this.message = `onPrevious index:${index}, pendingIndex:${pendingIndex}`
      })
      .layoutWeight(1)
    }
  }
}