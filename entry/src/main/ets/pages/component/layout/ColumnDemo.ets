/*
 * Column - 垂直布局
 *   space - Column 内的每个组件之间的间距
 *   reverse() - 是否需要反转排列
 *   alignItems() - Column 内的每个组件的水平对齐方式
 *   justifyContent() - Column 内的每个组件的垂直排列方式
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct ColumnDemo {
  @State message: string = 'Hello World';

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('水平对齐方式').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('垂直排列方式').align(Alignment.Top)
      }
    }
  }
}

@Component
struct MySample1 {
  build() {
    Column() {
      // space - Column 内的每个组件之间的间距
      Column({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }.width('90%').height(200).backgroundColor(Color.Orange)

      // reverse() - 是否需要反转排列
      Column({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }.width('90%')
      .reverse(true).height(200).backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample2 {

  @State horizontalAlign: HorizontalAlign = HorizontalAlign.Start
  valueList =  ["Start", "Center", "End"]

  build() {
    // alignItems() - Column 内的每个组件的水平对齐方式
    //   Start, Center, End
    Column({space: 5}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.horizontalAlign = HorizontalAlign[this.valueList[selectedIndex]]
      }})

      Column().width('80%').height(50).backgroundColor(Color.Blue)
      Column().width('80%').height(50).backgroundColor(Color.Blue)
      Column().width('80%').height(50).backgroundColor(Color.Blue)
    }.width('100%').backgroundColor(Color.Orange)
    .alignItems(this.horizontalAlign)
  }
}

@Component
struct MySample3 {

  @State flexAlign: FlexAlign = FlexAlign.Start
  valueList =  ["Start", "Center", "End", "SpaceBetween", "SpaceAround", "SpaceEvenly"]

  build() {
    Column({space: 5}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.flexAlign = FlexAlign[this.valueList[selectedIndex]]
      }})

      // justifyContent() - Column 内的每个组件的垂直排列方式
      //   Start - 整体居顶部
      //   Center - 整体居中
      //   End - 整体居底部
      //   SpaceBetween - 每个组件中间的空白相同，两侧边缘与父组件之间无空白
      //   SpaceAround - 每个组件中间的空白相同，两侧边缘与父组件之间的空白为组件之间的空白的二分之一
      //   SpaceEvenly - 每个组件中间的空白相同，两侧边缘与父组件之间的空白与组件之间的空白相同
      Column() {
        Column().width('80%').height(50).backgroundColor(Color.Blue)
        Column().width('80%').height(50).backgroundColor(Color.Blue)
        Column().width('80%').height(50).backgroundColor(Color.Blue)
      }
      .width('100%').height(400).backgroundColor(Color.Orange)
      .justifyContent(this.flexAlign)
    }.width('100%').height('100%')
  }
}
