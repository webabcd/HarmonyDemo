/*
 * Text - 文本显示框
 */

import { MyLog, TitleBar } from '../../TitleBar'
import { LengthMetrics } from '@kit.ArkUI'
import { font } from '@kit.ArkUI'

@Entry
@Component
struct TextDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('内容选择').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('自定义字体').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('交互').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
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
       *   textShadow() - 文字阴影（ShadowOptions 对象或者 ShadowOptions 对象集合）
       *     radius - 阴影的模糊半径
       *     color - 阴影的颜色
       *     offsetX - 阴影的 x 轴偏移量
       *     offsetY - 阴影的 y 轴偏移量
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
        .fontFamily('HarmonyOS Sans') // HarmonyOS Sans 是默认字体
        .decoration({
          type: TextDecorationType.Underline,
          color: Color.Red,
          style: TextDecorationStyle.SOLID,
        })
        .textShadow([
          { radius: 5, color: Color.Red, offsetX: 5, offsetY: 5 },
          { radius: 5, color: Color.Green, offsetX: 10, offsetY: 5 },
          { radius: 5, color: Color.Blue, offsetX: 15, offsetY: 5 },
          { radius: 5, color: Color.Orange, offsetX: 20, offsetY: 5 },
          { radius: 5, color: Color.Yellow, offsetX: 25, offsetY: 5 }
        ])

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
       * heightAdaptivePolicy() - 字体大小的自适应的方式（TextHeightAdaptivePolicy 枚举）
       *   MAX_LINES_FIRST - 优先根据 maxLines 调整字体大小，其次根据 minFontSize 和 maxFontSize 调整字体大小
       *   MIN_FONT_SIZE_FIRST - 根据 minFontSize 和 maxFontSize 调整字体大小
       *   LAYOUT_CONSTRAINT_FIRST - 优先根据布局约束调整字体大小，其次根据 minFontSize 和 maxFontSize 调整字体大小
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
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)

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

      /*
       * wordBreak() - 断行方式（WordBreak 枚举）
       *   NORMAL - CJK文本在任意2个字符间断行，Non-CJK文本只能在空白符处断行
       *   BREAK_ALL - CJK文本在任意2个字符间断行，Non-CJK文本在任意2个字符间断行
       *   BREAK_WORD - CJK文本在任意2个字符间断行，Non-CJK文本优先在空白字符处断行，如果整行没有空白字符则可以在任意2个字符间断行
       * lineBreakStrategy() - 在 wordBreak 的基础上的断行策略（LineBreakStrategy 枚举）
       *   BALANCED - 尽可能不拆词
       *   HIGH_QUALITY - 在 BALANCED 基础上尽可能填满行（除了最后一行）
       *   GREEDY - 尽可能在每行显示更多的字符
       *
       * CJK文本就是字符之间不需要空行的，类似中文
       * Non-CJK文本就是单词之间需要空行的，类似英文
       */
      Text('HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。')
        .width('100%')
        .fontSize(16)
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .wordBreak(WordBreak.NORMAL)
        .lineBreakStrategy(LineBreakStrategy.BALANCED)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ''

  // TextController 是用于和 Text 交互的，声明式编程通常都会用这种方式
  controller: TextController = new TextController();

  // 用于扩展 Text 默认的内容选中后的上下文菜单
  // menuItems - 默认的上下文菜单
  // TextMenuItem - 上下文菜单中的某一项
  //   id - 菜单项的标识
  //   content - 菜单项的内容
  //   icon - 菜单项的图标
  ExtendContextMenu(menuItems: Array<TextMenuItem>) {
    // 遍历当前上下文菜单的菜单项
    // 可以通过 id 来识别是什么菜单项
    //   CUT - 剪切
    //   COPY - 复制
    //   PASTE - 粘贴
    //   SELECT_ALL - 全选
    menuItems.forEach((value, index) => {
      if (value.id.equals(TextMenuItemId.COPY)) {
        MyLog.d("复制")
      }
    })
    let item1: TextMenuItem = {
      id: TextMenuItemId.of('item1'),
      content: 'item 1',
      icon: $r('app.media.app_icon'),
    }
    let item2: TextMenuItem = {
      id: TextMenuItemId.of('item2'),
      content: 'item 2',
      icon: $r('app.media.app_icon'),
    }
    menuItems.push(item1) // 在当前上下文菜单的结尾增加一个指定的菜单项
    menuItems.unshift(item2) // 在当前上下文菜单的开头增加一个指定的菜单项
    return menuItems
  }

  // 自定义的 Text 内容选中后的上下文菜单
  // Menu() - 上下文菜单，可以定义多组菜单
  //   MenuItemGroup() - 某一组菜单，可以定义多个菜单项
  //     MenuItem() - 某一菜单项
  //       startIcon - 菜单项起始处的图标
  //       content - 菜单项的内容
  //       onClick() - 菜单项被点击后
  @Builder MyContextMenu() {
    Column() {
      Menu() {
        MenuItemGroup() {
          MenuItem({ startIcon: $r('app.media.app_icon'), content: "menu 1" })
            .onClick((event) => {
              // 关闭指定的菜单
              this.controller.closeSelectionMenu();
            })
          MenuItem({ startIcon: $r('app.media.app_icon'), content: "menu 2" })
          MenuItem({ startIcon: $r('app.media.app_icon'), content: "menu 3" })
        }
        .backgroundColor(Color.Orange)
      }
    }
  }

  build() {
    Column({ space: 30 }) {
      Text(this.message).fontSize(12)

      /*
       * textSelectable() - 是否允许选中 Text 中的内容（TextSelectableMode 枚举）
       *   SELECTABLE_UNFOCUSABLE, SELECTABLE_FOCUSABLE, UNSELECTABLE
       * selection() - 通过指定起始位置和结束位置，设置当前被选中的内容
       * copyOption() - 复制 Text 中被选中的内容时的行为（CopyOptions 枚举）
       *   None - 不支持复制（默认值，此时不允许选中 Text 中的内容）
       *   InApp - 应用内复制
       *   LocalDevice - 设备内复制
       *   CROSS_DEVICE - 跨设备复制
       * onCopy() - 选中的内容复制后触发的事件
       */
      Text('HarmonyOS SDK 是面向鸿蒙原生应用和元服务开发的开放能力合集，提供包括应用框架、应用服务、系统、媒体、AI、图形在内的六大领域丰富完备的开放能力，助力构建焕然一新的鸿蒙原生应用和元服务，带来创新易用的全场景体验。')
        .fontSize(16)
        .textSelectable(TextSelectableMode.SELECTABLE_UNFOCUSABLE)
        .selection(10, 50)
        .copyOption(CopyOptions.InApp)
        .onCopy((value: string) => {
          this.message = '复制的内容：' + value
        })

      /*
       * Text 内可以声明多个 Span, ImageSpan, ContainerSpan, SymbolSpan 子组件，详见相关说明
       * bindSelectionMenu() - 使用自定义的上下文菜单
       *   spanType - 哪种类型的内容被选中后需要弹出自定义的上下文菜单（TextSpanType 枚举）
       *     TEXT - 选中的内容只有文本时
       *     IMAGE - 选中的内容只有图片时
       *     MIXED - 选中的内容既有文本又有图片时
       *   content - 自定义的上下文菜单组件
       *   TextResponseType - 调出上下文菜单的方式（TextResponseType 枚举）
       *     RIGHT_CLICK - 右键
       *     LONG_PRESS - 长按
       *     SELECT - 鼠标选择
       *   options - 选项
       *     onAppear - 自定义菜单弹出时的回调
       *     onDisappear - 自定义菜单关闭时的回调
       *   onTextSelectionChange - 选中内容发生变化时的回调
       *     selectionStart - 选中内容的起始位置
       *     selectionEnd - 选中内容的结束位置
       */
      Text(undefined, { controller: this.controller }) {
        Span('hello webabcd')
        ImageSpan($r('app.media.son'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
      }
      .fontSize(16)
      .copyOption(CopyOptions.InApp)
      .bindSelectionMenu(TextSpanType.MIXED, this.MyContextMenu, TextResponseType.LONG_PRESS, {
        onAppear: () => {
          this.message = `自定义菜单弹出了`;
        },
        onDisappear: () => {
          this.message = `自定义菜单关闭了`;
        },
      })
      .onTextSelectionChange((selectionStart: number, selectionEnd: number) => {
        this.message = `选中内容发生了变化：selectionStart:${selectionStart}, selectionEnd:${selectionEnd}`;
      })

      /*
       * editMenuOptions() - 扩展默认的上下文菜单
       *   onCreateMenu - 扩展上下文菜单的具体逻辑
       *   onMenuItemClick - 上下文菜单中的某一菜单项被点击后的回调
       *     menuItem - 被点击的菜单项
       *       id - 菜单项的标识，一般通过此值判断是哪个菜单项被点击了
       *         TextMenuItemId.CUT - 剪切
       *         TextMenuItemId.COPY - 复制
       *         TextMenuItemId.PASTE - 粘贴
       *         TextMenuItemId.SELECT_ALL - 全选
       *     textRange - 被选中的内容的范围
       *       start - 起始位置
       *       end - 结束位置
       */
      Text('hello webabcd')
        .fontSize(16)
        .copyOption(CopyOptions.InApp)
        .editMenuOptions({
          onCreateMenu: this.ExtendContextMenu,
          onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
            if (menuItem.id.equals(TextMenuItemId.of("item1"))) {
              this.message = "item1 clicked, start:" + textRange.start + "; end:" + textRange.end
              return true;
            }
            if (menuItem.id.equals(TextMenuItemId.COPY)) {
              this.message = "复制按钮被点击了, start:" + textRange.start + "; end:" + textRange.end
              // 返回值代表 handled（是否已被处理）
              //   返回 true 代表已被处理，则不会执行系统的默认逻辑，以本例来说就是选择的内容不会被复制到剪切板
              //   返回 false 代表未处理，则会执行系统的默认逻辑，以本例来说就是选择的内容会被复制到剪切板
              return false;
            }
            return false;
          }
        })
    }
  }
}

@Component
struct MySample3 {
  aboutToAppear() {
    // 把自定义的字体文件放到类似如下的地址 /entry/src/main/resources/rawfile/myfont.otf
    // font.registerFont() - 注册自定义字体
    //   familyName - 指定一个自定义的字体名称
    //   familySrc - 字体文件的地址
    font.registerFont({
      familyName: 'my-font',
      familySrc: $rawfile('myfont.otf') // 真实路径是 /entry/src/main/resources/rawfile/myfont.otf
    })
  }

  build() {
    Column({ space: 10 }) {
      Text("webabcd webabcd").fontSize(36)
        // 指定自定义的字体名称，从而使用已注册的自定义字体
        .fontFamily('my-font')
    }
  }
}

@Component
struct MySample4 {

  // TextController 是用于和 Text 交互的，声明式编程通常都会用这种方式
  controller: TextController = new TextController()

  @State message: string = "abc\nxyz"

  build() {
    Column({ space: 10 }) {

      // 创建 Text 的时候指定 TextController，后续就可以通过这个 TextController 和这个 Text 交互了
      Text('abcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz\nabcdefghijklmnopqrstuvwxyz', {
        controller: this.controller
      })
        .margin({ top: 30 })
        .backgroundColor(Color.Orange)
        .padding(10)
        .fontSize(16)
        .textSelectable(TextSelectableMode.SELECTABLE_UNFOCUSABLE)
        .selection(3, 10)
        .copyOption(CopyOptions.InApp)

      Button('关闭上下文菜单 closeSelectionMenu()')
        .onClick(() => {
          /*
           * TextController - 用于和绑定的 Text 之间的交互
           *   closeSelectionMenu() - 关闭上下文菜单
           */
          this.controller.closeSelectionMenu()
        })

      Button('获取布局相关信息 getLayoutManager()')
        .onClick(() => {
          /*
           * TextController - 用于和绑定的 Text 之间的交互
           *   getLayoutManager() - 获取布局管理对象
           *     getLineCount() - 获取内容的总行数
           *     getLineMetrics() - 获取指定行的布局相关信息
           *       startIndex - 当前行的起始字符，在整个文本中的索引位置
           *       endIndex - 当前行的结束字符，在整个文本中的索引位置
           *       ascent - 基线到当前行的字符顶部的距离（单位 px）
           *       descent - 基线到当前行的字符底部的距离（单位 px）
           *       baseline - 基线到整个文本顶部的距离（单位 px）
           *       topHeight - 当前行的顶部到整个文本的顶部的距离（单位 px）
           *       width - 当前行的宽（单位 px）
           *       height - 当前行的高（单位 px）
           *       left - 当前行的左侧边缘与 Text 组件的左侧边缘之间的距离（单位 px）
           *       lineNumber - 当前行的行索引位置
           */
          let layoutManager: LayoutManager = this.controller.getLayoutManager()

          let lineCount = layoutManager.getLineCount()
          this.message = `lineCount:${lineCount}\n`

          // 获取第 3 行的布局相关信息
          let lineMetrics = layoutManager.getLineMetrics(2)
          this.message += `startIndex:${lineMetrics.startIndex}, endIndex:${lineMetrics.endIndex},
          ascent:${lineMetrics.ascent}, descent:${lineMetrics.descent}, baseline:${lineMetrics.baseline}, topHeight:${lineMetrics.topHeight},
          width:${lineMetrics.width}, height:${lineMetrics.height}, left:${lineMetrics.left}, lineNumber:${lineMetrics.lineNumber}\n`

          let position = layoutManager.getGlyphPositionAtCoordinate(100, 30)
          this.message += `position:${position.position}, affinity:${position.affinity}`
        })

      Text(this.message).fontSize(16)

      Button('更新属性字符串 setStyledString()')
        .onClick(() => {
          /*
           * TextController - 用于和绑定的 Text 之间的交互
           *   setStyledString() - 设置 StyledString（请参见 StyledStringDemo.ets 中的相关说明）
           */
        })
    }
  }
}