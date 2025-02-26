/*
 * 事件相关
 * onAppear/onDisAppear, onAreaChange/onSizeChange, onVisibleAreaChange, 自定义事件
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct DisplayDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('onAppear/onDisAppear').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('onAreaChange/onSizeChange').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('onVisibleAreaChange').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('自定义事件').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State flag: boolean = true

  build() {
    Column({space:10}) {

      Text(this.message)

      Button("挂载/卸载").onClick(() => {
        this.flag = !this.flag
      })

      /*
       * onAppear() - 挂载到组件树上时的回调
       * onDisAppear() - 从组件树上卸载时的回调
       */
      if (this.flag) {
        Text('Text')
          .onAppear(() => {
            this.message = "onAppear"
          })
          .onDisAppear(() => {
            this.message = "onDisAppear"
          })
      }
    }
  }
}

@Component
struct MySample2 {

  @State text: string = 'click me'
  @State message: string = ''
  @State message2: string = ''

  build() {
    Column({space:10}) {

      /*
       * onAreaChange() - 组件的区域（尺寸和位置）发生变化时的回调
       *   oldValue, newValue - 变化前和变化后，组件的尺寸和位置（Area 对象）
       *     width, height - 尺寸
       *     position - 区域的左上角相对于父容器的左上角的位置
       *     globalPosition - 区域的左上角相对于页面的左上角的位置
       * onSizeChange() - 组件的尺寸发生变化时的回调
       *   oldValue, newValue - 变化前和变化后，组件的尺寸（SizeOptions 对象）
       *     width, height - 尺寸
       */
      Text(this.text).backgroundColor(Color.Green).fontColor(Color.White).margin(20)
        .onClick(() => {
          this.text = this.text + 'x'
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.message = `width:${newValue.width}\n`
          this.message += `height: ${newValue.height}\n`
          this.message += `position x:${newValue.position.x}\n`
          this.message += `position y:${newValue.position.y}\n`
          this.message += `globalPosition x:${newValue.globalPosition.x}\n`
          this.message += `globalPosition y:${newValue.globalPosition.y}`
        })
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          this.message2 = `width:${newValue.width}\n`
          this.message2 += `height: ${newValue.height}`
        })

      Text(this.message)

      Text(this.message2)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ''

  build() {
    Column({space:10}) {

      /*
       * onVisibleAreaChange() - 组件的可见区域发生变化时的回调
       *   ratios - 用于判断是否需要回调的关键点集合（此处关键点的意思是，组件可见面积与组件全部面积的比值）
       *     比如 [0.0] 的意思是，当前组件从可见变为完全不可见时，或者从完全不可见变为有一点点可见时，就会回调
       *     比如 [0.2, 0.3] 的意思是，当组件的可见面积的百分比大于或小于 0.2 或 0.3 时，就会回调
       *   event - 回调参数
       *     isExpanding - 是否是因为大于关键点而触发的回调
       *     currentRatio - 组件的可见面积的百分比
       */
      Scroll() {
        Column() {
          Text('Text1').backgroundColor(Color.Red).fontColor(Color.White).margin(20).width(300).height(500)
            .onVisibleAreaChange([0.0], (isExpanding: boolean, currentRatio: number) => {
              this.message += `Text1 isExpanding:${isExpanding}, currentRatio:${currentRatio}\n`
            })

          Text('Text2').backgroundColor(Color.Green).fontColor(Color.White).margin(20).width(300).height(500)
            .onVisibleAreaChange([0.0], (isExpanding: boolean, currentRatio: number) => {
              this.message += `Text2 isExpanding:${isExpanding}, currentRatio:${currentRatio}\n`
            })

          Text('Text3').backgroundColor(Color.Blue).fontColor(Color.White).margin(20).width(300).height(500)
            .onVisibleAreaChange([0.2, 0.3], (isExpanding: boolean, currentRatio: number) => {
              this.message += `Text3 isExpanding:${isExpanding}, currentRatio:${currentRatio}\n`
            })
        }
      }
      .height(200)

      Text(this.message)
    }
  }
}

@Component
struct MyComponent {
  @State title: string = "";

  // 定义自定义事件
  onOk?: () => void;
  onError?: (reason: string) => void;

  build() {
    Column({space:10}) {
      Text(this.title)
      Button("ok").onClick(() => {
        this.onOk?.()
      })
      Button("error").onClick(() => {
        this.onError?.("error")
      })
    }
  }
}
@Component
struct MySample4 {

  @State message: string = ''

  build() {
    Column({space:10}) {

      MyComponent({
        title: "title",
        // 使用自定义事件
        onOk: () => {
          this.message = "onOk"
        },
        onError: (reason:string) => {
          this.message = `onError: ${reason}`
        }
      })
      Text(this.message)
    }
  }
}