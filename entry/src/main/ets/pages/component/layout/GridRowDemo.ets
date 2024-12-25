/*
 * GridRow - 栅格布局（多行多列的网格布局）
 * GridCol - GridRow 的子组件（单元格）
 *
 * 支持不同的断点（分辨率）使用不同的布局
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct GridRowDemo {

  build() {
    Column({space:10}) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('GridRow').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('GridCol').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('断点').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

  build() {
    Column() {
      /*
       * GridRow - 栅格布局（多行多列的网格布局）
       *   columns - 列数
       *   gutter - 水平方向的间距和垂直方向的间距
       *   direction - 排列方向（GridRowDirection.Row 或 GridRowDirection.RowReverse）
       *
       * GridCol - GridRow 的子组件（单元格）
       */
      GridRow({
        columns: 5,
        gutter: {
          x: 10,
          y: 10
        },
        direction: GridRowDirection.Row
      }) {
        ForEach(this.array, (item: string) => {
          GridCol() {
            Text(item).height(50).textAlign(TextAlign.Center)
          }
          .borderColor(Color.Red)
          .borderWidth(2)
        })
      }
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column() {
      /*
       * GridRow - 栅格布局（多行多列的网格布局）
       *
       * GridCol - GridRow 的子组件（单元格）
       *   span - 当前单元格占用的列数
       *   offset - 当前单元格相对于原始位置的偏移列数
       *   order - 单元格用于排序的序号，会从小到大排列
       */
      GridRow({
        columns: 6,
        gutter: 10,
        direction: GridRowDirection.Row
      }) {
        GridCol({
          span: 2,
          offset: 0,
          order: 2
        }) {
          Text('0').height(50).textAlign(TextAlign.Center)
        }.borderColor(Color.Red).borderWidth(2)

        GridCol({
          span: 1,
          offset: 0,
          order: 0
        }) {
          Text('1').height(50).textAlign(TextAlign.Center)
        }.borderColor(Color.Red).borderWidth(2)

        GridCol({
          span: 1,
          offset: 0,
          order: 1
        }) {
          Text('2').height(50).textAlign(TextAlign.Center)
        }.borderColor(Color.Red).borderWidth(2)

        GridCol({
          span: 1,
          offset: 1,
          order: 2
        }) {
          Text('3').height(50).textAlign(TextAlign.Center)
        }.borderColor(Color.Red).borderWidth(2)
      }
    }
  }
}

@Component
struct MySample3 {

  array: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']
  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * GridRow - 栅格布局（多行多列的网格布局）
       *   breakpoints - 设置断点系统
       *     value - 断点数组，必须是单调递增的，最多 5 个断点
       *       比如 ["100vp", "200vp", "300vp", "400vp", "500vp"]
       *         xs - 0vp 到 100vp（左闭右开）
       *         sm - 100vp 到 200vp（左闭右开）
       *         md - 200vp 到 300vp（左闭右开）
       *         lg - 300vp 到 400vp（左闭右开）
       *         xl - 400vp 到 500vp（左闭右开）
       *         xxl - 500vp 到无限大
       *       比如 ["100vp", "200vp"]
       *         xs - 0vp 到 100vp（左闭右开）
       *         sm - 100vp 到 200vp（左闭右开）
       *         md - 200vp 到无限大
       *     reference - 断点系统的参照物（BreakpointsReference 枚举）
       *       WindowSize - 以窗口为参照
       *       ComponentSize - 以父容器为参照
       *   onBreakpointChange() - 当前断点发生变化时的回调
       *   columns - 列数（支持断点系统）
       *   gutter - 水平方向的间距和垂直方向的间距（支持断点系统）
       *
       * GridCol - GridRow 的子组件（单元格）
       *   span - 当前单元格占用的列数（支持断点系统）
       *   offset - 当前单元格相对于原始位置的偏移列数（支持断点系统）
       *   order - 单元格用于排序的序号，会从小到大排列（支持断点系统）
       *
       * 注：支持断点系统的意思是，允许根据不同的断点设置不同的值
       */
      GridRow({
        columns: {
          xs: 2, // 当前断点是 xs 时，columns 的值为 2
          sm: 4,
          md: 6,
          lg: 8,
          xl: 10,
          xxl: 12
        },
        gutter: {
          x: {
            xs: 10,
            sm: 10,
            md: 10,
            lg: 10,
            xl: 10,
            xxl: 10
          },
          y: {
            xs: 10,
            sm: 10,
            md: 10,
            lg: 10,
            xl: 10,
            xxl: 10
          }
        },
        breakpoints: {
          value: ["100vp", "200vp", "300vp", "400vp", "500vp"],
          reference: BreakpointsReference.WindowSize
        },
        direction: GridRowDirection.Row,
      }) {
        ForEach(this.array, (item: string) => {
          GridCol({
            span: {
              xs: 1,
              sm: 1,
              md: 1,
              lg: 1,
              xl: 1,
              xxl: 1
            },
            offset: {
              xs: 0,
              sm: 0,
              md: 0,
              lg: 0,
              xl: 0,
              xxl: 0
            },
            order: {
              xs: 0,
              sm: 0,
              md: 0,
              lg: 0,
              xl: 0,
              xxl: 0
            }
          }) {
            Text(item).width("100%").height(50).textAlign(TextAlign.Center)
          }
          .borderColor(Color.Red)
          .borderWidth(2)
        })
      }
      .onBreakpointChange((breakpoint: string) => {
        // 当前断点发生变化时的回调
        // 可能的值有 xs, sm, md, lg, xl, xxl
        this.message = `current breakpoint: ${breakpoint}`
      })
    }
  }
}
/*
 * 注：默认的断点系统如下
 * xs（Extra Small） - 水平宽度 0vp - 320vp（左闭右开）
 * sm（Small） - 水平宽度 320vp - 520vp（左闭右开）
 * md（Medium） - 水平宽度 520vp - 840vp（左闭右开）
 * lg（Large） - 水平宽度 840vp - 无限大
 * xl（Extra Large） - 自定义
 * xxl（Extra Extra Large） - 自定义
 */