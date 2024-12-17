/*
 * 在描述 UI 时使用 if/else, ForEach, LazyForEach, Repeat 语句
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
      // ForEach() 的详细应用，请详见 /component/list/ListDemo5.ets 中的说明
      ForEach(this.list, (item: string) => {
        Text(item)
      })
      ForEach(this.list, (item: string, index: number) => {
        Text(`${index} ${item}`)
      })

      // UI 描述中支持 LazyForEach 语句，要求数据必须来自一个 IDataSource 对象，且仅在 List, Grid, Swiper, WaterFlow 中有效
      // LazyForEach() 的详细应用，请详见 /component/list/ListDemo6.ets 中的说明
      // LazyForEach()

      // UI 描述中支持 Repeat 语句
      // Repeat() 的详细应用，请详见 /component/list/ListDemo7.ets 中的说明
      Repeat<string>(this.list)
        .each((obj: RepeatItem<string>) => {
          Text(`${obj.index} ${obj.item}`)
        })

    }.width('100%').height('100%')
  }
}