/*
 * Row - 水平布局
 *   space - Row 内的每个组件之间的间距
 *   reverse() - 是否需要反转排列
 *   alignItems() - Row 内的每个组件的垂直对齐方式
 *   justifyContent() - Row 内的每个组件的水平排列方式
 */

import { TitleBar, RadioBar } from '../../TitleBar';

@Entry
@Component
struct RowDemo {
  @State message: string = 'Hello World';

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('垂直对齐方式').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('水平排列方式').align(Alignment.Top)
      }
    }
  }
}

@Component
struct MySample1 {
  build() {
    Column() {
      // space - Row 内的每个组件之间的间距
      Row({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }.width('90%').backgroundColor(Color.Orange)

      // reverse() - 是否需要反转排列
      Row({ space: 20 }) {
        Text('1')
        Text('2')
        Text('3')
      }.width('90%')
      .reverse(true).backgroundColor(Color.Yellow)
    }
  }
}

@Component
struct MySample2 {

  @State verticalAlign: VerticalAlign = VerticalAlign.Top
  valueList =  ["Top", "Center", "Bottom"]

  build() {
    Column({space: 5}) {
      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.verticalAlign = VerticalAlign[this.valueList[selectedIndex]]
      }})

      // alignItems() - Row 内的每个组件的垂直对齐方式
      //   Top, Center, Bottom
      Row({space: 20}) {
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
      }
      .width('100%').height(400).backgroundColor(Color.Yellow)
      .alignItems(this.verticalAlign)
    }
    .width('100%').height('100%').alignItems(HorizontalAlign.Center)
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

      // justifyContent() - Row 内的每个组件的水平排列方式
      //   Start - 整体居左
      //   Center - 整体居中
      //   End - 整体居右
      //   SpaceBetween - 每个组件中间的空白相同，两侧边缘与父组件之间无空白
      //   SpaceAround - 每个组件中间的空白相同，两侧边缘与父组件之间的空白为组件之间的空白的二分之一
      //   SpaceEvenly - 每个组件中间的空白相同，两侧边缘与父组件之间的空白与组件之间的空白相同
      Row() {
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
        Column().width(50).height(100).backgroundColor(Color.Blue)
      }
      .width('100%').height(400).backgroundColor(Color.Yellow)
      .justifyContent(this.flexAlign)
    }
    .width('100%').height('100%').alignItems(HorizontalAlign.Center)
  }
}
