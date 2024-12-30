import { text } from '@kit.ArkGraphics2D';

import { router } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { TextReader } from '@kit.SpeechKit';
import util from '@ohos.util';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import utils from '@arkts.utils';

@Entry
@Component
struct Index {
  @State selectedNode1: number = -1
  @State siteMap: Node1[] = []

  aboutToAppear(): void {
    this.siteMap =
      [
        new Node1("临时测试用", [
          new Node2("ToolBar（工具栏）", "pages/component/navigation/ToolBarDemo"),
          new Node2("TabTitleBar（页签标题栏）", "pages/component/navigation/TabTitleBarDemo"),
          new Node2("TaskPool", "pages/arkts/concurrent/TaskPool2"),
        ]),
        new Node1("ArkTS 基础", [
          new Node2("基础", "pages/arkts/basic/Basic"),
          new Node2("数据类型", "pages/arkts/basic/DataType"),
          new Node2("boolean", "pages/arkts/basic/Boolean"),
          new Node2("number", "pages/arkts/basic/Number"),
          new Node2("string", "pages/arkts/basic/String"),
          new Node2("array", "pages/arkts/basic/Array"),
          new Node2("set", "pages/arkts/basic/Set"),
          new Node2("map", "pages/arkts/basic/Map"),
          new Node2("tuple", "pages/arkts/basic/Tuple"),
        ]),
        new Node1("ArkTS 类", [
          new Node2("enum", "pages/arkts/class/Enum"),
          new Node2("function", "pages/arkts/class/Function"),
          new Node2("interface", "pages/arkts/class/Interface"),
          new Node2("object", "pages/arkts/class/Object"),
          new Node2("类", "pages/arkts/class/Class"),
          new Node2("泛型", "pages/arkts/class/Generics"),
          new Node2("模块", "pages/arkts/module/Main",
            "pages/arkts/module/a.ets|pages/arkts/module/b.ets|pages/arkts/module/c.ets|pages/arkts/module/d.ets|pages/arkts/module/e.ets|pages/arkts/module/f.ets|pages/arkts/module/g.ets|pages/arkts/module/h.ets|pages/arkts/module/i.ets|pages/arkts/module/j.ets|pages/arkts/module/k.ets|pages/arkts/module/l.ets"),
        ]),
        new Node1("ArkTS 进阶", [
          new Node2("ArrayBuffer", "pages/arkts/advanced/ArrayBuffer"),
          new Node2("Promise", "pages/arkts/advanced/Promise"),
          new Node2("async/await", "pages/arkts/advanced/AsyncAwait"),
          new Node2("iterator, generator", "pages/arkts/advanced/IteratorGenerator"),
          new Node2("Proxy, Reflect", "pages/arkts/advanced/ProxyReflect"),
        ]),
        new Node1("ArkTS 多线程", [
          new Node2("TaskPool", "pages/arkts/concurrent/TaskPool", "pages/arkts/concurrent/SendableDemo_MyFunctionAndClass.ets"),
          new Node2("Worker", "pages/arkts/concurrent/Worker", "/entry/src/main/ets/workers/myworker"),
          new Node2("@Sendable（多线程共享对象）", "pages/arkts/concurrent/SendableDemo"),
          new Node2("use shared（多线程引用相同的模块只被加载一次）", "pages/arkts/concurrent/UseSharedDemo", "pages/arkts/concurrent/UseSharedDemo_1.ets|pages/arkts/concurrent/UseSharedDemo_2.ets"),
          new Node2("ASON（对 @Sendable 对象做序列化和反序列化）", "pages/arkts/concurrent/ASONDemo"),
        ]),
        new Node1("开发基础", [
          new Node2("ArkUI 基础", "pages/basic/Hello"),
          new Node2("@Builder 相关装饰器（@Builder, @BuilderParam, @LocalBuilder, WrappedBuilder）",
            "pages/basic/BuilderDemo"),
          new Node2("在描述 UI 时使用 if/else, ForEach, LazyForEach, Repeat 语句", "pages/basic/StatementDemo"),
          new Node2("生命周期", "pages/basic/LifecycleDemo"),
          new Node2("@Reusable（组件复用）", "pages/basic/ReusableDemo"),
        ]),
        new Node1("状态管理", [
          new Node2("@State", "pages/state/StateDemo"),
          new Node2("@Prop", "pages/state/PropDemo"),
          new Node2("@Link", "pages/state/LinkDemo"),
          new Node2("@ObjectLink/@Observed", "pages/state/ObjectLinkDemo"),
          new Node2("@Provide/@Consume", "pages/state/ProvideConsumeDemo"),
          new Node2("@Require, @Watch, @Track, $$", "pages/state/WatchDemo"),
          new Node2("v2 @ObservedV2/@Trace", "pages/state/v2/ObservedV2Demo"),
          new Node2("v2 @Local", "pages/state/v2/LocalDemo"),
          new Node2("v2 @Param, @Once, @Event", "pages/state/v2/ParamDemo"),
          new Node2("v2 @Provider()/@Consumer()", "pages/state/v2/ProviderConsumerDemo"),
          new Node2("v2 @Require, @Monitor, @Computed, !!", "pages/state/v2/MonitorDemo"),
          new Node2("v2 UIUtils.makeObserved()", "pages/state/v2/MakeObservedDemo"),
          new Node2("MVVM", "pages/state/mvvm/MVVMDemo", "pages/state/mvvm/model/MyModel.ets|pages/state/mvvm/view/MyTopView.ets|pages/state/mvvm/view/MyBottomView.ets|pages/state/mvvm/view/MyListView.ets|pages/state/mvvm/viewmodel/MyViewModel.ets"),
        ]),
        new Node1("组件（通用的属性方法和事件方法）", [
          new Node2("尺寸相关（width, height, aspectRatio, size, constraintSize, margin, padding）",
            "pages/component/common/SizeDemo"),
          new Node2("位置相关（align, direction, position, markAnchor, offset）", "pages/component/common/PositionDemo"),
        ]),
        new Node1("组件（布局类）", [
          new Node2("Column（垂直布局）", "pages/component/layout/ColumnDemo"),
          new Node2("Row（水平布局）", "pages/component/layout/RowDemo"),
          new Node2("Flex（垂直布局或水平布局）", "pages/component/layout/FlexDemo"),
          new Node2("Stack（堆叠布局）", "pages/component/layout/StackDemo"),
          new Node2("RelativeContainer（相对布局）", "pages/component/layout/RelativeContainerDemo"),
          new Node2("GridRow（栅格布局）", "pages/component/layout/GridRowDemo"),
          new Node2("ColumnSplit（垂直分栏布局）", "pages/component/layout/ColumnSplitDemo"),
          new Node2("RowSplit（水平分栏布局）", "pages/component/layout/RowSplitDemo"),
          new Node2("FolderStack（折叠屏悬停状态的堆叠布局）", "pages/component/layout/FolderStackDemo"),
          new Node2("FoldSplitContainer（折叠屏分栏布局）", "pages/component/layout/FoldSplitContainerDemo"),
          new Node2("Scroll（可滚动容器）", "pages/component/layout/ScrollDemo"),
          new Node2("Refresh（下拉刷新容器）", "pages/component/layout/RefreshDemo"),
          new Node2("SideBarContainer（侧边栏容器）", "pages/component/layout/SideBarContainerDemo"),
        ]),
        new Node1("组件（文本类）", [
          new Node2("Text（文本显示框）", "pages/component/text/TextDemo"),
          new Node2("StyledString（设置文本以及文本的不同位置的不同样式）", "pages/component/text/StyledStringDemo"),
          new Node2("Span（Text 的文本子组件）", "pages/component/text/SpanDemo"),
          new Node2("ImageSpan（Text 的图片子组件）", "pages/component/text/ImageSpanDemo"),
          new Node2("ContainerSpan（Text 的容器子组件）", "pages/component/text/ContainerSpanDemo"),
          new Node2("SymbolGlyph（符号图标）", "pages/component/text/SymbolGlyphDemo"),
          new Node2("SymbolSpan（Text 的符号图标子组件）", "pages/component/text/SymbolSpanDemo"),
          new Node2("Hyperlink（超链接）", "pages/component/text/HyperlinkDemo"),
          new Node2("RichText（html 文本）", "pages/component/text/RichTextDemo"),
          new Node2("TextInput（文本输入框）", "pages/component/text/TextInputDemo"),
          new Node2("TextArea（多行文本输入框）", "pages/component/text/TextAreaDemo"),
          new Node2("Search（搜索框）", "pages/component/text/SearchDemo"),
          new Node2("RichEditor（富文本编辑器）", "pages/component/text/RichEditorDemo"),
          new Node2("Marquee（跑马灯）", "pages/component/text/MarqueeDemo"),
        ]),
        new Node1("组件（按钮类）", [
          new Node2("Button（按钮）", "pages/component/button/ButtonDemo"),
          new Node2("Toggle（开关，选择框，切换按钮）", "pages/component/button/ToggleDemo"),
          new Node2("ProgressButton（可显示下载进度的下载按钮）", "pages/component/button/ProgressButtonDemo"),
          new Node2("Chip（带文字和图标的支持双状态的按钮）", "pages/component/button/ChipDemo"),
          new Node2("ChipGroup（Chip 组）", "pages/component/button/ChipGroupDemo"),
        ]),
        new Node1("组件（选择类）", [
          new Node2("Radio（单选框）", "pages/component/selection/RadioDemo"),
          new Node2("Checkbox（多选框）", "pages/component/selection/CheckboxDemo"),
          new Node2("CheckboxGroup（多选框组）", "pages/component/selection/CheckboxGroupDemo"),
          new Node2("Rating（评分框）", "pages/component/selection/RatingDemo"),
          new Node2("Select（下拉菜单）", "pages/component/selection/SelectDemo"),
          new Node2("CalendarPicker（日历选择框）", "pages/component/selection/CalendarPickerDemo"),
          new Node2("DatePicker（日期选择框）", "pages/component/selection/DatePickerDemo"),
          new Node2("TimePicker（时间选择框）", "pages/component/selection/TimePickerDemo"),
          new Node2("TextPicker（文本选择框）", "pages/component/selection/TextPickerDemo"),
          new Node2("Counter（计数器框）", "pages/component/selection/CounterDemo"),
          new Node2("CounterComponent（计数器组件框）", "pages/component/selection/CounterComponentDemo"),
        ]),
        new Node1("组件（进度类）", [
          new Node2("Progress（进度条）", "pages/component/progress/ProgressDemo"),
          new Node2("LoadingProgress（加载框）", "pages/component/progress/LoadingProgressDemo"),
          new Node2("SwipeRefresher（加载框）", "pages/component/progress/SwipeRefresherDemo"),
          new Node2("Slider（可拖动进度条）", "pages/component/progress/SliderDemo"),
          new Node2("Gauge（环形表进度条）", "pages/component/progress/GaugeDemo"),
        ]),
        new Node1("组件（展示类）", [
          new Node2("Badge（标记）", "pages/component/display/BadgeDemo"),
          new Node2("Blank（空白）", "pages/component/display/BlankDemo"),
          new Node2("Divider（分隔线）", "pages/component/display/DividerDemo"),
          new Node2("TextClock（系统时间实时显示框）", "pages/component/display/TextClockDemo"),
          new Node2("TextTimer（计时器框）", "pages/component/display/TextTimerDemo"),
          new Node2("ExceptionPrompt（异常提示框）", "pages/component/display/ExceptionPromptDemo"),
          new Node2("DataPanel（数据面板）", "pages/component/display/DataPanelDemo"),
          new Node2("QRCode（二维码）", "pages/component/display/QRCodeDemo"),
          new Node2("PatternLock（手势锁）", "pages/component/display/PatternLockDemo"),
        ]),
        new Node1("组件（导航类）", [
          new Node2("ToolBar（工具栏）", "pages/component/navigation/ToolBarDemo"),
        ]),
        new Node1("组件（弹出类）", [
          new Node2("promptAction（toast, menu, dialog, custom）", "pages/component/flyout/PromptActionDemo"),
          new Node2("Popup（弹出框）", "pages/component/flyout/PopupDemo"),
          new Node2("Menu（上下文菜单）", "pages/component/flyout/MenuDemo"),
          new Node2("AlertDialog（警告弹框）", "pages/component/flyout/AlertDialogDemo"),
          new Node2("ActionSheet（列表弹框）", "pages/component/flyout/ActionSheetDemo"),
          new Node2("CustomDialog（自定义弹框）", "pages/component/flyout/CustomDialogDemo"),
          new Node2("CustomDialog 之 TipsDialog（图文弹框）", "pages/component/flyout/CustomDialogDemo_TipsDialog"),
          new Node2("CustomDialog 之 SelectDialog（列表弹框）", "pages/component/flyout/CustomDialogDemo_SelectDialog"),
          new Node2("CustomDialog 之 ConfirmDialog（信息确认弹框）", "pages/component/flyout/CustomDialogDemo_ConfirmDialog"),
          new Node2("CustomDialog 之 AlertDialog（警告弹框）", "pages/component/flyout/CustomDialogDemo_AlertDialog"),
          new Node2("CustomDialog 之 LoadingDialog（加载弹框）", "pages/component/flyout/CustomDialogDemo_LoadingDialog"),
          new Node2("CustomDialog 之 CustomContentDialog（自定义内容弹框）", "pages/component/flyout/CustomDialogDemo_CustomContentDialog"),
          new Node2("CalendarPickerDialog（日历选择弹窗）", "pages/component/flyout/CalendarPickerDialogDemo"),
          new Node2("DatePickerDialog（日期滑动选择弹窗）", "pages/component/flyout/DatePickerDialogDemo"),
          new Node2("TimePickerDialog（时间滑动选择弹窗）", "pages/component/flyout/TimePickerDialogDemo"),
          new Node2("TextPickerDialog（文本滑动选择弹窗）", "pages/component/flyout/TextPickerDialogDemo"),
        ]),
        new Node1("组件（媒体类）", [
          new Node2("Image（图片）", "pages/component/media/ImageDemo"),
        ]),
        new Node1("组件（列表类）", [
          new Node2("List（列表基础）", "pages/component/list/ListDemo"),
          new Node2("List（分组列表）", "pages/component/list/ListDemo2"),
          new Node2("List（编辑列表）", "pages/component/list/ListDemo3"),
          new Node2("List（下拉刷新，上拉加载）", "pages/component/list/ListDemo4"),
          new Node2("List（ForEach 的应用）", "pages/component/list/ListDemo5"),
          new Node2("List（LazyForEach 的应用）", "pages/component/list/ListDemo6"),
          new Node2("List（Repeat 的应用）", "pages/component/list/ListDemo7"),
          new Node2("Grid（网格基础）", "pages/component/list/GridDemo"),
          new Node2("Grid（网格布局）", "pages/component/list/GridDemo2"),
          new Node2("Grid（滚动，多选，拖动排序，双指缩放并修改列数）", "pages/component/list/GridDemo3"),
          new Node2("Swiper（组件轮播列表）", "pages/component/list/SwiperDemo"),
          new Node2("WaterFlow（瀑布流列表）", "pages/component/list/WaterFlowDemo"),
          new Node2("GridObjectSortComponent（图标网格，支持增加、删除和排序）", "pages/component/list/GridObjectSortComponentDemo"),
          new Node2("TreeView（树状列表）", "pages/component/list/TreeViewDemo"),
          new Node2("AlphabetIndexer（单字符二级联动列表）", "pages/component/list/AlphabetIndexerDemo"),
        ]),
        new Node1("UI", [
          new Node2("颜色相关", "pages/ui/ColorDemo"),
          new Node2("单位相关", "pages/ui/UnitDemo"),
          new Node2("获取组件的尺寸和位置", "pages/ui/ComponentInfoDemo"),
          new Node2("样式相关", "pages/ui/StyleDemo", "pages/ui/MyButtonAttributeModifier.ets"),
          new Node2("主题相关", "pages/ui/ThemeDemo", "pages/ui/MyTheme.ets"),
        ]),
        new Node1("图形", [
          new Node2("边框", "pages/shape/BorderDemo"),
          new Node2("剪裁，遮罩", "pages/shape/ClipDemo"),
          new Node2("阴影", "pages/shape/ShadowDemo"),
          new Node2("模糊", "pages/shape/BlurDemo"),
          new Node2("渐变", "pages/shape/GradientDemo"),
          new Node2("图形绘制（Circle, Ellipse, Line, Polyline, Polygon, Path, Rect, Shape）", "pages/shape/ShapeDemo"),
          new Node2("图形变换（transform, rotate, translate, scale, skew）", "pages/shape/TransformDemo"),
        ]),
        new Node1("动画", [
          new Node2("属性动画", "pages/animation/AnimationDemo"),
          new Node2("@AnimatableExtend 结合 AnimatableArithmetic<T>（让不可动画属性支持属性动画）", "pages/animation/AnimatableExtendDemo"),
          new Node2("显式动画", "pages/animation/AnimationToDemo"),
          new Node2("关键帧动画", "pages/animation/KeyframeAnimateDemo"),
          new Node2("路径动画", "pages/animation/MotionPathDemo"),
          new Node2("单个组件显示和消失时的过渡动画", "pages/animation/TransitionDemo"),
          new Node2("一组件显示一组件消失时的过渡动画", "pages/animation/GeometryTransitionDemo"),
          new Node2("页面转场效果", "pages/animation/PageTransitionDemo", "pages/animation/PageTransitionDemo_1.ets|pages/animation/PageTransitionDemo_2.ets|pages/animation/PageTransitionDemo_3.ets"),
          new Node2("Curve（动画曲线）", "pages/animation/CurveDemo"),
        ]),
      ]
    let md = this.siteMapToMarkdown()
    return;

    /*
     * 因为用 Previewer 测试时，无法读取本地资源文件，所以只能用上面的方式构造索引数据，如果用模拟器或真机测试的时候就可以不用上面的代码，而用下面的代码了
     */

    let context = getContext(this)
    try {
      context.resourceManager.getRawFileContent("README.md").then((uint8Array) => {
        let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
        let str = textDecoder.decodeToString(uint8Array);
        let lines = str.split('\n');
        let n: Node1 | undefined;

        for (let i = 0; i < lines.length; i++) {
          let line = lines[i];
          if (line.startsWith('###')) {
            n = new Node1(line.substring(4).trim(), [])
            this.siteMap.push(n)
          } else if (n !== undefined && line.includes('. ')) {
            n.childNodes?.push(new Node2(
              line.trim(),
              lines[++i].substring(lines[i].indexOf('-') + 2).trim()
            ));
          }
        }
      });
    } catch (error) {
      console.error("Error reading file: ", error);
    }
  }

  siteMapToMarkdown() {
    let md = "# Harmony Demo\n\n"
    for (let i = 0; i < this.siteMap.length; i++) {
      let node1 = this.siteMap[i]
      md += `\n### ${node1.title}\n`
      for (let j = 0; j < node1.childNodes!.length; j++) {
        let node2 = node1.childNodes![j]
        md += `${j + 1}. ${node2.title}\n`
        md += `- ${node2.url}\n`
        if (node2.other != "") {
          let ary = node2.other.split('|')
          for (let value of ary) {
            md += `- ${value}\n`
          }
        }
      }
    }
    return md
  }

  scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column() {
        ForEach(this.siteMap, (node1: Node1, index: number) => {
          Column() {
            Row() {
              Text(node1.title)
                .fontSize(16)
                .margin({ left: 16 })

              Blank()

              Image(this.selectedNode1 == index ? $r('app.media.ic_arrow_down') : $r('app.media.ic_arrow_right'))
                .width(24)
                .height(24)
                .margin({ right: 6 })
            }
            .height(56)
            .width('100%')
            .onClick(() => {
              if (this.selectedNode1 == index) {
                this.selectedNode1 = -1
              } else {
                this.selectedNode1 = index
              }
            })

            if (this.selectedNode1 == index) {
              ForEach(this.siteMap[this.selectedNode1].childNodes, (node2: Node2) => {
                Column() {
                  Divider()
                    .height(1)
                    .opacity(0.2)
                    .margin({ left: 42, right: 8 })

                  Row() {
                    Text(node2.title)
                      .fontSize(16)
                      .layoutWeight(1)
                      .margin({ left: 42 })
                      .align(Alignment.Start)

                    Blank()
                  }
                  .height(48)
                  .width('100%')
                  .onClick(() => {
                    router.pushUrl({
                      url: node2.url,
                      params: {
                        title: node2.title
                      }
                    })
                  })
                }
              })
            }
          }
        })
      }
    }
  }
}

class Node1 {
  public title: string;
  public childNodes?: Node2[];
  constructor(title: string, childNodes?: Node2[]) {
    this.title = title;
    this.childNodes = childNodes;
  }
}

class Node2 {
  public title: string;
  public url: string;
  public other: string;

  constructor(title: string, url: string, other: string = "") {
    this.title = title;
    this.url = url;
    this.other = other;
  }
}