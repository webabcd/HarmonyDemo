/*
 * Slider - 可拖动进度条
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct SliderDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('样式').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      /*
       * Slider - 可拖动进度条
       *   value - 当前值
       *   min - 最小值
       *   max - 最大值
       *   step - 步长
       *   direction - 可拖动进度条的方向
       *     Axis.Horizontal - 水平的可拖动进度条
       *     Axis.Vertical - 垂直的可拖动进度条
       *   reverse - 是否反向拖动
       *     true 从左到右是正向拖动，从上到下是正向拖动
       *     false 从右到左是正向拖动，从下到上是正向拖动
       *   style - 样式类型（SliderStyle 枚举）
       *     OutSet - 滑块在滑轨上
       *     InSet - 滑块在滑轨内
       *     NONE - 无滑块
       *   onChange() - 因用户行为导致进度发生变化时的回调
       *     value - 当前值
       *     mode - 回调发生的类型（SliderChangeMode 枚举）
       *       Begin - 滑块开始滑动
       *       Moving - 滑块滑动中
       *       End - 滑块结束滑动
       *       Click - 因点击轨道从而使滑块滑动时
       *   sliderInteractionMode() - 点击轨道后的行为（SliderInteraction 枚举）
       *     SLIDE_AND_CLICK - 点击轨道后，滑块立即移动（默认值）
       *     SLIDE_ONLY - 点击轨道后，滑块不动
       *     SLIDE_AND_CLICK_UP - 点击轨道并抬起后，滑块移动
       */

      Slider({
        value: 10,
        min: 0,
        max: 100,
        step: 1,
        direction: Axis.Horizontal,
        reverse: false,
        style: SliderStyle.OutSet
      })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.message = `value:${value}, mode:${mode}`
        })
        .width('90%')

      Slider({
        value: 10,
        min: 0,
        max: 100,
        step: 1,
        direction: Axis.Horizontal,
        reverse: false,
        style: SliderStyle.InSet
      })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.message = `value:${value}, mode:${mode}`
        })
        .width('90%')

      Slider({
        value: 10,
        min: 0,
        max: 100,
        step: 1,
        direction: Axis.Horizontal,
        reverse: false,
        style: SliderStyle.NONE
      })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.message = `value:${value}, mode:${mode}`
        })
        .width('90%')

      Slider({
        value: 10,
        min: 0,
        max: 100,
        step: 1,
        direction: Axis.Vertical,
        reverse: true,
        style: SliderStyle.OutSet
      })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.message = `value:${value}, mode:${mode}`
        })
        .height(200)

      Slider({ value: 30, style: SliderStyle.OutSet })
        .sliderInteractionMode(SliderInteraction.SLIDE_AND_CLICK_UP)
        .slideRange({
          from: 30,
          to: 100
        })
        .width('90%')
    }
  }
}

@Component
struct MySample2 {

  @State myValue: number = 10

  build() {
    Column({ space: 10 }) {

      /*
       * Slider - 可拖动进度条
       *   showTips() - 当进度发生变化时，是否显示当前的进度提示，可以指定提示内容
       *   showSteps() - 是否在进度条内显示 step 点
       *   stepSize() - 设置 step 点的大小
       *   stepColor() - 设置 step 点的颜色
       *
       *   trackThickness() - 轨道的粗细
       *   trackColor() - 轨道颜色
       *   trackBorderRadius() - 轨道两端圆角半径
       *
       *   selectedColor() - 滑块左侧轨道颜色
       *   selectedBorderRadius() - 滑块左侧轨道两端圆角半径
       *
       *   blockColor() - 滑块颜色
       *   blockSize() - 滑块大小
       *     width, height
       *   blockBorderColor() - 滑块边框颜色
       *   blockBorderWidth() - 滑块边框宽度
       *   blockStyle() - 滑块样式（一个 SliderBlockStyle 对象）
       *     type - 类型（SliderBlockType 枚举）
       *       DEFAULT - 默认的圆形滑块
       *       IMAGE - 使用一个图片做滑块
       *       SHAPE - 使用一个图形做滑块（图形相关请参见 /shape/ShapeDemo.ets 中的相关说明）
       *     image - 当 SliderBlockType.IMAGE 时，设置滑块的图片
       *     shape - 当 SliderBlockType.SHAPE 时，设置滑块的图形
       */

      Slider({ value: 10, step: 10, style: SliderStyle.InSet })
        .blockColor(Color.Red)
        .trackColor(Color.Orange)
        .selectedColor(Color.Blue)
        .showTips(true)
        .showSteps(true)
        .stepSize(10)
        .stepColor(Color.White)
        .margin({ top: 50 }).width('90%')

      Slider({ value: this.myValue, style: SliderStyle.OutSet })
        .blockSize({
          width: 40,
          height: 40
        })
        .showTips(true, this.myValue.toFixed(0))
        .trackThickness(20)
        .blockBorderColor(Color.Red)
        .blockBorderWidth(5)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.myValue = value
        })
        .margin({ top: 20 }).width('90%')

      Slider({ value: 10, style: SliderStyle.InSet })
        .trackBorderRadius(10)
        .selectedBorderRadius(5)
        .margin({ top: 20 }).width('90%')

      Slider({ value: 10, style: SliderStyle.OutSet })
        .blockStyle({
          type: SliderBlockType.DEFAULT
        })
        .margin({ top: 20 }).width('90%')

      Slider({ value: 10, style: SliderStyle.OutSet })
        .blockStyle({
          type: SliderBlockType.IMAGE,
          image: $r('app.media.app_icon')
        })
        .margin({ top: 20 }).width('90%')

      Slider({ value: 10, style: SliderStyle.OutSet })
        .blockSize({
          width: 40,
          height: 40
        })
        .blockColor(Color.Red)
        .blockStyle({
          type: SliderBlockType.SHAPE,
          shape: new Path({
            commands: 'M108 0 L141 70 L218 78.3 L162 131 L175 205 L108 170 L41.2 205 L55 131 L1 78 L75 68 L108 0 Z'
          })
        })
        .margin({ top: 20 }).width('90%')
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  build() {
    Column() {

      Slider({ value: 10, })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.message = `value:${value}, mode:${mode}`
        })
        // 通过 contentModifier() 实现自定义 Slider（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MySliderModifier(Color.Orange))
    }
  }
}

// 实现 ContentModifier 接口
class MySliderModifier implements ContentModifier<SliderConfiguration> {

  // 自定义属性
  tipBackgroundColor: Color = Color.White
  // 构造函数
  constructor(tipBackgroundColor: Color) {
    this.tipBackgroundColor = tipBackgroundColor
  }

  // 返回指定的自定义 Slider
  applyContent() : WrappedBuilder<[SliderConfiguration]> {
    return wrapBuilder(buildSlider)
  }
}

// 自定义 Slider
@Builder function buildSlider(config: SliderConfiguration) {
  /*
   * SliderConfiguration - 自定义 Slider 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   value - 当前值
   *   min - 最小值
   *   max - 最大值
   *   step - 步长
   *   triggerChange() - 触发 Slider 的 onChange() 回调
   */
  Column() {
    Text(config.value + "%")
      .backgroundColor((config.contentModifier as MySliderModifier).tipBackgroundColor)
    Slider({
      value: config.value,
      min: config.min,
      max: config.max,
      step:config.step,
    })
      .onChange((value: number, mode: SliderChangeMode) => {
        config.triggerChange(value, mode)
      })
  }
}

