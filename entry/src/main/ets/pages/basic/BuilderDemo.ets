/*
 * @Builder 相关装饰器（@Builder, @BuilderParam, @LocalBuilder, WrappedBuilder）
 */

import { TitleBar } from '../TitleBar';

interface MyInterface {
  message: string;
}

// @Builder 表示函数会返回一个组件（可以在组件内部定义，也可以在组件外部定义）
@Builder function myBuilder1(param:MyInterface) {
  Text(`myBuilder1 ${param.message}`)
    .fontSize(24)
    .fontColor(Color.Orange)
}

// 本例用于演示 @BuilderParam
@Component
struct MyPage {
  message: string = 'MyPage';
  @Builder myComponent() {};

  // @BuilderParam 的作用就是用来指向 @Builder
  // 通过修改 @BuilderParam 的指向，则可以显示不同的组件
  @BuilderParam myBuilderParam: () => void = this.myComponent;

  build() {
    Column() {
      this.myBuilderParam()
    }
  }
}

// WrappedBuilder 用于封装 @Builder（注：被封装的必须是全局的 @Builder）
// @Builder 装饰的函数直接赋值给其他变量是无法使用的，所以需要通过 WrappedBuilder 解决这个问题
let myWrappedBuilder1: WrappedBuilder<[MyInterface]> = wrapBuilder(myBuilder1);
// 同理，如果你要通过数组直接管理多个 @Builder 装饰的函数也是无法使用的，所以需要通过 WrappedBuilder 数组解决这个问题
let myWrappedBuilder2: WrappedBuilder<[MyInterface]>[] = [wrapBuilder(myBuilder1), wrapBuilder(myBuilder1)];


@Entry
@Component
struct BuilderDemo {

  // @State 表示组件中的状态变量，状态变量变化会触发 UI 刷新
  @State message: string = 'aaa';

  // @Builder 表示函数会返回一个组件（@Builder 函数可以在组件内部定义，也可以在组件外部定义）
  // 在 @Builder 内如果使用了 @State 变量，则变量的变化会导致此 @Builder 的刷新
  @Builder myBuilder2() {
    Text(`myBuilder2 ${this.message}`)
      .fontSize(24)
      .fontColor(Color.Orange)
  }
  // 在 @Builder 中传递一个对象（引用类型），如果对象的某个属性来自一个 @State 变量，则变量的变化会导致此 @Builder 的刷新
  @Builder myBuilder3(param:MyInterface) {
    Text(`myBuilder3 ${param.message}`)
      .fontSize(24)
      .fontColor(Color.Orange)
  }
  // 在 @Builder 中如果传递了基本类型（值类型），则此 @Builder 不会因任何 @State 变量的变化而刷新
  @Builder myBuilder4(param:MyInterface, other:string) {
    Text(`myBuilder4 ${param.message} ${other}`)
      .fontSize(24)
      .fontColor(Color.Orange)
  }

  // 用于演示 @BuilderParam
  // @BuilderParam 指向此函数时，此函数内的 this 的指向会因是 @Builder 或 @LocalBuilder 而有所不同，详见后面的说明
  @Builder myBuilder5() {
    Text(`myBuilder5 ${this.message}`)
      .fontSize(24)
      .fontColor(Color.Orange)
  }
  // 用于演示 @BuilderParam
  // @BuilderParam 指向此函数时，此函数内的 this 的指向会因是 @Builder 或 @LocalBuilder 而有所不同，详见后面的说明
  @LocalBuilder myBuilder6() {
    Text(`myBuilder6 ${this.message}`)
      .fontSize(24)
      .fontColor(Color.Orange)
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      myBuilder1({
        message: this.message,
      })
      this.myBuilder2()
      this.myBuilder3({
        message: this.message,
      })
      this.myBuilder4({
        message: this.message,
      }, this.message)

      MyPage({
        // this.myBuilder5 是 @Builder 装饰的，会导致 this.myBuilder5 内的 this 指向的是 BuilderDemo 对象
        myBuilderParam: this.myBuilder5
      })
      MyPage({
        // this.myBuilder6 是 @LocalBuilder 装饰的，会导致 this.myBuilder6 内的 this 指向的是 MyPage 对象
        myBuilderParam: this.myBuilder6
      })
      MyPage() {
        // 通过尾随闭包的方式，即 (){ } 的方式，初始化 @BuilderParam，其 this 指向的是 MyPage 对象
        Text(`尾随闭包 ${this.message}`)
          .fontSize(24)
          .fontColor(Color.Orange)
      }

      // WrappedBuilder 的使用方法
      myWrappedBuilder1.builder({
        message: this.message
      })
      // WrappedBuilder 数组的使用方法
      ForEach(myWrappedBuilder2, (item: WrappedBuilder<[MyInterface]>, index: number) => {
        item.builder({
          message: `${this.message} ${index}`,
        })
      })

      Button('Ok', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(90)
        .height(40)
        .onClick(() => {
          this.message = "button pressed"
        })

    }.width('100%').height('100%')
  }
}