/*
 * List - Repeat 的应用
 *
 * Repeat 支持组件的复用
 */

import { MyLog, TitleBar } from '../../TitleBar';

@Entry
@Component
struct ListDemo7 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('进阶').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@ComponentV2
struct MyItem1 {
  @Param @Require type: string;
  @Param @Require item: string;

  aboutToAppear() {
    MyLog.d(`${this.type} aboutToAppear:${this.item}`)
  }

  aboutToDisappear(): void {
    MyLog.d(`${this.type} aboutToDisappear:${this.item}`)
  }

  build() {
    Text(this.item).width('100%')
      .fontSize(24).textAlign(TextAlign.Center)
      .backgroundColor(Color.Orange).borderRadius(20)
      .height(50)
      .onAppear(() => {
        // item 挂载到组件树上时
        MyLog.d(`${this.type} onAppear:${this.item}`)
      })
      .onDisAppear(() => {
        // item 从组件树上卸载时
        MyLog.d(`${this.type} onDisAppear:${this.item}`)
      })
  }
}
@ComponentV2
struct MySample1 {
  @Local array: string[] = ['0', '1', '2']

  build() {
    Column({space:10}) {
      Button('click me')
        .onClick(() => {
          this.array[2] = '999';
        })

      /*
       * Repeat - 支持组件的复用
       *   each() - 遍历数据
       *     obj - 封装好的遍历出来的数据（一个 RepeatItem 对象）
       *       item - 数据
       *       index - 索引位置
       *   key() -  用于生成 item 的键值，其作用请参见 ListDemo5.ets 中的说明
       *
       * 点击上面的按钮更新数组中位置 2 的数据，然后从下面的 Repeat 和 ForEach 的对比示例中，可以发现
       *   Repeat 中的位置 2 的 item 会被复用
       *   ForEach 中的位置 2 的 item 不会被复用（这个 item 会走一遍 onDisAppear, aboutToDisappear, aboutToAppear, onAppear）
       */
      Repeat<string>(this.array)
        .each((obj: RepeatItem<string>) => {
          // obj.item - 当前遍历出的数据
          // obj.index - 当前遍历出的数据的索引位置
          MyItem1({
            type: 'Repeat',
            item:`${obj.item}`
          })
        })
        .key((item: string) => item)

      ForEach(this.array, (item: string, index: number) => {
        MyItem1({
          type: 'ForEach',
          item:`${item}`
        })
      }, (item: string) => item)
    }
  }
}

@ComponentV2
struct MyItem2 {
  @Param @Require item: string;

  aboutToAppear() {
    MyLog.d(`aboutToAppear:${this.item}`)
  }

  aboutToDisappear(): void {
    MyLog.d(`aboutToDisappear:${this.item}`)
  }

  build() {
    Text(this.item).width('100%').fontColor(Color.White)
      .fontSize(48).textAlign(TextAlign.Center)
      .borderRadius(20)
      .height(200)
      .onAppear(() => {
        // item 挂载到组件树上时
        MyLog.d(`onAppear:${this.item}`)
      })
      .onDisAppear(() => {
        // item 从组件树上卸载时
        MyLog.d(`onDisAppear:${this.item}`)
      })
  }
}

@ComponentV2
struct MySample2 {

  @Local array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column() {
      List({space:10}) {
        /*
         * Repeat - 支持组件的复用
         *   each() - 遍历数据
         *     obj - 封装好的遍历出来的数据（一个 RepeatItem 对象）
         *       item - 数据
         *       index - 索引位置
         *   key() -  用于生成 item 的键值，其作用请参见 ListDemo5.ets 中的说明
         *   virtualScroll() - 滚动场景时的规则（仅在 List, Grid, Swiper, WaterFlow 中有效）
         *     totalCount - 数据源总长度
         *       当 totalCount 与数据源总长度一致时，一切正常，这是默认值
         *       当 totalCount 小于数据源总长度时，则最多只能滚动到 totalCount 的位置，如果后续需要加载更多就自己再写相关代码
         *       当 totalCount 大于数据源总长度时，则最多能滚动到的位置会依据数据源总长度，但是滚动条的位置会依据 totalCount
         *   templateId() - 为不同的 item 指定不同的模板 id
         *   template() - 为指定的模板 id 构造指定的组件
         *     cachedCount - 当前模板在 Repeat 的缓存池中可缓存的节点的最大数（仅在 List, Grid, Swiper, WaterFlow 中有效）
         *       其与 List 之类的 cachedCount() 的区别是：
         *       1、List 之类的 cachedCount() 指的是除了挂载可视区的 item 外，上部和下部分别需要挂载的 item 的数量，所有被挂载 item 都会被 Repeat 视为"可见"节点
         *       3、template() 的 cachedCount 指的是被 Repeat 视为"不可见"节点的最大的缓存数量
         */
        Repeat<string>(this.array)
          .each((obj: RepeatItem<string>) => {
            // obj.item - 当前遍历出的数据
            // obj.index - 当前遍历出的数据的索引位置

            // 默认的 item 模板
            MyItem2({
              item:`${obj.item}`
            }).backgroundColor(Color.Red)
          })
          .key((item: string, index: number) => {
            return item;
          })
          .virtualScroll({ totalCount: this.array.length })
          // 为不同的 item 指定不同的模板 id
          .templateId((item: string, index: number) => {
            if (index > 9) {
              return 'template0'
            } else {
              return (index % 2 === 0) ? 'template1' : 'template2';
            }
          })
          // 为指定的模板 id 构造指定的组件
          .template('template1', (obj: RepeatItem<string>) => {
            MyItem2({
              item:`template1 ${obj.item}`
            }).backgroundColor(Color.Green)
          }, { cachedCount: 5 })
          .template('template2', (obj: RepeatItem<string>) => {
            MyItem2({
              item:`template2 ${obj.item}`
            }).backgroundColor(Color.Blue)
          }, { cachedCount: 5 })
      }
      .cachedCount(5)
    }
  }
}