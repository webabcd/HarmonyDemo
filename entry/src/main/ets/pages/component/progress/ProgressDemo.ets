/*
 * Progress - 进度条
 */

import { RadioBar, TitleBar } from '../../TitleBar'

@Entry
@Component
struct ProgressDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('Linear').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('Ring').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('Eclipse').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('ScaleRing').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('Capsule').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State myValue:number = 0

  onDidBuild(): void {
    setInterval(() => {
      this.myValue += 10
      if (this.myValue > 100) {
        this.myValue = 0
      }
    }, 500)
  }

  build() {
    Column({space:20}) {

      /*
       * Progress - 进度条
       *   value - 进度条的当前值
       *   total - 进度条的最大值（注：最小值是 0）
       *   type - 进度条类型（Linear, Ring, Eclipse, ScaleRing, Capsule）
       *     Linear - 条形进度条
       *   value() - 进度条的当前值，如果指定了此值则会覆盖上面的那个 value 指定的值
       *   color() - 进度条前景色
       *   backgroundColor() - 进度条背景色
       *   style() - 样式（对于 ProgressType.Linear 来说，这是一个 ProgressStyleOptions 对象）
       *     strokeWidth - 进度条宽度
       *     strokeRadius - 进度条两端的圆角半径
       *     enableSmoothEffect - 进度条的值变化时，是否通过动画平滑过渡（默认值为 true）
       *     enableScanEffect - 是否在前景色中显示扫描效果（默认值为 false）
       */

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Linear,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          strokeRadius: 10,
          enableSmoothEffect: true,
          enableScanEffect: false,
        })
        .backgroundColor(Color.Red)
        .width(300)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Linear,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          strokeRadius: 10,
          enableSmoothEffect: false,
          enableScanEffect: false,
        })
        .backgroundColor(Color.Red)
        .width(300)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Linear,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          strokeRadius: 10,
          enableSmoothEffect: true,
          enableScanEffect: true,
        })
        .backgroundColor(Color.Red)
        .width(300)
    }
  }
}

@Component
struct MySample2 {

  @State myValue:number = 0

  onDidBuild(): void {
    setInterval(() => {
      this.myValue += 10
      if (this.myValue > 100) {
        this.myValue = 0
      }
    }, 500)
  }

  build() {
    Column({space:20}) {

      /*
       * Progress - 进度条
       *   value - 进度条的当前值
       *   total - 进度条的最大值（注：最小值是 0）
       *   type - 进度条类型（Linear, Ring, Eclipse, ScaleRing, Capsule）
       *     Ring - 环形进度条
       *   value() - 进度条的当前值，如果指定了此值则会覆盖上面的那个 value 指定的值
       *   color() - 进度条前景色
       *   backgroundColor() - 进度条背景色
       *   style() - 样式（对于 ProgressType.Ring 来说，这是一个 RingStyleOptions 对象）
       *     strokeWidth - 进度条宽度
       *     shadow - 是否显示阴影
       *     status - 环形进度条类型
       *       LOADING - 进度不可知
       *       PROGRESSING - 进度可知
       *     enableSmoothEffect - 进度条的值变化时，是否通过动画平滑过渡（默认值为 true）
       *     enableScanEffect - 是否在前景色中显示扫描效果（默认值为 false）
       */

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Ring,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 4,
          shadow: false,
          status: ProgressStatus.LOADING
        })
        .backgroundColor(Color.Red)
        .width(100)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Ring,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 4,
          shadow: true,
          status: ProgressStatus.PROGRESSING
        })
        .backgroundColor(Color.Red)
        .width(100)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Ring,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          enableSmoothEffect: true,
          enableScanEffect: true,
        })
        .backgroundColor(Color.Red)
        .width(100)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Ring,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          enableSmoothEffect: false,
          enableScanEffect: true,
        })
        .backgroundColor(Color.Red)
        .width(100)
    }
  }
}

@Component
struct MySample3 {

  @State myValue:number = 0

  onDidBuild(): void {
    setInterval(() => {
      this.myValue += 10
      if (this.myValue > 100) {
        this.myValue = 0
      }
    }, 500)
  }

  build() {
    Column({space:20}) {

      /*
       * Progress - 进度条
       *   value - 进度条的当前值
       *   total - 进度条的最大值（注：最小值是 0）
       *   type - 进度条类型（Linear, Ring, Eclipse, ScaleRing, Capsule）
       *     Eclipse - 圆形进度条
       *   value() - 进度条的当前值，如果指定了此值则会覆盖上面的那个 value 指定的值
       *   color() - 进度条前景色
       *   backgroundColor() - 进度条背景色
       *   style() - 样式（对于 ProgressType.Eclipse 来说，这是一个 EclipseStyleOptions 对象）
       *     enableSmoothEffect - 进度条的值变化时，是否通过动画平滑过渡（默认值为 true）
       */

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Eclipse,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          enableSmoothEffect: true
        })
        .backgroundColor(Color.Red)
        .width(100)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Eclipse,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          enableSmoothEffect: false
        })
        .backgroundColor(Color.Red)
        .width(100)
    }
  }
}

@Component
struct MySample4 {

  @State myValue:number = 0

  onDidBuild(): void {
    setInterval(() => {
      this.myValue += 10
      if (this.myValue > 100) {
        this.myValue = 0
      }
    }, 500)
  }

  build() {
    Column({space:20}) {

      /*
       * Progress - 进度条
       *   value - 进度条的当前值
       *   total - 进度条的最大值（注：最小值是 0）
       *   type - 进度条类型（Linear, Ring, Eclipse, ScaleRing, Capsule）
       *     ScaleRing - 环形且带刻度的进度条
       *   value() - 进度条的当前值，如果指定了此值则会覆盖上面的那个 value 指定的值
       *   color() - 进度条前景色
       *   backgroundColor() - 进度条背景色
       *   style() - 样式（对于 ProgressType.ScaleRing 来说，这是一个 ScaleRingStyleOptions 对象）
       *     strokeWidth - 进度条宽度
       *     scaleCount - 刻度数量
       *     scaleWidth - 刻度宽度
       *     enableSmoothEffect - 进度条的值变化时，是否通过动画平滑过渡（默认值为 true）
       */

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.ScaleRing,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          scaleCount: 120,
          scaleWidth: 2,
          enableSmoothEffect: true
        })
        .backgroundColor(Color.Red)
        .width(200)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.ScaleRing,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          strokeWidth: 20,
          scaleCount: 120,
          scaleWidth: 2,
          enableSmoothEffect: false
        })
        .backgroundColor(Color.Red)
        .width(200)
    }
  }
}

@Component
struct MySample5 {

  @State myValue:number = 0

  onDidBuild(): void {
    setInterval(() => {
      this.myValue += 10
      if (this.myValue > 100) {
        this.myValue = 0
      }
    }, 500)
  }

  build() {
    Column({space:20}) {

      /*
       * Progress - 进度条
       *   value - 进度条的当前值
       *   total - 进度条的最大值（注：最小值是 0）
       *   type - 进度条类型（Linear, Ring, Eclipse, ScaleRing, Capsule）
       *     Capsule - 胶囊进度条
       *   value() - 进度条的当前值，如果指定了此值则会覆盖上面的那个 value 指定的值
       *   color() - 进度条前景色
       *   backgroundColor() - 进度条背景色
       *   style() - 样式（对于 ProgressType.Capsule 来说，这是一个 CapsuleStyleOptions 对象）
       *     borderColor - 边框颜色
       *     borderWidth - 边框宽度
       *     content - 胶囊内显示的内容
       *     showDefaultPercentage - 是否在胶囊内显示进度百分比
       *       只有当没指定 content 时，showDefaultPercentage 设置为 true 才会生效
       *     font - 胶囊内显示的文字的字体样式
       *       size, weight, style, family
       *     fontColor - 胶囊内显示的文字的颜色
       *     enableSmoothEffect - 进度条的值变化时，是否通过动画平滑过渡（默认值为 true）
       *     enableScanEffect - 是否在前景色中显示扫描效果（默认值为 false）
       */

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Capsule,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          borderColor: Color.Blue,
          borderWidth: 4,
          content: 'content',
          showDefaultPercentage: false,
          font: {
            size: 24,
            weight: FontWeight.Bold,
            style: FontStyle.Normal,
            family: 'HarmonyOS Sans',
          },
          fontColor: Color.Orange,
          enableSmoothEffect: true,
          enableScanEffect: false,
        })
        .backgroundColor(Color.Red)
        .width(300)
        .height(100)

      Progress({
        value: 10,
        total: 100,
        type: ProgressType.Capsule,
      })
        .value(this.myValue)
        .color(Color.Green)
        .style({
          borderColor: Color.Blue,
          borderWidth: 4,
          showDefaultPercentage: true,
          font: {
            size: 24,
            weight: FontWeight.Bold,
            style: FontStyle.Normal,
            family: 'HarmonyOS Sans',
          },
          fontColor: Color.Orange,
          enableSmoothEffect: false,
          enableScanEffect: true,
        })
        .backgroundColor(Color.Red)
        .width(300)
        .height(100)
    }
  }
}

@Component
struct MySample6 {

  @State myValue:number = 0

  onDidBuild(): void {
    setInterval(() => {
      this.myValue += 1
      if (this.myValue > 3) {
        this.myValue = 0
      }
    }, 500)
  }

  build() {
    Column() {
      Progress({
        value: this.myValue,
        total: 3,
      })
        // 通过 contentModifier() 实现自定义 Progress（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyProgressModifier(Color.Red))
    }
  }
}

// 实现 ContentModifier 接口
class MyProgressModifier implements ContentModifier<ProgressConfiguration> {

  // 自定义属性
  color: Color = Color.White
  // 构造函数
  constructor(color:Color) {
    this.color = color
  }

  // 返回指定的自定义 Progress
  applyContent() : WrappedBuilder<[ProgressConfiguration]>
  {
    return wrapBuilder(buildProgress)
  }
}

// 自定义 Progress
@Builder function buildProgress(config: ProgressConfiguration) {
  /*
   * ProgressConfiguration - 自定义 Progress 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   value - 进度条的当前值
   *   total - 进度条的最大值（注：最小值是 0）
   */
  Column({ space: 10 }) {
    Text(`progress: ${config.value}/${config.total}`).fontSize(16)
    Row() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Path()
          .commands('M108 0 L141 70 L218 78.3 L162 131 L175 205 L108 170 L41.2 205 L55 131 L1 78 L75 68 L108 0 Z')
          .fill(config.enabled && config.value >=1 ? (config.contentModifier as MyProgressModifier).color : Color.White)
          .stroke(Color.Black)
          .strokeWidth(3)
        Path()
          .commands('M108 0 L141 70 L218 78.3 L162 131 L175 205 L108 170 L41.2 205 L55 131 L1 78 L75 68 L108 0 Z')
          .fill(config.enabled && config.value >=2 ? (config.contentModifier as MyProgressModifier).color : Color.White)
          .stroke(Color.Black)
          .strokeWidth(3)
        Path()
          .commands('M108 0 L141 70 L218 78.3 L162 131 L175 205 L108 170 L41.2 205 L55 131 L1 78 L75 68 L108 0 Z')
          .fill(config.enabled && config.value >=3 ? (config.contentModifier as MyProgressModifier).color : Color.White)
          .stroke(Color.Black)
          .strokeWidth(3)
      }
    }
  }
}