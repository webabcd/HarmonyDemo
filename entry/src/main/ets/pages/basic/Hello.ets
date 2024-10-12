/*
 * ArkUI 使用的是声明式 UI（declarative UI），不是传统的命令式编程
 * 1、UI 的命令式编程：先实例化一个 UI 对象，然后按需求修改这个对象
 * 2、UI 的声明式编程：描述你需要的 UI 即可，需要修改时就重新描述
 * 3、类似的声明式 UI 编程框架还有 Flutter, SwiftUI, Jetpack Compose
 */

// @ 开头的被称为装饰器，比如 @Entry, @Component, @State 等

// @Entry 表示该自定义组件为入口组件
@Entry
// @Component 表示自定义组件
@Component
// 通过 struct 定义组件（不支持继承，请通过组合的方式来实现组件的复用以及界面的构建）
struct Hello {
  // @State 表示组件中的状态变量，状态变量变化会触发UI刷新
  @State message: string = 'Hello World';

  // 构建 UI（在 build 内通过组件描述需要的 UI）
  build() {
    Column({ space: 20 }) {
      Text(this.message)
        .fontSize(16)
        .fontColor(Color.Blue)
      /*
       * Button 是一个按钮组件
       *   组件参数有啥，可通过快捷键 ctrl + p 查看，比如 Button 的参数有 label 和 options
       *   本例的 options 参数是一个 ButtonOptions 接口，这个接口里有什么参数，可以在 {} 中通过快捷键 ctrl + alt + space 查看
       *   其中的 width(), height() 等是属性方法，支持链式调用
       *   其中的 onClick() 等是事件方法，支持链式调用
       */
      Button('Ok', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .width(90)
        .height(40)
        .onClick(()=>{
          this.message = "cccccc"
        })
    }.width('100%').height('100%')
  }
}