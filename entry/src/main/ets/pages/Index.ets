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
    this.siteMap =
    [
      new Node1("ArkTS 基础", [
        new Node2("基础", "pages/arkts/basic/Basic"),
        new Node2("数据类型", "pages/arkts/basic/DataType"),
        new Node2("boolean", "pages/arkts/basic/Boolean"),
        new Node2("number", "pages/arkts/basic/Number"),
        new Node2("string", "pages/arkts/basic/String"),
        new Node2("array", "pages/arkts/basic/Array"),
        new Node2("set", "pages/arkts/basic/Set"),
        new Node2("map", "pages/arkts/basic/Map"),
        new Node2("tuple", "pages/arkts/basic/Tuple"),
      ]),
      new Node1("ArkTS 类", [
        new Node2("enum", "pages/arkts/class/Enum"),
        new Node2("function", "pages/arkts/class/Function"),
        new Node2("interface", "pages/arkts/class/Interface"),
        new Node2("object", "pages/arkts/class/Object"),
        new Node2("类", "pages/arkts/class/Class"),
        new Node2("泛型", "pages/arkts/class/Generics"),
        new Node2("模块", "pages/arkts/module/Main", "pages/arkts/module/a|pages/arkts/module/b|pages/arkts/module/c|pages/arkts/module/d|pages/arkts/module/e|pages/arkts/module/f|pages/arkts/module/g|pages/arkts/module/h|pages/arkts/module/i"),
      ]),
      new Node1("ArkTS 进阶", [
        new Node2("ArrayBuffer", "pages/arkts/advanced/ArrayBuffer"),
        new Node2("Promise", "pages/arkts/advanced/Promise"),
        new Node2("async/await", "pages/arkts/advanced/AsyncAwait"),
        new Node2("iterator, generator", "pages/arkts/advanced/IteratorGenerator"),
        new Node2("Proxy, Reflect", "pages/arkts/advanced/ProxyReflect"),
      ]),
      new Node1("开发基础", [
        new Node2("ArkUI 基础", "pages/basic/Hello"),
        new Node2("@Builder 相关装饰器（@Builder, @BuilderParam, @LocalBuilder, WrappedBuilder）", "pages/basic/BuilderDemo"),
        new Node2("@Style 相关装饰器（@Style, @Extend, stateStyles）", "pages/basic/StyleDemo"),
        new Node2("在描述 UI 时使用 if/else, ForEach 语句", "pages/basic/StatementDemo"),
        new Node2("生命周期", "pages/basic/LifecycleDemo"),
      ]),
      new Node1("状态管理", [
        new Node2("@State", "pages/state/StateDemo"),
        new Node2("@Prop, @Link, @Provide/@Consume, @Observed/@ObjectLink", "pages/state/PropDemo"),
        new Node2("@Watch, @Track, $$", "pages/state/WatchDemo"),
      ]),
      new Node1("组件（通用的属性方法和事件方法）", [
        new Node2("尺寸相关（width, height, size, constraintSize, margin, padding）", "pages/component/common/SizeDemo"),
        new Node2("位置相关（align, direction, position, markAnchor, offset）", "pages/component/common/PositionDemo"),
      ]),
      new Node1("组件（布局类）", [
        new Node2("Column（垂直布局）", "pages/component/layout/ColumnDemo"),
        new Node2("Row（水平布局）", "pages/component/layout/RowDemo"),
        new Node2("Flex（垂直布局或水平布局）", "pages/component/layout/FlexDemo"),
        new Node2("Stack（堆叠布局）", "pages/component/layout/StackDemo"),
        new Node2("FolderStack（可识别屏幕折叠悬停的堆叠布局）", "pages/component/layout/FolderStackDemo"),
        new Node2("RelativeContainer（相对布局）", "pages/component/layout/RelativeContainerDemo"),
      ]),
      new Node1("UI", [
        new Node2("颜色相关", "pages/ui/ColorDemo"),
        new Node2("单位相关", "pages/ui/UnitDemo"),
      ]),
      new Node1("图形", [
        new Node2("边框", "pages/shape/BorderDemo"),
        new Node2("剪裁，遮罩", "pages/shape/ClipDemo"),
      ]),
    ]
    this.siteMapToMarkdown()
    return;

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