/*
 * HarmonyOS Demo
 * 注：本例无法通过 Previewer 测试，需要用模拟器或真机
 */

import { router } from '@kit.ArkUI';
import util from '@ohos.util';

@Entry
@Component
struct Index {
  @State selectedNode1: number = -1
  @State siteMap: Node1[] = []

  aboutToAppear(): void {

    let context = getContext(this)
    context.resourceManager.getRawFileContent("README.md").then((uint8Array) => {
      let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
      let str = textDecoder.decodeToString(uint8Array);
      let lines = str.split('\n');
      let n: Node1 | undefined;

      for (let i = 0; i < lines.length; i++) {
        let line = lines[i];
        if (line.startsWith('###')) {
          n = new Node1(line.substring(4).trim(), [])
          this.siteMap.push(n)
        } else if (n !== undefined && line.includes('. ')) {
          n.childNodes?.push(new Node2(
            line.trim(),
            lines[++i].substring(lines[i].indexOf('-') + 2).trim()
          ));
        }
      }
    });
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
                  Divider().height(1).opacity(0.5).margin({ left: 8, right: 8 })

                  Row() {
                    Text(node2.title).fontSize(16).layoutWeight(1).margin({ left: 42 }).align(Alignment.Start)
                    Blank()
                  }
                  .width('100%')
                  .margin({ top: 10, bottom: 10 })
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