/*
 * Counter - 计数器框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct CounterDemo {

  @State value: number = 0

  @State index: number = 0
  @State list: string[] = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * Counter - 计数器框（指定一个子组件，用于显示当前值）
       *   enableInc() - 增加按钮是否可用
       *   enableDec() - 减少按钮是否可用
       *   onInc() - 增加按钮点击后的回调
       *   onDec() - 减少按钮点击后的回调
       */

      Counter() {
        Text(this.value.toString())
      }
      .enableInc(true)
      .enableDec(true)
      .onInc(() => {
        this.value++
      })
      .onDec(() => {
        this.value--
      })

      Counter() {
        Text(this.list[this.index])
      }
      .onInc(() => {
        this.index++
        if (this.index > 25) {
          this.index = 0
        }
      })
      .onDec(() => {
        this.index--
        if (this.index < 0) {
          this.index = 25
        }
      })
    }
  }
}