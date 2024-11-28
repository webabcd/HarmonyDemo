/*
 * Select - 下拉菜单
 */

import { TitleBar } from '../../TitleBar';
import { SymbolGlyphModifier } from '@kit.ArkUI';

@Entry
@Component
struct SelectDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  @State symbolModifier: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.ohos_wifi'))
    .fontColor([Color.Green])
    .symbolEffect(
      new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE),
      true
    )

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      /*
       * Select - 下拉菜单
       *   options - 下拉菜单的选项集合（SelectOption 对象集合）
       *     value - 选项文本
       *     icon - 选项图标
       *     symbolIcon - 选项图标（如果同时设置了 icon 和 symbolIcon，则以 symbolIcon 为准）
       *       关于 SymbolGlyph 请参见 /component/text/SymbolGlyphDemo.ets 中的说明
       *
       *   value() - 下拉菜单的主按钮上显示的文字
       *   font() - 下拉菜单的主按钮上显示的文字的字体样式（size, weight, style, family）
       *   fontColor() - 下拉菜单的主按钮上显示的文字的颜色
       *   arrowPosition() - 下拉菜单的主按钮上的箭头的位置（ArrowPosition 枚举）
       *     END, START
       *   space() - 下拉菜单的主按钮上的文字和箭头之间的距离
       *   controlSize() - 下拉菜单的主按钮的大小（ControlSize.NORMAL 或 ControlSize.SMALL）
       *     指定了 controlSize() 后，主按钮的大小会根据内容自动适应
       *
       *   optionFont() - 选项的字体样式（size, weight, style, family）
       *   optionFontColor() - 选项的字体颜色
       *   optionBgColor() - 选项的背景颜色
       *   divider() - 选项之间的分隔线
       *     strokeWidth, color, startMargin, endMargin
       *     注：如果需要隐藏分隔线的话，就 divider(null) 即可
       *
       *   selected() - 选中的选项的索引位置
       *   selectedOptionFont() - 选中的选项的字体样式（size, weight, style, family）
       *   selectedOptionFontColor() - 选中的选项的字体颜色
       *   selectedOptionBgColor() - 选中的选项的背景颜色
       *
       *   optionWidth() - 选项列表框的宽度
       *   optionHeight() - 选项列表框的最大高度（内容超过最大高度后，则可滚动）
       *   menuBackgroundColor() - 选项列表框的背景颜色
       *   menuBackgroundBlurStyle() - 选项列表框的模糊效果
       *   menuAlign() - 选项列表框相对于主按钮的对齐方式
       *     alignType - 对齐方式（MenuAlignType 枚举）
       *       START, CENTER, END
       *     offset - 在原有位置上的偏移距离
       *
       *   onSelect() - 选中某一项后的回调
       *     index - 选中项的索引位置
       *     text - 选中项的文本
       */
      Select([
        { value: 'aaa', icon: $r("app.media.app_icon") },
        { value: 'bbb', icon: $r("app.media.app_icon") },
        { value: 'ccc', icon: $r("app.media.app_icon") },
        { value: 'ddd', symbolIcon: this.symbolModifier }
      ])

        .value('请选择')
        .font({
          size: 16,
          weight: FontWeight.Normal,
          style: FontStyle.Normal,
          family: 'HarmonyOS Sans',
        })
        .fontColor(Color.Red)
        .arrowPosition(ArrowPosition.END)
        .space(10)
        .controlSize(ControlSize.NORMAL)

        .optionFont({
          size: 16,
          weight: FontWeight.Normal,
          style: FontStyle.Normal,
          family: 'HarmonyOS Sans',
        })
        .optionFontColor(Color.Black)
        .optionBgColor(Color.Transparent)
        // .divider({ strokeWidth: 1, color: Color.Blue, startMargin: 2, endMargin: 2 })
        .divider(null)

        .selected(1)
        .selectedOptionFont({
          size: 18,
          weight: FontWeight.Bold,
          style: FontStyle.Normal,
          family: 'HarmonyOS Sans',
        })
        .selectedOptionFontColor(Color.White)
        .selectedOptionBgColor(Color.Orange)

        .optionWidth(200)
        .optionHeight(500)
        .menuBackgroundColor(Color.White)
        .menuBackgroundBlurStyle(BlurStyle.Thin)
        .menuAlign(MenuAlignType.CENTER, {
          dx: 0,
          dy: 0,
        })

        .onSelect((index:number, text?: string | undefined)=>{
          this.message = `index:${index}, text:${text}`
        })
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column() {
        Select([
          { value: 'item1', icon: $r('app.media.app_icon') },
          { value: 'item1', icon: $r('app.media.app_icon') },
          { value: 'item1', icon: $r('app.media.app_icon') },
        ])
          .optionWidth(200)
          .value('请选择')
          .menuAlign(MenuAlignType.CENTER)
          // 通过 menuItemContentModifier() 实现自定义 MenuItemContent（指定一个实现了 ContentModifier 接口的对象）
          .menuItemContentModifier(new MyMenuItemContentModifier($r('app.media.son')))
    }
  }
}

// 实现 ContentModifier 接口
class MyMenuItemContentModifier implements ContentModifier<MenuItemConfiguration> {

  // 自定义属性
  endIcon: ResourceStr = ""
  // 构造函数
  constructor(endIcon: ResourceStr) {
    this.endIcon = endIcon;
  }

  // 返回指定的自定义 MenuItemContent
  applyContent(): WrappedBuilder<[MenuItemConfiguration]> {
    return wrapBuilder(MenuItemBuilder)
  }
}

// 自定义 MenuItemContent
@Builder function MenuItemBuilder(configuration: MenuItemConfiguration) {
  /*
   * MenuItemConfiguration - 自定义 MenuItemContent 的相关信息
   *   value - 当前选项的文本
   *   icon - 当前选项的图标
   *   symbolIcon - 当前选项的图标
   *   selected - 当前选项是否被选中
   *   index - 当前选项的索引位置
   *   triggerChange() - 触发 Select 的 onSelect() 回调
   */
  Row() {
    Image(configuration.icon).size({ width: 24, height: 24 })
    Text(configuration.value)
    Blank()
    Image((configuration.contentModifier as MyMenuItemContentModifier).endIcon).size({ width: 24, height: 24 })
  }
  .width('100%')
  .onClick(() => {
    configuration.triggerSelect(configuration.index, configuration.value.valueOf().toString())
  })
}