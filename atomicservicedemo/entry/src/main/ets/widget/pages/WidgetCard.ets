/*
 * 本例用于演示元服务的卡片
 */

@Entry
@Component
struct WidgetCard {

  build() {
    Column() {
      Text("click me")
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility',
      });
    })
  }
}