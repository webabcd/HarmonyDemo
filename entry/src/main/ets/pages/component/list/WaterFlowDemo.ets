/*
 * WaterFlow - 瀑布流列表
 *
 * 注：
 * 1、WaterFlow 是一个可滚动组件，相关特性请参见 /component/layout/ScrollDemo.ets 中的说明
 * 2、WaterFlow 的下拉刷新和上拉加载可以参考 /component/list/ListDemo4.ets 中的说明
 * 3、WaterFlow 结合 ForEach 的应用可以参考 /component/list/ListDemo5.ets 中的说明（但是不支持通过 ForEach 的 onMove() 拖动排序）
 * 4、WaterFlow 结合 LazyForEach 的应用可以参考 /component/list/ListDemo6.ets 中的说明
 * 5、WaterFlow 结合 Repeat 的应用可以参考 /component/list/ListDemo7.ets 中的说明
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct WaterFlowDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('分块').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

interface MyItem {
  title:string,
  height:number,
  color:number,
}

export class MyWaterFlowDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private array: MyItem[] = [];
  public totalCount(): number {
    return this.array.length;
  }
  public getData(index: number): MyItem {
    return this.array[index];
  }
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  public pushItem100(): void {
    let totalCount = this.totalCount()
    for (let i = totalCount; i < totalCount + 100; i++) {
      this.array.push({
        title: i.toString(),
        height: Math.floor(Math.random() * 100 + 50),
        color: Math.floor(Math.random() * (0xffffff + 1)),
      })
      this.listeners.forEach(listener => {
        listener.onDataAdd(i);
      })
    }
  }
}



@Component
struct MySample1 {

  dataSource: MyWaterFlowDataSource = new MyWaterFlowDataSource()

  aboutToAppear() {
    this.dataSource.pushItem100()
  }

  // 自定义 footer
  @Builder myFooter() {
    Text(`加载更多`).fontSize(24).backgroundColor(Color.Red).fontColor(Color.White).width('100%').height(50).textAlign(TextAlign.Center)
      .onClick(() => {
        // 加载更多
        this.dataSource.pushItem100()
      })
  }

  build() {
    Column() {
      /*
       * WaterFlow - 瀑布流列表
       *   footer - 自定义 footer（指定一个自定义组件）
       *   cachedCount() - 指定预挂载的 item 的数量（参见 /component/list/ListDemo6.ets 中的说明）
       *   columnsTemplate(), rowsTemplate(), columnsGap(), rowsGap() - 与 Grid 的相关用法一样（详见 /component/list/GridDemo.ets 中的说明）
       *   layoutDirection() - 布局方向（FlexDirection 枚举）
       *     Column, ColumnReverse - 纵向布局，按照 columnsTemplate() 布局，忽略 rowsTemplate()
       *     Row, RowReverse - 横向布局，按照 rowsTemplate() 布局，忽略 columnsTemplate()
       *   itemConstraintSize() - 用于指定每个 item 的宽和高的约束（一个 ConstraintSizeOptions 对象，可以指定最大宽高和最小宽高）
       *
       * FlowItem - WaterFlow 内的每个 item
       */
      WaterFlow({
        footer: this.myFooter()
      }) {
        LazyForEach(this.dataSource, (item: MyItem, index: number) => {
          FlowItem() {
            Column() {
              Text(item.title).fontSize(24)
            }
          }
          .width('100%')
          .height(item.height)
          .backgroundColor(item.color)
        }, (item: MyItem) => item.title)
      }
      .cachedCount(10)
      .layoutDirection(FlexDirection.Column)
      .columnsTemplate("1fr 1fr")
      .columnsGap(10)
      .rowsGap(10)
      .itemConstraintSize({
        minWidth:0, maxWidth:1000, minHeight:0, maxHeight:1000
      })
      .backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample2 {

  dataSource: MyWaterFlowDataSource = new MyWaterFlowDataSource()

  @State sections: WaterFlowSections = new WaterFlowSections()

  // 这个分块一共有 3 个数据，在 1 列中显示
  section_cell_3_1: SectionOptions = {
    itemsCount: 3,
    crossCount: 1,
    columnsGap: 10,
    rowsGap: 10,
    margin: { left: 10, top: 10, bottom: 10, right: 10 },
    // 根据 item 在整个瀑布流列表中的索引位置，返回这个 item 的高度
    onGetItemMainSizeByIndex: (index: number) => {
      return this.dataSource.getData(index).height
    }
  }

  // 这个分块一共有 2 个数据，在 2 列中显示
  section_cell_2_2: SectionOptions = {
    itemsCount: 2,
    crossCount: 2,
    margin: 0,
    // 根据 item 在整个瀑布流列表中的索引位置，返回这个 item 的高度
    onGetItemMainSizeByIndex: (index: number) => {
      return this.dataSource.getData(index).height
    }
  }

  aboutToAppear() {
    this.dataSource.pushItem100()

    let sectionOptions: SectionOptions[] = []
    let flag = 0
    for (let i = 0; i < this.dataSource.totalCount();) {
      if (flag == 0) {
        // 这 3 条数据归于 section_cell_3_1 分块
        sectionOptions.push(this.section_cell_3_1)
        i += 3
        flag = 1
      } else {
        // 这 2 条数据归于 section_cell_2_2 分块
        sectionOptions.push(this.section_cell_2_2)
        i += 2
        flag = 0
      }
    }
    this.sections.splice(0, 0, sectionOptions)
  }

  build() {
    Column({ space: 10 }) {
      Button('splice').onClick(() => {
        // 清除全部分块信息，然后让所有数据都属于这个分块
        let newSection: SectionOptions = {
          itemsCount: this.dataSource.totalCount(),
          crossCount: 2,
          onGetItemMainSizeByIndex: (index: number) => {
            return this.dataSource.getData(index).height
          }
        }
        this.sections.splice(0,  this.sections.length(), [newSection])
      })

      /*
       * WaterFlow - 瀑布流列表
       *   本例用于演示，如何对瀑布流列表中的数据做分块，每个分块可以定义自己的列数或行数等
       *   sections - 分块信息（一个 WaterFlowSections 对象，其相当于一个 SectionOptions 对象集合）
       *     splice(start, deleteCount, sections) - 从 start 位置开始删除数量为 deleteCount 的数据，然后在 start 的位置添加 sections（SectionOptions 对象集合）
       *     push(section) - 添加一个 SectionOptions 对象
       *     update(sectionIndex, section) - 更新 sectionIndex 位置的 section（一个 SectionOptions 对象）
       *     values - 获取 SectionOptions 对象集合
       *     length - 获取 SectionOptions 对象集合的长度
       *
       * SectionOptions - 一个 WaterFlowSections 对象包含多个 SectionOptions 对象
       *   itemsCount - 分块中的 item 的数量
       *   crossCount - 分块中的列数（纵向布局时）或行数（横向布局时）
       *   columnsGap() - 列间距
       *   rowsGap() - 行间距
       *   margin() - 外边距
       *   onGetItemMainSizeByIndex() - 返回指定索引位置的 item 的高度（纵向布局时）或宽度（横向布局时）
       *
       * FlowItem - WaterFlow 内的每个 item
       */
      WaterFlow({
        sections: this.sections,
      }) {
        LazyForEach(this.dataSource, (item: MyItem, index: number) => {
          FlowItem() {
            Column() {
              Text(item.title).fontSize(24)
            }
          }
          .width('100%')
          .backgroundColor(item.color)
        }, (item: MyItem) => item.title)
      }
      .backgroundColor(Color.Yellow)
      .layoutWeight(1)
    }
  }
}