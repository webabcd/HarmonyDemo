/*
 * CounterComponent - 计数器组件框
 */

import { TitleBar } from '../../TitleBar'
import { CounterComponent, CounterType, DateData } from '@kit.ArkUI'

@Entry
@Component
struct CounterComponentDemo {

  @State message: string = ""

  build() {
    Column({ space: 20 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * CounterComponent - 计数器组件框
       *   type - 类型（CounterType 枚举）
       *     LIST - 列表型
       *     COMPACT - 紧凑型
       *     INLINE - 内联型
       *     INLINE_DATE - 日期内联型
       *   numberOptions - 数字型
       *     label - 计数器的说明文本
       *     value - 当前值
       *     min - 最小值
       *     max - 最大值
       *     step - 步长
       *     textWidth - 数值文本的宽度
       *     onChange - 数值变化时的回调
       *       value - 变化后的值
       *   inlineOptions - 内联型
       *     value - 当前值
       *     min - 最小值
       *     max - 最大值
       *     step - 步长
       *     textWidth - 数值文本的宽度
       *     onChange - 数值变化时的回调
       *       value - 变化后的值
       *   dateOptions - 日期型
       *     year - 年
       *     month - 月
       *     day - 日
       *     step - 步长
       *     onDateChange - 日期变化时的回调
       *       date - 变化后的日期（一个 DateData 对象）
       *         year - 年
       *         month - 月
       *         day - 日
       */

      CounterComponent({
        options: {
          type: CounterType.LIST,
          numberOptions: {
            label: "label",
            value: 2,
            min: 0,
            max: 20,
            step: 1,
            textWidth: 40,
            onChange: (value: number) => {
              this.message = `value: ${value}`
            }
          }
        }
      }).width(200)

      CounterComponent({
        options: {
          type: CounterType.COMPACT,
          numberOptions: {
            label: "label",
            value: 2,
            min: 0,
            max: 20,
            step: 1,
            textWidth: 40,
            onChange: (value: number) => {
              this.message = `value: ${value}`
            }
          }
        }
      })

      CounterComponent({
        options: {
          type: CounterType.INLINE,
          inlineOptions: {
            value: 2,
            min: 0,
            max: 20,
            step: 1,
            textWidth: 40,
            onChange: (value: number) => {
              this.message = `value: ${value}`
            }
          }
        }
      })

      CounterComponent({
        options: {
          type: CounterType.INLINE_DATE,
          dateOptions: {
            year: 2002,
            month: 8,
            day: 16,
            step: 1,
            onDateChange: (date: DateData) => {
              this.message = `year: ${date.year}, month: ${date.month}, day: ${date.day}`
            }
          }
        }
      })
    }
  }
}