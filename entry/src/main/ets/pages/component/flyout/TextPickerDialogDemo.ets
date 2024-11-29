/*
 * TextPickerDialog - 文本滑动选择弹窗
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
           * TextPickerDialog.show() - 文本滑动选择弹窗，建议使用 this.getUIContext().showTextPickerDialog()
           *   range - 可选文本列表
           *   selected - 选中项的索引位置
           *   canLoop - 是否可循环滚动
           *   alignment - 显示位置（DialogAlignment 枚举）
           *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
           *   offset - 相对原有位置的偏移量
           *   maskRect - 遮罩层的位置和大小
           *   backgroundColor - 弹窗的背景
           *   selectedTextStyle - 选中文本的文本样式
           *   disappearTextStyle - 选中文本的最上和最下的文本的文本样式
           *   textStyle - 除了选中文本和选中文本的最上和最下的文本之外的文本的文本样式
           *   acceptButtonStyle - 确认按钮的样式
           *   cancelButtonStyle - 取消按钮的样式
           *   onWillAppear, onDidAppear, onWillDisappear, onDidDisappear - 弹窗显示和消失的相关事件
           *   onAccept - 点击确认按钮时的回调
           *     value - 当前选中的文本
           *   onCancel - 点击取消按钮时的回调
           *   onChange - 选中文本变化时的回调
           *     value - 当前选中的文本
           */
          this.getUIContext().showTextPickerDialog({
            range: ['aaa', 'bbb', 'ccc', 'ddd', 'eee'],
            selected: 3,
            canLoop: true,
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
              this.message += `onAccept ${value.index} ${value.value}\n`
            },
            onCancel: () => {
              this.message += 'onCancel\n'
            },
            onChange: (value) => {
              this.message += `onChange ${value.index} ${value.value}\n`
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

      /*
       * 多列文本选择的示例
       */
      Button("click me")
        .onClick(() => {
          this.getUIContext().showTextPickerDialog({
            range: [['aaa', 'bbb', 'ccc', 'ddd', 'eee'], ['111', '222', '333', '444', '555']],
            selected: [1, 2]
          })
        })
    }
  }
}