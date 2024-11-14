/*
 * TextArea - 多行文本输入框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct TextAreaDemo {

  @State message:string = ""
  /*
   * TextAreaController 是用于和 TextArea 交互的，声明式编程通常都会用这种方式
   *   caretPosition(), setTextSelection(), stopEditing() - 用法和 TextInputController 差不多，参见 TextInputDemo.ets 中的说明
   */
  controller: TextAreaController = new TextAreaController()

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * TextArea - 多行文本输入框
       *   onContentScroll() - 内容滚动时的回调
       *     totalOffsetX, totalOffsetY - 滚动的偏移量
       *   barState() - 滚动条的显示模式（BarState 枚举）
       *     Off - 不显示
       *     On - 内容可滚动的时候则显示，且不消失
       *     Auto - 内容可滚动的时候且被触摸了则显示，然后 2 秒后消失
       *   textOverflow() - 文本溢出后的显示方式（仅在设置了 maxLines() 之后有效）
       *     TextOverflow.Clip - 直接截断
       *     TextOverflow.Ellipsis - 溢出部分用省略号代替
       *   enablePreviewText() - 是否启用预上屏（需要输入法支持）
       *     预上屏的意思是：当用户输入特定的触发文本（如“hel”）时，输入框在当前位置上会显示预上屏内容（如“hello world”），然后点击回车之后就可以正式上屏了
       *     注：预上屏的内容不会触发 onWillInsert, onDidInsert, onWillDelete, onDidDelete 回调
       *
       * 注：其他用法和 Text, TextInput 差不多，详见 TextDemo.ets, TextInputDemo.ets 中的说明
       */
      TextArea({
        text: 'hello webabcd',
        controller: this.controller,
      })
        .caretColor(Color.Red)
        .width('90%')
        .height(100)
        .fontSize(16)
        .fontColor(Color.Black)
        .textIndent(20)
        .wordBreak(WordBreak.BREAK_ALL)
        .maxLength(2000)
        .showCounter(true, {
          thresholdPercentage: 1,
          highlightBorder: true
        })
        .onContentScroll((totalOffsetX: number, totalOffsetY: number) => {
          this.message = `onContentScroll: ${totalOffsetX}, ${totalOffsetY}`
        })
        .barState(BarState.Auto)
        .enablePreviewText(true)

      TextArea({
        text: 'HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。',
      })
        .caretColor(Color.Red)
        .width('90%')
        .fontSize(16)
        .fontColor(Color.Black)
        .maxLines(3)
        .textOverflow(TextOverflow.Ellipsis)
    }
  }
}