﻿# Harmony Demo


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
3. @Style 相关装饰器（@Style, @Extend, stateStyles）
- pages/basic/StyleDemo
4. 在描述 UI 时使用 if/else, ForEach 语句
- pages/basic/StatementDemo
5. 生命周期
- pages/basic/LifecycleDemo

### 状态管理
1. @State
- pages/state/StateDemo
2. @Prop, @Link, @Provide/@Consume, @Observed/@ObjectLink
- pages/state/PropDemo
3. @Watch, @Track, $$
- pages/state/WatchDemo

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
6. SymbolGlyph（图标符号）
- pages/component/text/SymbolGlyphDemo
7. SymbolSpan（Text 的图标符号子组件）
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

### 组件（按钮类）
1. Button（按钮）
- pages/component/button/ButtonDemo

### 组件（选择类）
1. Toggle（开关，选择框，切换按钮）
- pages/component/selection/ToggleDemo
2. Radio（单选框）
- pages/component/selection/RadioDemo
3. Checkbox（多选框）
- pages/component/selection/CheckboxDemo
4. CheckboxGroup（多选框组）
- pages/component/selection/CheckboxGroupDemo

### 组件（展示类）
1. Badge（标记）
- pages/component/display/BadgeDemo
2. Blank（空白）
- pages/component/display/BlankDemo
3. Divider（分隔线）
- pages/component/display/DividerDemo

### 组件（弹出类）
1. AlertDialog（警告弹框）
- pages/component/flyout/AlertDialogDemo

### 组件（媒体类）
1. Image（图片）
- pages/component/media/ImageDemo

### UI
1. 颜色相关
- pages/ui/ColorDemo
2. 单位相关
- pages/ui/UnitDemo

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
2. 显式动画
- pages/animation/AnimationToDemo
3. 关键帧动画
- pages/animation/KeyframeAnimateDemo
4. 路径动画
- pages/animation/MotionPathDemo
5. 单个组件显示和消失时的过渡动画
- pages/animation/TransitionDemo
6. 一组件显示一组件消失时的过渡动画
- pages/animation/GeometryTransitionDemo
7. 页面转场效果
- pages/animation/PageTransitionDemo
- pages/animation/PageTransitionDemo_1
- pages/animation/PageTransitionDemo_2
- pages/animation/PageTransitionDemo_3