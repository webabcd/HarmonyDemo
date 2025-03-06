/*
 * 生命周期
 * aboutToAppear, onDidBuild, onPageShow, onBackPress, onPageHide, aboutToDisappear
 *
 * 本例用于演示 @Entry 组件的生命周期和非 @Entry 组件的生命周期
 * 关于 UIAbility 的生命周期请参见 UIAbilityDemo.ets 中的相关说明
 */

import { MyLog, TitleBar } from '../TitleBar';
import { window } from '@kit.ArkUI';

// 用于演示 @Entry 组件的生命周期
@Entry
@Component
struct LifecycleDemo {

  @State showChild: boolean = true;

  // 只有被 @Entry 装饰的组件的生命周期才有 onPageShow
  onPageShow() {
    MyLog.d('onPageShow 页面显示时触发，比如路由进来或应用进入前台等');
  }

  // 只有被 @Entry 装饰的组件的生命周期才有 onPageHide
  onPageHide() {
    MyLog.d('onPageHide 页面隐藏时触发，比如路由离开或应用进入后台等');
  }

  // 只有被 @Entry 装饰的组件的生命周期才有 onBackPress
  onBackPress() {
    MyLog.d('onBackPress 用户点击返回按钮时触发');
    // 返回 false 则使用默认的返回逻辑
    // 返回 true 则需要自己处理返回逻辑
    return false
  }

  // 组件生命周期
  aboutToAppear() {
    MyLog.d('aboutToAppear 组件即将创建之前');

    // 开启 windowEvent 监听
    window.getLastWindow(getContext(this), (err, win) => {
      win.on("windowEvent", (event) => {
        // 监听切到前台和切到后台的事件
        if (event == window.WindowEventType.WINDOW_SHOWN) {
          MyLog.d('切到前台');
        } else if (event == window.WindowEventType.WINDOW_HIDDEN) {
          MyLog.d('切到后台');
        }
      });
    });
  }

  // 组件生命周期
  onDidBuild() {
    MyLog.d('onDidBuild 组件 build() 函数执行完成之后');
  }

  // 组件生命周期
  aboutToDisappear() {
    MyLog.d('aboutToDisappear 组件即将销毁之前');

    // 关闭 windowEvent 监听
    window.getLastWindow(getContext(this), (err, win) => {
      win.off("windowEvent");
    });
  }

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button('show/hide child')
        .onClick(() => {
          this.showChild = !this.showChild;
        })

      if (this.showChild) {
        Child()
      }
    }
  }
}

// 用于演示非 @Entry 组件的生命周期
@Component
struct Child {
  // 组件生命周期
  aboutToAppear() {
    MyLog.d('Child 组件即将创建之前');
  }

  // 组件生命周期
  onDidBuild() {
    MyLog.d('Child 组件 build() 函数执行完成之后');
  }

  // 组件生命周期
  aboutToDisappear() {
    MyLog.d('Child 组件即将销毁之前');
  }

  build() {
    Text('Text')
  }
}