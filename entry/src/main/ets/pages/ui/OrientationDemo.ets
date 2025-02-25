/*
 * 屏幕方向
 */

import { RadioBar, TitleBar } from '../TitleBar';
import { common } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';

@Entry
@Component
struct OrientationDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('通过程序控制').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过配置控制').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('控制悬浮窗方向').align(Alignment.Top)
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

  context = getContext(this) as common.UIAbilityContext;
  windowStage = this.context.windowStage;
  windowClass = this.windowStage.getMainWindowSync();

  valueList = ["UNSPECIFIED", "PORTRAIT", "LANDSCAPE", "PORTRAIT_INVERTED", "LANDSCAPE_INVERTED", "AUTO_ROTATION", "AUTO_ROTATION_PORTRAIT", "AUTO_ROTATION_LANDSCAPE", "AUTO_ROTATION_RESTRICTED", "AUTO_ROTATION_PORTRAIT_RESTRICTED", "AUTO_ROTATION_LANDSCAPE_RESTRICTED", "LOCKED", "AUTO_ROTATION_UNSPECIFIED", "USER_ROTATION_PORTRAIT", "USER_ROTATION_LANDSCAPE", "USER_ROTATION_PORTRAIT_INVERTED", "USER_ROTATION_LANDSCAPE_INVERTED", "FOLLOW_DESKTOP"]

  aboutToAppear() {
    let callback = async () => {
      /*
       * display.getDefaultDisplaySync() - 旋转后，显示设备的相关信息
       *   width - 宽
       *   height - 高
       *   orientation - 方向（display.Orientation 枚举）
       *     PORTRAIT - 竖屏
       *     LANDSCAPE - 横屏（竖屏顺时针旋转 90 度）
       *     PORTRAIT_INVERTED - 反向竖屏（竖屏顺时针旋转 180 度）
       *     LANDSCAPE_INVERTED - 反向横屏（竖屏顺时针旋转 270 度）
       */
      let newDisplay: display.Display = display.getDefaultDisplaySync();
      this.message += `orientation:${newDisplay.orientation}, width:${newDisplay.width}, height:${newDisplay.height}\n`
    }
    // 监听显示设备的方向变化
    display.on("change", callback);
  }

  aboutToDisappear(): void {
    // 关闭指定事件的监听
    display.off("change")
  }

  build() {
    Column({space:10}) {
      Text(this.message)

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        /*
         * windowClass.setPreferredOrientation() - 设置窗口的显示方向（window.Orientation 枚举）
         *   UNSPECIFIED - 未定义，由系统决定
         *   PORTRAIT - 竖屏
         *   LANDSCAPE - 横屏（竖屏顺时针旋转 90 度）
         *   PORTRAIT_INVERTED - 反向竖屏（竖屏顺时针旋转 180 度）
         *   LANDSCAPE_INVERTED - 反向横屏（竖屏顺时针旋转 270 度）
         *   AUTO_ROTATION - 跟随屏幕方向自动旋转（支持 4 个方向），且不受控制中心旋转开关的控制
         *   AUTO_ROTATION_PORTRAIT - 跟随屏幕方向自动旋转（仅支持竖屏和反向竖屏），且不受控制中心旋转开关的控制
         *   AUTO_ROTATION_LANDSCAPE - 跟随屏幕方向自动旋转（仅支持横屏和反向横屏），且不受控制中心旋转开关的控制
         *   AUTO_ROTATION_RESTRICTED - 跟随屏幕方向自动旋转（支持 4 个方向），且受控制中心旋转开关的控制
         *   AUTO_ROTATION_PORTRAIT_RESTRICTED - 跟随屏幕方向自动旋转（仅支持竖屏和反向竖屏），且受控制中心旋转开关的控制
         *   AUTO_ROTATION_LANDSCAPE_RESTRICTED - 跟随屏幕方向自动旋转（仅支持横屏和反向横屏），且受控制中心旋转开关的控制
         *   AUTO_ROTATION_UNSPECIFIED - 跟随屏幕方向自动旋转（由系统决定支持的方向，比如在经典的手机中仅支持 3 个方向，不支持反向竖屏），且受控制中心旋转开关的控制
         *   USER_ROTATION_PORTRAIT - 临时旋转到竖屏，之后跟随屏幕方向自动旋转（由系统决定支持的方向，比如在经典的手机中仅支持 3 个方向，不支持反向竖屏），且受控制中心旋转开关的控制
         *   USER_ROTATION_LANDSCAPE - 临时旋转到横屏，之后跟随屏幕方向自动旋转（由系统决定支持的方向，比如在经典的手机中仅支持 3 个方向，不支持反向竖屏），且受控制中心旋转开关的控制
         *   USER_ROTATION_PORTRAIT_INVERTED - 临时旋转到反向竖屏，之后跟随屏幕方向自动旋转（由系统决定支持的方向，比如在经典的手机中仅支持 3 个方向，不支持反向竖屏），且受控制中心旋转开关的控制
         *   USER_ROTATION_LANDSCAPE_INVERTED - 临时旋转到反向横屏，之后跟随屏幕方向自动旋转（由系统决定支持的方向，比如在经典的手机中仅支持 3 个方向，不支持反向竖屏），且受控制中心旋转开关的控制
         *   LOCKED - 方向锁定
         *   FOLLOW_DESKTOP - 跟随桌面的旋转模式
         */
        this.windowClass.setPreferredOrientation(window.Orientation[this.valueList[selectedIndex]]);
      }})
    }
    .width('100%')
    .height('100%')
  }
}

/*
 * 通过配置控制窗口方向需要在 src/main/module.json5 中做类似如下的配置
 * {
 *   "module": {
 *     "abilities": [
 *       {
 *         "orientation": "portrait"
 *       }
 *     ]
 *   }
 * }
 * 其中 orientation 的可用值和说明如下
 *  unspecified - 未定义，由系统决定
 *  landscape - 横屏
 *  portrait - 竖屏
 *  landscape_inverted - 反向横屏
 *  portrait_inverted - 反向竖屏
 *  auto_rotation - 跟随屏幕方向自动旋转（支持 4 个方向），且不受控制中心旋转开关的控制
 *  auto_rotation_landscape - 跟随屏幕方向自动旋转（仅支持横屏和反向横屏），且不受控制中心旋转开关的控制
 *  auto_rotation_portrait - 跟随屏幕方向自动旋转（仅支持竖屏和反向竖屏），且不受控制中心旋转开关的控制
 *  auto_rotation_restricted - 跟随屏幕方向自动旋转（支持 4 个方向），且受控制中心旋转开关的控制
 *  auto_rotation_landscape_restricted - 跟随屏幕方向自动旋转（仅支持横屏和反向横屏），且受控制中心旋转开关的控制
 *  auto_rotation_portrait_restricted - 跟随屏幕方向自动旋转（仅支持竖屏和反向竖屏），且受控制中心旋转开关的控制
 *  auto_rotation_unspecified：跟随屏幕方向自动旋转（由系统决定支持的方向，比如在经典的手机中仅支持 3 个方向，不支持反向竖屏），且受控制中心旋转开关的控制
 *  locked - 方向锁定
 *  follow_recent - 跟随最近窗口的旋转模式
 *  follow_desktop - 跟随桌面的旋转模式
 */
@Component
struct MySample2 {

  @State message: string = ""

  aboutToAppear() {
    let callback = async () => {
      let newDisplay: display.Display = display.getDefaultDisplaySync();
      this.message += `orientation:${newDisplay.orientation}, width:${newDisplay.width}, height:${newDisplay.height}\n`
    }
    display.on("change", callback);
  }

  aboutToDisappear(): void {
    display.off("change")
  }

  build() {
    Column({space:10}) {
      Text(this.message)
    }
    .width('100%')
    .height('100%')
  }
}

/*
 * 控制悬浮窗方向需要在 src/main/module.json5 中做类似如下的配置
 * {
 *   "module": {
 *     "abilities": [
 *       {
 *         "preferMultiWindowOrientation": "landscape_auto"
 *       }
 *     ]
 *   }
 * }
 * 其中 preferMultiWindowOrientation 的可用值和说明如下
 *  default - 默认
 *  portrait - 竖屏悬浮窗
 *  landscape - 横屏悬浮窗
 *  landscape_auto - 由程序解决是竖屏悬浮窗还是横屏悬浮窗
 */
@Component
struct MySample3 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext;
  windowStage = this.context.windowStage;
  windowClass = this.windowStage.getMainWindowSync();

  aboutToAppear() {
    let callback = async () => {
      let newDisplay: display.Display = display.getDefaultDisplaySync();
      this.message += `orientation:${newDisplay.orientation}, width:${newDisplay.width}, height:${newDisplay.height}\n`
    }
    display.on("change", callback);
  }

  aboutToDisappear(): void {
    display.off("change")
  }

  build() {
    Column({space:10}) {

      Button("横屏悬浮框").onClick(() => {
        // 横屏悬浮框（需要先在 module.json5 中配置 "preferMultiWindowOrientation": "landscape_auto"）
        this.windowClass.enableLandscapeMultiWindow()
      })

      Button("竖屏悬浮框").onClick(() => {
        // 竖屏悬浮框（需要先在 module.json5 中配置 "preferMultiWindowOrientation": "landscape_auto"）
        this.windowClass.disableLandscapeMultiWindow()
      })

      Text(this.message)
    }
    .width('100%')
    .height('100%')
  }
}