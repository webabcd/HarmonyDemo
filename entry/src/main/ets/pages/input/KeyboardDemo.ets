/*
 * 键盘类输入
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct KeyboardDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('按键事件').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('快捷键').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ''

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * focusable() - 是否可获取焦点
       * defaultFocus() - 是否默认焦点
       * onFocus() - 获取焦点时的回调
       * onBlur() - 失去焦点时的回调
       * onKeyEvent() - 按键按下或抬起时的回调（需要在焦点状态下），回调参数是一个 KeyEvent 类型的对象
       *   type - 按键行为的类型（KeyType 枚举）
       *     Down, Up
       *   keyCode - 按键的键码
       *   keyText - 按键的键值
       *   timestamp - 事件触发时，距系统启动时的时间戳
       * onKeyPreIme() - 按键按下或抬起前的回调（需要在焦点状态下），回调参数是一个 KeyEvent 类型的对象
       *   return false - 代表没处理，会触发 onKeyEvent() 回调
       *   return true - 代表已处理，不会触发 onKeyEvent() 回调
       */
      Button('KeyEvent')
        .focusable(true)
        .defaultFocus(true)
        .onFocus(() => {
          this.message = "onFocus"
        })
        .onBlur(() => {
          this.message = "onBlur"
        })
        .onKeyEvent((event: KeyEvent) => {
          this.message += `onKeyEvent\n`
          this.message += `type:${KeyType[event.type]}\n`
          this.message += `keyCode:${event.keyCode}\n`
          this.message += `keyText:${event.keyText}\n`
          this.message += `timestamp:${event.timestamp}\n`
        })
        .onKeyPreIme((event: KeyEvent) => {
          this.message = `onKeyPreIme\n`
          this.message += `type:${KeyType[event.type]}\n`
          this.message += `keyCode:${event.keyCode}\n`
          this.message += `keyText:${event.keyText}\n`
          this.message += `timestamp:${event.timestamp}\n`
          return false
        })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ''

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * keyboardShortcut() - 设置快捷键
       *   value - 快捷键的单个字符
       *   keys - 快捷键的修饰键
       *     ModifierKey.CTRL, ModifierKey.SHIFT, ModifierKey.ALT
       *   action - 快捷键被触发后的回调（如果不指定这个参数，则快捷键被触发后会调用 onClick() 回调）
       *
       * 注：快捷键不要求当前组件在焦点状态，只要当前组件已经挂载到获焦窗口的组件树上，那么就会响应快捷键
       */

      Button("SHIFT + 1").onClick((event: ClickEvent) => {
        this.message = "SHIFT + 1";
      })
        .keyboardShortcut('1', [ModifierKey.SHIFT])

      Button("SHIFT + A").onClick((event: ClickEvent) => {
        this.message = "SHIFT + A";
      })
        .keyboardShortcut('A', [ModifierKey.SHIFT])

      Button("F1").onClick((event: ClickEvent) => {
        this.message = "F1";
      })
        .keyboardShortcut(FunctionKey.F1, [])

      // keyboardShortcut() 设置多遍则会同时支持多个快捷键
      Button('SHIFT + X 或 SHIFT + Y 或 SHIFT + Z').onClick((event: ClickEvent) => {
        this.message = "SHIFT + X 或 SHIFT + Y 或 SHIFT + Z";
      })
        .keyboardShortcut('X', [ModifierKey.SHIFT])
        .keyboardShortcut('Y', [ModifierKey.SHIFT])
        .keyboardShortcut('Z', [ModifierKey.SHIFT])
    }
  }
}