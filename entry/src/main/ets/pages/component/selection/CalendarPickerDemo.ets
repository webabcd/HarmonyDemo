/*
 * CalendarPicker - 日历选择框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct CalendarPickerDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * CalendarPicker - 日历选择框
       *   selected - 当前选中的日期
       *   hintRadius - 日历上的选中日期的矩形背景框的圆角半径
       *   edgeAlign() - 日历相对于显示框的位置（CalendarAlign 枚举）
       *     START, CENTER, END
       *   textStyle() - 显示框中的文本的样式
       *   onChange() - 选中日期变化时的回调
       *     value - 当前选中日期的 Date 对象
       */
      CalendarPicker({
        selected: new Date(),
        hintRadius: 10,
      })
        .edgeAlign(CalendarAlign.END)
        .textStyle({
          color: Color.Red,
          font: {
            size: 24,
            weight: 400,
          }
        })
        .onChange((value) => {
          this.message = `onChange ${JSON.stringify(value)}`
        })
    }
  }
}