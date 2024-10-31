import { text } from '@kit.ArkGraphics2D';

import { router } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { TextReader } from '@kit.SpeechKit';
import util from '@ohos.util';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import utils from '@arkts.utils';

@Entry
@Component
struct Index {

  @State selectedNode1: number = -1
  @State siteMap: Node1[] = []

  aboutToAppear(): void {


    /*
     * 因为用 Previewer 测试时，无法读取本地资源文件，所以只能用上面的方式构造索引数据，如果用模拟器或真机测试的时候就可以不用上面的代码，而用下面的代码了
     */

    let context = getContext(this)
    try {
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
    } catch (error) {
      console.error("Error reading file: ", error);
    }
  }

  siteMapToMarkdown() {
    let md = "# Harmony Demo\n\n"
    for (let i = 0; i < this.siteMap.length; i++) {
      let node1 = this.siteMap[i]
      md += `\n### ${node1.title}\n`
      for (let j = 0; j < node1.childNodes!.length; j++) {
        let node2 = node1.childNodes![j]
        md += `${ j + 1 }. ${node2.title}\n`
        md += `- ${node2.url}\n`
        if (node2.other != "")
        {
          let ary = node2.other.split('|')
          for (let value of ary) {
            md += `- ${value}\n`
          }
        }
      }
    }
  }

  build() {
    Column() {
      ForEach(this.siteMap, (node1: Node1, index: number) => {
        Column() {
          Row() {
            Text(node1.title)
              .fontSize(16)
              .margin({ left: 16 })

            Blank()

            Image(this.selectedNode1 == index ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
              .width(24)
              .height(24)
              .margin({ right: 6 })
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
                Divider()
                  .height(1)
                  .opacity(0.2)
                  .margin({ left: 42, right: 8 })

                Row() {
                  Text(node2.title)
                    .fontSize(16)
                    .layoutWeight(1)
                    .margin({ left: 42 })
                    .align(Alignment.Start)

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