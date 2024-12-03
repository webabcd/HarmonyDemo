/*
 * ExceptionPrompt - 异常提示框
 */

import { TitleBar } from '../../TitleBar';
import { ExceptionPrompt, MarginType } from '@kit.ArkUI'

@Entry
@Component
struct ExceptionPromptDemo {

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * ExceptionPrompt - 异常提示框
       *   icon - 图标
       *   tip - 左侧提示文本
       *   actionText - 右侧按钮文本
       *   marginTop - 异常提示框距顶部的距离
       *   isShown - 是否显示
       *   onTipClick - 点击异常提示框时的回调
       *   onActionTextClick - 点击右侧按钮时的回调
       */
      ExceptionPrompt({
        options: {
          marginType: MarginType.DEFAULT_MARGIN,
          icon: $r('sys.media.ohos_ic_public_fail'),
          tip: 'tip',
          actionText: 'button',
          marginTop: 100,
          isShown: true,
        },
        onTipClick: () => {
          this.message = "onTipClick()"
        },
        onActionTextClick: () => {
          this.message = "onActionTextClick()"
        },
      })
    }
  }
}