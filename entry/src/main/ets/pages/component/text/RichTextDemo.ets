/*
 * RichText - html 文本（底层用的是 web 组件显示的，资源占用较高，为了避免资源占用推荐使用 RichEditor 组件）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct RichTextDemo {

  @State message:string = ""

  html: string =
    // '<meta name="viewport" content="width=device-width">' +
    '<meta name="viewport" content="width=200">' +
    '<h1 style="text-align: center;">h1 标题</h1>' +
    '<div style="font-size: 24px;text-align: center;">我是 div</div>';

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(24)

      /*
       * RichText - html 文本（底层用的是 web 组件显示的，资源占用较高）
       *   onStart - 网页加载开始时
       *   onComplete - 网页加载结束时
       */
      RichText(this.html)
        .onStart(() => {
          this.message += "RichText onStart\n"
        })
        .onComplete(() => {
          this.message += "RichText onComplete\n"
        })
        .width(400)
        .height(300)
        .backgroundColor(Color.Orange)
    }
  }
}