/*
 * 焦点
 */

import { TitleBar } from '../../TitleBar'
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI'

@Entry
@Component
struct FocusDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('组件走焦').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('焦点组走焦').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  controller: TextInputController = new TextInputController()

  /*
   * focusable() - 是否允许获取焦点
   * focusOnTouch() - 是否可以通过点击获取焦点
   * defaultFocus() - 是否默认获得焦点（仅页面创建后第一次进入时有效）
   * focusBox() - 获取焦点后的，焦点框样式（一个 FocusBoxStyle 对象）
   *   margin, strokeColor, strokeWidth
   *   注：仅走焦（比如 tab 键）时有效，如果通过用户点击获取焦点则无效
   * id() - 组件的 id
   *
   * focusControl.requestFocus() - 通过指定的组件的 id 让指定的组件获取焦点，返回值为指定的组件是否成功地获取到了焦点
   *
   * TextInput
   *   enableKeyboardOnFocus() - 当 TextInput 通过程序的方式获取焦点时是否需要弹出软键盘
   * TextInputController
   *   stopEditing() - 让绑定的 TextInput 失去焦点，如果当前软键盘因为此 TextInput 而弹出，则也会被关闭
   */
  build() {
    Column({space:10}) {
      TextInput().width('90%').height(40)

      TextInput({controller:this.controller}).width('90%').height(40)
        .defaultFocus(true)
        .enableKeyboardOnFocus(false)
        .id("myTextInput")

      TextInput().width('90%').height(40)
        .focusable(false) // 不能获取焦点

      TextInput().width('90%').height(40)
        .focusOnTouch(false) // 可以通过走焦或程序的方式获取焦点，但是不能通过点击的方式获取焦点

      Button("让第 2 个 TextInput 获取焦点").onClick(() => {
        // 让 id 为 myTextInput 的组件获取焦点，返回值为指定的组件是否成功地获取到了焦点
        let ok = focusControl.requestFocus("myTextInput")
      })
        // 获取焦点后的，焦点框样式（仅走焦时有效，通过点击或程序获取焦点均无效）
        .focusBox({
          margin: LengthMetrics.px(20), // 边框与组件之间的间距
          strokeColor: ColorMetrics.rgba(255, 0, 0), // 边框的颜色
          strokeWidth: LengthMetrics.px(10) // 边框的宽度
        })

      Button("让第 2 个 TextInput 失去焦点").onClick(() => {
        this.controller.stopEditing()
      })
    }
  }
}

@Component
struct MySample2 {

  /*
   * tabIndex() - 通过 tab 键走焦
   *   组件的 tabIndex 的默认值为 0
   *   如果页面内每个组件的 tabIndex 均为 0 则按照布局顺序走焦
   *   如果页面内有 tabIndex 大于 0 的组件，则按照 tabIndex 从小到大的顺序走焦，且 tabIndex 为 0 的组件无法通过 tab 键走焦
   *   如果不希望组件通过 tab 键走焦，则将 tabIndex 设置为 -1 即可
   * groupDefaultFocus() - 当父容器获取到 tab 键焦点时，当前组件是否是默认焦点
   *   仅当父容器的 tabIndex 大于 1 时有效
   *   如需在父容器的内部的组件之间走焦，则可以通过方向键
   */
  build() {
    Column({space:10}) {

      TextInput().width('90%').height(40)
        .tabIndex(4)

      TextInput().width('90%').height(40)
        .tabIndex(2)

      TextInput().width('90%').height(40)
        .tabIndex(1)

      TextInput().width('90%').height(40)
        .tabIndex(3)

      // 此 Column 获取到焦点后，默认焦点会落在 button3 上，然后可以通过方向键在 button1, button2, button3 之间走焦（如果按 tab 键则当前 Column 会失焦）
      Column({ space: 10 }) {
        Button('button1')
        Button('button2')
        Button('button3')
          .groupDefaultFocus(true) // 父容器获取到 tab 焦点后，此组件为默认焦点
      }
      .width('100%')
      .backgroundColor(Color.Yellow)
      .tabIndex(6)

      // 此 Column 获取到焦点后，默认焦点会落在 button2 上，然后可以通过方向键在 button1, button2, button3 之间走焦（如果按 tab 键则当前 Column 会失焦）
      Column({ space: 10 }) {
        Button('button1')
        Button('button2')
          .groupDefaultFocus(true) // 父容器获取到 tab 焦点后，此组件为默认焦点
        Button('button3')
      }
      .width('100%')
      .backgroundColor(Color.Orange)
      .tabIndex(5)
    }
  }
}

@Component
struct MySample3 {

  /*
   * focusScopeId() - 焦点组设置
   *   id - 当前父容器的标识
   *   isGroup - 当前父容器是否是焦点组
   * focusScopePriority() - 在所属焦点组获取焦点后，子组件的获取焦点的优先级
   *   scopeId - 所属焦点组通过 focusScopeId() 指定的标识
   *   priority - 获焦优先级（一个 FocusPriority 枚举）
   *     优先级从低到高分别为: AUTO, PRIOR, PREVIOUS
   *
   * 注：如果需要使用焦点组，则不能使用 tabIndex
   */
  build() {
    Column({space:10}) {

      // 本例中
      // 按下 tab 键后会在 button1, button2, button3, 第 2 个 column 之间走焦
      // 第 2 个 column 获取焦点后，默认焦点会落在 button6 上
      // 第 2 个 column 获取焦点后，可以通过方向键在其内的组件之间走焦（如果按 tab 键则当前 Column 会失焦）
      Column({ space: 10 }) {
        Button('button1')
        Button('button2')
        Button('button3')
      }
      .width('100%')
      .backgroundColor(Color.Yellow)

      Column({ space: 10 }) {
        Button('button4')
        Button('button5')
        Button('button6')
          .focusScopePriority('focusScope', FocusPriority.PREVIOUS)
      }
      .width('100%')
      .backgroundColor(Color.Orange)
      .focusScopeId('focusScope', true)
    }
  }
}