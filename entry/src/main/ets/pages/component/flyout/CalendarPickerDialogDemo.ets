/*
 * CalendarPickerDialog - 日历选择弹窗
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct CalendarPickerDialogDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button("click me")
        .onClick(() => {
          /*
           * CalendarPickerDialog.show() - 弹出日历选择弹窗
           *   selected - 当前选中的日期
           *   hintRadius - 选中日期的矩形背景框的圆角半径
           *   backgroundColor - 弹窗的背景
           *   acceptButtonStyle - 确认按钮的样式
           *   cancelButtonStyle - 取消按钮的样式
           *   onWillAppear, onDidAppear, onWillDisappear, onDidDisappear - 弹窗显示和消失的相关事件
           *   onAccept - 点击确认按钮时的回调
           *     value - 当前选中日期的 Date 对象
           *   onCancel - 点击取消按钮时的回调
           *   onChange - 选中日期变化时的回调
           *     value - 当前选中日期的 Date 对象
           */
          CalendarPickerDialog.show({
            selected: new Date(),
            hintRadius: 10,
            backgroundColor: Color.White,
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
              this.message += `onAccept ${JSON.stringify(value)}\n`
            },
            onCancel: () => {
              this.message += 'onCancel\n'
            },
            onChange: (value) => {
              this.message += `onChange ${JSON.stringify(value)}\n`
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
      Button("click me").onClick(() => { CalendarPickerDialog.show({ selected: new Date() }) })
    }
  }
}