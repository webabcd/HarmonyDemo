/*
 * AttributeModifier<T> - 用于动态设置指定类型的组件的属性（可以根据自定义逻辑为属性设置不同的值，且支持多态样式设置属性）
 * ContentModifier<T> - 用于自定义指定类型组件的内容
 * DrawModifier - 用于自定义组件绘制
 * GestureModifier - 用于动态设置组件的手势识别
 */

import { TitleBar } from '../../TitleBar';
import { drawing } from '@kit.ArkGraphics2D';

@Entry
@Component
struct ModifierDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('AttributeModifier').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('ContentModifier').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('DrawModifier').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('GestureModifier').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}


/*
 * AttributeModifier<T> - 用于动态设置指定类型的组件的属性（可以根据自定义逻辑为属性设置不同的值，且支持多态样式设置属性）
 *   applyNormalAttribute - normal 状态的样式
 *   applyPressedAttribute - pressed 状态的样式
 *   applySelectedAttribute - selected 状态的样式（当调用 select(true) 时，则会走到 selected 状态）
 *     支持 selected 状态的组件有 Checkbox, CheckboxGroup, Radio, Toggle, ListItem, GridItem, MenuItem
 *     需要通过组件的相关方法才能让组件走到 selected 状态，仅通过用户行为走不到 selected 状态
 *       Checkbox 的 select() 方法
 *       CheckboxGroup 的 selectAll() 方法
 *       Radio 的 checked() 方法
 *       Toggle 的 isOn() 方法
 *       ListItem 的 selected() 方法
 *       GridItem 的 selected() 方法
 *       MenuItem 的 selected() 方法
 *   applyDisabledAttribute - disabled 状态的样式（当调用 enabled(false) 时，则会走到 disabled 状态）
 *   applyFocusedAttribute - focused 状态的样式（通过 tab 键获取焦点时）
 */
class MyButtonModifier implements AttributeModifier<ButtonAttribute> {
  // 注：在 AttributeModifier 内不支持 @State 之类的
  isDarkTheme: boolean = false

  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.isDarkTheme) {
      instance.backgroundColor(Color.Blue)
    } else {
      instance.backgroundColor(Color.Orange)
    }
  }

  applyPressedAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Yellow)
    instance.fontColor(Color.Black)
  }

  applyDisabledAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Gray)
    instance.fontColor(Color.White)
    instance.border({
      width: 10,
      color: Color.Red,
    })
  }

  applyFocusedAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Blue)
    instance.fontColor(Color.White)
    instance.border({
      width: 5,
      color: Color.Green
    })
  }
}
class MyToggleModifier implements AttributeModifier<ToggleAttribute> {
  // 注：在 AttributeModifier 内不支持 @State 之类的
  isDarkTheme: boolean = false

  applySelectedAttribute(instance: ToggleAttribute): void {
    if (this.isDarkTheme) {
      instance.selectedColor(Color.Blue)
    } else {
      instance.selectedColor(Color.Orange)
    }
  }
}
@Component
struct MySample1 {

  @State myButtonModifier: MyButtonModifier = new MyButtonModifier()
  @State myToggleModifier: MyToggleModifier = new MyToggleModifier()

  build() {
    Column({space:10}) {

      Button(`isDarkTheme:${this.myButtonModifier.isDarkTheme}`)
        .onClick(() => {
          this.myButtonModifier.isDarkTheme = !this.myButtonModifier.isDarkTheme
          this.myToggleModifier.isDarkTheme = !this.myToggleModifier.isDarkTheme
        })

      /*
       * attributeModifier() - 用于设置组件的 AttributeModifier<T> 对象
       */

      Button("button 1").attributeModifier(this.myButtonModifier)

      Button("button 2").attributeModifier(this.myButtonModifier).enabled(false)

      Toggle({ type: ToggleType.Switch, isOn: true }).attributeModifier(this.myToggleModifier)
    }
  }
}


/*
 * ContentModifier<T> - 用于自定义指定类型组件的内容
 */
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
  .backgroundColor(Color.Yellow)
}
@Component
struct MySample2 {

  @State message:string = ""
  @State myCheckboxModifier: MyCheckboxModifier = new MyCheckboxModifier(Color.Red, Color.Green);

  build() {
    Column({space:10}) {

      Checkbox({ name: 'myCheckbox' })
        // 通过 contentModifier() 实现自定义 Checkbox（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(this.myCheckboxModifier)
        .onChange((value: boolean) => {
          this.message = `myCheckbox: ${value}`
        })

      Text(this.message).fontSize(16)
    }
  }
}


/*
 * DrawModifier - 用于自定义组件绘制
 *   drawBehind() - 绘制组件的背景层
 *   drawContent() - 绘制组件的中景层
 *   drawFront() - 绘制组件的前景层
 *   invalidate() - 重新绘制
 */
class MyDrawModifier extends DrawModifier {
  scale: number = 1

  drawBehind(context: DrawContext): void {
    const brush = new drawing.Brush();
    brush.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
    context.canvas.attachBrush(brush)
    context.canvas.drawRect({
      left: vp2px(0),
      top: vp2px(0),
      right: vp2px(context.size.width),
      bottom: vp2px(context.size.height)
    });
  }

  drawContent(context: DrawContext): void {
    const brush = new drawing.Brush();
    brush.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });
    context.canvas.attachBrush(brush);
    context.canvas.drawRect({
      left: vp2px(20),
      top: vp2px(20),
      right: vp2px((context.size.width - 20) * this.scale),
      bottom: vp2px((context.size.height - 20) * this.scale)
    })
  }

  drawFront(context: DrawContext): void {
    const brush = new drawing.Brush();
    brush.setColor({ alpha: 255, red: 0, green: 0, blue: 255 });
    context.canvas.attachBrush(brush);
    context.canvas.drawRect({
      left: vp2px(40),
      top: vp2px(40),
      right: vp2px((context.size.width - 40) * this.scale),
      bottom: vp2px((context.size.height - 40) * this.scale)
    })
  }
}
@Component
struct MySample3 {

  @State myDrawModifier: MyDrawModifier = new MyDrawModifier();

  build() {
    Column({space:10}) {

      Text('text').width(200).height(200)
        .onClick(() => {
          this.myDrawModifier.scale = this.myDrawModifier.scale == 1 ? 0.5 : 1
          // 当修改了 DrawModifier 后，需要调用 invalidate() 以便重新绘制
          this.myDrawModifier.invalidate()
        })
        .drawModifier(this.myDrawModifier)
    }
  }
}


/*
 * GestureModifier - 用于动态设置组件的手势识别
 *   applyGesture() - 设置组件需要绑定的手势识别
 */
class MyGestureModifier implements GestureModifier {

  // true 代表只支持双击，不支持单击
  // false 代表只支持单击，不支持双击
  supportDoubleTap: boolean = false

  // 用于回调
  onGestureRecognized: (type: string) => void = () => {}

  constructor(supportDoubleTap: boolean, onGestureRecognized: (type: string) => void) {
    this.supportDoubleTap = supportDoubleTap
    this.onGestureRecognized = onGestureRecognized
  }

  applyGesture(event: UIGestureEvent): void {
    if (this.supportDoubleTap) {
      // 支持双击
      event.addGesture(
        new TapGestureHandler({ count: 2, fingers: 1 }).onAction((event: GestureEvent) => {
          this.onGestureRecognized("doubleTap")
        })
      )
    } else {
      // 支持单击
      event.addGesture(
        new TapGestureHandler({ count: 1, fingers: 1 }).onAction((event: GestureEvent) => {
          this.onGestureRecognized("singleTap")
        })
      )
    }
  }
}
@Component
struct MySample4 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      // 只支持双击，不支持单击
      Column().width(100).height(100).backgroundColor(Color.Blue)
        .gestureModifier(new MyGestureModifier(true, (type: string) => {
          this.message = type
        }))

      // 只支持单击，不支持双击
      Column().width(100).height(100).backgroundColor(Color.Blue)
        .gestureModifier(new MyGestureModifier(false, (type: string) => {
          this.message = type
        }))
    }
  }
}
