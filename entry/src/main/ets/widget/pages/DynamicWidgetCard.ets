/*
 * 卡片的具体实现（本例演示的是动态卡片）
 *
 * 静态卡片仅支持 UI 组件布局
 * 动态卡片除了支持 UI 组件布局外，还支持组件的通用事件方法以及自定义动画效果，可以用于需要交互的场景
 */

@Entry
@Component
struct DynamicWidgetCard {

  @LocalStorageProp('content') content: string = ''

  @State rotateAngle: number = 0

  build() {
    Column() {
      // 动态卡片在静态卡片的基础上增加了对组件的通用事件方法以及自定义动画效果的支持
      Button(`click me ${this.content}`)
        .onClick(() => {
          this.rotateAngle = this.rotateAngle === 0 ? 360 : 0
        })
        .rotate({ angle: this.rotateAngle })
        .animation({ playMode: PlayMode.Normal} )
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}