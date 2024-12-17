/*
 * SwipeRefresher - 加载框
 */

import { TitleBar } from '../../TitleBar';
import { SwipeRefresher } from '@kit.ArkUI';

@Entry
@Component
struct SwipeRefresherDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * SwipeRefresher - 加载框
       *   content - 文本内容
       *   isLoading - 是否显示加载框动画
       */

      SwipeRefresher({
        content: 'loading',
        isLoading: true
      })

      SwipeRefresher({
        content: '',
        isLoading: true
      })

      SwipeRefresher({
        content: 'loading',
        isLoading: false
      })
    }
  }
}