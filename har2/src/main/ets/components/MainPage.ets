@Component
export struct MainPage {

  // 组件参数，在调用此组件的时候可以对其初始化
  param1: string = ""

  @State message: string = 'hello har2\n';

  aboutToAppear(): void {
    this.message += `param1: ${this.param1}`
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}