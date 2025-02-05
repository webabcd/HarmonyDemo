# Harmony Demo


### ArkTS 基础
1. 基础
- pages/arkts/basic/Basic
2. 数据类型
- pages/arkts/basic/DataType
3. boolean
- pages/arkts/basic/Boolean
4. number
- pages/arkts/basic/Number
5. string
- pages/arkts/basic/String
6. array
- pages/arkts/basic/Array
7. set
- pages/arkts/basic/Set
8. map
- pages/arkts/basic/Map
9. tuple
- pages/arkts/basic/Tuple

### ArkTS 类
1. enum
- pages/arkts/class/Enum
2. function
- pages/arkts/class/Function
3. interface
- pages/arkts/class/Interface
4. object
- pages/arkts/class/Object
5. 类
- pages/arkts/class/Class
6. 泛型
- pages/arkts/class/Generics
7. 模块
- pages/arkts/module/Main
- pages/arkts/module/a.ets
- pages/arkts/module/b.ets
- pages/arkts/module/c.ets
- pages/arkts/module/d.ets
- pages/arkts/module/e.ets
- pages/arkts/module/f.ets
- pages/arkts/module/g.ets
- pages/arkts/module/h.ets
- pages/arkts/module/i.ets
- pages/arkts/module/j.ets
- pages/arkts/module/k.ets
- pages/arkts/module/l.ets

### ArkTS 进阶
1. ArrayBuffer
- pages/arkts/advanced/ArrayBuffer
2. Promise
- pages/arkts/advanced/Promise
3. async/await
- pages/arkts/advanced/AsyncAwait
4. iterator, generator
- pages/arkts/advanced/IteratorGenerator
5. Proxy, Reflect
- pages/arkts/advanced/ProxyReflect
6. Record, Partial
- pages/arkts/advanced/RecordPartial

### ArkTS 多线程
1. TaskPool（任务池基础）
- pages/arkts/concurrent/TaskPoolDemo
- pages/arkts/concurrent/TaskPoolDemo_1.ets
2. TaskPool（任务池进阶1）
- pages/arkts/concurrent/TaskPoolDemo2
3. TaskPool（任务池进阶2）
- pages/arkts/concurrent/TaskPoolDemo3
4. Worker（工作线程）
- pages/arkts/concurrent/WorkerDemo
- /entry/src/main/ets/workers/myworker.ets
5. @Sendable（多线程共享对象）
- pages/arkts/concurrent/SendableDemo
6. AsyncLock（异步锁）
- pages/arkts/concurrent/AsyncLockDemo
7. use shared（多线程引用相同的模块只被加载一次）
- pages/arkts/concurrent/UseSharedDemo
- pages/arkts/concurrent/UseSharedDemo_1.ets
- pages/arkts/concurrent/UseSharedDemo_2.ets
8. ASON（对 @Sendable 对象做序列化和反序列化）
- pages/arkts/concurrent/ASONDemo

### 开发基础
1. ArkUI 基础
- pages/basic/Hello
2. @Builder 相关装饰器（@Builder, @BuilderParam, @LocalBuilder, WrappedBuilder）
- pages/basic/BuilderDemo
3. 在描述 UI 时使用 if/else, ForEach, LazyForEach, Repeat 语句
- pages/basic/StatementDemo
4. 生命周期
- pages/basic/LifecycleDemo
5. @Reusable（组件复用）
- pages/basic/ReusableDemo

### 状态管理
1. @State
- pages/state/StateDemo
2. @Prop
- pages/state/PropDemo
3. @Link
- pages/state/LinkDemo
4. @ObjectLink/@Observed
- pages/state/ObjectLinkDemo
5. @Provide/@Consume
- pages/state/ProvideConsumeDemo
6. @Require, @Watch, @Track, $$
- pages/state/WatchDemo
7. v2 @ObservedV2/@Trace
- pages/state/v2/ObservedV2Demo
8. v2 @Local
- pages/state/v2/LocalDemo
9. v2 @Param, @Once, @Event
- pages/state/v2/ParamDemo
10. v2 @Provider()/@Consumer()
- pages/state/v2/ProviderConsumerDemo
11. v2 @Require, @Monitor, @Computed, !!
- pages/state/v2/MonitorDemo
12. v2 UIUtils.makeObserved()
- pages/state/v2/MakeObservedDemo
13. MVVM
- pages/state/mvvm/MVVMDemo
- pages/state/mvvm/model/MyModel.ets
- pages/state/mvvm/view/MyTopView.ets
- pages/state/mvvm/view/MyBottomView.ets
- pages/state/mvvm/view/MyListView.ets
- pages/state/mvvm/viewmodel/MyViewModel.ets

### 组件（通用的属性方法和事件方法）
1. 尺寸相关（width, height, aspectRatio, size, constraintSize, margin, padding）
- pages/component/common/SizeDemo
2. 位置相关（align, direction, position, markAnchor, offset）
- pages/component/common/PositionDemo

### 组件（布局类）
1. Column（垂直布局）
- pages/component/layout/ColumnDemo
2. Row（水平布局）
- pages/component/layout/RowDemo
3. Flex（垂直布局或水平布局）
- pages/component/layout/FlexDemo
4. Stack（堆叠布局）
- pages/component/layout/StackDemo
5. RelativeContainer（相对布局）
- pages/component/layout/RelativeContainerDemo
6. GridRow（栅格布局）
- pages/component/layout/GridRowDemo
7. ColumnSplit（垂直分栏布局）
- pages/component/layout/ColumnSplitDemo
8. RowSplit（水平分栏布局）
- pages/component/layout/RowSplitDemo
9. FolderStack（折叠屏悬停状态的堆叠布局）
- pages/component/layout/FolderStackDemo
10. FoldSplitContainer（折叠屏分栏布局）
- pages/component/layout/FoldSplitContainerDemo
11. Scroll（可滚动容器）
- pages/component/layout/ScrollDemo
12. Refresh（下拉刷新容器）
- pages/component/layout/RefreshDemo
13. SideBarContainer（侧边栏容器）
- pages/component/layout/SideBarContainerDemo

### 组件（文本类）
1. Text（文本显示框）
- pages/component/text/TextDemo
2. StyledString（设置文本以及文本的不同位置的不同样式）
- pages/component/text/StyledStringDemo
3. Span（Text 的文本子组件）
- pages/component/text/SpanDemo
4. ImageSpan（Text 的图片子组件）
- pages/component/text/ImageSpanDemo
5. ContainerSpan（Text 的容器子组件）
- pages/component/text/ContainerSpanDemo
6. SymbolGlyph（符号图标）
- pages/component/text/SymbolGlyphDemo
7. SymbolSpan（Text 的符号图标子组件）
- pages/component/text/SymbolSpanDemo
8. Hyperlink（超链接）
- pages/component/text/HyperlinkDemo
9. RichText（html 文本）
- pages/component/text/RichTextDemo
10. TextInput（文本输入框）
- pages/component/text/TextInputDemo
11. TextArea（多行文本输入框）
- pages/component/text/TextAreaDemo
12. Search（搜索框）
- pages/component/text/SearchDemo
13. RichEditor（富文本编辑器）
- pages/component/text/RichEditorDemo
14. Marquee（跑马灯）
- pages/component/text/MarqueeDemo

### 组件（按钮类）
1. Button（按钮）
- pages/component/button/ButtonDemo
2. Toggle（开关，选择框，切换按钮）
- pages/component/button/ToggleDemo
3. ProgressButton（可显示下载进度的下载按钮）
- pages/component/button/ProgressButtonDemo
4. Chip（带文字和图标的支持双状态的按钮）
- pages/component/button/ChipDemo
5. ChipGroup（Chip 组）
- pages/component/button/ChipGroupDemo

### 组件（选择类）
1. Radio（单选框）
- pages/component/selection/RadioDemo
2. Checkbox（多选框）
- pages/component/selection/CheckboxDemo
3. CheckboxGroup（多选框组）
- pages/component/selection/CheckboxGroupDemo
4. Rating（评分框）
- pages/component/selection/RatingDemo
5. Select（下拉菜单）
- pages/component/selection/SelectDemo
6. CalendarPicker（日历选择框）
- pages/component/selection/CalendarPickerDemo
7. DatePicker（日期选择框）
- pages/component/selection/DatePickerDemo
8. TimePicker（时间选择框）
- pages/component/selection/TimePickerDemo
9. TextPicker（文本选择框）
- pages/component/selection/TextPickerDemo
10. Counter（计数器框）
- pages/component/selection/CounterDemo
11. CounterComponent（计数器组件框）
- pages/component/selection/CounterComponentDemo

### 组件（进度类）
1. Progress（进度条）
- pages/component/progress/ProgressDemo
2. LoadingProgress（加载框）
- pages/component/progress/LoadingProgressDemo
3. SwipeRefresher（加载框）
- pages/component/progress/SwipeRefresherDemo
4. Slider（可拖动进度条）
- pages/component/progress/SliderDemo
5. Gauge（环形表进度条）
- pages/component/progress/GaugeDemo

### 组件（展示类）
1. Badge（标记）
- pages/component/display/BadgeDemo
2. Blank（空白）
- pages/component/display/BlankDemo
3. Divider（分隔线）
- pages/component/display/DividerDemo
4. TextClock（系统时间实时显示框）
- pages/component/display/TextClockDemo
5. TextTimer（计时器框）
- pages/component/display/TextTimerDemo
6. ExceptionPrompt（异常提示框）
- pages/component/display/ExceptionPromptDemo
7. DataPanel（数据面板）
- pages/component/display/DataPanelDemo
8. QRCode（二维码）
- pages/component/display/QRCodeDemo
9. PatternLock（手势锁）
- pages/component/display/PatternLockDemo

### 组件（导航类）
1. ComposeTitleBar（主标题栏）
- pages/component/navigation/ComposeTitleBarDemo
2. SubHeader（子标题栏）
- pages/component/navigation/SubHeaderDemo
3. EditableTitleBar（编辑型标题栏）
- pages/component/navigation/EditableTitleBarDemo
4. SelectTitleBar（带下拉标题栏）
- pages/component/navigation/SelectTitleBarDemo
5. TabTitleBar（页签标题栏）
- pages/component/navigation/TabTitleBarDemo
6. ToolBar（工具栏）
- pages/component/navigation/ToolBarDemo
7. Stepper（引导页）
- pages/component/navigation/StepperDemo
8. Tabs（页签导航）
- pages/component/navigation/TabsDemo
9. TabContent（页签导航的某个页签及其对应的内容）
- pages/component/navigation/TabContentDemo
10. Navigation（导航组件的显示）
- pages/component/navigation/NavigationDemo
11. Navigation（导航组件的导航）
- pages/component/navigation/NavigationDemo2
- pages/component/navigation/pages/NavigationDemo2_Page1.ets
- pages/component/navigation/pages/NavigationDemo2_Page2.ets
- pages/component/navigation/pages/NavigationDemo2_Page3.ets
12. Navigation（导航组件的转场动画）
- pages/component/navigation/NavigationDemo3
- pages/component/navigation/pages/NavigationDemo3_Page1.ets
13. NavDestination（导航目标页）
- pages/component/navigation/NavDestinationDemo
14. NavRouter（简版导航）
- pages/component/navigation/NavRouterDemo
15. Navigator（导航器）
- pages/component/navigation/NavigatorDemo
- pages/component/navigation/pages/NavigatorDemo_Page1.ets
16. router（路由接口）
- pages/component/navigation/RouterDemo
- pages/component/navigation/pages/RouterDemo_Page1.ets

### 组件（弹出类）
1. promptAction（toast, menu, dialog, custom）
- pages/component/flyout/PromptActionDemo
2. Popup（弹出框）
- pages/component/flyout/PopupDemo
3. Menu（上下文菜单）
- pages/component/flyout/MenuDemo
4. AlertDialog（警告弹框）
- pages/component/flyout/AlertDialogDemo
5. ActionSheet（列表弹框）
- pages/component/flyout/ActionSheetDemo
6. CustomDialog（自定义弹框）
- pages/component/flyout/CustomDialogDemo
7. CustomDialog 之 TipsDialog（图文弹框）
- pages/component/flyout/CustomDialogDemo_TipsDialog
8. CustomDialog 之 SelectDialog（列表弹框）
- pages/component/flyout/CustomDialogDemo_SelectDialog
9. CustomDialog 之 ConfirmDialog（信息确认弹框）
- pages/component/flyout/CustomDialogDemo_ConfirmDialog
10. CustomDialog 之 AlertDialog（警告弹框）
- pages/component/flyout/CustomDialogDemo_AlertDialog
11. CustomDialog 之 LoadingDialog（加载弹框）
- pages/component/flyout/CustomDialogDemo_LoadingDialog
12. CustomDialog 之 CustomContentDialog（自定义内容弹框）
- pages/component/flyout/CustomDialogDemo_CustomContentDialog
13. CalendarPickerDialog（日历选择弹窗）
- pages/component/flyout/CalendarPickerDialogDemo
14. DatePickerDialog（日期滑动选择弹窗）
- pages/component/flyout/DatePickerDialogDemo
15. TimePickerDialog（时间滑动选择弹窗）
- pages/component/flyout/TimePickerDialogDemo
16. TextPickerDialog（文本滑动选择弹窗）
- pages/component/flyout/TextPickerDialogDemo

### 组件（媒体类）
1. Image（图片）
- pages/component/media/ImageDemo
2. Video（视频播放器）
- pages/component/media/VideoDemo

### 组件（列表类）
1. List（列表基础）
- pages/component/list/ListDemo
2. List（分组列表）
- pages/component/list/ListDemo2
3. List（编辑列表）
- pages/component/list/ListDemo3
4. List（下拉刷新，上拉加载）
- pages/component/list/ListDemo4
5. List（ForEach 的应用）
- pages/component/list/ListDemo5
6. List（LazyForEach 的应用）
- pages/component/list/ListDemo6
7. List（Repeat 的应用）
- pages/component/list/ListDemo7
8. Grid（网格基础）
- pages/component/list/GridDemo
9. Grid（网格布局）
- pages/component/list/GridDemo2
10. Grid（滚动，多选，拖动排序，双指缩放并修改列数）
- pages/component/list/GridDemo3
11. Swiper（组件轮播列表）
- pages/component/list/SwiperDemo
12. WaterFlow（瀑布流列表）
- pages/component/list/WaterFlowDemo
13. GridObjectSortComponent（图标网格，支持增加、删除和排序）
- pages/component/list/GridObjectSortComponentDemo
14. TreeView（树状列表）
- pages/component/list/TreeViewDemo
15. AlphabetIndexer（单字符二级联动列表）
- pages/component/list/AlphabetIndexerDemo

### 组件（webview）
1. Web（基础）
- pages/component/webview/WebDemo
- /entry/src/main/resources/rawfile/html1.html
- /entry/src/main/resources/rawfile/html2.html

### UI
1. 颜色相关
- pages/ui/ColorDemo
2. 单位相关
- pages/ui/UnitDemo
3. 获取组件的尺寸和位置
- pages/ui/ComponentInfoDemo
4. 样式相关
- pages/ui/StyleDemo
- pages/ui/MyButtonAttributeModifier.ets
5. 主题相关
- pages/ui/ThemeDemo
- pages/ui/MyTheme.ets
6. 安全区域
- pages/ui/SafeAreaDemo

### 图形
1. 边框
- pages/shape/BorderDemo
2. 剪裁，遮罩
- pages/shape/ClipDemo
3. 阴影
- pages/shape/ShadowDemo
4. 模糊
- pages/shape/BlurDemo
5. 渐变
- pages/shape/GradientDemo
6. 图形绘制（Circle, Ellipse, Line, Polyline, Polygon, Path, Rect, Shape）
- pages/shape/ShapeDemo
7. 图形变换（transform, rotate, translate, scale, skew）
- pages/shape/TransformDemo

### 动画
1. ImageAnimator（帧动画）
- pages/animation/ImageAnimatorDemo
2. 属性动画
- pages/animation/AnimationDemo
3. @AnimatableExtend 结合 AnimatableArithmetic<T>（让不可动画属性支持属性动画）
- pages/animation/AnimatableExtendDemo
4. 显式动画
- pages/animation/AnimationToDemo
5. 关键帧动画
- pages/animation/KeyframeAnimateDemo
6. 路径动画
- pages/animation/MotionPathDemo
7. 单个组件显示和消失时的过渡动画
- pages/animation/TransitionDemo
8. 一组件显示一组件消失时的过渡动画
- pages/animation/GeometryTransitionDemo
9. 页面转场效果
- pages/animation/PageTransitionDemo
- pages/animation/PageTransitionDemo_1.ets
- pages/animation/PageTransitionDemo_2.ets
- pages/animation/PageTransitionDemo_3.ets
10. Curve（动画曲线）
- pages/animation/CurveDemo

### 资源
1. 图标资源
- pages/resource/IconDemo
2. 国际化
- pages/resource/InternationalizationDemo
- /entry/src/main/resources/base/element/string.json
- /entry/src/main/resources/zh_CN/element/string.json
- /entry/src/main/resources/en_US/element/string.json
3. 资源
- pages/resource/ResourceDemo
- /entry/src/main/resources/base/element/boolean.json
- /entry/src/main/resources/base/element/color.json
- /entry/src/main/resources/base/element/float.json
- /entry/src/main/resources/base/element/integer.json
- /entry/src/main/resources/base/element/strarray.json
- /entry/src/main/resources/base/element/string.json
- /entry/src/main/resources/vertical-xxxldpi/element/string.json
- /entry/src/main/resources/rawfile/mytext.txt
- /entry/src/main/resources/resfile/mytext.txt
