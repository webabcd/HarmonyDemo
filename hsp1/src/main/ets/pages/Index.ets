import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'hello hsp1\n';

  aboutToAppear(): void {
    /*
     * router.getParams() - 获取 router 传递过来的数据
     */
    const params = router.getParams() as Record<string, string>
    this.message += `param1: ${params.param1}`
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