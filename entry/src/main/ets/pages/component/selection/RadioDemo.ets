/*
 * Radio - 单选框
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct RadioDemo {

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
       * Radio - 单选框
       *   name - 单选框的名字
       *   group - 组名，同组单选框最多只能有一个是选中状态
       *   indicatorType - 选中状态时的对钩的类型（RadioIndicatorType 枚举）
       *     TICK - 对钩
       *     DOT - 圆圈
       *     CUSTOM - 自定义
       *   indicatorBuilder - 自定义选中状态时单选框中的内容（指定一个 CustomBuilder）
       *     前提是 indicatorType 设置为 RadioIndicatorType.CUSTOM
       *   checked() - 是否是选中状态
       *   radioStyle() - 单选框样式（一个 RadioStyle 对象）
       *     checkedBackgroundColor - 选中状态时的背景色
       *     uncheckedBorderColor - 未选中状态时的边框的颜色
       *     indicatorColor - 选中状态时的对钩的颜色
       *   onChange() - 选中状态发生变化时的回调
       */

      Radio({ value: 'radio1', group: 'radioGroup' })
        .width(50)
        .height(50)
        .checked(true)
        .radioStyle({
          checkedBackgroundColor: Color.Red,
          uncheckedBorderColor: Color.Green,
          indicatorColor: Color.Blue
        })
        .onChange((isChecked: boolean) => {
          this.message = `radio1: ${isChecked}`
        })

      Radio({ value: 'radio2', group: 'radioGroup',
        indicatorType:RadioIndicatorType.TICK
      })
        .width(50)
        .height(50)
        .onChange((isChecked: boolean) => {
          this.message = `radio2: ${isChecked}`
        })

      Radio({ value: 'radio3', group: 'radioGroup',
        indicatorType:RadioIndicatorType.DOT
      })
        .width(50)
        .height(50)
        .onChange((isChecked: boolean) => {
          this.message = `radio3: ${isChecked}`
        })

      // 通过 indicatorBuilder 自定义选中状态时多选框中的内容
      Radio({ value: 'radio4', group: 'radioGroup',
        indicatorType:RadioIndicatorType.CUSTOM,
        indicatorBuilder:() => { this.indicatorBuilder() }
      })
        .width(50)
        .height(50)
        .onChange((isChecked: boolean) => {
          this.message = `radio4: ${isChecked}`
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
      Radio({ value: 'radio1', group: 'radioGroup'})
        // 通过 contentModifier() 实现自定义 Radio（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyRadioStyle(Color.Red, Color.Green))
        .onChange((value: boolean) => {
          this.message = `radio1: ${value}`
        })

      Text(this.message).fontSize(16)
    }
  }
}

// 实现 ContentModifier 接口
class MyRadioStyle implements ContentModifier<RadioConfiguration> {

  // 自定义属性
  checkedColor: Color = Color.White
  uncheckedColor: Color = Color.Black
  // 构造函数
  constructor(checkedColor: Color, uncheckedColor: Color) {
    this.checkedColor = checkedColor
    this.uncheckedColor = uncheckedColor
  }

  // 返回指定的自定义 Radio
  applyContent() : WrappedBuilder<[RadioConfiguration]>
  {
    return wrapBuilder(buildRadio)
  }
}

// 自定义 Radio
@Builder function buildRadio(config: RadioConfiguration) {
  /*
   * RadioConfiguration - 自定义 Radio 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   value - 单选框的名字
   *   checked - 是否是选中状态
   *   triggerChange() - 触发 Radio 的 onChange() 回调
   */
  Column({ space: 10 }) {
    Circle({ width: 150, height: 150 })
      .fill(config.checked ? (config.contentModifier as MyRadioStyle).checkedColor : (config.contentModifier as MyRadioStyle).uncheckedColor)
    Button(`选中 ${config.value}`)
      .onClick(() => {
        // triggerChange() 的参数可以在 Radio 的 onChange() 中通过 isChecked 获取到
        config.triggerChange(true);
      })
    Button(`未选中 ${config.value}`)
      .onClick(() => {
        config.triggerChange(false);
      })
  }
}