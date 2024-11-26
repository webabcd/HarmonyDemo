/*
 * TextInput - 文本输入框
 */

import { MyLog, TitleBar } from '../../TitleBar'

@Entry
@Component
struct TextInputDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('输入类型').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('交互').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('事件').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('自定义软键盘').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {
  @State text: string = 'abc'

  @Builder myBuilder() {
    Image($r('app.media.son'))
      .width(50).height(50)
  }

  build() {
    Column({space: 10}) {

      Text(this.text)

      /*
       * TextInput - 文本输入框
       *   以下这些属性的用法和 Text 组件是一样，详见 TextDemo.ets 中的说明
       *     fontColor(), fontSize(), fontStyle(), fontWeight(), fontFamily()
       *     decoration(), textAlign(), lineHeight(), letterSpacing(), textIndent()
       *     wordBreak(), minFontSize(), maxFontSize(), heightAdaptivePolicy(), lineBreakStrategy()
       *     editMenuOptions()
       *   text - 显示的文本
       *   placeholder - 占位文本
       *   placeholderColor() - 占位文本的颜色
       *   placeholderFont() - 占位文本的 size, weight, style, family
       *   caretColor() - 光标的颜色
       *   maxLength() - 允许输入的最大字符数
       *   showCounter() - 是否在右下角显示字符计数器
       *   selectionMenuHidden() - 选中文本后是否不弹出上下文菜单
       */
      TextInput({
        // 通过 $$ 为 TextInput 组件的 text 属性提供数据的双向同步功能
        text: $$this.text,
        placeholder: '请输入信息',
      })
        .placeholderColor(Color.Orange)
        .placeholderFont({
          size: 14,
          weight: FontWeight.Normal,
          style: FontStyle.Normal,
          family: 'HarmonyOS Sans',
        })
        .caretColor(Color.Red)
        .width('90%')
        .height(40)
        .fontSize(14)
        .fontColor(Color.Black)
        .decoration({
          type: TextDecorationType.Underline,
          color: Color.Red,
          style: TextDecorationStyle.SOLID,
        })
        .maxLength(80)
        .showCounter(true, {
          // 这里 20 的意思是 maxLength() 的大小乘以 0.2 等于 16，即当输入字符的长度达到 16 后显示计数器
          thresholdPercentage: 20,
          // 当输入字符数达到 maxLength() 的大小时，输入框是否显示红色边框
          highlightBorder: true
        })
        .selectionMenuHidden(false)

      /*
       * 设置 TextInput 的边框和背景色
       */
      TextInput().width('90%').height(60).fontSize(14).fontColor(Color.Black)
        .borderRadius(0)
        .borderColor(Color.Blue)
        .borderWidth(2)
        .backgroundColor(Color.Orange)

      /*
       * style() - 输入框的风格
       *   Default - 默认
       *   Inline - 内联，输入的字符超过宽度限制时会自动换行
       *     仅当 type(InputType.Normal) 时有效
       * maxLines() - 当 style(TextInputStyle.Inline) 时，输入框的最大行数
       *   这个最大行数是用于限制输入框的最大高度的，当输入数据超过了最大行数后输入框的高度就不会再变，但是可以继续输入数据，然后通过上下滑动查看数据
       * onContentScroll() - 内容滚动时的回调
       *   totalOffsetX, totalOffsetY - 滚动的偏移量
       * barState() - 滚动条的显示模式（BarState 枚举）
       *   Off - 不显示
       *   On - 内容可滚动的时候则显示，且不消失
       *   Auto - 内容可滚动的时候且被触摸了则显示，然后 2 秒后消失
       * textOverflow() - 文本溢出后的显示方式（仅在设置了 maxLines() 之后有效）
       *   TextOverflow.Clip - 直接截断
       *   TextOverflow.Ellipsis - 溢出部分用省略号代替
       */
      TextInput().width('90%').height(40)
        .style(TextInputStyle.Inline)
        .maxLines(3)
        .onContentScroll((totalOffsetX: number, totalOffsetY: number) => {
          this.text = `onContentScroll: ${totalOffsetX}, ${totalOffsetY}`
        })
        .barState(BarState.Auto)
      TextInput().width('90%').height(40)
        .style(TextInputStyle.Inline)
        .maxLines(3)
        .textOverflow(TextOverflow.Ellipsis)

      /*
       * caretStyle() - 光标的样式
       *   width - 光标的宽度
       *   color - 光标的颜色
       * caretPosition() - 获得焦点后，光标的默认位置
       * defaultFocus() - 是否默认获得焦点
       * enableKeyboardOnFocus() - 当通过用户点击以外的方式获取焦点时，是否需要弹出软键盘
       */
      TextInput({ text: "abcdefghijklmnopqrstuvwxyz"}).width('90%').height(60).fontSize(14).fontColor(Color.Black)
        .caretStyle({
          width: 5,
          color: Color.Red
        })
        .caretPosition(3) // 光标显示在 c 和 d 之间
        .defaultFocus(true)
        .enableKeyboardOnFocus(false)

      /*
       * showUnderline() - 是否使用下划线样式的文本框
       *   仅当 type(InputType.Normal) 时有效
       * showUnit() - 在文本框内部的右侧显示指定的自定义组件
       *   仅当 showUnderline(true) 时有效
       * showError() - 在文本框的下面显示指定的错误信息
       * underlineColor() - 当 showUnderline(true) 时下划线的颜色
       *   normal - 输入框不在焦点时，下划线的颜色
       *   typing - 输入框在焦点时，下划线的颜色
       *   error - 当通过 showError() 显示错误信息时，下划线的颜色
       *   disable - 当 enabled(false) 时，下划线的颜色
       */
      TextInput().width('90%').height(60).fontSize(14).fontColor(Color.Black)
        .showUnderline(true)
        .showUnit(this.myBuilder)
        .showError('error message')
      TextInput().width('90%').height(60).fontSize(14).fontColor(Color.Black)
        .showUnderline(true)
        .underlineColor({
          normal: Color.Black,
          typing: Color.Green,
          error: Color.Red,
          disable: Color.Gray
        })
    }
  }
}

@Component
struct MySample2 {
  @State text: string = ''
  @State isShowPassword: boolean = false

  build() {
    Column({ space: 10 }) {

      Text(this.text)

      /*
       * type() - 输入框允许输入的数据的类型，以及弹出的软键盘的类型（InputType 枚举）
       *   Normal, Number, PhoneNumber, Email, Password, NUMBER_PASSWORD, USER_NAME, NEW_PASSWORD, NUMBER_DECIMAL, URL
       * contentType() - 弹出的软键盘上的自动填充类型
       * enableAutoFill() - 是否启用自动填充功能
       * enterKeyType() - 软键盘的回车的类型（EnterKeyType 枚举）
       *   Go, Search, Send, Next, Done, PREVIOUS, NEW_LINE
       */
      TextInput().width('90%').height(40)
        .type(InputType.Email) // 弹出适合输入 email 的软键盘，并且只能输入符合 email 类型的数据
        .contentType(ContentType.EMAIL_ADDRESS) // 在已启用情景化自动填充的情况下，支持邮箱地址的自动保存和自动填充
        .enableAutoFill(true)
        .enterKeyType(EnterKeyType.Search)

      /*
       * type(InputType.Password) - 输入框为密码框类型（使用圆点代替字符）
       * showPasswordIcon() - 是否显示密码框右侧的按钮（点击后会触发 onSecurityStateChange() 回调）
       * showPassword() - 是否明文显示密码
       * onSecurityStateChange() - 点击密码框右侧的按钮时的回调
       *   isShowPassword - 是否明文显示密码
       * passwordIcon() - 用于自定义密码框右侧的按钮
       *   onIconSrc - 密码框明文显示时的按钮图标
       *   offIconSrc - 密码框密文显示时的按钮图标
       */
      TextInput().width('90%').height(40)
        .type(InputType.Password)
        .showPasswordIcon(true)
        .showPassword(this.isShowPassword)
        .onSecurityStateChange(((isShowPassword: boolean) => {
          this.isShowPassword = isShowPassword
        }))
      TextInput().width('90%').height(40)
        .type(InputType.Password)
        .showPasswordIcon(true)
        .passwordIcon({
          onIconSrc: $r('app.media.startIcon'),
          offIconSrc: $r('app.media.son')
        })
        .showPassword(this.isShowPassword)
        .onSecurityStateChange(((isShowPassword: boolean) => {
          this.isShowPassword = isShowPassword
        }))

      /*
       * inputFilter() - 通过正则表达式设置允许输入的字符
       *   value - 用于判断合法字符的正则表达式
       *   error - 输入了非法字符时的回调
       */
      TextInput().width('90%').height(40)
        .inputFilter('[a-z]', (e) => {
          // 这里的 e 就是输入的非法字符
          this.text += e
        })
    }
  }
}

@Component
struct MySample3 {

  @State text: string = 'abcdefghijklmnopqrstuvwxyz'
  // TextInputController 是用于和 TextInput 交互的，声明式编程通常都会用这种方式
  controller: TextInputController = new TextInputController()

  build() {
    Column({ space: 10 }) {

      // 创建 TextInput 的时候指定 TextInputController，后续就可以通过这个 TextInputController 和这个 TextInput 交互了
      TextInput({
        text: this.text,
        controller: this.controller,
      })

      /*
       * TextInputController - 用于控制 TextInput 的 controller
       *   getCaretOffset() - 获取当前光标的位置
       *     index - 光标所在的字符位置
       *     x - 光标所在的行位置
       *     x - 光标所在的列位置
       *   caretPosition() - 设置光标位置
       *   setTextSelection() - 设置选中的文本
       *     selectionStart - 起始位置
       *     selectionEnd - 结束位置
       *     options - 选项
       *       menuPolicy - 弹出上下文菜单的策略
       *         DEFAULT - 默认
       *         HIDE - 不弹出上下文菜单
       *         SHOW - 弹出上下文菜单
       *   stopEditing() - 关闭软键盘，且失去焦点
       */

      Button('获取/设置光标的位置')
        .onClick(() => {
          let caretOffset = this.controller.getCaretOffset()
          let position = caretOffset.index + 1
          if (position > this.text.length) {
            position = 0
          }
          this.controller.caretPosition(position)
        })

      Button('设置选中的文本')
        .onClick(() => {
          this.controller.setTextSelection(3, 6, { menuPolicy: MenuPolicy.SHOW }) // def 被选中，且弹出上下文菜单
        })

      Button('关闭软键盘，且失去焦点')
        .onClick(() => {
          this.controller.stopEditing()
        })
    }
  }
}

@Component
struct MySample4 {

  @State message:string = ""
  controller: TextInputController = new TextInputController()

  build() {
    Column({ space: 10 }) {

      TextInput({ text: 'abc'} )
        .width('90%')

        /*
         * onWillInsert(), onDidInsert() - 插入字符时的一对回调
         *   insertValue, insertOffset - 插入的值和位置
         * onWillDelete(), onDidDelete() - 删除字符时的一对回调
         *   deleteValue, deleteValue, direction - 删除的值和位置，以及删除的方向
         * onChange() - 内容变化时的回调
         * onCopy(), onCut(), onPaste() - 复制，剪切，粘贴时的回调
         * onEditChange() - 输入状态发生变化时的回调
         *   isEditing 为 true 代表输入框有光标时的状态，即编辑状态
         *   isEditing 为 false 代表输入框无光标时的状态，即非编辑状态
         * onSubmit() - 按下回车键时的回调
         *   enterKey - 软键盘的回车的类型（EnterKeyType 枚举）
         *     Go, Search, Send, Next, Done, PREVIOUS, NEW_LINE
         *   event - 事件参数（一个 SubmitEvent 对象）
         *     text - 当前的文本内容
         *     keepEditableState() - 保持编辑状态（注：默认在 onSubmit() 之后会变为非编辑状态）
         */

        .onWillInsert((info: InsertValue) => {
          this.message += `onWillInsert, insertValue:${info.insertValue}, insertOffset:${info.insertOffset}\n`
          // 返回 true 则代表允许此次输入，然后会调用 onDidInsert()
          // 返回 false 则代表拒绝此次输入，之后也不会调用 onDidInsert()
          return false;
        })
        .onDidInsert((info: InsertValue) => {
          this.message += `onDidInsert, insertValue:${info.insertValue}, insertOffset:${info.insertOffset}\n`
        })
        .onWillDelete((info: DeleteValue) => {
          this.message += `onWillDelete, deleteValue:${info.deleteValue}, deleteValue:${info.deleteValue}, direction:${info.direction}\n`
          // 返回 true 则代表允许此次删除，然后会调用 onDidDelete()
          // 返回 false 则代表拒绝此次删除，之后也不会调用 onDidDelete()
          return true;
        })
        .onDidDelete((info: DeleteValue) => {
          this.message += `onDidDelete, deleteValue:${info.deleteValue}, deleteValue:${info.deleteValue}, direction:${info.direction}\n`
        })
        .onChange((value: string) => {
          this.message += `onChange: ${value}\n`
        })

        .onCopy((value: string) => {
          this.message += `onCopy: ${value}\n`
        })
        .onCut((value: string) => {
          this.message += `onCut: ${value}\n`
        })
        .onPaste((value: string) => {
          this.message += `onPaste: ${value}\n`
        })

        .onEditChange((isEditing: boolean) => {
          this.message += `onEditChange: ${isEditing}\n`
        })
        .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
            this.message += `onSubmit, enterKey:${enterKey}, text:${event.text}\n`
            // 默认在 onSubmit() 之后输入框会变为非编辑状态，如果调用 keepEditableState() 则可以保持编辑状态
            event.keepEditableState()
        })

      Text(this.message).fontSize(16)
    }
  }
}

@Component
struct MySample5 {

  controller: TextInputController = new TextInputController()
  @State inputValue: string = ""

  // 自定义软键盘组件
  @Builder
  CustomKeyboardBuilder() {
    Column({ space: 10 }) {
      Row() {
        Button('X').width(100).fontColor(Color.White).backgroundColor(Color.Blue).onClick(() => {
          // 关闭自定义键盘
          this.controller.stopEditing()
        })
      }

      Grid() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, '*', 0, '#'], (item: number | string) => {
          GridItem() {
            Button(item.toString()).width(100).fontColor(Color.White).backgroundColor(Color.Blue)
              .onClick(() => {
                this.inputValue += item
              })
          }
        })
      }.maxCount(3).columnsGap(10).rowsGap(10).padding(5)
    }.backgroundColor(Color.Orange)
  }

  build() {
    Column({ space: 10 }) {
      TextInput({ controller: this.controller, text: this.inputValue }).borderWidth(1).borderColor(Color.Blue)
        /*
         * customKeyboard() - 绑定自定义软键盘
         *   supportAvoidance - 弹出自定义软键盘时，输入框是否需要自动避让以避免被软键盘覆盖
         */
        .customKeyboard(this.CustomKeyboardBuilder(), {
          supportAvoidance: true
        })
    }.height('95%').justifyContent(FlexAlign.End)
  }
}