/*
 * TimePickerDialog - 时间滑动选择弹窗
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct TimePickerDialogDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button("click me")
        .onClick(() => {
          /*
           * TimePickerDialog.show() - 时间滑动选择弹窗，建议使用 this.getUIContext().showTimePickerDialog()
           *   selected - 当前选中的时间
           *   useMilitaryTime - 是否是 24 小时制
           *   format - 时间选择的类型（TimePickerFormat 枚举）
           *     HOUR_MINUTE - 时分选择
           *     HOUR_MINUTE_SECOND - 时分秒选择
           *   dateTimeOptions - 一些选项
           *     hour, minute - 还有好多类似的属性，指定为 ’numeric‘ 则不补 0，指定为 '2-digit' 则补 0
           *   alignment - 显示位置（DialogAlignment 枚举）
           *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
           *   offset - 相对原有位置的偏移量
           *   maskRect - 遮罩层的位置和大小
           *   backgroundColor - 弹窗的背景
           *   selectedTextStyle - 选中时间的文本样式
           *   disappearTextStyle - 选中时间的最上和最下的时间的文本样式
           *   textStyle - 除了选中时间和选中时间的最上和最下的时间之外的时间的文本样式
           *   acceptButtonStyle - 确认按钮的样式
           *   cancelButtonStyle - 取消按钮的样式
           *   onWillAppear, onDidAppear, onWillDisappear, onDidDisappear - 弹窗显示和消失的相关事件
           *   onAccept - 点击确认按钮时的回调
           *     value - 当前选中的时间（hour, minute, second）
           *   onCancel - 点击取消按钮时的回调
           *   onChange - 选中时间变化时的回调
           *     value - 当前选中的时间（hour, minute, second）
           */
          this.getUIContext().showTimePickerDialog({
            selected: new Date(),
            useMilitaryTime: true,
            format: TimePickerFormat.HOUR_MINUTE_SECOND,
            dateTimeOptions: {
              hour: '2-digit',
              minute: '2-digit',
              second: '2-digit',
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
            onAccept: (value) => {
              this.message += `onAccept ${value.hour} ${value.minute} ${value.second}\n`
            },
            onCancel: () => {
              this.message += 'onCancel\n'
            },
            onChange: (value) => {
              this.message += `onChange ${value.hour} ${value.minute} ${value.second}\n`
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
      Button("click me").onClick(() => { this.getUIContext().showTimePickerDialog({ selected: new Date() }) })
    }
  }
}