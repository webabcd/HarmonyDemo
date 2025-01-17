/*
 * TabContent - 页签导航的某个页签及其对应的内容
 * Tabs 的子组件通过 TabContent 定义某个页签及其对应的内容
 */

import { TitleBar } from '../../TitleBar';
import { SymbolGlyphModifier } from '@kit.ArkUI';

@Entry
@Component
struct TabContentDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('允许定义选中样式和未选中样式的页签').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('图文方式的页签').align(Alignment.Top)
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

  @Builder tabBarBuilder() {
    Text("aaa").fontSize(24)
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      Tabs() {

        /*
         * TabContent - 页签导航的某个页签及其对应的内容
         *   子组件 - 页签对应的内容
         *   tabBar() - 页签
         *     一个字符串
         *     一个自定义组件
         *     一个 { icon, text }
         *   onWillShow() - 切换到此页签之前的回调
         *   onWillHide() - 切换走此页签之前的回调
         */
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Pink)
        }.tabBar(this.tabBarBuilder())

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar("bbb")

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar({
          icon: $r("app.media.app_icon"),
          text: "ccc"
        })
        .onWillShow(() => {
          this.message = "onWillShow"
        })
        .onWillHide(() => {
          this.message = "onWillHide"
        })
      }
      .barMode(BarMode.Fixed)
      .barBackgroundColor(Color.Yellow)
      .barHeight(100)
      .height(200)
    }
  }
}

@Component
struct MySample2 {

  @Builder tabBarBuilder() {
    Text("aaa").fontSize(24)
  }

  /*
   * SubTabBarStyle - 允许定义选中样式和未选中样式的页签
   *   of() - 页签文本
   *   padding() - 内边距
   *   labelStyle() - 页签文本的样式
   *     overflow, maxLines, minFontSize, maxFontSize, heightAdaptivePolicy - 详见 component/text/TextDemo.ets 中的说明
   *     font - 字体（size, style, weight, family）
   *     selectedColor - 选中时的颜色
   *     unselectedColor - 未选中时的颜色
   *   selectedMode() - 页签被选中时的附加效果（SelectedMode 枚举）
   *     INDICATOR - 为页签文本显示一条下划线
   *     BOARD - 为页签文本显示一个背景色
   *   indicator - 页签被选中时，其下划线的样式（仅 SelectedMode.INDICATOR 时有效）
   *     color - 颜色
   *     height - 高度
   *     width - 宽度
   *     borderRadius - 圆角半径
   *     marginTop - 下划线与页签文本的间距
   *   board - 页签被选中时，其背景色的样式（仅 SelectedMode.BOARD 时有效）
   *     borderRadius - 圆角半径
   */
  getTabBar_indicator(text: string) {
    return SubTabBarStyle.of(text)
      .padding({
        top: 0,
        right: 40,
        bottom: 0,
        left: 40
      })
      .labelStyle({
        overflow: TextOverflow.Ellipsis,
        maxLines: 1,
        minFontSize: 24,
        maxFontSize: 24,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
        font: {
          size: 24,
          weight: 400,
        },
        selectedColor: Color.Red,
        unselectedColor: Color.Green,
      })
      .indicator({
        color: Color.Blue,
        height: 20,
        width: 100,
        borderRadius: 5,
        marginTop: 5
      })
      .selectedMode(SelectedMode.INDICATOR)
  }

  getTabBar_board(text: string) {
    return SubTabBarStyle.of(text)
      .padding({
        top: 0,
        right: 40,
        bottom: 0,
        left: 40
      })
      .labelStyle({
        overflow: TextOverflow.Ellipsis,
        maxLines: 1,
        minFontSize: 24,
        maxFontSize: 24,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
        font: {
          size: 24,
          weight: 400,
        },
        selectedColor: Color.Red,
        unselectedColor: Color.Green,
      })
      .board({
        borderRadius: 10,
      })
      .selectedMode(SelectedMode.BOARD)
  }

  build() {
    Column({space:10}) {
      Tabs() {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Pink)
        }.tabBar(this.getTabBar_indicator("pink"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar(this.getTabBar_indicator("red"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar(this.getTabBar_indicator("green"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar(this.getTabBar_indicator("blue"))
      }
      .barMode(BarMode.Scrollable)
      .barBackgroundColor(Color.Yellow)
      .barHeight(100)
      .height(200)

      Tabs() {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Pink)
        }.tabBar(this.getTabBar_board("pink"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar(this.getTabBar_board("red"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar(this.getTabBar_board("green"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar(this.getTabBar_board("blue"))
      }
      .barMode(BarMode.Scrollable)
      .barBackgroundColor(Color.Yellow)
      .barHeight(100)
      .height(200)
    }
  }
}

@Component
struct MySample3 {

  /*
   * BottomTabBarStyle - 图文方式的页签
   *   of() - 页签图文
   *     可以指定一个图标和一个文本
   *     可以指定两个图标（分别是未选中时的图标和选中时的图标）和一个文本
   *   padding() - 内边距
   *   labelStyle() - 页签文本的样式
   *     overflow, maxLines, minFontSize, maxFontSize, heightAdaptivePolicy - 详见 component/text/TextDemo.ets 中的说明
   *     font - 字体（size, style, weight, family）
   *     selectedColor - 选中时的颜色
   *     unselectedColor - 未选中时的颜色
   *   iconStyle() - 页签图标的样式
   *     selectedColor - 选中时的颜色
   *     unselectedColor - 未选中时的颜色
   *   verticalAlign() - 垂直方向的对齐方式
   *     Top, Center, Bottom
   *   layoutMode() - 页签图标和页签文本之间的排列方式（LayoutMode 枚举）
   *     VERTICAL - 图标和文本上下排列
   *     HORIZONTAL - 图标和文本左右排列
   *     AUTO - 页签宽度大于 104vp 则图标和文本左右排列，否则图标和文本上下排列
   *   symmetricExtensible() - 仅 BarMode.Fixed 时有效
   *     false - 每个页签的宽度平均分配
   *     true - 每个页签的宽度平均分配，但是如果某个页签的图文中的文本的长度显示不下，且左右有空白时则允许扩展出去
   */
  getTabBar(text: string) {
    return BottomTabBarStyle.of($r("app.media.app_icon"), text)
      .padding({
        top: 0,
        right: 0,
        bottom: 0,
        left: 0
      })
      .labelStyle({
        overflow: TextOverflow.Ellipsis,
        maxLines: 1,
        minFontSize: 24,
        maxFontSize: 24,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
        font: {
          size: 24,
          weight: 400,
        },
        selectedColor: Color.Red,
        unselectedColor: Color.Green,
      })
      .iconStyle({
        selectedColor: Color.Red,
        unselectedColor: Color.Green,
      })
      .verticalAlign(VerticalAlign.Top)
      .layoutMode(LayoutMode.VERTICAL)
      .symmetricExtensible(true)
  }

  getTabBar2(text: string) {
    return BottomTabBarStyle.of({
      normal: new SymbolGlyphModifier($r('sys.symbol.worldclock_fill_1')), // 未选中时的图标
      selected: new SymbolGlyphModifier($r('sys.symbol.worldclock_fill_2')) // 选中时的图标
    }, text)
  }

  build() {
    Column({space:10}) {

      Tabs() {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Pink)
        }.tabBar(this.getTabBar("pink"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar(this.getTabBar("red"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar(this.getTabBar("green"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar(this.getTabBar("blue"))
      }
      .barMode(BarMode.Fixed)
      .barBackgroundColor(Color.Yellow)
      .barHeight(100)
      .height(200)

      Tabs() {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Pink)
        }.tabBar(this.getTabBar2("pink"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Red)
        }.tabBar(this.getTabBar2("red"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar(this.getTabBar2("green"))
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Blue)
        }.tabBar(this.getTabBar2("blue"))
      }
      .barMode(BarMode.Fixed)
      .barBackgroundColor(Color.Yellow)
      .barHeight(100)
      .height(200)
    }
  }
}