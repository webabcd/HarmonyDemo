import { LengthMetrics, router } from '@kit.ArkUI';

@Component
export struct TitleBar {

  private title: string = "";

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.title = params?.title || '';
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_arrow_left'))
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
      .margin({bottom: 10})
      .width('100%')
    }
  }
}

@Component
export struct RadioBar {
  @State valueList: string[] = [];
  @State selectedIndex: number = 0;

  groupName: string = 'radioGroup';

  onChange?: (selectedIndex: number) => void;

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { main: LengthMetrics.vp(10) } }) {
      ForEach(this.valueList, (item: string, index: number) => {
        Column() {
          Radio({ value: item, group: this.groupName })
            .checked(index == this.selectedIndex)
            .height(14)
            .width(14)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedIndex = index
                if (this.onChange) {
                  this.onChange(this.selectedIndex);
                }
              }
            })
          Text(item).fontSize(14)
        }
      })
    }
  }
}
