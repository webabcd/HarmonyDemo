/*
 * 在描述 UI 时使用 if/else, ForEach 语句
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct StatementDemo {

  @State
  flag:number = 0

  list: Array<string> = ['one', 'two', 'three'];

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // UI 描述中支持 if/else 语句
      if (this.flag == 0) {
        Text("flag == 0")
      } else if (this.flag == 1) {
        Text("flag == 1")
      }
      Button("button")
        .onClick(() => {
          this.flag = this.flag == 0 ? 1 : 0;
        })

      // UI 描述中支持 ForEach 语句
      ForEach(this.list, (item: string) => {
        Text(item)
      })
      ForEach(this.list, (item: string, index: number) => {
        Text(`${index} ${item}`)
      })

    }.width('100%').height('100%')
  }
}