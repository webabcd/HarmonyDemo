@Entry({ routeName: "myRouteName2" })
@Component
export struct MyPage {
  @State message: string = 'hello routeName2';

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