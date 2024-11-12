/*
 * StyledString - 官方称之为“属性字符串”，其用设置文本以及文本的不同位置的不同样式
 *   Text 通过 TextController 支持此特性
 *   RichEditor 通过 RichEditorStyledStringController 支持此特性
 */

import { TitleBar, MyLog } from '../../TitleBar'
import { LengthMetrics } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'

@Entry
@Component
struct StyledStringDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('StyledString').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('MutableStyledString').align(Alignment.Top)
      }
    }
  }
}

@Component
struct MySample1 {

  @State message:string = ""

  textStyle: TextStyle = new TextStyle({
    fontColor: Color.Orange,
    fontSize: LengthMetrics.vp(32),
  });

  /*
   * StyledString - 设置文本，以及文本的不同位置的不同样式（不支持 @State 装饰）
   *   value - 需要显示的文本内容
   *   styles - 样式集合（StyleOptions 类型的集合）
   *     start - 需要指定当前样式的字符串的起始位置
   *     length - 需要指定当前样式的字符串的长度
   *     styledKey - 需要指定的样式类型（StyledStringKey 枚举）
   *       FONT - 字体相关
   *       DECORATION - 下划线/中划线/上划线
   *       TEXT_SHADOW - 阴影
   *       BASELINE_OFFSET - 文本在原位置上的偏移量
   *       LETTER_SPACING - 文本字符间距
   *       LINE_HEIGHT - 行高
   *       PARAGRAPH_STYLE - 段落样式
   *       GESTURE - 手势事件
   *     styledValue - 需要指定的样式（和 Text 的相关效果差不多，详见 TextDemo.ets 中的相关说明）
   *       TextStyle - 对应 StyledStringKey.FONT
   *         fontColor, fontFamily, fontSize, fontWeight, fontStyle
   *       DecorationStyle - 对应 StyledStringKey.DECORATION
   *         type, color, style
   *       TextShadowStyle - 对应 StyledStringKey.TEXT_SHADOW
   *         radius, type, color, offsetX, offsetY
   *       BaselineOffsetStyle - 对应 StyledStringKey.BASELINE_OFFSET
   *         大于 0 向上偏移，小于 0 向下偏移
   *       LetterSpacingStyle - 对应 StyledStringKey.LETTER_SPACING
   *       LineHeightStyle - 对应 StyledStringKey.LINE_HEIGHT
   *       ParagraphStyle - 对应 StyledStringKey.PARAGRAPH_STYLE
   *         textAlign, textIndent, maxLines, overflow, wordBreak
   *       GestureStyle - 对应 StyledStringKey.GESTURE
   *         onClick, onLongPress
   */
  styledString: StyledString = new StyledString("abcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz", [
    {
      start: 0,
      length: 3,
      styledKey: StyledStringKey.FONT,
      styledValue: this.textStyle
    },
    {
      start: 5,
      length: 3,
      styledKey: StyledStringKey.FONT,
      styledValue: new TextStyle({
        fontColor: Color.Red,
        fontSize: LengthMetrics.vp(24),
      })
    },
    {
      start: 5,
      length: 3,
      styledKey: StyledStringKey.DECORATION,
      styledValue: new DecorationStyle({
        type: TextDecorationType.LineThrough,
        color: Color.Green
      })
    },
    {
      start: 5,
      length: 3,
      styledKey: StyledStringKey.TEXT_SHADOW,
      styledValue: new TextShadowStyle({
        radius: 5,
        type: ShadowType.COLOR,
        color: Color.Blue,
        offsetX: 10,
        offsetY: 10
      })
    },
    {
      start: 10,
      length: 3,
      styledKey: StyledStringKey.BASELINE_OFFSET,
      styledValue: new BaselineOffsetStyle(LengthMetrics.vp(10))
    },
    {
      start: 15,
      length: 3,
      styledKey: StyledStringKey.LETTER_SPACING,
      styledValue: new LetterSpacingStyle(LengthMetrics.vp(20))
    },
    {
      start: 27,
      length: 1,
      styledKey: StyledStringKey.LINE_HEIGHT,
      styledValue: new LineHeightStyle(LengthMetrics.vp(100))
    },
    {
      start: 27,
      length: 1,
      styledKey: StyledStringKey.PARAGRAPH_STYLE,
      styledValue: new ParagraphStyle({
        textIndent: LengthMetrics.vp(30),
      })
    },
    {
      start: 27,
      length: 53,
      styledKey: StyledStringKey.GESTURE,
      styledValue:  new GestureStyle({
        onClick: () => {
          this.message = "27 - 53 onClick"
        },
        onLongPress: () => {
          this.message = "27 - 53 onLongPress"
        }
      })
    }
  ]);

  controller: TextController = new TextController();

  onDidBuild() {
    /*
     * TextController - 用于和绑定的 Text 之间的交互
     *   setStyledString() - 设置 StyledString
     */
    // 注：
    // 如果你想要页面一加载就设置 StyledString，则不能在 aboutToAppear() 时设置，因为此时组件还没有被挂载上
    // 而是要在 onDidBuild() 或 onPageShow() 时设置
    this.controller.setStyledString(this.styledString);
  }

  build() {
    Column({space: 10}) {

      // 显示属性字符串
      Text(undefined, { controller: this.controller })
        .fontSize(16)

      /*
        * StyledString - 设置文本，以及文本的不同位置的不同样式
        *   getString() - 获取当前的文本字符串
        *   getStyles() - 获取指定的字符范围中的所有样式对象的集合
        */
      Button('获取当前 StyledString 对象的 string 和 styles')
        .onClick(() => {
          let string = this.styledString.getString()
          let styles = this.styledString.getStyles(0, 20)
          this.message = `string:${string}, styles(1)_start:${styles[1].start}, styles(1)_length:${styles[1].length}, styles(1)_styledKey:${styles[1].styledKey}`
        })

      Text(this.message)
        .fontSize(16)
    }
  }
}

@Component
struct MySample2 {

  /*
   * MutableStyledString - 增加了增删改操作的 StyledString（继承自 StyledString）
   */
  mutableStyledString: MutableStyledString = new MutableStyledString("abcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz", [
    {
      start: 0,
      length: 3,
      styledKey: StyledStringKey.FONT,
      styledValue: new TextStyle({
        fontColor: Color.Orange,
        fontSize: LengthMetrics.vp(32),
      })
    }
  ]);

  controller: TextController = new TextController();

  onDidBuild() {
    this.controller.setStyledString(this.mutableStyledString);
  }

  build() {
    Column({space: 10}) {

      Text(undefined, { controller: this.controller })
        .fontSize(16)

      Button('更新 MutableStyledString')
        .onClick(() => {

          /*
           * replaceString(), insertString(), removeString() - 对字符串做相关操作
           * replaceStyle(), setStyle(), removeStyle(), removeStyles(), clearStyles() - 对样式做相关操作
           * replaceStyledString(), insertStyledString(), appendStyledString() - 对 StyledString 做相关操作
           */

          this.mutableStyledString.replaceString(0, 3, "xxx")

          this.mutableStyledString.setStyle({
            start: 23,
            length: 3,
            styledKey: StyledStringKey.FONT,
            styledValue: new TextStyle({
              fontColor: Color.Red,
              fontSize: LengthMetrics.vp(48),
            })
          })

          this.mutableStyledString.appendStyledString(new StyledString('123', [
            {
              start: 0,
              length: 3,
              styledKey: StyledStringKey.FONT,
              styledValue: new TextStyle({
                fontColor: Color.Green,
                fontSize: LengthMetrics.vp(32),
              })
            }
          ]))

          // 因为 StyledString 不支持 @State 装饰，所以需要通过 TextController 的 setStyledString() 更新
          this.controller.setStyledString(this.mutableStyledString)
        })
    }
  }
}
