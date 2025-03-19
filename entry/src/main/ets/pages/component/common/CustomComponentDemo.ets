/*
 * 自定义组件
 */

import { Helper } from '../../../utils/Helper'
import { MyLog, TitleBar } from '../../TitleBar'

@Entry
@Component
struct CustomComponentDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('简单示例').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('自定义布局').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('内置方法').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('自定义 controller').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}


// 自定义组件的简单示例
@Component
struct MyCustomComponent1 {
  // 组件参数，在调用此组件的时候可以传递此参数
  // 如果用 @Require 装饰，则代表在构造组件的时候必须要传参
  // 定义的参数默认是必须要初始化的，如果不想初始化就定义为 ? 或 ! 即可
  @Require message!: string

  // 定义回调函数
  onCallback?: (value: string) => void;

  build() {
    Button(`MyComponent1 ${this.message}`)
      .onClick(() => {
        if (this.onCallback) {
          this.onCallback(Helper.getTimestampString())
        }
      })
  }
}
@Component
struct MySample1 {

  @State message: string = 'Hello World';

  build() {
    Column({space:10}) {

      Text(this.message)

      MyCustomComponent1({
        message: "abc",
        // 回调函数
        onCallback: (value: string) => {
          this.message = value
        }
      })
    }
  }
}


// 自定义组件，用于演示自定义布局
// 先通过 onMeasureSize() 计算每个子组件的尺寸，再通过 onPlaceChildren() 指定每个子组件的位置
@Component
struct MyCustomComponent2 {

  @Builder doNothingBuilder() { }
  @BuilderParam builder: () => void = this.doNothingBuilder

  /*
   * 通过 onMeasureSize() 计算每个子组件的尺寸（注：先 onMeasureSize 再 onPlaceChildren）
   *   selfLayoutInfo - 父组件的布局信息（一个 GeometryInfo 对象）
   *     width, height, borderWidth, margin, padding
   *   children - 子组件数组（一个 Measurable 对象数组）
   *     measure() - 测量并返回指定的子组件的尺寸，测量后的结果可以在 onPlaceChildren() 中获取到
   *     getMargin(), getPadding(), getBorderWidth() - 获取指定的子组件的 margin, padding, borderWidth 的值
   *   constraint - 父组件的约束信息
   *     minWidth, maxWidth, minHeight, maxHeight
   *
   * 注：onMeasureSize() 的返回值为当前自定义组件的尺寸
   */
  onMeasureSize(selfLayoutInfo: GeometryInfo, children: Array<Measurable>, constraint: ConstraintSizeOptions) {
    MyLog.d(`onMeasureSize selfLayoutInfo:${JSON.stringify(selfLayoutInfo)}`)

    children.forEach((child, index) => {
      // 通过 minWidth, maxWidth, minHeight, maxHeight 测量并返回 child 的尺寸
      // 测量后，对应的子组件的尺寸就确定了，后续也可以在 onPlaceChildren() 中获取到
      let measureResult: MeasureResult = child.measure({
        minWidth: selfLayoutInfo.width,
        maxWidth: selfLayoutInfo.width,
        minHeight: selfLayoutInfo.height / children.length,
        maxHeight: selfLayoutInfo.height / children.length,
      })
      MyLog.d(`onMeasureSize chile(${index}) width:${measureResult.width}, height:${measureResult.height}`)
    })

    let result: SizeResult = {
      width: selfLayoutInfo.width,
      height: selfLayoutInfo.height
    }
    // 返回当前自定义组件的尺寸
    return result;
  }

  /*
   * 通过 onPlaceChildren() 指定每个子组件的位置（注：先 onMeasureSize 再 onPlaceChildren）
   *   selfLayoutInfo - 父组件的布局信息（一个 GeometryInfo 对象）
   *     width, height, borderWidth, margin, padding
   *   children - 子组件数组（一个 Layoutable 对象数组）
   *     measureResult - 获取指定的子组件的尺寸（注：此尺寸是在 onMeasureSize 中测量出的结果）
   *     layout() - 设置指定的子组件的位置
   *     getMargin(), getPadding(), getBorderWidth() - 获取指定的子组件的 margin, padding, borderWidth 的值
   *   constraint - 父组件的约束信息
   *     minWidth, maxWidth, minHeight, maxHeight
   */
  onPlaceChildren(selfLayoutInfo: GeometryInfo, children: Array<Layoutable>, constraint: ConstraintSizeOptions) {
    let posY = 0;
    children.forEach((child) => {
      // 通过 x, y 设置 child 的位置
      child.layout({ x: 0, y: posY })
      // 通过 measureResult 获取 child 的尺寸（注：此尺寸是在 onMeasureSize 中测量出的结果）
      posY = posY + child.measureResult.height;
    })
  }

  build() {
    this.builder()
  }
}
@Component
struct MySample2 {

  // 自定义组件的子组件
  @Builder myBuilder() {
    ForEach(["1", "2", "3"], (item: string) => {
      Text(item).fontSize(36).borderWidth(1)
    })
  }

  build() {
    Column({space:10}) {
      // 使用自定义组件
      MyCustomComponent2({ builder: this.myBuilder })
        .width(300).height(300).backgroundColor(Color.Yellow)
    }
  }
}


// 自定义组件，用于演示自定义组件中的可用的内置方法
@Component
struct MyCustomComponent3 {

  @State message: string = ""

  aboutToAppear(): void {
    // 获取 UIContext
    let uiContext = this.getUIContext()
    this.message = `100vp = ${uiContext.vp2px(100)}px\n`

    // 获取组件的唯一 id
    let uniqueId: number = this.getUniqueId();
    this.message += `uniqueId: ${uniqueId}\n`

    // 获取组件所属的 NavDestinationInfo
    let navDestinationInfo = this.queryNavDestinationInfo();
    this.message += `navDestinationInfo: ${JSON.stringify(navDestinationInfo)}\n`

    // 获取组件所属的 NavigationInfo
    let navigationInfo = this.queryNavigationInfo();
    this.message += `navigationInfo: ${JSON.stringify(navigationInfo)}\n`

    // 获取组件所属的 RouterPageInfo
    let routerPageInfo = this.queryRouterPageInfo();
    this.message += `routerPageInfo: ${JSON.stringify(routerPageInfo)}\n`
  }

  build() {
    Text(this.message)
  }
}
@Component
struct MySample3 {
  build() {
    Column({space:10}) {
      MyCustomComponent3()
    }
  }
}


// 自定义 controller
class MyCustomComponent4Controller {
  changeText: (value: string) => void = (value: string) => {  }
}
// 自定义组件，用于演示自定义 controller
@Component
struct MyCustomComponent4 {

  @State text: string = 'hello controller'
  controller!: MyCustomComponent4Controller

  aboutToAppear() {
    if (this.controller) {
      this.controller.changeText = this.changeText.bind(this);
    }
  }

  private changeText(value: string) {
    this.text = value;
  }

  build() {
    Column() {
      Text(this.text)
    }
  }
}
@Component
struct MySample4 {

  controller: MyCustomComponent4Controller = new MyCustomComponent4Controller();

  build() {
    Column({space:10}) {
      MyCustomComponent4({
        controller: this.controller
      })

      Button('调用 controller 的 changeText()').onClick(() => {
        this.controller.changeText(Helper.getTimestampString());
      })
    }
  }
}