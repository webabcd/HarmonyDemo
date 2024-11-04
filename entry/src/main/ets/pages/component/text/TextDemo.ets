/*
 * Text - 文本显示框
 */
import { TitleBar } from '../../TitleBar'
import { LengthMetrics } from '@kit.ArkUI'

@Entry
@Component
struct TextDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({space: 10}) {
      /*
       * Text - 文本显示框
       *   content - 需要显示的内容，如果来自 resource 则在 /entry/src/main/resources/base/element/string.json 配置
       *   fontColor() - 字体颜色
       *   font() - 可以指定 size, weight, style, family
       *   fontSize() - 字体大小（设置了此值，则 font 的 size 无效）
       *   fontWeight() - 字体粗细（设置了此值，则 font 的 weight 无效）
       *   fontStyle() - 字体斜体（设置了此值，则 font 的 style 无效）
       *   fontFamily() - 字体（设置了此值，则 font 的 family 无效）
       *   decoration() - 下划线/中划线/上划线
       *     type - 类型（TextDecorationType 枚举）
       *       None - 无
       *       Underline - 下划线
       *       Overline - 上划线
       *       LineThrough - 中划线
       *     color - 颜色
       *     style - 样式（TextDecorationStyle 枚举）
       *       SOLID - 实线
       *       DOTTED - 点状线
       *       DASHED - 虚线
       *       WAVY - 波浪线
       */
      Text($r('app.string.hello_webabcd'))
        .fontColor(Color.Blue)
        .font({
          size: 1,
          weight: FontWeight.Normal,
          style: FontStyle.Normal,
          family: 'HarmonyOS Sans',
        })
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontStyle(FontStyle.Italic)
        .fontFamily('HarmonyOS Sans')
        .decoration({
          type: TextDecorationType.Underline,
          color: Color.Red,
          style: TextDecorationStyle.SOLID,
        })

      /*
       * textAlign - 文本的水平对齐方式
       *   Center, Start, End, JUSTIFY（两端对齐）
       * align  - 文本的垂直对齐方式
       *   TopStart, Top, TopEnd, Start, Center, End, BottomStart, Bottom, BottomEnd
       *
       * 注：两端对齐的意思是除了最后一行以外，所有行都会扩展其单词间距以填满整行，且每行的开始和结束都与容器的边缘对齐
       */
      Text($r('app.string.hello_webabcd'))
        .width('100%')
        .height(50)
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .textAlign(TextAlign.End)
        .align(Alignment.Bottom)

      /*
       * textCase - 大小写
       *   Normal, LowerCase, UpperCase
       * baselineOffset - 文本在原位置上的偏移量
       *   大于 0 向上偏移，小于 0 向下偏移
       */
      Text($r('app.string.hello_webabcd'))
        .width('100%')
        .height(50)
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .align(Alignment.Top)
        .textCase(TextCase.UpperCase)
        .baselineOffset(-10)

      /*
       * minFontSize(), maxFontSize() - 最小字体大小和最大字体大小，用于自动调整字体大小以便适应容器大小
       * textIndent() - 首行缩进值
       * maxLines() - 最大行数
       * letterSpacing() - 字符之间的间距
       * lineSpacing() - 行之间的间距
       * lineHeight() - 行高
       */
      Text('HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。')
        .width('100%')
        .height(80)
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .textAlign(TextAlign.JUSTIFY) // 两端对齐
        .minFontSize(9)
        .maxFontSize(24)
        .maxLines(100)
        .textIndent(20)
        .letterSpacing(1)
        .lineSpacing(LengthMetrics.vp(5))
        .lineHeight(10)

      /*
       * textOverflow() - 文本溢出后的显示方式
       *   overflow - TextOverflow（枚举）
       *     None - 直接截断
       *     Clip - 直接截断
       *     Ellipsis - 溢出部分用省略号代替
       *     MARQUEE - 跑马灯
       * ellipsisMode() - 有溢出文本并用省略号代替时，省略号的显示位置（TextOverflow 枚举）
       *   START - 省略号显示在开头
       *   CENTER - 省略号显示在中间
       *   END - 省略号显示在结尾
       * wordBreak() - 断行方式（WordBreak 枚举）
       *   NORMAL - CJK文本在任意2个字符间断行，Non-CJK文本只能在空白符处断行
       *   BREAK_ALL - CJK文本在任意2个字符间断行，Non-CJK文本在任意2个字符间断行
       *   BREAK_WORD - CJK文本在任意2个字符间断行，Non-CJK文本优先在空白字符处断行，如果整行没有空白字符则可以在任意2个字符间断行
       *
       * CJK文本就是字符之间不需要空行的，类似中文
       * Non-CJK文本就是单词之间需要空行的，类似英文
       */
      Text('HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。')
        .width('100%')
        .height(50)
        .fontSize(16)
        .maxLines(2)
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .wordBreak(WordBreak.NORMAL)
    }
  }
}