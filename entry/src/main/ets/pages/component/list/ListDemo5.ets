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
        TabContent() { MySample1() }.tabBar('拖动排序').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('性能优化').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('大量数据').align(Alignment.Top)
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
         * ForEach() 的 onMove() 用于启用 List 的 ListItem 的拖动排序
         *   也就是说，调用 ForEach() 的 onMove() 后，ListItem 就会支持拖动排序
         *   onMove() - List 内的 ForEach() 内的 ListItem 的拖动排序后的回调，可以在此处写具体的数据排序逻辑
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
            // 注：这里的代码仅用于更新数据源，而界面上的排序是由框架的 ForEach() 的 onMove() 自己实现的（也就是说即使没有下面的代码，也不影响界面上的排序）
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
struct MyItem {
  type: string = ""
  item: string = "";

  aboutToAppear() {
    // 每次 item 创建都会打印这个日志，可以通过此日志理解 ForEach() 的第 3 个参数的意义
    MyLog.d(`${this.type} aboutToAppear:${this.item}`)
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
         * 开始时，ForEach() 中的每个 item 都会被挂载到组件树上，即每个 item 都会走到 onAppear()
         * 然后每个 item 在渲染时会遵循如下规则
         * 1、内存中没有对应的键值的 item，则会新建 item 后渲染
         * 注：新建 item 时会走到组件的 aboutToAppear()，然后这个 item 就会以其键值为标识被保存到内存中
         * 2、内存中有对应的键值的 item，且之前未被渲染，则直接渲染这个 item
         * 3、内存中有对应的键值的 item，且之前已被渲染，则不再做任何渲染
         */

        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            MyItem({ type: 'keyGenerator1', item: `${item}`
            })
          },
            /*
             * 这个是 ForEach() 的第 3 个参数的生成键值的默认逻辑（即不指定第 3 个参数时的默认逻辑）
             * 根据打印的日志理解
             * 点击本例的按钮，在位置 0 处添加一项，会导致所有 item 的键值都发生变化
             *
             * 所以，实际开发时建议用每个 item 的唯一标识做键值
             */
            (item: object, index: number) => {
              return index + '__' + JSON.stringify(item);
            })
        }
        .backgroundColor(Color.Red)
        .layoutWeight(1)

        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            MyItem({ type: 'keyGenerator2', item: `${item}` })
          },
            /*
             * 自定义 ForEach() 的键值生成逻辑
             * 根据打印的日志理解
             * 点击本例的按钮，在位置 0 处添加一项，不会导致其他 item 的键值发生变化
             *
             * 所以，实际开发时建议用每个 item 的唯一标识做键值
             */
            (item: number) => item.toString())
        }
        .backgroundColor(Color.Green)
        .layoutWeight(1)

        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            MyItem({ type: 'keyGenerator3', item: `${item}` })
          },
            /*
             * 自定义 ForEach() 的键值生成逻辑
             * 根据打印的日志理解
             * 本例的 List 永远都只会渲染 5 个 item 且每个 item 的显示内容不变
             * 即使点击本例的按钮，在位置 0 处添加一项后，也只会渲染 5 个 item 且每个 item 的显示内容不变（item 的顺序可能会有变化）
             * 开发时要注意这个问题
             *
             * 所以，实际开发时建议用每个 item 的唯一标识做键值
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
struct MySample3 {

  @State array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {

        /*
         * List - ForEach 的应用
         * 测试本例会发现，开始时每个 item 都会被挂载到组件树上，即每个 item 都会走到 onAppear()
         * 当显示大量数据时会占用较多的资源
         * 如果想要 ListItem 根据 List 的滚动位置，按需 onAppear() 和 onDisAppear() 则可以使用 LazyForEach（请参见 ListDemo6.ets 中的说明）
         */

        List({ space: 20 }) {
          ForEach(this.array, (item: string, index: number) => {
            ListItem() {
              MyItem({ type: 'xxx', item: `${item}` })
            }
            .margin({ left: 20, right: 20 })
            .onAppear(() => {
              // item 挂载到组件树上时
              MyLog.d(`onAppear:${index}`)
            })
            .onDisAppear(() => {
              // item 从组件树上卸载时
              MyLog.d(`onDisAppear:${index}`)
            })
          }, (item: string) => item)
        }
        .backgroundColor(Color.Yellow)
      }
    }
  }
}