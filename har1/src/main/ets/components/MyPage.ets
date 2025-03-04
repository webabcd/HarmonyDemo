@Entry({ routeName: "myRouteName1" })
@Component
export struct MyPage {
  @State message: string = 'hello routeName1';

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