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
- pages/arkts/module/a
- pages/arkts/module/b
- pages/arkts/module/c
- pages/arkts/module/d
- pages/arkts/module/e
- pages/arkts/module/f
- pages/arkts/module/g
- pages/arkts/module/h
- pages/arkts/module/i

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

### ArkTS 多线程
1. TaskPool
- pages/arkts/concurrent/TaskPool
- pages/arkts/concurrent/MyFunctionAndClass
2. Worker
- pages/arkts/concurrent/Worker
- /entry/src/main/ets/workers/myworker

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
12. MVVM
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
5. FolderStack（可识别屏幕折叠悬停的堆叠布局）
- pages/component/layout/FolderStackDemo
6. RelativeContainer（相对布局）
- pages/component/layout/RelativeContainerDemo
7. Scroll（可滚动容器）
- pages/component/layout/ScrollDemo
8. Refresh（下拉刷新容器）
- pages/component/layout/RefreshDemo

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

### 组件（弹出类）
1. promptAction（toast, menu, dialog, custom）
- pages/component/flyout/PromptActionDemo
2. Popup（弹出框）
- pages/component/flyout/PopupDemo
3. AlertDialog（警告弹框）
- pages/component/flyout/AlertDialogDemo
4. ActionSheet（列表弹框）
- pages/component/flyout/ActionSheetDemo
5. CustomDialog（自定义弹框）
- pages/component/flyout/CustomDialogDemo
6. CustomDialog 之 TipsDialog（图文弹框）
- pages/component/flyout/CustomDialogDemo_TipsDialog
7. CustomDialog 之 SelectDialog（列表弹框）
- pages/component/flyout/CustomDialogDemo_SelectDialog
8. CustomDialog 之 ConfirmDialog（信息确认弹框）
- pages/component/flyout/CustomDialogDemo_ConfirmDialog
9. CustomDialog 之 AlertDialog（警告弹框）
- pages/component/flyout/CustomDialogDemo_AlertDialog
10. CustomDialog 之 LoadingDialog（加载弹框）
- pages/component/flyout/CustomDialogDemo_LoadingDialog
11. CustomDialog 之 CustomContentDialog（自定义内容弹框）
- pages/component/flyout/CustomDialogDemo_CustomContentDialog
12. CalendarPickerDialog（日历选择弹窗）
- pages/component/flyout/CalendarPickerDialogDemo
13. DatePickerDialog（日期滑动选择弹窗）
- pages/component/flyout/DatePickerDialogDemo
14. TimePickerDialog（时间滑动选择弹窗）
- pages/component/flyout/TimePickerDialogDemo
15. TextPickerDialog（文本滑动选择弹窗）
- pages/component/flyout/TextPickerDialogDemo

### 组件（媒体类）
1. Image（图片）
- pages/component/media/ImageDemo

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
11. GridObjectSortComponent（图标网格，支持增加、删除和排序）
- pages/component/list/GridObjectSortComponentDemo
12. TreeView（树状列表）
- pages/component/list/TreeViewDemo
13. AlphabetIndexer（单字符二级联动列表）
- pages/component/list/AlphabetIndexerDemo

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
1. 属性动画
- pages/animation/AnimationDemo
2. @AnimatableExtend 结合 AnimatableArithmetic<T>（让不可动画属性支持属性动画）
- pages/animation/AnimatableExtendDemo
3. 显式动画
- pages/animation/AnimationToDemo
4. 关键帧动画
- pages/animation/KeyframeAnimateDemo
5. 路径动画
- pages/animation/MotionPathDemo
6. 单个组件显示和消失时的过渡动画
- pages/animation/TransitionDemo
7. 一组件显示一组件消失时的过渡动画
- pages/animation/GeometryTransitionDemo
8. 页面转场效果
- pages/animation/PageTransitionDemo
- pages/animation/PageTransitionDemo_1.ets
- pages/animation/PageTransitionDemo_2.ets
- pages/animation/PageTransitionDemo_3.ets
9. Curve（动画曲线）
- pages/animation/CurveDemo
