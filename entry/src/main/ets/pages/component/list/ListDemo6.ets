/*
 * List - LazyForEach 的应用
 *
 * LazyForEach 支持懒挂载（仅在 List, Grid, Swiper, WaterFlow 中有效）
 * 懒挂载的意思就是，一个显示大量数据的 List 滚动后，会挂载（onAppear）正在显示的 item，且会卸载（onDisAppear）未显示的 item，从而减少资源占用
 */

import { MyLog, TitleBar } from '../../TitleBar';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
struct ListDemo6 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MyItem {
  item: string = "";

  aboutToAppear() {
    MyLog.d(`aboutToAppear:${this.item}`)
  }

  aboutToDisappear(): void {
    MyLog.d(`aboutToDisappear:${this.item}`)
  }

  build() {
    ListItem() {
      Text(this.item).width('100%')
        .fontSize(24).textAlign(TextAlign.Center)
        .backgroundColor(Color.Orange).borderRadius(20)
        .height(50)
    }
    .margin({ left: 20, right: 20 })
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
@Component
struct MySample1 {

  private data: MyDataSource = new MyDataSource(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']);

  build() {
    Column({space:10}) {
      Flex({wrap: FlexWrap.Wrap, direction: FlexDirection.Row, space:{ main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) }}) {
        Button("添加").onClick(() => this.data.addData(0, Math.floor(Math.random() * 1000).toString()))
        Button("删除").onClick(() => this.data.deleteData(0))
        Button("更新").onClick(() => this.data.changeData(0, Math.floor(Math.random() * 1000).toString()))
        Button("移动").onClick(() => this.data.moveData(0, 2))
        Button("交换").onClick(() => this.data.exchangeData(0, 2))
        Button("刷新全部").onClick(() => this.data.reloadData())
        Button("批量操作").onClick(() => this.data.batchOperation())
      }

      /*
       * List - 列表
       *   cachedCount() - 指定预挂载的 item 的数量（仅 LazyForEach 或 Repeat 结合 List, Grid, Swiper, WaterFlow 时有效）
       *     要支持 item 的预挂载，需要使用 LazyForEach 或 Repeat（关于 List 结合 Repeat 的应用请参见 /component/list/ListDemo7.ets 中的说明）
       *     每次除了挂载可视区的 item 外，还会在上和下分别预挂载指定数量的 item（其他的 item 会被卸载）
       *
       * LazyForEach - 在 ForEach 的基础上支持懒挂载（数据来自一个 IDataSource 对象）
       *   LazyForEach 的第 3 个参数是 keyGenerator 用于生成 item 的键值，其作用请参见 ListDemo5.ets 中的说明
       *   LazyForEach 的 onMove() 用于实现拖动排序，请参见 ListDemo5.ets 中的说明
       *
       * 注：
       * 1、item 被创建时会走到 aboutToAppear，item 被销毁时会走到 aboutToDisappear
       * 2、item 挂载到组件树上时会走到 onAppear，item 从组件树上卸载时会走到 onDisAppear
       * 3、item 从组件树上卸载之后，就会被销毁，下次再使用时会重新创建
       */
      List({ space: 10 }) {
        LazyForEach(this.data, (item: string, index: number) => {
          MyItem({
            item:`${item}`
          })
        }, (item: string, index: number) => item)
          .onMove((from:number, to:number) => {
            // 注：这里的代码仅用于更新数据源，而界面上的排序是由框架自己实现的（也就是说即使没有下面的代码，也不影响界面上的排序）
            this.data.moveData_withoutNotify(from, to)
          })
      }
      .cachedCount(5)
    }
    .margin({ left: 20, right: 20 })
  }
}

// 实现 IDataSource 接口，用于管理 listener 监听，以及通知 LazyForEach 做相关操作并刷新
// 注：这个类用于为 LazyForEach 提供数据，以及于通知 LazyForEach 做相关操作并刷新，但是它并不会更新数据源
class BasicDataSource implements IDataSource {

  private listeners: DataChangeListener[] = [];
  private originDataArray: string[] = [];

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): string {
    return this.originDataArray[index];
  }

  // 此方法会由框架自动调用，用于为 LazyForEach 组件的数据源注册 listener 监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 此方法会由框架自动调用，用于为 LazyForEach 组件的数据源注销 listener 监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知 LazyForEach 组件，需要在位置 index 处添加 item
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
      // 上面的相当于下面的，但是在一个 IDataSource 内，onDatasetChange 和 onDataXXX 不能混用，否则可能会报错 Error: onDatasetChange cannot be used with other interface
      // listener.onDataAdd(index);
    })
  }

  // 通知 LazyForEach 组件，在位置 index 处的 item 发生了变化
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.CHANGE, index: index}]);
      // 上面的相当于下面的，但是在一个 IDataSource 内，onDatasetChange 和 onDataXXX 不能混用，否则可能会报错 Error: onDatasetChange cannot be used with other interface
      // listener.onDataChange(index);
    })
  }

  // 通知 LazyForEach 组件，需要删除位置 index 处的 item
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
      // 上面的相当于下面的，但是在一个 IDataSource 内，onDatasetChange 和 onDataXXX 不能混用，否则可能会报错 Error: onDatasetChange cannot be used with other interface
      // listener.onDataDelete(index);
    })
  }

  // 通知 LazyForEach 组件，将位置 from 的 item 移动到位置 to
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.MOVE, index: {from: from, to: to}}]);
    })
  }

  // 通知 LazyForEach 组件，将位置 index1 和 index2 的 item 互换
  notifyDataExchange(index1: number, index2: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.EXCHANGE, index: {start: index1, end: index2}}]);
    })
  }

  // 通知 LazyForEach 组件，需要重载所有 item
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.RELOAD}]);
      // 上面的相当于下面的，但是在一个 IDataSource 内，onDatasetChange 和 onDataXXX 不能混用，否则可能会报错 Error: onDatasetChange cannot be used with other interface
      // listener.onDataReloaded();
    })
  }

  // 通知 LazyForEach 组件，需要并行执行多个指定的操作
  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }
}

// BasicDataSource 实现了 IDataSource 接口，用于管理 listener 监听，以及通知 LazyForEach 做相关操作并刷新
// MyDataSource 继承自 BasicDataSource，增加了更新源数据的逻辑
class MyDataSource extends BasicDataSource
{
  private dataArray: string[] = [];

  constructor(dataArray: string[]) {
    super();
    this.dataArray = dataArray
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public addData(index: number, data: string): void {
    // 更新源数据
    this.dataArray.splice(index, 0, data);
    // 通知 LazyForEach 做相关操作并刷新
    this.notifyDataAdd(index);
  }

  public deleteData(index: number): void {
    // 更新源数据
    this.dataArray.splice(index, 1);
    // 通知 LazyForEach 做相关操作并刷新
    this.notifyDataDelete(index);
  }

  public changeData(index: number, data: string): void {
    // 更新源数据
    this.dataArray.splice(index, 1, data);
    // 通知 LazyForEach 做相关操作并刷新
    this.notifyDataChange(index);
  }

  public moveData(from: number, to: number): void {
    // 更新源数据
    let tmp = this.dataArray.splice(from, 1)
    this.dataArray.splice(to, 0, tmp[0])
    // 通知 LazyForEach 做相关操作并刷新
    this.notifyDataMove(from, to);
  }

  public moveData_withoutNotify(from: number, to: number): void {
    // 更新源数据
    let tmp = this.dataArray.splice(from, 1)
    this.dataArray.splice(to, 0, tmp[0])
  }

  public exchangeData(index1: number, index2: number): void {
    // 更新源数据
    let temp: string = this.dataArray[index1];
    this.dataArray[index1] = this.dataArray[index2];
    this.dataArray[index2] = temp;
    // 通知 LazyForEach 做相关操作并刷新
    this.notifyDataExchange(index1, index2);
  }

  public reloadData(): void {
    // 更新源数据
    this.dataArray = this.dataArray.map((item: string) => {
      return item + 'x';
    })
    // 通知 LazyForEach 做相关操作并刷新
    this.notifyDataReload();
  }

  public batchOperation(): void {
    // 更新源数据
    // 懒得写了，反正要知道 listener.onDatasetChange() 用于通知 LazyForEach 做相关操作并刷新，但是它并不会更新数据源
    // 同样的，更新了数据源之后，也不会让 LazyForEach 做相关操作并刷新

    // 通知 LazyForEach 并行执行多个指定的操作并刷新（注意是并行执行所有逻辑，而不是串行执行）
    this.notifyDatasetChange([
      { type: DataOperationType.DELETE, index: 0, count: 1 },
      { type: DataOperationType.MOVE, index: { from: 1, to: 2 } },
      // { type: DataOperationType.ADD, index: 0, count: 1 },
      // { type: DataOperationType.EXCHANGE, index: { start: 0, end: 1 } },
      // { type: DataOperationType.CHANGE, index: 0 },
      // { type: DataOperationType.RELOAD },
    ]);
  }
}