/*
 * FoldSplitContainer - 折叠屏分栏布局
 *   可以定义 3 个分栏区域（首要区域，次要区域，扩展区域），悬停时会自动避让折痕区域
 *
 * 注：
 * 1、折叠屏的折叠状态有：完全折叠，完全展开，半折叠
 * 2、折叠屏的适配状态有：折叠，展开，悬停（悬停的意思是半折叠且横屏，如果是半折叠且竖屏则相当于展开状态）
 */

import { TitleBar } from '../../TitleBar'
import { FoldSplitContainer, PresetSplitRatio, ExtraRegionPosition, ExpandedRegionLayoutOptions, HoverModeRegionLayoutOptions, FoldedRegionLayoutOptions,
  HoverModeStatus } from '@kit.ArkUI';

@Entry
@Component
struct FoldSplitContainerDemo {
  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('二分栏').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('三分栏').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('定义布局').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @Builder
  privateRegion() {
    Text("primary").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Red)
  }

  @Builder
  secondaryRegion() {
    Text("secondary").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Green)
  }

  build() {
    RelativeContainer() {
      /*
       * FoldSplitContainer - 折叠屏分栏布局
       *   primary - 首要区域的自定义组件
       *   secondary - 次要区域的自定义组件
       */
      FoldSplitContainer({
        primary: () => {
          this.privateRegion()
        },
        secondary: () => {
          this.secondaryRegion()
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct MySample2 {

  @Builder
  privateRegion() {
    Text("primary").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Red)
  }

  @Builder
  secondaryRegion() {
    Text("secondary").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Green)
  }

  @Builder
  extraRegion() {
    Text("extra").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Blue)
  }

  build() {
    RelativeContainer() {
      /*
       * FoldSplitContainer - 折叠屏分栏布局
       *   primary - 首要区域的自定义组件
       *   secondary - 次要区域的自定义组件
       *   extra - 扩展区域的自定义组件
       */
      FoldSplitContainer({
        primary: () => {
          this.privateRegion()
        },
        secondary: () => {
          this.secondaryRegion()
        },
        extra: () => {
          this.extraRegion()
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  @Builder
  privateRegion() {
    Text("primary " + this.message).fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Red)
  }

  @Builder
  secondaryRegion() {
    Text("secondary").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Green)
  }

  @Builder
  extraRegion() {
    Text("extra").fontSize(24).textAlign(TextAlign.Center)
      .width('100%').height('100%').fontColor(Color.White).backgroundColor(Color.Blue)
  }

  @State expandedLayoutOptions: ExpandedRegionLayoutOptions = {
    isExtraRegionPerpendicular: false,
    extraRegionPosition: ExtraRegionPosition.TOP,
    verticalSplitRatio: PresetSplitRatio.LAYOUT_2V3, // 0.6666666666666666
    horizontalSplitRatio: PresetSplitRatio.LAYOUT_3V2, // 1.5
  }

  @State hoverModeLayoutOptions: HoverModeRegionLayoutOptions = {
    showExtraRegion: true,
    extraRegionPosition: ExtraRegionPosition.BOTTOM,
    horizontalSplitRatio: PresetSplitRatio.LAYOUT_1V1, // 1.0
  }

  @State foldedLayoutOptions: FoldedRegionLayoutOptions = {
    verticalSplitRatio: 2.0
  }

  build() {
    Column() {
      /*
       * FoldSplitContainer - 折叠屏分栏布局
       *   primary - 首要区域的自定义组件
       *   secondary - 次要区域的自定义组件
       *   extra - 扩展区域的自定义组件
       *   expandedLayoutOptions - 展开状态时的布局（一个 ExpandedRegionLayoutOptions 对象）
       *     isExtraRegionPerpendicular - 扩展区域是否显示在右侧，并且从上到下填满（默认值为 true）
       *     extraRegionPosition - 扩展区域的显示位置（当 isExtraRegionPerpendicular 设置为 false 时有效）
       *       ExtraRegionPosition.TOP 或 ExtraRegionPosition.BOTTOM
       *     verticalSplitRatio - 主要区域与次要区域之间的高度比
       *     horizontalSplitRatio - 主要区域与扩展区域之间的宽度比
       *   hoverModeLayoutOptions - 悬停状态时的布局（一个 HoverModeRegionLayoutOptions 对象）
       *     showExtraRegion - 是否显示扩展区域（默认值为 false）
       *     extraRegionPosition - 扩展区域的显示位置
       *       ExtraRegionPosition.TOP 或 ExtraRegionPosition.BOTTOM
       *     horizontalSplitRatio - 次要区域与扩展区域之间的宽度比
       *   foldedLayoutOptions - 折叠状态时的布局（一个 FoldedRegionLayoutOptions 对象）
       *     verticalSplitRatio - 主要区域与次要区域之间的高度比
       *   animationOptions - 动画参数（一个 AnimateParam 对象）
       *   onHoverStatusChange - 进入或退出悬停状态时的回调（回调参数是一个 HoverModeStatus 对象）
       *     foldStatus - 当前的折叠状态
       *       FOLD_STATUS_UNKNOWN - 未知
       *       FOLD_STATUS_EXPANDED - 完全展开
       *       FOLD_STATUS_FOLDED - 完全折叠
       *       FOLD_STATUS_HALF_FOLDED - 半折叠
       *     isHoverMode - 当前是否是悬停状态
       *     appRotation - 当前应用的方向（AppRotation 枚举）
       *       ROTATION_0, ROTATION_90, ROTATION_180, ROTATION_270
       *     windowStatusType - 当前窗口模式（WindowStatusType 枚举）
       *       UNDEFINED, FULL_SCREEN, MAXIMIZE, MINIMIZE, FLOATING, SPLIT_SCREEN
       */
      FoldSplitContainer({
        primary: () => {
          this.privateRegion()
        },
        secondary: () => {
          this.secondaryRegion()
        },
        extra: () => {
          this.extraRegion()
        },
        expandedLayoutOptions: this.expandedLayoutOptions,
        hoverModeLayoutOptions: this.hoverModeLayoutOptions,
        foldedLayoutOptions: this.foldedLayoutOptions,
        animationOptions: { duration: 3000 },
        onHoverStatusChange: (status: HoverModeStatus) => {
          this.message = `onHoverStatusChange: ${JSON.stringify(status)}`
        }
      })
    }
    .width("100%")
    .height("100%")
  }
}