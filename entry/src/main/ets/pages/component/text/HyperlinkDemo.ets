/*
 * Hyperlink - 超链接
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct HyperlinkDemo {
  build() {
    Column({ space: 30 }) {
      TitleBar()

      /*
       * Hyperlink() - 超链接（可以声明一个 Image 类型的子组件）
       *   address - 超链接地址
       *   content - 显示的文本（当 Hyperlink 有子组件时则不会显示此文本）
       *   color() - 颜色
       */

      Hyperlink('https://www.cnblogs.com/webabcd') {
        Image($r('app.media.son'))
          .width(200)
          .height(200)
      }

      Hyperlink('https://www.cnblogs.com/webabcd', 'click me').color(Color.Orange)
    }
  }
}