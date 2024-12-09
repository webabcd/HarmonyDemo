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
      // ForEach() 的第 3 个参数用于 List 的 ListItem 的拖动排序，详见 /component/list/ListDemo3.ets 中的说明
      // ForEach() 的性能优化的应用，详见 /component/list/ListDemo4.ets 中的说明
      ForEach(this.list, (item: string) => {
        Text(item)
      })
      ForEach(this.list, (item: string, index: number) => {
        Text(`${index} ${item}`)
      })

    }.width('100%').height('100%')
  }
}