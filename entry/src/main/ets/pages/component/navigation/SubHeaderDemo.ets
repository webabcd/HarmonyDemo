/*
 * SubHeader - 子标题栏
 * 左侧有图标，主标题，子标题，下拉菜单，右侧有一个文本按钮或多个图标按钮
 */

import { LengthMetrics, OperationType, SubHeader, SymbolGlyphModifier, TextModifier } from '@kit.ArkUI';
import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct SubHeaderDemo {

  @Builder myTitle(): void {
    Text('自定义标题').fontSize(24).fontColor(Color.Red).fontWeight(FontWeight.Bold)
  }

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * SubHeader - 子标题栏
       *   titleBuilder - 自定义标题（指定一个自定义组件）
       *   icon - 左侧图标（指定了 icon 后，则 primaryTitle 无效）
       *   iconSymbolOptions - 左侧图标的样式（一个 SymbolOptions 对象）
       *     fontColor, fontSize, fontWeight - 颜色，大小，粗细
       *   primaryTitle - 主标题
       *   primaryTitleModifier - 主标题的样式
       *   secondaryTitle - 子标题
       *   secondaryTitleModifier - 子标题的样式
       *   operationType - 右侧按钮的类型（OperationType 枚举）
       *     TEXT_ARROW - 按钮自带右箭头
       *     BUTTON - 按钮不带右箭头
       *     ICON_GROUP - 图标类型按钮（最多支持 3 个图标）
       *     LOADING - 按钮是一个加载动画
       *   operationItem - 右侧按钮（一个 OperationOption 对象数组）
       *     value - 按钮文本，或图标资源（当 operationType 设置为 OperationType.ICON_GROUP 时）
       *     action - 按钮被点击后的回调
       *   operationSymbolOptions - 右侧图标按钮的样式（一个 SymbolOptions 对象数组），当 operationType 设置为 OperationType.ICON_GROUP 时有效
       *     fontColor, fontSize, fontWeight - 颜色，大小，粗细
       *   select - 左侧下拉菜单（一个 SelectOptions 对象）
       *     options - 选项集合（一个 SelectOption 对象数组）
       *       value - 选项文本
       *       icon - 选项图标
       *       symbolIcon - 选项图标（如果同时设置了 icon 和 symbolIcon，则以 symbolIcon 为准）
       *         关于 SymbolGlyph 请参见 /component/text/SymbolGlyphDemo.ets 中的说明
       *     value - 下拉菜单的主按钮上显示的文字
       *     selected - 选中的选项的索引位置
       *     onSelect() - 选中某一项后的回调
       *       index - 选中项的索引位置
       *       value - 选中项的文本
       *   contentMargin - 外边距
       *   contentPadding - 内边距
       */

      SubHeader({
        icon: $r('app.media.app_icon'),
        iconSymbolOptions: {
          fontColor: [Color.Red],
          fontSize: 24,
          fontWeight: 400,
        },
        secondaryTitle: 'secondaryTitle',
        operationType: OperationType.TEXT_ARROW,
        operationItem: [{ value: 'button', action: () => { } }],
        contentMargin: { start: LengthMetrics.vp(10), end: LengthMetrics.vp(10), top: LengthMetrics.vp(0), bottom: LengthMetrics.vp(0) },
        contentPadding: { start: LengthMetrics.vp(10), end: LengthMetrics.vp(10), top: LengthMetrics.vp(0), bottom: LengthMetrics.vp(0) },
      })

      SubHeader({
        primaryTitle: 'primaryTitle',
        secondaryTitle: 'secondaryTitle',
        operationType: OperationType.BUTTON,
        operationItem: [{ value: 'button', action: () => { } }]
      })

      SubHeader({
        primaryTitle: 'primaryTitle',
        secondaryTitle: 'secondaryTitle',
        operationType: OperationType.LOADING,
      })

      // 左侧有 1 个下拉菜单，右侧有 3 个图标按钮
      SubHeader({
        select: {
          options: [
            { value: 'aaa', icon: $r("app.media.app_icon") },
            { value: 'bbb', icon: $r("app.media.app_icon") },
            { value: 'ccc', icon: $r("app.media.app_icon") },
            { value: 'ddd', symbolIcon: new SymbolGlyphModifier($r('sys.symbol.ohos_wifi')).fontColor([Color.Green]) }
          ],
          value: 'select',
          selected: 2,
          onSelect: (index: number, value?: string) => {  }
        },
        operationType: OperationType.ICON_GROUP,
        operationItem: [
          { value: $r('sys.symbol.ohos_wifi'), action: () => { } },
          { value: $r('sys.symbol.ohos_star'), action: () => { } },
          { value: $r('sys.symbol.ohos_trash'), action: () => { } },
        ],
        operationSymbolOptions: [
          { fontColor: [Color.Red], fontSize: 24, fontWeight: 400, },
          { fontColor: [Color.Green], fontSize: 24, fontWeight: 400, },
          { fontColor: [Color.Blue], fontSize: 24, fontWeight: 400, },
        ]
      })

      // 自定义主标题和子标题的样式
      SubHeader({
        primaryTitle: 'primaryTitle',
        secondaryTitle: 'secondaryTitle',
        primaryTitleModifier:  new TextModifier().fontColor(Color.Red).fontStyle(FontStyle.Italic),
        secondaryTitleModifier:  new TextModifier().fontColor(Color.Green).fontStyle(FontStyle.Italic),
        operationItem: [{ value: 'button', action: () => { } }]
      })

      // 自定义标题
      SubHeader({
        titleBuilder: () => {
          this.myTitle();
        },
        primaryTitle: 'primaryTitle',
        secondaryTitle: 'secondaryTitle',
        operationItem: [{ value: 'button', action: () => { } }]
      })
    }
  }
}