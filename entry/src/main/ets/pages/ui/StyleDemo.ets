/*
 * 样式相关（@Style, @Extend, stateStyles）
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

  @State checkbox_selected: boolean = false

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
      Text('Text1').width('100%').height(40).fontColor(Color.White).fontSize(24)
        .stateStyles({
          normal: {
            .backgroundColor(Color.Black)
          },
          focused: {
            .backgroundColor(Color.Blue)
          },
          pressed: {
            .backgroundColor(Color.Orange)
          },
        })
        // 注：设置了 onClick() 的组件才能获取焦点，才能走到 focused 状态
        .onClick(() => {

        })
      Text('Text2').width('100%').height(40).fontColor(Color.White).fontSize(24)
        .stateStyles({
          normal: this.normalStyle,
          pressed: this.pressedStyle,
        })
      Text('Text3').width('100%').height(40).fontColor(Color.White).fontSize(24)
        .stateStyles({
          disabled: {
            .backgroundColor(Color.Orange)
          },
        })
        // 注：当 enabled(false) 时，则会走到 disabled 状态
        .enabled(false)
      Checkbox().width(50).height(50).shape(CheckBoxShape.ROUNDED_SQUARE)
        // 通过 select(true) 可以让 Checkbox 组件走到 selected 状态
        // 注：
        // 支持 selected 状态的组件有 Checkbox, CheckboxGroup, Radio, Toggle, ListItem, GridItem, MenuItem
        // 需要通过组件的相关方法才能让组件走到 selected 状态，仅通过用户行为走不到 selected 状态
        //   Checkbox 的 select() 方法
        //   CheckboxGroup 的 selectAll() 方法
        //   Radio 的 checked() 方法
        //   Toggle 的 isOn() 方法
        //   ListItem 的 selected() 方法
        //   GridItem 的 selected() 方法
        //   MenuItem 的 selected() 方法
        .select(this.checkbox_selected)
        .onClick(() => {
          this.checkbox_selected = !this.checkbox_selected
        })
        .stateStyles({
          normal: {
            .borderWidth(1)
            .borderColor(Color.Red)
          },
          selected: {
            .borderWidth(10)
            .borderColor(Color.Green)
          },
        })

    }.width('100%').height('100%')
  }
}