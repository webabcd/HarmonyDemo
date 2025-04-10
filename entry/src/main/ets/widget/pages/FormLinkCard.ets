/*
 * FormLink - 为静态卡片提供与应用交互的能力
 */

import { Helper } from '../../utils/Helper'

@Entry
@Component
struct FormLinkCard {

  @LocalStorageProp('content') content: string = ''

  build() {
    Column() {
      FormLink({
        action: 'router',
        bundleName: 'com.webabcd.harmonydemo',
        moduleName: 'entry',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility',
        params: {
          'k1': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column().backgroundColor(Color.Red).width('100%').height('100%')
      }
      .width('100%').layoutWeight(1)

      FormLink({
        action: 'router',
        uri: "webabcd://a.b.c/api?p1=xyz",
        params: {
          'k1': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column().backgroundColor(Color.Green).width('100%').height('100%')
      }
      .width('100%').layoutWeight(1)

      FormLink({
        action: 'message',
        params: {
          'message': 'messageEvent'
        }
      }) {
        Column() {
          Text(this.content).fontColor(Color.White)
        }.backgroundColor(Color.Blue).width('100%').height('100%').justifyContent(FlexAlign.Center)
      }
      .width('100%').layoutWeight(1)

      FormLink({
        action: 'call',
        abilityName: 'com.webabcd.harmonydemo.EntryAbility',
        params: {
          'method': 'v1',
          'k2': `${Helper.getTimestampString()}`,
        }
      }) {
        Column().backgroundColor(Color.Orange).width('100%').height('100%')
      }
      .width('100%').layoutWeight(1)
    }
    .width('100%')
  }
}