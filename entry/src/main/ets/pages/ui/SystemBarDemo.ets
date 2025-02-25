/*
 * 顶部的系统状态栏和底部的系统导航栏
 */

import {  TitleBar } from '../TitleBar';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct SystemBarDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
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

  // 显示顶部的系统状态栏和底部的系统导航栏
  showSystemBar() {
    this.windowClass.setWindowSystemBarEnable(['status', 'navigation']).then(() => {
      this.message = '显示成功';
    }).catch((err: BusinessError) => {
      this.message =`显示失败, errCode${err.code}, errMessage:${err.message}`;
    });
  }

  // 隐藏顶部的系统状态栏和底部的系统导航栏
  hideSystemBar() {
    this.windowClass.setWindowSystemBarEnable([]).then(() => {
      this.message = '隐藏成功';
    }).catch((err: BusinessError) => {
      this.message =`隐藏失败, errCode${err.code}, errMessage:${err.message}`;
    });
  }

  // 进入全屏（沉浸式效果）
  // 沉浸式效果就是顶部的系统状态栏和底部的系统导航栏会叠放在主界面之上
  enterFullScreen() {
    this.windowClass.setWindowLayoutFullScreen(true).then(() => {
      this.message = '进入全屏成功';
    }).catch((err: BusinessError) => {
      this.message =`进入全屏失败, errCode${err.code}, errMessage:${err.message}`;
    });
  }

  // 退出全屏（非沉浸式效果）
  // 非沉浸式效果就是顶部的系统状态栏和底部的系统导航栏与主界面都会独立显示
  exitFullScreen() {
    this.windowClass.setWindowLayoutFullScreen(false).then(() => {
      this.message = '退出全屏成功';
    }).catch((err: BusinessError) => {
      this.message =`退出全屏失败, errCode${err.code}, errMessage:${err.message}`;
    });
  }

  // 沉浸式效果
  enableImmersiveMode() {
    this.windowClass.setImmersiveModeEnabledState(true)
  }

  // 非沉浸式效果
  disableImmersiveMode() {
    this.windowClass.setImmersiveModeEnabledState(false)
  }

  // 设置顶部的系统状态栏和底部的系统导航栏的样式
  setSystemBarStyle() {
    let systemBarProperties: window.SystemBarProperties = {
      statusBarColor: '#ff0000', // 状态栏背景色
      statusBarContentColor: '#ffffff',  // 状态栏前景色
      navigationBarColor: '#00ff00', // 导航栏背景色（我这里测试无效）
      navigationBarContentColor: '#ffffff', // 导航栏前景色（我这里测试无效）
    };
    this.windowClass.setWindowSystemBarProperties(systemBarProperties).then(() => {
      this.message = '设置成功';
    }).catch((err: BusinessError) => {
      this.message =`设置失败, errCode${err.code}, errMessage:${err.message}`;
    });
  }

  build() {
    Column({space:10}) {
      Button("显示顶部的系统状态栏和底部的系统导航栏").onClick(() => {
        this.showSystemBar()
      })
      Button("隐藏顶部的系统状态栏和底部的系统导航栏").onClick(() => {
        this.hideSystemBar()
      })

      Button("进入全屏（沉浸式效果）").onClick(() => {
        this.enterFullScreen()
      })
      Button("退出全屏（非沉浸式效果）").onClick(() => {
        this.exitFullScreen()
      })

      Button("沉浸式效果").onClick(() => {
        this.enableImmersiveMode()
      })
      Button("非沉浸式效果").onClick(() => {
        this.disableImmersiveMode()
      })

      Button("设置顶部的系统状态栏和底部的系统导航栏的样式").onClick(() => {
        this.setSystemBarStyle()
      })

      Text(this.message)
    }
    .width('100%')
    .height('100%')
  }
}
