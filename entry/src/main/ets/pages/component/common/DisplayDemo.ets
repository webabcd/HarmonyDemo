/*
 * 显示相关
 * visibility, overlay, clickEffect
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct DisplayDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('visibility').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('overlay').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('clickEffect').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({ space: 10 }) {

      /*
       * visibility() - 显示状态（Visibility 枚举）
       *   Visible - 显示
       *   Hidden - 隐藏（占位）
       *   None - 隐藏（不占位）
       */
      Column().width(100).height(100).backgroundColor(Color.Red).visibility(Visibility.Hidden)
      Column().width(100).height(100).backgroundColor(Color.Green).visibility(Visibility.Visible)
      Column().width(100).height(100).backgroundColor(Color.Blue).visibility(Visibility.None)
      Column().width(100).height(100).backgroundColor(Color.Orange).visibility(Visibility.Visible)
    }
  }
}

@Component
struct MySample2 {

  @Builder myBuilder() {
    Column() {
      Image($r('app.media.app_icon'))
    }
    .width(50)
    .height(50)
  }

  build() {
    Column({ space: 10 }) {

      /*
       * overlay() - 在当前组件上叠加一个组件
       *   value - 需要叠加的文本或自定义组件
       *   options - 选项（一个 OverlayOptions 对象）
       *     align - 叠加的组件相对于父容器的对齐方式
       *       Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
       *     offset - 叠加的组件的偏移量
       *       x, y
       */

      Image($r('app.media.son'))
        .width(200)
        .height(200)
        .overlay("overlay", {
          align: Alignment.BottomEnd,
          offset: {
            x: 0,
            y: 0,
          }
        })

      Image($r('app.media.son'))
        .width(200)
        .height(200)
        .overlay(this.myBuilder(), {
          align: Alignment.BottomEnd,
          offset: {
            x: 0,
            y: 0,
          }
        })
    }
  }
}

@Component
struct MySample3 {

  build() {
    Column({ space: 10 }) {

      Button("no clickEffect").width(300).height(100)

      /*
       * clickEffect() - 点击后，组件的缩放动画效果的相关参数
       *   level - 缩放动画效果的级别（ClickEffectLevel 枚举）
       *     LIGHT - 速度较快
       *     MIDDLE - 速度中等
       *     HEAVY - 速度较慢
       *   scale - 缩放比例的最小值
       */

      Button("clickEffect（LIGHT, 0.5）").width(300).height(100)
        .clickEffect({
          level:ClickEffectLevel.LIGHT,
          scale: 0.5,
        })

      Button("clickEffect（MIDDLE, 0.5）").width(300).height(100)
        .clickEffect({
          level:ClickEffectLevel.MIDDLE,
          scale: 0.5,
        })

      Button("clickEffect（HEAVY, 0.5）").width(300).height(100)
        .clickEffect({
          level:ClickEffectLevel.HEAVY,
          scale: 0.5,
        })
    }
  }
}