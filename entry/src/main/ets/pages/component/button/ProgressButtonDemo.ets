/*
 * ProgressButton - 可显示下载进度的下载按钮
 */

import { TitleBar } from '../../TitleBar';
import { ProgressButton } from '@kit.ArkUI';

@Entry
@Component
struct ProgressButtonDemo {

  @State myProgress: number = 0
  @State myText: string = '开始下载'
  @State isRunning: boolean = false

  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * ProgressButton - 可显示下载进度的下载按钮
       *   progress - 进度值（0 - 100 之间）
       *   content - 按钮内显示的文本内容
       *   enable - 是否可用
       *   progressButtonWidth - 按钮的宽度
       *   clickCallback() - 按钮的点击回调
       */
      ProgressButton({
        progress: this.myProgress,
        content: this.myText,
        enable: true,
        progressButtonWidth: "100",
        clickCallback: () => {
          this.isRunning = !this.isRunning
          if (!this.isRunning && this.myProgress < 100) {
            this.myText = '继续下载'
          }
          let timer = setInterval(() => {
            if (this.isRunning) {
              if (this.myProgress == 100) {
                this.myText = '下载完成'
              } else {
                this.myProgress++
              }
            } else {
              clearInterval(timer)
            }
          }, 100)
        }
      })
    }
  }
}