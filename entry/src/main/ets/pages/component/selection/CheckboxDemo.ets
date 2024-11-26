/*
 * Checkbox - 多选框
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CheckboxDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message:string = ""

  @Builder indicatorBuilder() {
    Image($r("app.media.app_icon"))
  }

  build() {
    Column({ space: 10 }) {
      /*
       * Checkbox - 多选框
       *   name - 多选框的名字
       *   indicatorBuilder - 自定义选中状态时多选框中的内容（指定一个 CustomBuilder）
       *   select() - 是否是选中状态
       *   selectedColor() - 选中时的背景色
       *   backgroundColor() - 未选中时的背景色
       *   unselectedColor() - 未选中时的边框的颜色
       *   shape() - 多选框的形状（CheckBoxShape 枚举）
       *     CIRCLE - 圆形
       *     ROUNDED_SQUARE - 圆角方形
       *   onChange() - 选中状态发生变化时的回调
       *   mark() - 多选框中的对钩的样式（MarkStyle 接口）
       *     strokeColor - 对钩的颜色
       *     size - 对钩的大小
       *     strokeWidth - 对钩的画笔宽度
       */

      Checkbox(({ name: 'checkbox1' })).width(50).height(50)
        .select(true)
        .selectedColor(Color.Red)
        .unselectedColor(Color.Green)
        .shape(CheckBoxShape.CIRCLE)
        .onChange((value: boolean) => {
          this.message = `checkbox1: ${value}`
        })

      Checkbox(({ name: 'checkbox2' })).width(50).height(50)
        .select(true)
        .selectedColor(Color.Red)
        .unselectedColor(Color.Green)
        .backgroundColor(Color.Orange)
        .shape(CheckBoxShape.ROUNDED_SQUARE)
        .onChange((value: boolean) => {
          this.message = `checkbox2: ${value}`
        })

      // 通过 mark() 自定义选中状态时多选框中的对钩的样式
      Checkbox(({ name: 'checkbox3' })).width(50).height(50)
        .select(true)
        .selectedColor(Color.Red)
        .unselectedColor(Color.Green)
        .shape(CheckBoxShape.ROUNDED_SQUARE)
        .onChange((value: boolean) => {
          this.message = `checkbox3: ${value}`
        })
        .mark({
          strokeColor: Color.Blue,
          size: 30,
          strokeWidth: 5
        })

      // 通过 indicatorBuilder 自定义选中状态时多选框中的内容
      Checkbox(({
        name: 'checkbox4',
        indicatorBuilder:() => { this.indicatorBuilder() }
      }))
        .width(50)
        .height(50)
        .onChange((value: boolean) => {
          this.message = `checkbox4: ${value}`
        })

      Text(this.message).fontSize(16)
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""

  build() {
    Column({ space: 20 }) {
      Checkbox({ name: 'myCheckbox' })
        // 通过 contentModifier() 实现自定义 Checkbox（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyCheckboxModifier(Color.Red, Color.Green))
        .onChange((value: boolean) => {
          this.message = `myCheckbox: ${value}`
        })

      Text(this.message).fontSize(16)
    }
  }
}

// 实现 ContentModifier 接口
class MyCheckboxModifier implements ContentModifier<CheckBoxConfiguration> {

  // 自定义属性
  selectedColor: Color = Color.White
  unselectedColor: Color = Color.Black
  // 构造函数
  constructor(selectedColor: Color, unselectedColor: Color) {
    this.selectedColor = selectedColor
    this.unselectedColor = unselectedColor
  }

  // 返回指定的自定义 Checkbox
  applyContent() : WrappedBuilder<[CheckBoxConfiguration]>
  {
    return wrapBuilder(buildCheckbox)
  }
}

// 自定义 Checkbox
@Builder function buildCheckbox(config: CheckBoxConfiguration) {
  /*
   * CheckBoxConfiguration - 自定义 Checkbox 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   name - 多选框的名字
   *   selected - 是否是选中状态
   *   triggerChange() - 触发 Checkbox 的 onChange() 回调
   */
  Column({ space: 10 }) {
    Circle({ width: 150, height: 150 })
      .fill(config.selected ? (config.contentModifier as MyCheckboxModifier).selectedColor : (config.contentModifier as MyCheckboxModifier).unselectedColor)
    Button('选中')
      .onClick(() => {
        // triggerChange() 的参数可以在 Checkbox 的 onChange() 中通过 value 获取到
        config.triggerChange(true);
      })
    Button('未选中')
      .onClick(() => {
        config.triggerChange(false);
      })
  }
}