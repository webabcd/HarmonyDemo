import { router } from "@kit.ArkUI";

/*
 * @Entry() - 通过 routeName 指定命名路由的名称，其他包可以通过 router.pushNamedRoute() 导航至指定名称的页面
 */
@Entry({ routeName: "routeName1" })
@Component
export struct MyPage {
  @State message: string = 'hello routeName1\n';

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