import { router } from '@kit.ArkUI';

export * from '../utils/MyLog';

@Component
export struct TitleBar {

  private title: string = "";

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.title = params.title || '';
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(20)
          .height(20)
          .margin({ left: 26 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Text(this.title)
          .fontSize(20)
          .layoutWeight(1)
          .margin({ left: 16 })
          .align(Alignment.Start)
        Blank()
      }
      .height(56)
      .width('100%')
    }
  }
}