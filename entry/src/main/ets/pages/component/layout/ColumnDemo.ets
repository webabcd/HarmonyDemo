@Entry
@Component
struct ColumnDemo {
  @State message: string = 'Hello World';

  build() {
    Tabs() {
      TabContent() { MySample1() }.tabBar('首页')
      TabContent() { MySample2() }.tabBar('首页2')
    }
  }
}

@Component
struct MySample1 {
  build() {
    Column({ space: 20 }) {
      Text('space: 20').fontSize(15).fontColor(Color.Gray).width('90%')
      Row().width('90%').height(50).backgroundColor(0xF5DEB3)
      Row().width('90%').height(50).backgroundColor(0xD2B48C)
      Row().width('90%').height(50).backgroundColor(0xF5DEB3)
    }.width('100%')
  }
}

@Component
struct MySample2 {

  @State horizontalAlign: HorizontalAlign = HorizontalAlign.Start;

  build() {
    Column({}) {
      MyRadio({valueList: ["Start", "Center", "End"], onChange: (selectedIndex: number) => {
        if (selectedIndex == 0) {
          this.horizontalAlign = HorizontalAlign.Start;
        } else if (selectedIndex == 1) {
          this.horizontalAlign = HorizontalAlign.Center;
        } else if (selectedIndex == 2) {
          this.horizontalAlign = HorizontalAlign.End;
        }
      }})

      Column() {
      }.width('80%').height(50).backgroundColor(0xF5DEB3)

      Column() {
      }.width('80%').height(50).backgroundColor(0xD2B48C)

      Column() {
      }.width('80%').height(50).backgroundColor(0xF5DEB3)
    }.width('100%').alignItems(this.horizontalAlign).backgroundColor('rgb(242,242,242)')
  }
}

@Component
struct MyRadio {
  @State valueList: string[] = [];
  @State selectedIndex: number = 0;

  onChange?: (selectedIndex: number) => void;

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
      ForEach(this.valueList, (item: string, index: number) => {
        Column() {
          Radio({ value: item, group: 'radioGroup' })
            .checked(index == this.selectedIndex)
            .height(24)
            .width(24)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedIndex = index
                if (this.onChange) {
                  this.onChange(this.selectedIndex);
                }
              }
            })
          Text(item)
        }
      })
    }.padding(10)
  }
}
