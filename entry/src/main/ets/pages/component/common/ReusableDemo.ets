/*
 * @Reusable - 组件复用
 *
 * 组件复用的意思是，当组件从组件树上被移除时，不会销毁而是被放入到复用缓存中
 * 后续再用到这个组件的时候，就会从复用缓存中获取
 *
 * 注：@ComponentV2 不支持 @Reusable
 */

import { MyLog, TitleBar } from '../../TitleBar';


@Entry
@Component
struct ReusableDemo {

  @State flag: boolean = false

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button('click me')
        .onClick(() => {
          this.flag = !this.flag
        })

      if (this.flag) {
        // MyComponent1 没有用 @Reusable 装饰
        // 在不停地显示和隐藏 MyComponent1 的过程中，会循环走到 aboutToAppear, onAppear, onDisAppear, aboutToDisappear
        // 说明此组件没有被复用
        MyComponent1()

        // MyComponent2 用 @Reusable 装饰了
        // 在第一次显示和隐藏 MyComponent2 的过程中，会走到 aboutToAppear, onAppear, onDisAppear
        // 然后在后续的不停地显示和隐藏 MyComponent2 的过程中，会循环走到 aboutToReuse, onAppear, onDisAppear
        // 说明此组件被复用了
        MyComponent2({
          r: Math.floor(Math.random() * 1000)
        })
      }
    }
  }
}

@Component
struct MyComponent1 {
  aboutToAppear() {
    MyLog.d(`1 aboutToAppear`)
  }
  aboutToDisappear(): void {
    MyLog.d(`1 aboutToDisappear`)
  }
  build() {
    Column() { }.width(100).height(100).backgroundColor(Color.Orange)
    .onAppear(() => {
      // 挂载到组件树上时
      MyLog.d(`1 onAppear`)
    })
    .onDisAppear(() => {
      // 从组件树上卸载时
      MyLog.d(`1 onDisAppear`)
    })
  }
}

@Reusable
@Component
struct MyComponent2 {
  @State r:number = 0
  aboutToAppear() {
    MyLog.d(`2 aboutToAppear`)
  }
  aboutToDisappear(): void {
    MyLog.d(`2 aboutToDisappear`)
  }
  // 通过 @Reusable 装饰的组件，复用时会走到 aboutToReuse() 方法
  // 如下例：
  // this.r 获取到的是，组件被放入到缓存之前时 r 参数的值
  // params.r 获取到的是，组件复用时，外部传递过来的 r 参数的值
  aboutToReuse(params: Record<string, ESObject>) {
    MyLog.d(`2 aboutToReuse this.r:${this.r}, params.r:${params.r as number}`)
    // 根据组件复用时，外部传递过来的 r 参数的值更新 this.r 的值
    this.r = params.r as number
  }
  build() {
    Column() { }.width(100).height(100).backgroundColor(Color.Orange)
    .onAppear(() => {
      // 挂载到组件树上时
      MyLog.d(`2 onAppear`)
    })
    .onDisAppear(() => {
      // 从组件树上卸载时
      MyLog.d(`2 onDisAppear`)
    })
  }
}