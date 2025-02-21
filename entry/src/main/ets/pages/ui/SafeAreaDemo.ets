/*
 * 安全区域
 * 对于全面屏来说，非安全区域指的是顶部的摄像头区域和底部的导航条区域，默认不会在非安全区域显示自定义内容
 * 沉浸式效果，就是扩展安全区域，以便在非安全区域显示自定义内容
 *
 * expandSafeArea() - 扩展当前组件的安全区域
 *   types - 用于指定什么情况下需要扩展安全区域
 *     没有特殊要求的话，就设置为 [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD] 即可
 *   edges - 用于指定安全区域扩展的方向
 *     如果四周都需要扩展的话，就设置为 [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END] 即可
 */

import { RadioBar, TitleBar } from '../TitleBar'
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct SafeAreaDemo {

  @State message: string = ''
  @State demonIndex: number = 0
  array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  @State topUnsafeAreaRect: window.Rect = { left: 0, top: 0, width: 0, height: 0 }
  @State cutoutRect: window.Rect = { left: 0, top: 0, width: 0, height: 0 }
  @State navigationIndicatorRect: window.Rect = { left: 0, top: 0, width: 0, height: 0 }

  onPageShow() {
    let context = getContext(this) as common.UIAbilityContext;
    let windowStage = context.windowStage;
    let windowClass = windowStage.getMainWindowSync();

    // 全面屏，顶部的非安全区域的大小和位置
    this.topUnsafeAreaRect = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect
    // 挖孔屏，顶部的摄像头区域的大小和位置
    this.cutoutRect = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT).topRect
    // 全面屏，底部的导航条区域的大小和位置
    this.navigationIndicatorRect = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect

    this.message = `TYPE_SYSTEM: ${JSON.stringify(this.topUnsafeAreaRect)}\n`
    this.message += `TYPE_CUTOUT: ${JSON.stringify(this.cutoutRect)}\n`
    this.message += `TYPE_NAVIGATION_INDICATOR: ${JSON.stringify(this.navigationIndicatorRect)}`
  }

  @Builder myComponent() {
    Column({space:10}) {
      Text(this.message)
      RadioBar({valueList: ["一般组件的沉浸式效果", "滚动组件的沉浸式效果", "无沉浸式效果"], selectedIndex: this.demonIndex, onChange: (selectedIndex: number) => {
        this.demonIndex = selectedIndex
      }})
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder demo1() {
    // Stack 的安全区域扩展到四周了，但只是背景色之类的会扩展到原来的非安全区域
    // Stack 内的组件并不会显示到原来的非安全区域，如果需要在非安全区域显示则可以通过 offset() 之类的实现
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        TitleBar()
        this.myComponent()
      }

      Column().borderWidth(5).borderColor(Color.Red)
        .width(`${this.topUnsafeAreaRect.width}px`)
        .height(`${this.topUnsafeAreaRect.height}px`)
        .offset({
          y: `${-this.topUnsafeAreaRect.height}px`
        })

      Column().borderWidth(5).borderColor(Color.Green)
        .width(`${this.cutoutRect.width}px`)
        .height(`${this.cutoutRect.height}px`)
        .offset({
          x: `${this.cutoutRect.left}px`,
          y: `${this.cutoutRect.top - this.topUnsafeAreaRect.height}px`
        })

      Column().borderWidth(5).borderColor(Color.Blue)
        .width(`${this.navigationIndicatorRect.width}px`)
        .height(`${this.navigationIndicatorRect.height}px`)
        .offset({
          x: `${this.navigationIndicatorRect.left}px`,
          y: `${this.navigationIndicatorRect.top - this.topUnsafeAreaRect.height}px`
        })
    }
    .height('100%').width('100%').backgroundColor(Color.Orange)
    .expandSafeArea(
      [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD],
      [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END]
    )
  }

  @Builder demo2() {
    // Stack 的安全区域扩展到四周了
    // Stack 内的 List 的安全区域也扩展到四周了（如果可滚动组件的安全区域扩展到四周，则可滚动组件中的内容可以显示到原来的非安全区域）
    Stack({ alignContent: Alignment.TopStart }) {
      List({ space: 20, }) {
        ForEach(this.array, (item: string) => {
          ListItem() {
            Text(item).width('100%').height(100).fontSize(48)
              .textAlign(TextAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin({ left: 20, right: 20 })
        }, (item: string) => item)
      }
      .width('100%')
      .height('100%')
      .expandSafeArea(
        [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD],
        [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END]
      )

      Column() {
        TitleBar()
        this.myComponent()
      }
    }
    .backgroundColor(Color.Yellow)
    .expandSafeArea(
      [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD],
      [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END]
    )
  }

  @Builder demo3() {
    Stack({ alignContent: Alignment.TopStart }) {
      List({ space: 20, }) {
        ForEach(this.array, (item: string) => {
          ListItem() {
            Text(item).width('100%').height(100).fontSize(48)
              .textAlign(TextAlign.Center).backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin({ left: 20, right: 20 })
        }, (item: string) => item)
      }
      .width('100%')
      .height('100%')

      Column() {
        TitleBar()
        this.myComponent()
      }
    }
    .backgroundColor(Color.Yellow)
  }

  build() {
    if (this.demonIndex == 0) {
      this.demo1()
    } else if (this.demonIndex == 1) {
      this.demo2()
    } else if (this.demonIndex == 2) {
      this.demo3()
    } else {

    }
  }
}
