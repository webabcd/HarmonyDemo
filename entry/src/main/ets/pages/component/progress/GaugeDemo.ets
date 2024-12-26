/*
 * Gauge - 环形表进度条
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct GaugeDemo {

  build() {
    Column({ space: 10 }) {
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

  // 自定义的在 Gauge 底部显示的说明内容
  @Builder descriptionBuilder() {
    Text('说明文本').width('100%').height("100%")
      .fontColor(Color.Red)
      .textAlign(TextAlign.Center)
  }

  build() {
    Column({ space: 10 }) {

      /*
       * Gauge - 环形表进度条
       *   value - 当前值
       *   min - 最小值
       *   max - 最大值
       *   value() - 进度条的当前值，如果指定了此值则会覆盖上面的那个 value 指定的值
       *   startAngle() - 环形表的起始点的角度（默认值为 0）
       *   endAngle() - 环形表的结束点的角度（默认值为 360）
       *   strokeWidth() - 进度条的画笔宽度
       *   trackShadow() - 进度条阴影
       *     radius - 阴影的模糊半径
       *     offsetX - 阴影的 x 轴偏移量
       *     offsetY - 阴影的 y 轴偏移量
       *   description() - 自定义的说明内容（指定一个自定义组件），其会显示在组件的底部
       *     不指定的话则会在底部显示 min 值和 max 值，如果不想显示的话就指定为 null 即可
       *   indicator() - 指针样式（指定为 null 则不显示）
       *     icon - 指针图标（必须是 svg 格式）
       *     space - 指针距离环外侧的距离
       *   colors - 进度条颜色
       *     也可以指定一个颜色数组，最多可以显示 9 段不同的颜色，并指定每段颜色所占的比重
       *     不指定的话，默认会是一段绿色到红色的渐变色
       */
      Gauge({ value: 30, min: 1, max: 100 }) {
        Column() {
          Text('Text').fontSize(24)
        }.width('100%').height('100%').backgroundColor(Color.Orange).justifyContent(FlexAlign.Center)
      }
      .value(25)
      .startAngle(-150)
      .endAngle(150)
      .strokeWidth(10)
      .trackShadow({
        radius: 10,
        offsetX: 10,
        offsetY: 10
      })
      .description(this.descriptionBuilder)
      .colors(Color.Green)
      .width(150)

      Gauge({ value: 50, min: 1, max: 100 }) {
        Column() {
          Text('Text').fontSize(24)
        }.width('100%').height('100%').backgroundColor(Color.Orange).justifyContent(FlexAlign.Center)
      }
      .value(50)
      .startAngle(-150)
      .endAngle(150)
      .strokeWidth(10)
      .indicator({
        icon: $r('app.media.ic_arrow_up'),
        space: 15,
      })
      .colors([
        [new LinearGradient([{ color: Color.Red, offset: 0 }, { color: Color.Green, offset: 1 }]), 1],
        [new LinearGradient([{ color: Color.Green, offset: 0 }, { color: Color.Blue, offset: 1 }]), 2],
        [new LinearGradient([{ color: Color.Blue, offset: 0 }, { color: Color.Red, offset: 1 }]), 1],
      ])
      .width(150)

      Gauge({ value: 75, min: 1, max: 100 }) {
        Column() {
          Text('Text').fontSize(24)
        }.width('100%').height('100%').backgroundColor(Color.Orange).justifyContent(FlexAlign.Center)
      }
      .value(75)
      .startAngle(-150)
      .endAngle(150)
      .strokeWidth(10)
      .description(null)
      .indicator(null)
      .width(150)
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column() {
      Gauge({ value: 75, min: 1, max: 100 })
        // 通过 contentModifier() 实现自定义 Gauge（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyGaugeModifier(Color.Orange))
    }
  }
}

// 实现 ContentModifier 接口
class MyGaugeModifier implements ContentModifier<GaugeConfiguration> {

  // 自定义属性
  color: Color = Color.Red
  // 构造函数
  constructor(color: Color) {
    this.color = color
  }

  // 返回指定的自定义 Gauge
  applyContent(): WrappedBuilder<[GaugeConfiguration]> {
    return wrapBuilder(buildGauge)
  }
}

// 自定义 Gauge
@Builder function buildGauge(config: GaugeConfiguration) {
  /*
   * GaugeConfiguration - 自定义 Gauge 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   value - 当前值
   *   min - 最小值
   *   max - 最大值
   */
  Column() {
    Gauge({
      value: config.value,
      min: config.min,
      max: config.max
    }).width("100%").colors((config.contentModifier as MyGaugeModifier).color)
  }
  .width("100%")
}

