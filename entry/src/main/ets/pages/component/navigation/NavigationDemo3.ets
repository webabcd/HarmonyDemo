/*
 * Navigation - 导航组件
 * 包括顶部的导航栏，中部的内容区，底部的工具栏
 *
 * 本例用于演示导航组件的转场动画
 * Navigation 是导航的根组件，导航到的目标页是 NavDestination 组件，导航栈中包含的是多个 NavDestination 组件
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct NavigationDemo3 {

  navPathStack: NavPathStack = new NavPathStack();

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * Navigation - 导航组件
       *   customNavContentTransition() - 控制转场动画
       *     from, to - 退场页面的信息和进场页面的信息（一个 NavContentInfo 对象）
       *       name - 当前页面的名称（对应的路由名称）
       *       index - 当前页面在导航栈中的索引位置，如果是 Navigation 组件则返回值为 -1
       *       mode - 当前页面的模式（NavDestinationMode 枚举），如果当前页面是 Navigation 组件则返回值为 undefined
       *         STANDARD - 标准模式的 NavDestination
       *         DIALOG- 对话框模式的 NavDestination
       *       param - 页面最初入栈时传递过来的数据
       *       navDestinationId - 当前 NavDestination 的标识（由系统自动生成）
       *     operation - 转场类型（NavigationOperation 枚举）
       *       PUSH	- 此次转场为页面进场
       *       POP - 此次转场为页面退场
       *       REPLACE - 此次转场为页面替换
       *     返回值是一个 NavigationAnimatedTransition 对象（用于控制转场动画），如果不需要动画则返回 undefined
       *       timeout - 动画时长
       *       isInteractive - 动画过程中是否可交互
       *       onTransitionEnd - 动画结束后的回调
       *       transition - 开始转场时的回调（回调参数是一个 NavigationTransitionProxy 对象）
       *         from, to - 退场页面的信息和进场页面的信息（一个 NavContentInfo 对象）
       *         isInteractive - 动画过程中是否可交互
       *
       * 注：customNavContentTransition() 是用于控制转场动画的，实际的动画逻辑需要在相关的页面中定义
       */
      Navigation(this.navPathStack) {
        Column({space:10}) {
          Button('pushPath').onClick(() => {
            this.navPathStack.pushPath({
              name: 'navigationDemo3_page1',
            })
          })
        }
      }
      .customNavContentTransition((from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
        CustomTransition.getInstance().operation = operation;
        let customAnimation: NavigationAnimatedTransition = {
          onTransitionEnd: (isSuccess: boolean) => {
            CustomTransition.getInstance().resetState();
            CustomTransition.getInstance().proxy = undefined;
          },
          transition: (transitionProxy: NavigationTransitionProxy) => {
            CustomTransition.getInstance().proxy = transitionProxy;
            let id: string | undefined = operation == NavigationOperation.PUSH ? (to.navDestinationId) : (from.navDestinationId);
            if (id) {
              // 启动转场动画（实际的动画逻辑是在相关的页面中定义的）
              CustomTransition.getInstance().animate(id, operation);
            }
          },
          timeout: 3000,
          isInteractive: true,
        }
        return customAnimation;
      })
    }
  }
}

// 页面的动画控制的相关信息
export interface MyAnimation {
  animateCallback: ((operation: NavigationOperation) => void | undefined) | undefined;
}

// 用于保存多个页面的不同的动画控制的相关信息
const customTransitionMap: Map<string, MyAnimation> = new Map();
export class CustomTransition {
  private static customTransition = new CustomTransition();
  static getInstance() {
    return CustomTransition.customTransition;
  }

  proxy: NavigationTransitionProxy | undefined = undefined;
  operation: NavigationOperation = NavigationOperation.PUSH

  // 为指定的页面注册一个动画控制的相关信息
  register(id: string, animateCallback: (operation: NavigationOperation) => void ): void {
    if (customTransitionMap.has(id)) {
      let myAnimation = customTransitionMap.get(id);
      if (myAnimation != undefined) {
        myAnimation.animateCallback = animateCallback;
        return;
      }
    }
    let params: MyAnimation = {
      animateCallback: animateCallback
    };
    customTransitionMap.set(id, params);
  }

  // 为指定的页面取消注册动画控制的相关信息
  unregister(id: string): void {
    customTransitionMap.delete(id);
  }

  // 启动指定页面的转场动画
  animate(id: string, operation: NavigationOperation) {
    let animateCallback = customTransitionMap.get(id)?.animateCallback;
    if (!animateCallback) {
      return;
    }
    animateCallback(operation);
  }

  // 更新指定页面的转场动画的进度
  updateProgress(progress: number) {
    if (!this.proxy?.updateTransition) {
      return;
    }
    progress = this.operation == NavigationOperation.PUSH ? 1 - progress : progress;
    this.proxy?.updateTransition(progress);
  }

  finishTransition() {
    this.proxy?.finishTransition();
  }

  cancelTransition() {
    if (this.proxy?.cancelTransition) {
      this.proxy.cancelTransition();
    }
  }

  resetState() {

  }
}