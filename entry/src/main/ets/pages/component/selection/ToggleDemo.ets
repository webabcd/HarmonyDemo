/*
 * Toggle - 包括开关，选择框和切换按钮
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct ToggleDemo {

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

  build() {
    Column({ space: 10 }) {
      /*
       * Toggle - 包括开关，选择框和切换按钮
       *   type - 类型（ToggleType 枚举）
       *     Switch - 开关
       *     Checkbox - 选择框
       *     Button - 切换按钮（此类型时，可以为 Toggle 组件指定子组件）
       *   isOn - 是否是打开状态
       *   selectedColor() - 打开状态时的背景色
       *   switchPointColor() - 当 ToggleType.Switch 时，滑块的背景色
       *   onChange() - 打开/关闭状态发生变化时的回调
       */

      Toggle({ type: ToggleType.Switch, isOn: true })
        .selectedColor(Color.Red)
        .switchPointColor(Color.Green)
        .onChange((isOn: boolean) => {
          this.message = `isOn: ${isOn}`
        })

      Toggle({ type: ToggleType.Checkbox, isOn: true })
        .size({ width: 20, height: 20 })
        .selectedColor(Color.Red)
        .onChange((isOn: boolean) => {
          this.message = `isOn: ${isOn}`
        })
        .backgroundColor(Color.Green)
        .borderRadius(10)

      // 当 ToggleType.Button 时，通过子组件描述 Toggle 中显示的内容
      Toggle({ type: ToggleType.Button, isOn: true }) {
        Text('text').fontColor(Color.White).fontSize(16)
      }
      .width(100)
      .selectedColor(Color.Red)
      .onChange((isOn: boolean) => {
        this.message = `isOn: ${isOn}`
      })
      .backgroundColor(Color.Green)

      Text(this.message).fontSize(16)
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""

  build() {
    Column({ space: 20 }) {
      /*
       * switchStyle() - 自定义 ToggleType.Switch 时的样式
       *   pointRadius - 圆形滑块的半径
       *   pointColor - 圆形滑块的颜色
       *   unselectedColor - 关闭状态时的背景色
       *   trackBorderRadius - 滑轨的边框的半径
       */
      Toggle({ type: ToggleType.Switch, isOn: true })
        .size({ width: 100, height: 20 })
        .margin({ top: 20 })
        .selectedColor(Color.Red) // 打开状态时的背景色
        .switchStyle({
          pointRadius: 30,
          pointColor: Color.Green,
          unselectedColor: Color.Blue,
          trackBorderRadius: 10,
        })
        .onChange((isOn: boolean) => {
          this.message = `isOn: ${isOn}`
        })

      // 通过 contentModifier() 实现自定义 Toggle（指定一个实现了 ContentModifier 接口的对象）
      Toggle({ type: ToggleType.Switch})
        .enabled(true)
        .contentModifier(new MySwitchStyle(Color.Red, Color.Green))
        .onChange((isOn: boolean) => {
          this.message = `isOn: ${isOn}`
        })

      Text(this.message).fontSize(16)
    }
  }
}

// 实现 ContentModifier 接口
class MySwitchStyle implements ContentModifier<ToggleConfiguration> {

  // 自定义属性
  selectedColor: Color = Color.White
  unselectedColor: Color = Color.Black
  // 构造函数
  constructor(selectedColor: Color, unselectedColor: Color) {
    this.selectedColor = selectedColor
    this.unselectedColor = unselectedColor
  }

  // 返回指定的自定义 Switch
  applyContent() : WrappedBuilder<[ToggleConfiguration]>
  {
    return wrapBuilder(buildSwitch)
  }
}

// 自定义 Switch
@Builder function buildSwitch(config: ToggleConfiguration) {
  /*
   * ToggleConfiguration - 自定义 Toggle 的相关信息
   *   enabled - 是否可用
   *   isOn - 是否是打开状态
   *   triggerChange() - 触发 Toggle 的 onChange() 回调
   */
  Column({ space: 10 }) {
    Circle({ width: 150, height: 150 })
      .fill(config.isOn ? (config.contentModifier as MySwitchStyle).selectedColor : (config.contentModifier as MySwitchStyle).unselectedColor)
    Button('打开')
      .onClick(() => {
        // triggerChange() 的参数可以在 Toggle 的 onChange() 中通过 isOn 获取到
        config.triggerChange(true);
      })
    Button('关闭')
      .onClick(() => {
        config.triggerChange(false);
      })
  }
}
