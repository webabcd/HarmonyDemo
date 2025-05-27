import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {

  build() {
    Column({space:10}) {
      Text('huawei account')

      Button("华为账号的默认登录").onClick(() => {
        router.pushUrl({url:"pages/HuaweiDefaultLogin"})
      })
    }
    .height('100%')
    .width('100%')
  }
}