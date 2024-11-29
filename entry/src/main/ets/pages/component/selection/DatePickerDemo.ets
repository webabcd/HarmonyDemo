/*
 * DatePicker - 日期选择框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct DatePickerDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * DatePicker - 日期选择框
       *   start - 可选日期的起始时间
       *   end - 可选日期的结束时间
       *   selected - 当前选中的日期
       *   lunar() - 是否是农历日期选择框
       *   selectedTextStyle() - 选中日期的文本样式
       *   disappearTextStyle() - 选中日期的最上和最下的日期的文本样式
       *   textStyle() - 除了选中日期和选中日期的最上和最下的日期之外的日期的文本样式
       *   onChange() - 选中日期变化时的回调
       *     value - 当前选中日期的 Date 对象
       */
      DatePicker({
        start: new Date('1970-1-1'),
        end: new Date('2100-1-1'),
        selected: new Date(),
      })
        .lunar(false)
        .textStyle({
          color: Color.Red,
          font: {
            size: '18',
            weight: 400,
          }
        })
        .disappearTextStyle({
          color: Color.Green,
          font: {
            size: '22',
            weight: 400,
          }
        })
        .selectedTextStyle({
          color: Color.Blue,
          font: {
            size: '14',
            weight: 400,
          }
        })
        .onDateChange((value: Date) => {
          this.message = `onChange ${JSON.stringify(value)}`
        })
    }
  }
}