/*
 * NavDestination - 导航组件（Navigation）导航到的目标页
 */

import { CustomTransition } from '../NavigationDemo3';

@Builder function navigationDemo3_page1_builder(name: string, param: Object) {
  NavigationDemo3_Page1()
}

@Component
struct NavigationDemo3_Page1 {

  navPathStack: NavPathStack = new NavPathStack()

  @State navDestinationId: string = ""
  @State translateX: string = '0';

  build() {

    NavDestination() {
      Column({space:10}) {

        Text(`navDestinationId:${this.navDestinationId}`)

        Button('pushPath').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo3_page1',
          })
        })
      }
    }
    .title('NavigationDemo3_Page1')
    .onReady((context: NavDestinationContext) => {
      this.navPathStack = context.pathStack
      this.navDestinationId = context.navDestinationId ?? ""

      CustomTransition.getInstance().register(this.navDestinationId, (operation: NavigationOperation) => {
        if (operation == NavigationOperation.PUSH) { // 入栈动画
          this.translateX = '100%';
          animateTo({
            duration: 3000,
            onFinish: () => {
              this.translateX = '0';
            }
          }, () => {
            this.translateX = '0';
          })
        } else if (operation == NavigationOperation.POP) { // 出栈动画
          this.translateX = '0';
          animateTo({
            duration: 3000,
            onFinish: () => {
              this.translateX = '0';
            }
          }, () => {
            this.translateX = '100%';
          })
        }
      });
    })
    .onDisAppear(() => {
      CustomTransition.getInstance().unregister(this.navDestinationId);
    })
    .translate({ x: this.translateX })
    .backgroundColor(Math.floor(Math.random() * (0xffffff + 1)))
  }
}