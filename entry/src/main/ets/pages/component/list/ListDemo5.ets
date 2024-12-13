/*
 * List - ForEach 的应用
 */

import { MyLog, TitleBar } from '../../TitleBar';

@Entry
@Component
struct ListDemo5 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('排序').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('性能优化').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      List({ space: 20, initialIndex: 0 }) {
        /*
         * List - ForEach 的应用
         * 本例用于演示，如何通过 ForEach 的方式实现 ListItem 的拖动排序
         * 另外，如果需要更多的拖动排序效果，可以通过自定义的方式实现 ListItem 的拖动排序，详见 /component/list/ListDemo3.ets 中的说明
         *
         * ForEach() 的 onMove() 用于启用 List 的 ListItem 的拖动操作
         *   也就是说，调用 ForEach() 的 onMove() 后，ListItem 就会支持拖动操作
         *   onMove() - List 内的 ForEach() 内的 ListItem 的拖动操作后的回调，可以在此处写具体的数据排序逻辑
         *     from - 拖动中的 item 的起始索引位置
         *     to - 拖动中的 item 的目标索引位置
         */
        ForEach(this.array, (item: number, index: number) => {
          ListItem() {
            Text(item.toString()).height(100).width('100%')
              .fontSize(48).fontColor(Color.White).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).borderRadius(20)
          }
          .margin({ left: 20, right: 20 })
        })
          .onMove((from:number, to:number) => {
            // 根据用户的操作排序数据
            let tmp = this.array.splice(from, 1);
            this.array.splice(to, 0, tmp[0])
          })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample2 {

  @State array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {

        /*
         * List - ForEach 的应用
         * 本例用于演示，如何通过 ForEach() 的第 3 个参数做性能优化
         *
         * ForEach() 的第 3 个参数用于生成 item 的键值
         * 每个 item 在渲染时
         * 1、内存中没有对应的键值的 item，则会新建 item 后渲染
         * 2、内存中有对应的键值的 item，且之前未被渲染，则直接渲染这个 item
         * 3、内存中有对应的键值的 item，且之前已被渲染，则不再做任何渲染
         */

        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            MyItem({
              type: 'keyGenerator1',
              item: `${item}`
            })
          },
            /*
             * 这个是 ForEach() 的第 3 个参数的生成键值的默认逻辑（即不指定第 3 个参数时的默认逻辑）
             * 根据打印的日志理解
             * 点击本例的按钮，在位置 0 处添加一项，会导致所有 item 的键值都发生变化
             *
             * 所以，开发时要注意，如果默认的键值生成逻辑会导致相同的 item 在某些情况下生成不同的键值，
             * 那么就应该通过自定义键值生成逻辑做优化，一般来说用每个 item 的唯一标识做键值会比较好
             */
            (item: object, index: number) => {
              return index + '__' + JSON.stringify(item);
            })
        }
        .backgroundColor(Color.Red)
        .layoutWeight(1)

        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            MyItem({
              type: 'keyGenerator2',
              item: `${item}`
            })
          },
            /*
             * 自定义 ForEach() 的键值生成逻辑
             * 根据打印的日志理解
             * 点击本例的按钮，在位置 0 处添加一项，不会导致其他 item 的键值发生变化
             *
             * 所以，开发时要注意，如果默认的键值生成逻辑会导致相同的 item 在某些情况下生成不同的键值，
             * 那么就应该通过自定义键值生成逻辑做优化，一般来说用每个 item 的唯一标识做键值会比较好
             */
            (item: number) => item.toString())
        }
        .backgroundColor(Color.Green)
        .layoutWeight(1)

        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            MyItem({
              type: 'keyGenerator3',
              item: `${item}`
            })
          },
            /*
             * 自定义 ForEach() 的键值生成逻辑
             * 根据打印的日志理解
             * 本例的 List 永远都只会渲染 5 个 item 且每个 item 的显示内容不变
             * 即使点击本例的按钮，在位置 0 处添加一项后，也只会渲染 5 个 item 且每个 item 的显示内容不变（item 的顺序可能会有变化）
             *
             * 开发时要注意这个问题
             */
            (item: number) => {
              return (item % 5).toString()
            })
        }
        .backgroundColor(Color.Blue)
        .layoutWeight(1)
      }

      Button('在位置 0 处添加一项')
        .onClick(() => {
          this.array.unshift(Math.floor(Math.random() * 1000))
        })
    }
  }
}

@Component
struct MyItem {
  type: string = ""
  item: string = "";

  aboutToAppear() {
    // 每次 item 创建都会打印这个日志，可以通过此日志理解 ForEach() 的第 3 个参数的意义
    MyLog.d(`${this.type} item:${this.item}`)
  }

  build() {
    ListItem() {
      Text(this.item).width('100%')
        .fontSize(24).textAlign(TextAlign.Center)
        .backgroundColor(Color.Orange).borderRadius(20)
        .height(50)
    }
    .margin({ left: 20, right: 20 })
  }
}