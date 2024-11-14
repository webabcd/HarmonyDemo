/*
 * RichEditor - 富文本编辑器（支持图文混排和文本交互式编辑）
 *
 * 注：部分用法和 Text, TextInput 差不多，详见 TextDemo.ets, TextInputDemo.ets, StyledStringDemo.ets 中的说明
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct RichEditorDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('添加自定义组件').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('自定义上下文菜单').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('属性字符串').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  // RichEditorController 是用于和 RichEditor 交互的，声明式编程通常都会用这种方式
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  @State message: string = ""

  build() {
    Column({space: 10}) {

      Text(this.message).fontSize(16)

      /*
       * RichEditor - 富文本编辑器（可以添加编辑多个不同种类的 span）
       *   placeholder() - 无输入时的占位文本
       *   onReady() - 富文本编辑器初始化完成后的回调
       *   onSelect() - 选中内容后的回调
       *   aboutToIMEInput(), onIMEInputComplete() - 输入字符前和输入字符后的一对回调
       *   aboutToDelete(), onDeleteComplete() - 删除字符前和删除字符后的一对回调
       * RichEditorController - 富文本编辑器的 controller
       *   addTextSpan() - 添加文本 span
       *   addSymbolSpan() - 添加图标符号 span
       *   addImageSpan() - 添加图片 span
       *   addBuilderSpan() - 插入自定义组件 span
       *   updateSpanStyle() - 更新指定范围的文本 span 的样式
       *   updateParagraphStyle() - 更新指定范围的段落的样式
       *   setTypingStyle() - 设置新输入的文本的样式
       *   getTypingStyle() - 获取新输入的文本的样式
       *   getSpans() - 获取指定范围内的所有 span
       *   deleteSpans() - 删除指定范围内的数据
       *   getParagraphs() - 获取指定范围内的所有段落
       *   setSelection() - 设置选中内容的范围
       *   getSelection() - 获取选中内容的范围和选中的内容
       */
      Button("全部斜体").onClick(() => {
        // 全部文本都变为斜体
        this.controller.updateSpanStyle({
          start: -1,
          end: -1,
          textStyle:
          {
            fontStyle: FontStyle.Italic
          }
        })
      })
      Button("字符索引 1 - 4 加粗蓝色").onClick(() => {
        // 将索引位置 1 - 4 的所有文本的样式变为蓝色且加粗
        this.controller.updateSpanStyle({
          start: 1,
          end: 5,
          textStyle:
          {
            fontWeight: FontWeight.Bolder,
            fontColor: Color.Blue,
          }
        })
      })
      Button("获取字符索引 1 - 9 的所有父 span 集合").onClick(() => {
        // 获取索引位置 1 - 9 的内容的所属的所有父 span 集合
        let content = "";
        this.controller.getSpans({
          start: 1,
          end: 10
        }).forEach(item => {
          // 当前 span 是图片 span
          if (typeof(item as RichEditorImageSpanResult)['imageStyle'] != 'undefined'){
            content += (item as RichEditorImageSpanResult).valueResourceStr;
            content += "\n"
          }
          // 当前 span 是图标符号 span
          else if(typeof(item as RichEditorTextSpanResult)['symbolSpanStyle'] != 'undefined') {
            content += (item as RichEditorTextSpanResult).symbolSpanStyle?.fontSize;
            content += "\n"
          }
          // 当前 span 是文本 span
          else {
            content += (item as RichEditorTextSpanResult).value;
            content += "\n"
          }
        })
        this.message = content
      })
      Button("字符索引 1 - 2 删除").onClick(() => {
        // 删除索引位置 1 - 2 的内容
        this.controller.deleteSpans({
          start: 1,
          end: 3
        })
      })
      Button("全部段落居右显示").onClick(() => {
        // 全部段落居右显示
        this.controller.updateParagraphStyle({
          start: -1,
          end: -1,
          style: {
            textAlign: TextAlign.End,
          }
        })
      })

      Column() {
        RichEditor(this.options)
          .placeholder("请输入", {
            fontColor: Color.Gray,
            font: {
              size: 16,
              weight: FontWeight.Normal,
              style: FontStyle.Normal,
              family: "HarmonyOS Sans",
            }
          })
          .onReady(() => {
            // 添加文本 span，并指定其样式以及手势事件
            this.controller.addTextSpan("012345",
              {
                style:
                {
                  fontColor: Color.Orange,
                  fontSize: 32
                },
                gesture:
                {
                  onClick: () => {
                    this.message = "app.media.app_icon onClick"
                  },
                  onLongPress: () => {
                    this.message = "app.media.app_icon onClick onLongPress"
                  }
                }
              })
            // 添加图标符号 span，并指定其样式
            this.controller.addSymbolSpan($r("sys.symbol.wifi"),
              {
                style:
                {
                  fontSize: 32
                }
              })
            // 添加图片 span，并指定其样式
            this.controller.addImageSpan($r("app.media.app_icon"),
              {
                imageStyle:
                {
                  size: ["48vp", "48vp"]
                }
              })
            // 添加文本 span，并指定其样式
            this.controller.addTextSpan("56789",
              {
                style:
                {
                  fontColor: Color.Black,
                  fontSize: 32
                }
              })
            // 设置新输入的文本的样式
            this.controller.setTypingStyle(
              {
                fontColor: Color.Blue,
                fontSize: 48,
              })
          })
          // 选中内容后的回调
          .onSelect((value: RichEditorSelection) => {
            this.message += `\nonSelect: ${value.selection[0]}, ${value.selection[1]}`
          })
          // 输入字符前的回调
          .aboutToIMEInput((value: RichEditorInsertValue) => {
            this.message = `aboutToIMEInput
  insertValue:${value.insertValue},
  insertOffset:${value.insertOffset},
  previewText:${value.previewText}`
            // 返回 true 则代表允许此次输入，然后会调用 onIMEInputComplete()
            // 返回 false 则代表拒绝此次输入，之后也不会调用 onIMEInputComplete()
            return true;
          })
          // 输入字符后的回调
          .onIMEInputComplete((value: RichEditorTextSpanResult) => {
            // value - 输入的字符的所属的 span 的值
            // spanIndex - 输入的字符的所属的 span 在 RichEditor 中的所有 span 中的索引位置
            // offsetInSpan - 输入的字符在所属 span 中的索引位置
            this.message += `\nonIMEInputComplete
  value:${value.value}
  previewText:${value.previewText}
  spanIndex:${value.spanPosition.spanIndex}
  spanRange:${value.offsetInSpan[0]}, ${value.offsetInSpan[1]}`
          })
          // 删除字符前的回调
          .aboutToDelete((value: RichEditorDeleteValue) => {
            // richEditorDeleteSpans - 删除的所有内容的所属 span 的集合（如何判断当前 span 的类型已经在前面说明过了）
            this.message = `aboutToDelete,
offset:${value.offset}
direction:${value.direction}
length:${value.length}
richEditorDeleteSpans length:${value.richEditorDeleteSpans.length}`
            // 返回 true 则代表允许此次删除，然后会调用 onDeleteComplete()
            // 返回 false 则代表拒绝此次删除，之后也不会调用 onDeleteComplete()
            return true;
          })
          // 删除字符后的回调
          .onDeleteComplete(() => {
            this.message += `\nonDeleteComplete`
          })
          .borderWidth(1)
          .borderColor(Color.Blue)
          .width("95%")
          .height("200")
      }
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""
  controller: RichEditorController = new RichEditorController();

  // 自定义组件
  @Builder myBuilder() {
    Row({ space: 10 }) {
      Image($r("app.media.app_icon")).width(24).height(24)
      Text('hello').fontSize(16)
    }.backgroundColor(Color.Orange)
  }
  // 自定义组件 span
  private myBuilderSpan: CustomBuilder = this.myBuilder.bind(this)

  build() {
    Column({space: 10}) {

      Text(this.message).fontSize(16)

      RichEditor({
       controller: this.controller
      })
        .onReady(() => {
          this.controller.addTextSpan("012",
            {
              style:
              {
                fontColor: Color.Red,
                fontSize: 24,
              }
            })
          this.controller.addTextSpan("34567",
            {
              style:
              {
                fontColor: Color.Red,
                fontSize: 24,
              }
            })
        })
        .borderWidth(1)
        .borderColor(Color.Blue)
        .width("95%")
        .height("200")

      Button("插入自定义组件 span")
        .onClick(() => {
          /*
           * addBuilderSpan() - 插入自定义组件 span
           *   value - 需要插入的自定的组件 span
           *   options - 插入选项
           *     offset - 插入的位置
           *   返回值为：插入后，自定义组件 span 在所有 span 中的索引位置
           */
          let index = this.controller.addBuilderSpan(
            this.myBuilderSpan, {
              offset: 5, // 在索引位置 5 之前插入自定义组件 span
            })
          // 以本例来说
          // 第一次在索引位置 5 之前插入自定义组件 span 后，原来的 2 个 span 会变为 4 个 span
          // 第 1 个 span 是 012
          // 第 2 个 span 是 34
          // 第 3 个 span 是 新插入的自定义组件 span
          // 第 4 个 span 是 567
          this.message = `spanIndex:${index}, spansCount:${this.controller.getSpans().length}`
        })
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ''
  controller: RichEditorController = new RichEditorController();

  // 自定义组件
  @Builder myBuilder() {
    Row({ space: 10 }) {
      Image($r("app.media.app_icon")).width(24).height(24)
      Text('hello').fontSize(16)
    }.backgroundColor(Color.Orange)
  }
  // 自定义组件 span
  private myBuilderSpan: CustomBuilder = this.myBuilder.bind(this)

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
    Column({ space: 10 }) {

      /*
       * bindSelectionMenu() - 使用自定义的上下文菜单
       *   spanType - 哪种类型的内容被选中后需要弹出自定义的上下文菜单（RichEditorSpanType 枚举）
       *     TEXT - 选中的内容只有文本时
       *     IMAGE - 选中的内容只有图片时
       *     BUILDER - 选中的内容只有自定义组件 span 时
       *     MIXED - 选中的内容有 2 种或以上的类型时
       *   content - 自定义的上下文菜单组件
       *   TextResponseType - 调出上下文菜单的方式（ResponseType 枚举）
       *     RightClick - 右键
       *     LongPress - 长按
       *   options - 用于设置一些回调函数
       *     onAppear - 自定义菜单弹出时的回调
       *     onDisappear - 自定义菜单关闭时的回调
       */
      RichEditor({
        controller: this.controller
      })
        .onReady(() => {
          this.controller.addTextSpan("01234",
            {
              style:
              {
                fontColor: Color.Orange,
                fontSize: 32
              }
            })
          this.controller.addImageSpan($r("app.media.app_icon"),
            {
              imageStyle:
              {
                size: ["48vp", "48vp"]
              }
            })
          this.controller.addBuilderSpan(this.myBuilderSpan)
        })
        .bindSelectionMenu(RichEditorSpanType.MIXED, this.MyContextMenu, ResponseType.LongPress, {
          onAppear: () => {
            this.message = `自定义菜单弹出了`;
          },
          onDisappear: () => {
            this.message = `自定义菜单关闭了`;
          },
        })
        .borderWidth(1)
        .borderColor(Color.Blue)
        .width("95%")
        .height("200")
    }
  }
}

@Component
struct MySample4 {

  @State message:string = ""
  controller1: RichEditorController = new RichEditorController();
  controller2: TextController = new TextController();

  build() {
    Column({ space: 10 }) {

      RichEditor({
        controller: this.controller1
      })
        .onReady(() => {
          this.controller1.addTextSpan("012345",
            {
              style:
              {
                fontColor: Color.Orange,
                fontSize: 32
              }
            })
          this.controller1.addImageSpan($r("app.media.app_icon"),
            {
              imageStyle:
              {
                size: ["48vp", "48vp"]
              }
            })
          this.controller1.addTextSpan("56789",
            {
              style:
              {
                fontColor: Color.Black,
                fontSize: 32
              }
            })
        })
        .borderWidth(1)
        .borderColor(Color.Blue)
        .width("95%")
        .height("100")

      Text(undefined, { controller: this.controller2 })
        .fontSize(16)

      Text(this.message)
        .fontSize(16)

      /*
       * 关于 RichEditor 的属性字符串，即 StyledString 的用法详见 StyledStringDemo.ets 中的说明
       * RichEditorController - 用于和 RichEditor 交互
       *   toStyledString() - 将指定范围的内容转为 StyledString
       *   fromStyledString() - 将指定的 StyledString 转为 span 集合
       */
      Button("toStyledString() 和 fromStyledString()").onClick(() => {
        // 将全部内容转为 StyledString 对象
        let styledString = this.controller1.toStyledString({
          start: -1,
          end: -1
        })
        this.controller2.setStyledString(styledString)

        let spans = this.controller1.fromStyledString(styledString)
        this.message = JSON.stringify(spans)
      })
    }
  }
}