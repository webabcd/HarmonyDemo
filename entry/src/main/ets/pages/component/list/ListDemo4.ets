/*
 * List - 列表的下拉刷新，上拉加载
 */

import { MyLog, TitleBar } from '../../TitleBar';

@Entry
@Component
struct ListDemo4 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('下拉刷新').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('上拉加载').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State isRefreshing: boolean = false
  private array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      /*
       * 通过 Refresh 为 List 增加下拉刷新操作（更多请参见 component/layout/RefreshDemo.ets 中的说明）
       */
      Refresh({
        refreshing: $$this.isRefreshing,
      }) {
        List({ space: 20 }) {
          ForEach(this.array, (item: number) => {
            ListItem() {
              Text(item.toString()).width('100%')
                .fontSize(48).textAlign(TextAlign.Center)
                .backgroundColor(Color.Orange).borderRadius(20)
                .height(100)
            }
            .margin({ left: 20, right: 20 })
          })
        }
        .width('100%')
        .height('100%')
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 2000)
      })
    }
    .backgroundColor(Color.Yellow)
  }
}

@Component
struct MySample2 {

  @State array: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State canLoad: boolean = false;
  @State isLoading: boolean = false;

  // 自定义的用于显示"加载更多"的 item
  @Builder myFooter() {
    Row() {
      LoadingProgress().height(32).width(48)
      Text("加载更多")
    }
    .width("100%")
    .height(64)
    .justifyContent(FlexAlign.Center)
    // 加载数据中则显示，否则隐藏
    .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)
  }

  build() {
    List({ space: 20 }) {
      ForEach(this.array, (item: number) => {
        ListItem() {
          Text(item.toString()).width('100%')
            .fontSize(48).textAlign(TextAlign.Center)
            .backgroundColor(Color.Orange).borderRadius(20)
            .height(100)
        }
        .margin({ left: 20, right: 20 })
      })

      /*
       * 通过 ListItem 显示 List 上拉操作时的"加载更多"
       */
      ListItem() {
        this.myFooter();
      }
    }
    .width('100%')
    .height('100%')
    .onScrollIndex((start: number, end: number) => {
      // 加载更多
      if (this.canLoad && end >= this.array.length - 1) {
        this.canLoad = false;
        this.isLoading = true;
        // 在此处写具体的数据加载逻辑
        setTimeout(() => {
          for (let i = 0; i < 10; i++) {
            this.array.push(this.array.length);
            this.isLoading = false; // 显示"加载更多"
          }
        }, 2000)
      }
    })
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      // 有上拉操作就允许加载更多
      if (offset > 5 && !this.isLoading) {
        this.canLoad = true;
      }
      return { offsetRemain: offset };
    })
    .backgroundColor(Color.Yellow)
  }
}