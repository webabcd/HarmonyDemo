/*
 * 屏幕和窗口
 */

import { TitleBar } from '../TitleBar';
import { common } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';

@Entry
@Component
struct DisplayWindowDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('屏幕').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('窗口').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  /*
   * display.getDefaultDisplaySync() - 获取当前屏幕的相关信息（一个 Display 对象）
   *   orientation - 屏幕方向
   *     PORTRAIT（竖屏）, LANDSCAPE（竖屏顺时针旋转 90 度）, PORTRAIT_INVERTED（竖屏顺时针旋转 180 度）, LANDSCAPE_INVERTED（竖屏顺时针旋转 270 度）
   *   width - 屏幕宽度，单位 px
   *   height - 屏幕高度，单位 px
   *   densityDPI - dpi(Dots Per Inch) 每英寸点数
   *   densityPixels - 逻辑像素的密度，比如此值为 3 时 1vp 等于 3px
   *   scaledDensity - 字体像素的密度，比如此值为 3 时 1fp 等于 3px
   * display.isFoldable() - 是否是可折叠屏
   * display.getAllDisplayPhysicalResolution() - 获取折叠屏的各种状态的分辨率（一个 DisplayPhysicalResolution 对象数组）
   *   foldDisplayMode - 状态（FoldDisplayMode 枚举）
   *     FOLD_DISPLAY_MODE_FULL - 展开状态
   *     FOLD_DISPLAY_MODE_MAIN - 折叠状态时的主屏
   *   physicalWidth - 宽度，单位 px
   *   physicalHeight - 高度，单位 px
   *
   * display.on('foldStatusChange', callback) - 监听显示设备的折叠状态的变化，回调参数是一个 FoldStatus 枚举
   *   FOLD_STATUS_UNKNOWN - 未知
   *   FOLD_STATUS_EXPANDED - 完全展开
   *   FOLD_STATUS_FOLDED - 完全折叠
   *   FOLD_STATUS_HALF_FOLDED - 半折叠
   * display.off('foldStatusChange') - 关闭指定事件的监听
   */

  async aboutToAppear() {
    let ui = display.getDefaultDisplaySync()
    this.message += `orientation:${ui.orientation}\n`
    this.message += `width:${ui.width}\n`
    this.message += `height:${ui.height}\n`
    this.message += `densityDPI:${ui.densityDPI}\n`
    this.message += `densityPixels:${ui.densityPixels}\n`
    this.message += `scaledDensity:${ui.scaledDensity}\n`

    this.message += `isFoldable:${display.isFoldable()}\n`
    let uiFoldList = await display.getAllDisplayPhysicalResolution()
    for (let uiFold of uiFoldList) {
      this.message += `displayState:${uiFold.foldDisplayMode}, physicalWidth:${uiFold.physicalWidth}, physicalHeight:${uiFold.physicalHeight}\n`
    }

    let callback = (foldStatus: display.FoldStatus) => {
      this.message += `foldStatus:${foldStatus}\n`
    }
    display.on('foldStatusChange', callback)
  }

  aboutToDisappear(): void {
    // 关闭指定事件的监听
    display.off('foldStatusChange')
  }

  build() {
    Column({space:10}) {

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext;
  windowStage = this.context.windowStage;
  windowClass = this.windowStage.getMainWindowSync();

  /*
   * windowClass.getWindowProperties() - 获取当前窗口的相关信息（一个 WindowProperties 对象）
   *   windowRect - 窗口的矩形区域
   *   brightness - 屏幕亮度（0 - 1 之间，如果是 -1 则代表跟随系统的亮度）
   *   isKeepScreenOn - 屏幕是否常亮
   * windowClass.setWindowKeepScreenOn() - 设置当前屏幕是否常亮
   * windowClass.setWindowBrightness() - 设置当前屏幕的亮度（0 - 1 之间，如果是 -1 则代表跟随系统的亮度）
   *
   * windowClass.on('windowSizeChange', callback) - 监听窗口尺寸的变化，回调参数是一个 Size 对象
   *   width, height
   * windowClass.off('windowSizeChange') - 关闭指定事件的监听
   */

  aboutToAppear(): void {
    let windowProperties = this.windowClass.getWindowProperties();
    this.message += `width:${windowProperties.windowRect.width}, height:${windowProperties.windowRect.height}\n`
    this.message += `brightness:${windowProperties.brightness}\n`
    this.message += `isKeepScreenOn:${windowProperties.isKeepScreenOn}\n`

    let callback = (size: Size) => {
      this.message += `width:${size.width}, height:${size.height}\n`
    }
    this.windowClass.on('windowSizeChange', callback)
  }

  aboutToDisappear(): void {
    this.windowClass.off('windowSizeChange')
  }

  setWindowKeepScreenOn() {
    this.windowClass.setWindowKeepScreenOn(true)
  }

  setWindowBrightness() {
    this.windowClass.setWindowBrightness(0.5)
  }

  build() {
    Column({space:10}) {

      Button("设置屏幕为常亮状态").onClick(() => {
        this.setWindowKeepScreenOn()
      })

      Button("设置屏幕的亮度").onClick(() => {
        this.setWindowBrightness()
      })

      Text(this.message)
    }
  }
}
