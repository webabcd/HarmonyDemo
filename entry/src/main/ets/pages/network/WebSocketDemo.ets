/*
 * ohpm install @ohos/crypto-js
 */

import { MyLog, TitleBar } from '../TitleBar'

import { socket } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { webview } from '@kit.ArkWeb'
import { buffer, util } from '@kit.ArkTS'
import { CryptoJS } from '@ohos/crypto-js'

@Entry
@Component
struct WebSocketDemo {



  build() {
    Column({space:10}) {
      TitleBar()


    }
  }
}
