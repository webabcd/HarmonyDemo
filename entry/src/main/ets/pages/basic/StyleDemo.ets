/*
 * @Style 相关装饰器（@Style, @Extend, stateStyles）
 */

import { TitleBar } from '../TitleBar';

// @Styles 用于定义通用属性和通用事件（可以在组件内部定义，也可以在全局定义）
// @Styles 装饰的函数不能有参数，只能在当前文件中使用（也就是说不支持 export，如果想实现 export 功能，请参见 AttributeModifier 的说明）
@Styles function myStyles1() {
  .width("100%")
  .height(50)
  .foregroundColor(Color.White)
  .backgroundColor(Color.Orange)
}

// @Extend 用于定义通用属性和通用事件，以及指定组件的私有属性和私有事件（仅支持在全局定义）
// @Extend(Text) 的意思就是可以定义 Text 的私有属性和私有事件
@Extend(Text) function myExtend1() {
  .width("100%")
  .height(50)
  .fontSize(24)
  .fontColor(Color.White)
  .backgroundColor(Color.Orange)
}
// @Extend 装饰的函数支持传递参数，只能在当前文件中使用（也就是说不支持 export，如果想实现 export 功能，请参见 AttributeModifier 的说明）
// 因为 @Extend 只能在全局定义，如果你想在事件中修改组件内的变量的话，就可以类似下面的参数 onClick: () => void 的方式实现
@Extend(Text) function myExtend2(fontColor:Color, onClick: () => void) {
  .myExtend1() // 通过此方式继承其他的 @Extend
  .fontColor(fontColor)
  .onClick(onClick)
}

@Entry
@Component
struct StyleDemo {

  @State message: string = "hello @Styles";

  // @Styles 用于定义通用属性和通用事件（可以在组件内部定义，也可以在全局定义）
  // @Styles 装饰的函数不能有参数，只能在当前文件中使用（也就是说不支持 export，如果想实现 export 功能，请参见 AttributeModifier 的说明）
  @Styles myStyles2() {
    .width("100%")
    .height(50)
    .foregroundColor(Color.White)
    .backgroundColor(Color.Blue)
    .onClick(() => {
      this.message = "myStyles2 onClick";
    })
  }

  // 用于演示通过 stateStyles 指定各种状态的样式
  @Styles normalStyle() {
    .backgroundColor(Color.Black)
  }
  @Styles pressedStyle() {
    .backgroundColor(Color.Orange)
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 使用 @Styles 的示例
      Text(`${this.message} myStyles1`)
        .myStyles1()
        .fontSize(24)
      Text(`${this.message} myStyles2`)
        .myStyles2()
        .fontSize(24)

      // 使用 @Extend 的示例
      Text(`${this.message} myExtend1`)
        .myExtend1()
        .fontSize(24)
      Text(`${this.message} myExtend2`)
        .myExtend2(Color.Red, () => {
          // 通过此种方式，让全局的 @Extend 可以修改组件内的变量
          this.message = "myExtend2 onClick"
        })
        .fontSize(24)

      // stateStyles 用于分别指定各种状态的样式，也支持在 @Styles 或 @Extend 中设置
      // 状态有 normal, pressed, selected, disabled, focused
      Text('Text1')
        .myExtend1()
        .stateStyles({
          normal: {
            .backgroundColor(Color.Black)
          },
          pressed: {
            .backgroundColor(Color.Orange)
          },
        })
      Text('Text2')
        .myExtend1()
        .stateStyles({
          normal: this.normalStyle,
          pressed: this.pressedStyle,
        })

    }.width('100%').height('100%')
  }
}