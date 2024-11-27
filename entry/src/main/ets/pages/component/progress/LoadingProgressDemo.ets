/*
 * LoadingProgress - 加载框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct LoadingProgressDemo {

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

  build() {
    Column({ space: 10 }) {

      /*
       * LoadingProgress - 加载框
       *   color() - 颜色
       *   enableLoading() - 是否显示加载框动画
       *     true - 显示加载框动画
       *     false - 隐藏加载框动画，但是会占位，且不影响边框之类的显示
       */

      LoadingProgress().width(50).height(50)
        .color(Color.Red)
        .enableLoading(true)

      LoadingProgress().width(50).height(50)
        .color(Color.Green)
        .enableLoading(false)
        .borderWidth(1)
        .borderColor(Color.Orange)
        .borderRadius(25)

      LoadingProgress().width(50).height(50)
        .color(Color.Blue)
        .enableLoading(true)
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column() {
      LoadingProgress().width(100).height(100)
        // 通过 contentModifier() 实现自定义 LoadingProgress（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyLoadingProgressModifier(Color.Green))
    }
  }
}

// 实现 ContentModifier 接口
class MyLoadingProgressModifier implements ContentModifier<LoadingProgressConfiguration> {

  // 自定义属性
  color: Color = Color.White
  // 构造函数
  constructor(color:Color) {
    this.color = color
  }

  // 返回指定的自定义 LoadingProgress
  applyContent() : WrappedBuilder<[LoadingProgressConfiguration]>
  {
    return wrapBuilder(buildLoadingProgress)
  }
}

// 自定义 LoadingProgress
@Builder function buildLoadingProgress(config: LoadingProgressConfiguration) {
  /*
   * LoadingProgressConfiguration - 自定义 LoadingProgress 的相关信息
   *   enabled - 是否可用
   *   enableLoading() - 是否显示加载框动画
   *     true - 显示加载框动画
   *     false - 隐藏加载框动画，但是会占位，且不影响边框之类的显示
   */
  Column() {
    Progress({
      value: 0,
      type: ProgressType.Ring,
    })
      .style({
        status: ProgressStatus.LOADING
      })
      .color(config.enabled ? (config.contentModifier as MyLoadingProgressModifier).color : Color.White)
      .backgroundColor(Color.Red)
  }
}