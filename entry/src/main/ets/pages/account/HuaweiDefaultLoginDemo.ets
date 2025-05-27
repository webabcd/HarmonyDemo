/*
 * 华为账号的默认登录
 *
 * 关于示例代码，请参见 /HarmonyDemo/huaweilogindemo 目录中的 /huaweilogindemo/entry/src/main/ets/HuaweiDefaultLogin.ets
 * 关于配置与证书之类的说明，请参见 /entry/src/main/ets/pages/account/readme.txt
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct HuaweiDefaultLoginDemo {

  @State message: string = "请参见 /HarmonyDemo/huaweilogindemo 目录中的 /huaweilogindemo/entry/src/main/ets/HuaweiDefaultLogin.ets 中的示例"

  build() {
    Column({space:10}) {
      TitleBar()
      Text(this.message)
    }
  }
}