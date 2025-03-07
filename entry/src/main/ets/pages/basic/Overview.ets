/*
 * 基础知识
 * 参见 /readme.txt 中的相关说明
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct Overview {
  build() {
    Column({ space: 10 }) {
      TitleBar()
      Text('参见 /readme.txt 中的相关说明')
    }
  }
}