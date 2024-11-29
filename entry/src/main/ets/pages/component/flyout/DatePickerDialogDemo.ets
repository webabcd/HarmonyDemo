/*
 * DatePickerDialogDemo - 日期滑动选择弹窗
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct DatePickerDialogDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button("click me")
        .onClick(() => {
          /*
           * DatePickerDialog.show() - 日期滑动选择弹窗，建议使用 this.getUIContext().showDatePickerDialog()
           *   start - 可选日期的起始时间
           *   end - 可选日期的结束时间
           *   selected - 当前选中的日期
           *   showTime - 是否显示时间选项
           *   useMilitaryTime - 是否是 24 小时制
           *   lunar - 是否显示农历
           *   lunarSwitch - 是否显示农历切换开关
           *   dateTimeOptions - 一些选项
           *     hour, minute - 还有好多类似的属性，指定为 ’numeric‘ 则不补 0，指定为 '2-digit' 则补 0
           *   alignment - 显示位置（DialogAlignment 枚举）
           *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
           *   offset - 相对原有位置的偏移量
           *   maskRect - 遮罩层的位置和大小
           *   backgroundColor - 弹窗的背景
           *   selectedTextStyle - 选中日期的文本样式
           *   disappearTextStyle - 选中日期的最上和最下的日期的文本样式
           *   textStyle - 除了选中日期和选中日期的最上和最下的日期之外的日期的文本样式
           *   acceptButtonStyle - 确认按钮的样式
           *   cancelButtonStyle - 取消按钮的样式
           *   onWillAppear, onDidAppear, onWillDisappear, onDidDisappear - 弹窗显示和消失的相关事件
           *   onAccept - 点击确认按钮时的回调
           *     value - 当前选中日期的 Date 对象
           *   onCancel - 点击取消按钮时的回调
           *   onChange - 选中日期变化时的回调
           *     value - 当前选中日期的 Date 对象
           */
          this.getUIContext().showDatePickerDialog({
            start: new Date("2000-1-1"),
            end: new Date("2100-12-31"),
            selected: new Date(),
            showTime: true,
            useMilitaryTime: false,
            lunar: false,
            lunarSwitch: true,
            dateTimeOptions: {
              hour: '2-digit',
              minute: '2-digit',
            },
            alignment: DialogAlignment.Bottom,
            offset: {
              dx: 0,
              dy: -20,
            },
            maskRect: {x:0, y:0, width:'100%', height:'100%'},
            backgroundColor: Color.White,
            textStyle: {
              color: Color.Red,
              font: {
                size: '18',
                weight: 400,
              }
            },
            disappearTextStyle: {
              color: Color.Green,
              font: {
                size: '22',
                weight: 400,
              }
            },
            selectedTextStyle: {
              color: Color.Blue,
              font: {
                size: '14',
                weight: 400,
              }
            },
            acceptButtonStyle: {
              type: ButtonType.Normal,
              style: ButtonStyleMode.NORMAL,
              role: ButtonRole.NORMAL,
              fontColor: Color.White,
              fontSize: 24,
              fontWeight: 400,
              backgroundColor: Color.Orange,
              borderRadius: 20,
            },
            cancelButtonStyle: {

            },
            onDateAccept: (value) => {
              this.message += `onDateAccept ${JSON.stringify(value)}\n`
            },
            onCancel: () => {
              this.message += 'onCancel\n'
            },
            onDateChange: (value) => {
              this.message += `onDateChange ${JSON.stringify(value)}\n`
            },
            onWillAppear: () => {
              this.message += 'onWillAppear\n'
            },
            onDidAppear: () => {
              this.message += 'onDidAppear\n'
            },
            onWillDisappear: () => {
              this.message += 'onWillDisappear\n'
            },
            onDidDisappear: () => {
              this.message += 'onDidDisappear\n'
            },
          })
        })

      // 默认弹窗
      Button("click me").onClick(() => { this.getUIContext().showDatePickerDialog({ selected: new Date() }) })
    }
  }
}