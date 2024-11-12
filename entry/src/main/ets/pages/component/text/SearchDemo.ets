/*
 * Search - 搜索框
 */

import { RadioBar, TitleBar } from '../../TitleBar'
import { SymbolGlyphModifier } from '@kit.ArkUI'

@Entry
@Component
struct SearchDemo {

  @State message:string = ""
  /*
   * SearchController 是用于和 Search 交互的，声明式编程通常都会用这种方式
   *   caretPosition(), setTextSelection(), stopEditing() - 用法和 TextInputController 差不多，参见 TextInputDemo.ets 中的说明
   */
  controller: SearchController = new SearchController()

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * Search - 搜索框
       *   type() - 搜索框允许输入的数据的类型，以及弹出的软键盘的类型（SearchType 枚举）
       *     NORMAL, NUMBER, PHONE_NUMBER, EMAIL, NUMBER_DECIMAL, URL
       *   searchButton() - 设置搜索按钮的文字和样式（搜索框右侧的按钮）
       *   searchIcon() - 设置搜索图标（搜索框左侧的图标）
       *     可以指定图标的地址，大小和颜色
       *     也可以指定一个 SymbolGlyphModifier 类型的图标
       *   cancelButton() - 设置取消按钮的图标和样式（点击此按钮后会清空搜索框中的内容）
       *     style - 按钮的显示模式
       *       CancelButtonStyle.CONSTANT - 总是显示
       *       CancelButtonStyle.INVISIBLE - 总是隐藏
       *       CancelButtonStyle.INPUT - 搜索框中有内容则显示，无内容则隐藏
       *     icon - 图标
       *       可以指定图标的地址，大小和颜色
       *       也可以指定一个 SymbolGlyphModifier 类型的图标
       *
       * 注：其他用法和 Text, TextInput 差不多，详见 TextDemo.ets, TextInputDemo.ets 中的说明
       */

      Search({
        placeholder: '请输入',
        controller: this.controller
      })
        .width('95%')
        .height(40)
        .fontColor(Color.White)
        .textFont({
          size: 16
        })
        .placeholderColor(Color.Grey)
        .backgroundColor(Color.Orange)
        .type(SearchType.PHONE_NUMBER)
        .onSubmit((value: string) => {
          this.message = value
        })

      Search({
        placeholder: '请输入',
        controller: this.controller
      })
        .width('95%')
        .height(40)
        .fontColor(Color.White)
        .textFont({
          size: 16
        })
        .placeholderColor(Color.Grey)
        .backgroundColor(Color.Orange)
        .onSubmit((value: string) => {
          this.message = value
        })
        .searchButton('搜索', {
          fontSize: 16,
          fontColor: Color.Green
        })
        .searchIcon({
          size: 16,
          color: Color.White,
          src: $r('app.media.app_icon')
        })
        .cancelButton({
          style: CancelButtonStyle.CONSTANT,
          icon: {
            size: 16,
            color: Color.White,
            src: $r('app.media.son')
          }
        })

      Search({
        placeholder: '请输入',
        controller: this.controller
      })
        .width('95%')
        .height(40)
        .fontColor(Color.White)
        .textFont({
          size: 16
        })
        .placeholderColor(Color.Grey)
        .backgroundColor(Color.Orange)
        .onSubmit((value: string) => {
          this.message = value
        })
        .searchButton('搜索', {
          fontSize: 16,
          fontColor: Color.Green
        })
        .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontColor([Color.Red]))
        .cancelButton({
          style: CancelButtonStyle.INPUT,
          icon: new SymbolGlyphModifier($r('sys.symbol.xmark')).fontColor([Color.Green])
        })
    }
  }
}