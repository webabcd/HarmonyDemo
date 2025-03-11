import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State selectedNode1: number = 0
  @State siteMap: Node1[] = []

  aboutToAppear(): void {
    this.siteMap =
      [
        new Node1("NDK - Native Development Kit", [
          new Node2("NDK 基础", "pages/NdkDemo"),
        ]),
      ]
    return;
  }

  scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column() {
        ForEach(this.siteMap, (node1: Node1, index: number) => {
          Column() {
            Row() {
              Text(node1.title).fontSize(16).margin({ left: 16 })
              Blank()
              Image(this.selectedNode1 == index ? $r('app.media.ic_arrow_down') : $r('app.media.ic_arrow_right'))
                .width(24).height(24).margin({ right: 6 })
            }
            .height(56)
            .width('100%')
            .onClick(() => {
              if (this.selectedNode1 == index) {
                this.selectedNode1 = -1
              } else {
                this.selectedNode1 = index
              }
            })

            if (this.selectedNode1 == index) {
              ForEach(this.siteMap[this.selectedNode1].childNodes, (node2: Node2) => {
                Column() {
                  Divider().height(1).opacity(0.2).margin({ left: 42, right: 8 })

                  Row() {
                    Text(node2.title).fontSize(16).layoutWeight(1).margin({ left: 42 }).align(Alignment.Start)
                    Blank()
                  }
                  .height(48)
                  .width('100%')
                  .onClick(() => {
                    router.pushUrl({
                      url: node2.url,
                      params: {
                        title: node2.title
                      }
                    })
                  })
                }
              })
            }
          }
        })
      }
    }
  }
}

class Node1 {
  public title: string;
  public childNodes?: Node2[];
  constructor(title: string, childNodes?: Node2[]) {
    this.title = title;
    this.childNodes = childNodes;
  }
}

class Node2 {
  public title: string;
  public url: string;
  public other: string;

  constructor(title: string, url: string, other: string = "") {
    this.title = title;
    this.url = url;
    this.other = other;
  }
}