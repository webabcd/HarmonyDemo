/*
 * TimePicker - 时间选择框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct TimePickerDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * TimePicker - 时间选择框
       *   selected - 当前选中的时间
       *   format - 时间选择的类型（TimePickerFormat 枚举）
       *     HOUR_MINUTE - 时分选择
       *     HOUR_MINUTE_SECOND - 时分秒选择
       *   useMilitaryTime() - 是否是 24 小时制
       *   loop() - 是否可循环滚动
       *   dateTimeOptions() - 一些选项
       *     hour, minute - 还有好多类似的属性，指定为 ’numeric‘ 则不补 0，指定为 '2-digit' 则补 0
       *   enableHapticFeedback() - 是否启用触觉反馈
       *   selectedTextStyle() - 选中时间的文本样式
       *   disappearTextStyle() - 选中时间的最上和最下的时间的文本样式
       *   textStyle() - 除了选中时间和选中时间的最上和最下的时间之外的时间的文本样式
       *   onChange() - 选中时间变化时的回调
       *     value - 当前选中的时间（hour, minute, second）
       */
      TimePicker({
        selected: new Date(),
        format: TimePickerFormat.HOUR_MINUTE,
      })
        .useMilitaryTime(false)
        .loop(true)
        .dateTimeOptions({
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit',
        })
        .enableHapticFeedback(true)
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
        .onChange((value: TimePickerResult) => {
          this.message = `onChange ${value.hour} ${value.minute} ${value.second}`
        })

      // 24 小时制的时分秒选择框
      TimePicker({
        selected: new Date(),
        format: TimePickerFormat.HOUR_MINUTE_SECOND
      })
        .useMilitaryTime(true)
        .backgroundColor(Color.Orange)
    }
  }
}