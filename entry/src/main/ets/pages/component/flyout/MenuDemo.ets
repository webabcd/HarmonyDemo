/*
 * Menu - 上下文菜单
 *
 * bindContextMenu() - 为组件绑定一个上下文菜单（长按或右键）
 * bindMenu() - 为组件绑定一个上下文菜单（单击）
 * ContextMenu.close() - 关闭上下文菜单
 *
 * Menu, MenuItemGroup, MenuItem - 构造标准的上下文菜单的相关组件
 */

import { TitleBar } from '../../TitleBar'
import { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI'

@Entry
@Component
struct ContextMenuDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('bindContextMenu()').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('bindMenu()').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('Menu, MenuItemGroup, MenuItem').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State isShown: boolean = false

  @Builder myMenu() {
    Column() {
      Button("button1").onClick(() => {

      })
      Divider()
      Button("button2").onClick(() => {

      })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width(200)
    .height(150)
  }

  build() {
    Column({space:10}) {
      Text(this.message)

      /*
       * bindContextMenu() - 为组件绑定一个上下文菜单（长按或右键）
       *   content - 自定义的菜单组件
       *   responseType - 菜单的弹出条件（ResponseType	枚举）
       *     LongPress, RightClick
       *   options - 选项（一个 ContextMenuOptions 对象）
       *     placement - 弹出菜单相对于绑定的组件的显示位置（Placement 枚举）
       *       Left, Right, Top, Bottom, TopLeft, TopRight, BottomLeft, BottomRight, LeftTop, LeftBottom, RightTop, RightBottom
       *     offset - 弹出菜单在当前位置的基础上的偏移距离
       *     enableArrow - 是否显示箭头
       *     arrowOffset - 箭头的偏移距离
       *     onAppear() - 完全弹出时的回调
       *     onDisappear() - 完全隐藏时的回调
       *     aboutToAppear() - 开始弹出时的回调
       *     aboutToDisappear() - 开始隐藏时的回调
       *     backgroundColor, backgroundBlurStyle - 背景颜色，背景的模糊效果
       *     transition - 菜单的显示消失的动画效果（TransitionEffect 对象）
       *       注：关于 TransitionEffect 的使用请参见 TransitionDemo.ets 中的说明
       *
       * ContextMenu.close() - 关闭上下文菜单
       */
      Text("Text1").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindContextMenu(this.myMenu, ResponseType.LongPress, {
          placement: Placement.BottomLeft,
          offset: {
            x: 50,
            y: 20
          },
          enableArrow: true,
          arrowOffset: 100,
          onAppear: () => {
            // 开始弹出到完全弹出之间会有一段动画效果
            this.message = '完全弹出'
          },
          onDisappear: () => {
            // 开始隐藏到完全隐藏之间会有一段动画效果
            this.message = '完全隐藏'
          },
          aboutToAppear: () => {
            // 开始弹出到完全弹出之间会有一段动画效果
            this.message = '开始弹出'
          },
          aboutToDisappear: () => {
            // 开始隐藏到完全隐藏之间会有一段动画效果
            this.message = '开始隐藏'
          },
          backgroundColor: Color.Transparent,
          backgroundBlurStyle: BlurStyle.Thin,
          transition: TransitionEffect.asymmetric(
            // 菜单出现时的过渡动画效果
            TransitionEffect.SLIDE.animation({ duration: 1000 }),
            // 菜单消失时的过渡动画效果
            TransitionEffect.OPACITY.animation({ duration: 1000 })
          ),
        })

      /*
       * bindContextMenu() - 为组件绑定一个上下文菜单（长按或右键）
       *   isShown - 是否显示菜单
       *   content - 自定义的菜单组件
       *   options - 选项（一个 ContextMenuOptions 对象）
       */
      Text("Text2").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindContextMenu(this.isShown, this.myMenu,{
          placement: Placement.BottomLeft,
          onDisappear: () => {
            this.isShown = false
          },
        })
      Button('显示 Text2 的上下文菜单').onClick(() => {
        this.isShown = !this.isShown
      })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  @Builder myMenu() {
    Column() {
      Button("button1").onClick(() => {

      })
      Divider()
      Button("button2").onClick(() => {

      })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width(200)
    .height(150)
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * bindMenu() - 为组件绑定一个上下文菜单（单击）
       *   content - 自定义的菜单组件
       *   options - 选项（一个 MenuOptions 对象）
       *     showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 的所属窗口之外）
       *     placement - 弹出菜单相对于绑定的组件的显示位置（Placement 枚举）
       *       Left, Right, Top, Bottom, TopLeft, TopRight, BottomLeft, BottomRight, LeftTop, LeftBottom, RightTop, RightBottom
       *     offset - 弹出菜单在当前位置的基础上的偏移距离
       *     enableArrow - 是否显示箭头
       *     arrowOffset - 箭头的偏移距离
       *     onAppear() - 完全弹出时的回调
       *     onDisappear() - 完全隐藏时的回调
       *     aboutToAppear() - 开始弹出时的回调
       *     aboutToDisappear() - 开始隐藏时的回调
       *     backgroundColor, backgroundBlurStyle - 背景颜色，背景的模糊效果
       *     transition - 菜单的显示消失的动画效果（TransitionEffect 对象）
       *       注：关于 TransitionEffect 的使用请参见 TransitionDemo.ets 中的说明
       *
       * ContextMenu.close() - 关闭上下文菜单
       */
      Text("Text1").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindMenu(this.myMenu, {
          showInSubWindow: false,
          placement: Placement.BottomLeft,
          offset: {
            x: 50,
            y: 20
          },
          enableArrow: true,
          arrowOffset: 100,
          onAppear: () => {
            // 开始弹出到完全弹出之间会有一段动画效果
            this.message = '完全弹出'
          },
          onDisappear: () => {
            // 开始隐藏到完全隐藏之间会有一段动画效果
            this.message = '完全隐藏'
          },
          aboutToAppear: () => {
            // 开始弹出到完全弹出之间会有一段动画效果
            this.message = '开始弹出'
          },
          aboutToDisappear: () => {
            // 开始隐藏到完全隐藏之间会有一段动画效果
            this.message = '开始隐藏'
          },
          backgroundColor: Color.Transparent,
          backgroundBlurStyle: BlurStyle.Thin,
          transition: TransitionEffect.asymmetric(
            // 菜单出现时的过渡动画效果
            TransitionEffect.SLIDE.animation({ duration: 1000 }),
            // 菜单消失时的过渡动画效果
            TransitionEffect.OPACITY.animation({ duration: 1000 })
          ),
        })

      /*
       * bindMenu() - 为组件绑定一个上下文菜单（单击）
       *   content - 除了像上面的例子那样指定一个自定义的菜单组件之外，还可以指定一个 MenuElement 对象数组
       *   options - 选项（一个 MenuOptions 对象）
       *     title - 菜单的标题（仅在 content 指定一个 MenuElement 对象数组时有效）
       *
       * MenuElement - 用于定义菜单项
       *   value - 菜单项的文本
       *   icon - 菜单项的图标
       *   symbolIcon - 菜单项的图标（如果同时设置了 icon 和 symbolIcon，则以 symbolIcon 为准）
       *     关于 SymbolGlyph 请参见 /component/text/SymbolGlyphDemo.ets 中的说明
       *   enabled - 是否可点击
       *   action - 点击后的回调
       */
      Text("Text2").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindMenu([
          {
            value: 'menu 1',
            icon: $r('app.media.app_icon'),
            enabled: true,
            action: () => { }
          },
          {
            symbolIcon: new SymbolGlyphModifier($r('sys.symbol.ohos_wifi')).fontColor([Color.Green]),
            value: 'menu 2',
            enabled: false,
            action: () => { }
          },
        ], {
          title: "title",
          placement: Placement.BottomLeft,
        })
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ''

  @Builder mySubMenu() {
    Menu() {
      MenuItem({ content: "item 1", })
      MenuItem({ content: "item 2", })
    }
  }

  /*
   * Menu - 标准的上下文菜单组件
   *   font() - 字体样式（size, weight, style, family）
   *   fontColor() - 字体颜色
   *   radius() - 圆角半径
   *   width() - 宽度
   *   menuItemDivider() - MenuItem 之间的分隔线（一个 DividerStyleOptions 对象）
   *     strokeWidth, color, startMargin, endMargin
   *   menuItemGroupDivider() - MenuItemGroup 之间的分隔线（一个 DividerStyleOptions 对象）
   *     strokeWidth, color, startMargin, endMargin
   *   subMenuExpandingMode() - 子菜单的展开模式（SubMenuExpandingMode 枚举）
   *     SIDE_EXPAND - 侧边通过弹窗打开
   *     EMBEDDED_EXPAND - 内嵌到主菜单展开
   *     STACK_EXPAND - 在主菜单上通过弹窗打开，同时主菜单做半透明效果
   *
   * MenuItemGroup - Menu 内的 MenuItem 分组
   *   header, footer - 组的 header 和 footer，可以指定一个字符串或自定义组件
   *
   * MenuItem - Menu 内的或 MenuItemGroup 内的菜单项（可以指定一个 MenuItemOptions 对象或一个自定义组件）
   *   startIcon, symbolStartIcon - 左侧图标
   *   endIcon, symbolEndIcon - 右侧图标
   *   content - 左侧内容
   *   labelInfo - 右侧内容
   *   contentFont(), contentFontColor() - 左侧内容的字体样式和字体颜色
   *   labelFont(), labelFontColor() - 右侧内容的字体样式和字体颜色
   *   onChange() - 选中状态发生变化时的回调
   */
  @Builder myMenu(subMenuExpandingMode:SubMenuExpandingMode) {
    Menu() {
      MenuItem({
        startIcon: $r("app.media.app_icon"),
        content: "item 1",
        labelInfo: "labelInfo",
        endIcon: $r("app.media.ic_settings"),
      })
        .contentFont({ size: 24, weight: 600 })
        .contentFontColor(Color.Green)
        .labelFont({ size: 24, weight: 600 })
        .labelFontColor(Color.Green)
        .onChange((selected: boolean) => {
          this.message = `item 1: ${selected}`
        })

      MenuItem({
        symbolStartIcon: new SymbolGlyphModifier($r('sys.symbol.ohos_wifi')).fontColor([Color.Green]),
        content: "item 2",
        labelInfo: "labelInfo",
        symbolEndIcon: new SymbolGlyphModifier($r('sys.symbol.ohos_trash')).fontColor([Color.Green]),
      })

      MenuItem({
        content: "item 3（有子菜单）",
        builder: () => this.mySubMenu()
      })

      MenuItemGroup({
        header: 'header',
        footer: 'footer'
      }) {
        MenuItem({ content: "item 1", })
        MenuItem({ content: "item 2", })
      }
    }
    .font({ size: 16, weight: 400 })
    .fontColor(Color.Orange)
    .radius(10)
    .width(300)
    .menuItemDivider({
      strokeWidth: LengthMetrics.vp(5),
      color: Color.Red,
      startMargin: LengthMetrics.vp(0),
      endMargin: LengthMetrics.vp(0),
    })
    .menuItemGroupDivider({
      strokeWidth: LengthMetrics.vp(5),
      color: Color.Blue,
      startMargin: LengthMetrics.vp(0),
      endMargin: LengthMetrics.vp(0),
    })
    .subMenuExpandingMode(subMenuExpandingMode)
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      Text("Text1").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindMenu(this.myMenu(SubMenuExpandingMode.SIDE_EXPAND))
        .bindContextMenu(this.myMenu(SubMenuExpandingMode.SIDE_EXPAND), ResponseType.LongPress)

      Text("Text2").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindMenu(this.myMenu(SubMenuExpandingMode.EMBEDDED_EXPAND))
        .bindContextMenu(this.myMenu(SubMenuExpandingMode.EMBEDDED_EXPAND), ResponseType.LongPress)

      Text("Text3").fontSize(24).textAlign(TextAlign.Center)
        .width('100%').height(100).backgroundColor(Color.Yellow)
        .bindMenu(this.myMenu(SubMenuExpandingMode.STACK_EXPAND))
        .bindContextMenu(this.myMenu(SubMenuExpandingMode.STACK_EXPAND), ResponseType.LongPress)
    }
  }
}