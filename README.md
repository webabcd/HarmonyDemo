﻿# HarmonyOS Demo（鸿蒙开发的示例代码和说明）

> [我的博客](https://webabcd.cnblogs.com/)

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
1. 基础知识
- pages/basic/Overview
- /readme.txt
- /readme_agc.txt
- /readme_ohpm.txt
2. ArkUI 基础
- pages/basic/Hello
3. @Builder 相关装饰器（@Builder, @BuilderParam, @LocalBuilder, WrappedBuilder）
- pages/basic/BuilderDemo
4. 在描述 UI 时使用 if/else, ForEach, LazyForEach, Repeat 语句
- pages/basic/StatementDemo
5. 生命周期
- pages/basic/LifecycleDemo
6. UIAbility
- pages/basic/UIAbilityDemo
- /entry/src/main/module.json5
- /entry/src/main/ets/entryability/EntryAbility.ets
- /entry/src/main/ets/entryability/EntryAbility2.ets
- /entry/src/main/ets/pages/basic/UIAbilityDemo2.ets
7. UIAbility 的启动类型
- pages/basic/LaunchTypeDemo
- /entry/src/main/ets/entryability/EntryAbility_singleton.ets
- /entry/src/main/ets/entryability/EntryAbility_multiton.ets
- /entry/src/main/ets/entryability/EntryAbility_specified.ets
- /entry/src/main/ets/MyAbilityStage.ets
8. HAP（Harmony Ability Package）
- pages/basic/HapDemo
- /entry/src/main/ets/MyAbilityStage.ets
- /feature1/src/main/ets/feature1ability/Feature1Ability.ets
- /feature1/src/main/ets/pages/Index.ets
9. HSP（Harmony Shared Package）
- pages/basic/HspDemo
- /hsp1/Index.ets
- /hsp1/src/main/ets/utils/Helper.ets
- /hsp1/src/main/ets/components/MyPage.ets
- /hsp1/src/main/ets/pages/Index.ets
10. HAR（Harmony Archive）
- pages/basic/HarDemo
- /har1/Index.ets
- /har1/src/main/ets/utils/Helper.ets
- /har1/src/main/ets/components/MainPage.ets
- /har1/src/main/ets/components/MyPage.ets
- /har2/Index.ets
- /har2/src/main/ets/utils/Helper.ets
- /har2/src/main/ets/components/MainPage.ets
- /har2/src/main/ets/components/MyPage.ets
11. AppStartup - 启动任务
- pages/basic/AppStartupDemo
- /entry/src/main/resources/base/profile/startup_config.json
- /entry/src/main/ets/startup/MyStartupConfigEntry.ets
- /entry/src/main/ets/startup/StartupTask1.ets
- /entry/src/main/ets/startup/StartupTask2.ets
- /entry/src/main/ets/startup/StartupTask3.ets
- /entry/src/main/ets/startup/StartupTask4.ets
12. Context - 上下文
- pages/basic/ContextDemo

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
7. LocalStorage
- pages/state/LocalStorageDemo
8. AppStorage
- pages/state/AppStorageDemo
9. PersistentStorage
- pages/state/PersistentStorageDemo
10. v2 @ObservedV2/@Trace
- pages/state/v2/ObservedV2Demo
11. v2 @Local
- pages/state/v2/LocalDemo
12. v2 @Param, @Once, @Event
- pages/state/v2/ParamDemo
13. v2 @Provider()/@Consumer()
- pages/state/v2/ProviderConsumerDemo
14. v2 @Require, @Monitor, @Computed, !!
- pages/state/v2/MonitorDemo
15. v2 UIUtils.makeObserved()
- pages/state/v2/MakeObservedDemo
16. v2 AppStorageV2
- pages/state/v2/AppStorageV2Demo
- pages/state/v2/AppStorageV2Demo_Page1.ets
17. v2 PersistenceV2
- pages/state/v2/PersistenceV2Demo
18. MVVM
- pages/state/mvvm/MVVMDemo
- pages/state/mvvm/model/MyModel.ets
- pages/state/mvvm/view/MyTopView.ets
- pages/state/mvvm/view/MyBottomView.ets
- pages/state/mvvm/view/MyListView.ets
- pages/state/mvvm/viewmodel/MyViewModel.ets

### 组件（通用的属性方法和事件方法）
1. @Reusable（组件复用）
- pages/component/common/ReusableDemo
2. 尺寸相关（width, height, aspectRatio, size, constraintSize, margin, padding, pixelRound）
- pages/component/common/SizeDemo
3. 位置相关（align, direction, position, markAnchor, offset）
- pages/component/common/PositionDemo
4. 显示相关（visibility, overlay, clickEffect）
- pages/component/common/DisplayDemo
5. 前景背景
- pages/component/common/ForegroundBackgroundDemo
6. 事件相关（onAppear/onDisAppear, onAreaChange/onSizeChange, onVisibleAreaChange, 自定义事件）
- pages/component/common/EventDemo
7. 焦点
- pages/component/common/FocusDemo
8. 自定义组件
- pages/component/common/CustomComponentDemo
9. AttributeModifier, ContentModifier, DrawModifier, GestureModifier
- pages/component/common/ModifierDemo

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
2. Modal（全模态弹出框）
- pages/component/flyout/ModalDemo
3. Sheet（半模态弹出框）
- pages/component/flyout/SheetDemo
4. Popup（弹出框）
- pages/component/flyout/PopupDemo
5. Menu（上下文菜单）
- pages/component/flyout/MenuDemo
6. AlertDialog（警告弹框）
- pages/component/flyout/AlertDialogDemo
7. ActionSheet（列表弹框）
- pages/component/flyout/ActionSheetDemo
8. CustomDialog（自定义弹框）
- pages/component/flyout/CustomDialogDemo
9. CustomDialog 之 TipsDialog（图文弹框）
- pages/component/flyout/CustomDialogDemo_TipsDialog
10. CustomDialog 之 SelectDialog（列表弹框）
- pages/component/flyout/CustomDialogDemo_SelectDialog
11. CustomDialog 之 ConfirmDialog（信息确认弹框）
- pages/component/flyout/CustomDialogDemo_ConfirmDialog
12. CustomDialog 之 AlertDialog（警告弹框）
- pages/component/flyout/CustomDialogDemo_AlertDialog
13. CustomDialog 之 LoadingDialog（加载弹框）
- pages/component/flyout/CustomDialogDemo_LoadingDialog
14. CustomDialog 之 CustomContentDialog（自定义内容弹框）
- pages/component/flyout/CustomDialogDemo_CustomContentDialog
15. CalendarPickerDialog（日历选择弹窗）
- pages/component/flyout/CalendarPickerDialogDemo
16. DatePickerDialog（日期滑动选择弹窗）
- pages/component/flyout/DatePickerDialogDemo
17. TimePickerDialog（时间滑动选择弹窗）
- pages/component/flyout/TimePickerDialogDemo
18. TextPickerDialog（文本滑动选择弹窗）
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
2. Web（拦截）
- pages/component/webview/WebDemo2
- /entry/src/main/resources/rawfile/html2.html
- /entry/src/main/resources/rawfile/html3.html

### 输入
1. 触摸类输入
- pages/input/TouchDemo
2. 键盘类输入
- pages/input/KeyboardDemo
3. 手势识别
- pages/input/GestureDemo
4. 拖拽
- pages/input/DragDropDemo

### UI
1. 颜色相关
- pages/ui/ColorDemo
2. 单位相关
- pages/ui/UnitDemo
3. 样式相关
- pages/ui/StyleDemo
- pages/ui/MyButtonAttributeModifier.ets
4. 主题相关
- pages/ui/ThemeDemo
- pages/ui/MyTheme.ets
5. 安全区域
- pages/ui/SafeAreaDemo
6. 状态栏和导航栏
- pages/ui/SystemBarDemo
7. 屏幕和窗口
- pages/ui/DisplayWindowDemo
8. 获取组件的尺寸和位置
- pages/ui/ComponentInfoDemo
9. 屏幕方向
- pages/ui/OrientationDemo

### 图形
1. 边框
- pages/shape/BorderDemo
2. 剪裁，遮罩
- pages/shape/ClipDemo
3. 阴影
- pages/shape/ShadowDemo
4. 模糊，滤镜
- pages/shape/BlurDemo
5. 渐变
- pages/shape/GradientDemo
6. 图形绘制（Circle, Ellipse, Line, Polyline, Polygon, Path, Rect, Shape）
- pages/shape/ShapeDemo
7. 图形变换（transform, rotate, translate, scale, skew）
- pages/shape/TransformDemo
8. 图像效果
- pages/shape/EffectDemo

### 动画
1. ImageAnimator（帧动画）
- pages/animation/ImageAnimatorDemo
2. AnimatorResult（number 动画）
- pages/animation/AnimatorResultDemo
3. 属性动画
- pages/animation/AnimationDemo
4. @AnimatableExtend 结合 AnimatableArithmetic<T>（让不可动画属性支持属性动画）
- pages/animation/AnimatableExtendDemo
5. 显式动画
- pages/animation/AnimationToDemo
6. 关键帧动画
- pages/animation/KeyframeAnimateDemo
7. 路径动画
- pages/animation/MotionPathDemo
8. 单个组件显示和消失时的过渡动画
- pages/animation/TransitionDemo
9. 一组件显示一组件消失时的过渡动画
- pages/animation/GeometryTransitionDemo
10. 页面转场效果
- pages/animation/PageTransitionDemo
- pages/animation/PageTransitionDemo_1.ets
- pages/animation/PageTransitionDemo_2.ets
- pages/animation/PageTransitionDemo_3.ets
11. Curve（动画曲线）
- pages/animation/CurveDemo

### canvas
1. canvas 基础，动画
- pages/canvas/CanvasDemo
2. 通过 CanvasRenderingContext2D 绘制图形（简单图形，路径图形，贝塞尔曲线，Path2D，画笔样式，渐变色，图像色）
- pages/canvas/CanvasRenderingContext2DDemo
3. 通过 CanvasRenderingContext2D 绘制图形（文本，图像，变换，透明，阴影）
- pages/canvas/CanvasRenderingContext2DDemo2
4. 通过 CanvasRenderingContext2D 绘制图形（图像滤镜，叠加绘制，图层，清除指定的区域，画布转图片，上下文的保存和加载）
- pages/canvas/CanvasRenderingContext2DDemo3

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

### 存储
1. 用户首选项
- pages/storage/PreferencesDemo
2. 应用文件（沙箱目录）
- pages/storage/AppFileDemo
3. 用户文件（公共目录）
- pages/storage/UserFileDemo

### 媒体
1. 保存文件到媒体库
- pages/media/MediaLibraryDemo
2. 从媒体库读取文件
- pages/media/MediaLibraryDemo2
3. AVPlayer（播放器，用于播放视频或音频）
- pages/media/AVPlayerDemo
4. SoundPool（音效播放器）
- pages/media/SoundPoolDemo
5. AVTranscoder（视频转码）
- pages/media/AVTranscoderDemo
- /entry/src/main/ets/workers/transcodeworker.ets
6. AVMetadataExtractor（提取视频或音频的元数据信息）
- pages/media/AVMetadataExtractorDemo
7. AVImageGenerator（提取视频指定时间点的图像）
- pages/media/AVImageGeneratorDemo

### 通知
1. 通知（授权，文本，进度条，角标）
- pages/notification/NotificationDemo
2. 通知（更新，删除，跳转，渠道）
- pages/notification/NotificationDemo2

### 卡片
1. 静态卡片
- pages/widget/StaticWidgetDemo
- /entry/src/main/module.json5
- /entry/src/main/resources/base/profile/form_config.json
- /entry/src/main/ets/entryformability/EntryFormAbility.ets
- /entry/src/main/ets/widget/pages/StaticWidgetCard.ets
2. FormLink（为静态卡片提供与应用交互的能力）
- pages/widget/FormLinkDemo
- /entry/src/main/ets/entryformability/EntryFormAbility.ets
- /entry/src/main/ets/widget/pages/FormLinkCard.ets
- /entry/src/main/ets/entryability/EntryAbility.ets
3. AddFormMenuItem（在应用内添加卡片）
- pages/widget/AddFormMenuItemDemo
- /entry/src/main/resources/base/profile/form_config.json
4. 动态卡片
- pages/widget/DynamicWidgetDemo
- /entry/src/main/module.json5
- /entry/src/main/resources/base/profile/form_config.json
- /entry/src/main/ets/entryformability/EntryFormAbility.ets
- /entry/src/main/ets/widget/pages/DynamicWidgetCard.ets

### 网络
1. http（通过 HttpRequest 实现 http 请求）
- pages/network/HttpDemo
- /webapi/webapi/webserver.py
2. json
- pages/network/JsonDemo
3. http server
- pages/network/HttpServerDemo
4. WebSocket
- pages/network/WebSocketDemo
- /entry/src/main/resources/rawfile/WebSocketClient.html
5. 网络信息
- pages/network/NetworkInfoDemo
6. http（通过 rcp 实现 http 请求，基础）
- pages/network/RcpDemo
- /webapi/webapi/webserver.py
7. http（通过 rcp 实现 http 请求，进阶）
- pages/network/RcpDemo2
- /webapi/webapi/webserver.py
8. http（通过 rcp 实现 http 请求，上传下载和流）
- pages/network/RcpDemo3
- /webapi/webapi/webserver.py

### 后台
1. 短时任务（应用退到后台之后，允许继续运行一段时间）
- pages/background/TransientTaskDemo
2. 长时任务（应用退到后台之后，允许特定任务长时间运行）
- pages/background/ContinuousTaskDemo
3. 延迟任务（由系统决策，在合适的时候执行）
- pages/background/DeferredTaskDemo
- pages/background/MyWorkSchedulerExtensionAbility.ets
4. 提醒任务（提供倒计时提醒或闹钟提醒或日历提醒）
- pages/background/ReminderTaskDemo

### 跨进程通信
1. Deep Linking
- pages/ipc/DeepLinkingDemo
- /entry/src/main/resources/rawfile/DeepLinking.html
- /harmonydemo2/entry/src/main/module.json5
- /harmonydemo2/entry/src/main/ets/entryability/EntryAbility.ets
- /harmonydemo2/entry/src/main/ets/pages/Index.ets
2. App Linking
- pages/ipc/AppLinkingDemo
- /entry/src/main/resources/rawfile/AppLinking.html
- /harmonydemo2/entry/src/main/module.json5
- /harmonydemo2/entry/src/main/ets/entryability/EntryAbility.ets
- /harmonydemo2/entry/src/main/ets/pages/Index.ets
3. Want
- pages/ipc/WantDemo
4. 剪切板
- pages/ipc/PasteboardDemo
5. 系统分享
- pages/ipc/ShareDemo
- /harmonydemo2/entry/src/main/module.json5
- /harmonydemo2/entry/src/main/ets/entryability/EntryAbility.ets
- /harmonydemo2/entry/src/main/ets/pages/Index.ets

### 信息
1. 各种信息
- pages/info/InfoDemo
2. emitter（用于同一进程内不同线程间或同一线程内发送和订阅事件）
- pages/info/EmitterDemo
3. CommonEventManager（用于进程间通信，以及订阅系统事件）
- pages/info/CommonEventManagerDemo

### 元服务
1. 元服务
- pages/atomicservice/AtomicServiceDemo
- /atomicservicedemo/entry/src/main/ets/pages/Index.ets
- /atomicservicedemo/entry/src/main/ets/widget/pages/WidgetCard.ets

### 华为账号
1. 华为账号的默认登录
- pages/account/HuaweiDefaultLoginDemo
- /huaweilogindemo/entry/src/main/ets/pages/HuaweiDefaultLogin.ets
- /entry/src/main/ets/pages/account/readme.txt

### Native Development Kit
1. NDK 基础
- pages/ndk/NdkDemo
- /ndk1/src/main/ets/pages/NdkDemo.ets
- /ndk1/src/main/cpp/napi_init.cpp
- /ndk1/src/main/cpp/CMakeLists.txt
- /ndk1/src/main/cpp/types/libndk1/Index.d.ts
- /ndk1/src/main/cpp/types/libndk1/oh-package.json5

### 安全
1. 加密解密
- pages/security/CryptoDemo
2. 关键资产
- pages/security/AssetStoreDemo
3. 申请权限
- pages/security/PermissionDemo
4. 用户认证
- pages/security/UserAuthenticationDemo

### 优化
1. hilog 日志
- pages/optimize/HiLogDemo
2. HiAppEvent（事件日志）
- pages/optimize/HiAppEventDemo
3. errorManager（捕获未处理异常）
- pages/optimize/ErrorManagerDemo
- /entry/src/main/ets/entryability/EntryAbility.ets
4. HiDebug（用于获取 cpu, 内存等信息）
- pages/optimize/HiDebugDemo

### 测试
1. 单元测试
- pages/test/UnitTest
- /entry/src/test/List.test.ets
- /entry/src/test/UnitTest.test.ets

### 工具
1. Targets, Products
- pages/tool/TargetsProducts
- /entry/build-profile.json5
- /hsp1/build-profile.json5
- /build-profile.json5
- /entry/src/default/MyConfig.ets
- /entry/src/default/resources/base/element/string.json
- /entry/src/target1/MyConfig.ets
- /entry/src/target1/resources/base/element/string.json
- /entry/src/target2/MyConfig.ets
- /entry/src/target2/resources/base/element/string.json