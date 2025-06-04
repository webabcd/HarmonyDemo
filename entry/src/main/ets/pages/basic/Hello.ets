/*
 * ArkUI 基础
 *
 * ArkUI 使用的是声明式 UI（declarative UI），不是传统的命令式编程
 * 1、UI 的命令式编程：先实例化一个 UI 对象，然后按需求修改这个对象
 * 2、UI 的声明式编程：描述你需要的 UI 即可，需要修改时就重新描述
 * 3、类似的声明式 UI 编程框架还有 Flutter, SwiftUI, Jetpack Compose
 */

import { TitleBar } from '../TitleBar';
import { promptAction } from '@kit.ArkUI';

// @ 开头的被称为装饰器，比如 @Entry, @Component, @State 等

// @Entry 表示该自定义组件为入口组件
// 注：@Entry 组件需要在 main_pages.json 文件（在 module.json5 中通过 "pages":"$profile:main_pages" 指定的）中声明
@Entry
// @Component 表示自定义组件
@Component
// 通过 struct 定义组件（不支持继承，请通过组合的方式来实现组件的复用以及界面的构建）
struct Hello {

  // 定义普通变量（声明时必须初始化）
  name: string = "webabcd"
  // @State 表示组件中的状态变量（声明时必须初始化），状态变量变化会触发相关 UI 刷新
  @State message: string = 'Hello World';

  // 定义普通函数
  hello(): string {
    return `hello: ${this.name}`
  }
  // @Builder 表示函数会返回一个或多个组件（可以在组件内部定义，也可以在全局定义）
  @Builder myBuilder1() {
    Text(this.message)
      .fontSize(24)
      .fontColor(Color.Orange)
  }

  // 构建 UI（在 build 内通过组件描述需要的 UI）
  build() {
    Column({ space: 20 }) {

      // 先 import { TitleBar } from '../TitleBar'; 就可以用 TitleBar 了
      // 如果之前没有 import 则可以把光标放到 TitleBar() 内然后通过快捷键 alt + enter 添加相关的 import
      TitleBar()

      Text(this.message)
        .fontSize(16)
        .fontColor(Color.Blue)
      /*
       * Button 是一个按钮组件（构造 UI 组件的时候不用 new）
       *   组件参数有啥，可通过快捷键 ctrl + p 查看，比如 Button 的参数有 label 和 options
       *   本例的 options 参数是一个 ButtonOptions 接口，这个接口里有什么参数，可以在 {} 中通过快捷键 ctrl + alt + space 查看
       *   其中的 width(), height() 等是属性方法，支持链式调用
       *   其中的 onClick() 等是事件方法，支持链式调用
       */
      Button('button', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .width(90)
        .height(40)
        .onClick(() => {
          // 修改 @State 变量，会触发相关 UI 刷新
          this.message = this.hello()
        })
      // 使用组件内部 @Builder 函数中定义的组件
      this.myBuilder1()
      // 使用组件外部 @Builder 函数中定义的组件
      myBuilder2()
      // 使用 @Component 的自定义组件，并为组件传递参数
      MyComponent({
        message: "abc",
        // 回调函数
        onCallback: () => {
          this.message = 'MyComponent callback'
        }
      })
    }.width('100%').height('100%')
  }
}

// @Builder 表示函数会返回一个或多个组件（可以在组件内部定义，也可以在全局定义）
@Builder function myBuilder2() {
  // 声明一个需要返回的组件，如果有复杂逻辑的话，可以在这里声明一个 @Component 装饰的自定义组件
  Text("myBuilder2")
    .fontSize(24)
    .fontColor(Color.Green)
}

// 通过 @Component 定义一个自定义组件
@Component
struct MyComponent {
  // 组件参数，在调用此组件的时候可以传递此参数
  // 如果用 @Require 装饰，则代表在构造组件的时候必须要传参
  @Require message = ""

  // 定义回调函数
  onCallback?: () => void;

  build() {
    Button(`MyComponent ${this.message}`)
      .onClick(() => {
        if (this.onCallback) {
          this.onCallback()
        }
      })
  }
}