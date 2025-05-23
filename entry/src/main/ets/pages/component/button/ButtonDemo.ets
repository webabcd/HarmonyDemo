/*
 * Button - 按钮
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct ButtonDemo {

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
  build() {
    Column({ space: 10 }) {
      /*
       * Button - 按钮
       *   label - 文字
       *   options - 选项（一个 ButtonOptions 对象）
       *     type - 按钮类型（ButtonType 枚举）
       *       Normal - 普通
       *       Circle - 圆形
       *       Capsule - 胶囊（圆角矩形）
       *     stateEffect - 是否启用按下时的效果（如果想自定义按钮按下后的效果，可以参见 /ui/StyleDemo.ets 中的说明）
       *     buttonStyle - 按钮样式（ButtonStyleMode 枚举）
       *       NORMAL - 普通
       *       TEXTUAL - 纯文本，无颜色
       *       EMPHASIZED - 效果突出的按钮
       *     controlSize - 按钮尺寸（ControlSize 枚举）
       *       NORMAL - 普通
       *       SMALL - 小按钮
       *     role - 按钮角色（ButtonRole 枚举）
       *       NORMAL - 普通
       *       ERROR - 警示按钮
       *   type() - 同 options 的 type，有冲突则以此为准
       *   stateEffect() - 同 options 的 stateEffect，有冲突则以此为准
       *   buttonStyle() - 同 options 的 buttonStyle，有冲突则以此为准
       *   controlSize() - 同 options 的 controlSize，有冲突则以此为准
       *   role() - 同 options 的 role，有冲突则以此为准
       *   enabled() - 按钮是否可用
       */
      Button('Normal', { type: ButtonType.Normal, stateEffect: true }).width(100)
      Button('Circle', { type: ButtonType.Circle, stateEffect: true }).width(100)
      Button('Capsule', { type: ButtonType.Capsule, stateEffect: true }).width(100)
      Button('stateEffect:false', { stateEffect: false })

      Button('NORMAL', { buttonStyle: ButtonStyleMode.NORMAL });
      Button('TEXTUAL', { buttonStyle: ButtonStyleMode.TEXTUAL });
      Button('EMPHASIZED', { buttonStyle: ButtonStyleMode.EMPHASIZED });

      Button('SMALL', { controlSize: ControlSize.SMALL });

      Button('ERROR', { role: ButtonRole.ERROR })

      Button('button')
        .type(ButtonType.Capsule)
        .stateEffect(true)
        .buttonStyle(ButtonStyleMode.EMPHASIZED)
        .controlSize(ControlSize.NORMAL)
        .role(ButtonRole.NORMAL)

      Button('enabled(false)').enabled(false)
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {

      /*
       * Button - 按钮
       *   labelStyle() - 自定义按钮显示的文字的样式，相关参数的说明可以参看 component/text/TextDemo.ets
       *   backgroundColor() - 按钮背景的颜色
       *   foregroundColor() - 按钮文字的颜色
       */
      Button("button")
        .width(100)
        .labelStyle({
          overflow: TextOverflow.Clip,
          maxLines: 1,
          minFontSize: 16,
          maxFontSize: 16,
          heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
          font: {
            size: 20,
            weight: FontWeight.Bold,
            family: 'HarmonyOS Sans',
            style: FontStyle.Italic
          }
        })
        .backgroundColor(Color.Black)
        .foregroundColor(Color.White)

      // 通过在 Button 内声明子组件的方式，自定义按钮的显示内容
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        Row() {
          SymbolGlyph($r('sys.symbol.ohos_wifi')).fontColor([Color.Orange]).fontSize(48)
          Text('abc').fontColor(Color.White).fontSize(48)
        }
      }

      // 通过 contentModifier() 实现自定义按钮（指定一个实现了 ContentModifier 接口的对象）
      Button()
        .contentModifier(new MyButtonModifier(Color.Orange))
        .onClick((event) => {
          this.message = `x:${event.x}, y:${event.y}`
        })
      Text(this.message)
        .fontSize(16)
    }
  }
}

// 实现 ContentModifier 接口
class MyButtonModifier implements ContentModifier<ButtonConfiguration> {

  // 自定义属性
  myColor:Color = Color.Black
  // 构造函数
  constructor(myColor:Color) {
    this.myColor = myColor
  }

  // 返回指定的自定义按钮
  applyContent() : WrappedBuilder<[ButtonConfiguration]>
  {
    return wrapBuilder(buildButton)
  }
}

// 自定义按钮
@Builder function buildButton(config: ButtonConfiguration) {
  /*
   * ButtonConfiguration - 自定义按钮的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   pressed - 按钮是否被按下
   *   triggerClick() - 触发按钮的 onClick 回调
   */
  Column({space:5}) {
    Rect({ width: 100, height: 50 })
      // 获取自定义按钮的自定义属性
      .fill((config.contentModifier as MyButtonModifier).myColor)
      .gesture(
        TapGesture()
          .onAction((event: GestureEvent) => {
            // triggerClick() 的两个参数可以在 Button 的 onClick() 中通过 event.x 和 event.y 获取到
            config.triggerClick(event.fingerList[0].localX, event.fingerList[0].localY)
        }))
    Text(`enabled: ${config.enabled}`)
    Text(`pressed: ${config.pressed}`)
  }
}
