/*
 * 剪切板
 *
 * 注：按照文档所述，读取剪切板数据前需要用户授权，但是我这里测试的结果是不用用户授权也可以读取剪切板数据
 */

import { TitleBar } from '../TitleBar';
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
import { Helper } from '../../utils/Helper';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct PasteboardDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('复制/粘贴单条数据').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('复制/粘贴多条数据').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('其它').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State pixelMap: PixelMap | undefined = undefined

  // 图片资源转 PixelMap 对象
  private async getPixmapFromMedia(resource: Resource): Promise<image.PixelMap> {
    // 资源转 Uint8Array 对象
    let uint8Array = await getContext(this).resourceManager.getMediaContent({
      bundleName: resource.bundleName,
      moduleName: resource.moduleName,
      id: resource.id
    })

    // 图片 Uint8Array 对象转 PixelMap 对象
    let imageSource = image.createImageSource(uint8Array.buffer)
    let pixelMap: image.PixelMap = await imageSource.createPixelMap({
      // RGBA_8888 的意思是 r 占用 8 位，g 占用 8 位，b 占用 8 位，a 占用 8 位
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    })
    await imageSource.release()
    return pixelMap
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      Image(this.pixelMap).width(200).height(200)

      /*
       * pasteboard.createData() - 构造一个 PasteData 对象，用于保存到剪切板
       *   mimeType - 需要保存到剪切板的数据的类型
       *     MIMETYPE_TEXT_PLAIN - text/plain
       *     MIMETYPE_TEXT_HTML - text/html
       *     MIMETYPE_TEXT_URI - text/uri
       *     MIMETYPE_TEXT_WANT - text/want
       *     MIMETYPE_PIXELMAP - pixelMap
       *   value - 需要保存到剪切板的数据
       *     可用类型有 string | image.PixelMap | Want | ArrayBuffer
       *
       * pasteboard.getSystemPasteboard() - 获取 SystemPasteboard 对象
       *   setData() - 复制指定 PasteData 对象到剪切板
       *   getData() - 从剪切板中获取 PasteData 对象
       *   hasData() - 剪切板中是否有数据
       *   hasDataType() - 剪切板中是否有指定类型的数据
       *   clearData() - 清除剪切板中的数据
       *
       * PasteData - 复制/粘贴对象
       *   getPrimaryText() - 从 PasteData 对象中获取 text/plain 类型的数据
       *   getPrimaryHtml() - 从 PasteData 对象中获取 text/html 类型的数据
       *   getPrimaryUri() - 从 PasteData 对象中获取 text/uri 类型的数据
       *   getPrimaryWant() - 从 PasteData 对象中获取 text/want 类型的数据
       *   getPrimaryPixelMap() - 从 PasteData 对象中获取 pixelMap 类型的数据
       */

      Button("复制字符串").onClick(() => {
        let dataText = `hello ${Helper.getTimestampString()}`
        let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, dataText)
        let systemPasteboard = pasteboard.getSystemPasteboard()
        systemPasteboard.setData(pasteData, (err, data) => {
          if (err) {
            this.message = `复制字符串失败：${err.message}`
          } else {
            this.message = `复制字符串成功`
          }
        });
      })

      Button("粘贴字符串").onClick(() => {
        let systemPasteboard = pasteboard.getSystemPasteboard()
        systemPasteboard.getData().then((pasteData: pasteboard.PasteData) => {
          this.message = pasteData.getPrimaryText()
        }).catch((err: BusinessError) => {
          this.message = `粘贴字符串失败：${err.message}`
        });
      })

      Button("复制图片").onClick(async () => {
        let pixelMap = await this.getPixmapFromMedia($r('app.media.son'))
        let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_PIXELMAP, pixelMap)
        let systemPasteboard = pasteboard.getSystemPasteboard()
        systemPasteboard.setData(pasteData, (err, data) => {
          if (err) {
            this.message = `复制图片失败：${err.message}`
          } else {
            this.message = `复制图片成功`
          }
        });
      })

      Button("粘贴图片，并清除剪切板").onClick(() => {
        let systemPasteboard = pasteboard.getSystemPasteboard()
        if (systemPasteboard.hasDataType("pixelMap")) {
          systemPasteboard.getData().then((pasteData: pasteboard.PasteData) => {
            this.pixelMap = pasteData.getPrimaryPixelMap()
            systemPasteboard.clearDataSync()
          }).catch((err: BusinessError) => {
            this.message = `粘贴图片失败：${err.message}`
          });
        } else {
          this.message = `剪切板中没有图片类型的数据`
        }
      })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * pasteboard.createData() - 构造一个 PasteData 对象，用于保存到剪切板
       * pasteboard.createRecord() - 构造一个 PasteDataRecord 对象，允许在 PasteData 中添加多个 PasteDataRecord
       *   mimeType - 需要保存到剪切板的数据的类型
       *     MIMETYPE_TEXT_PLAIN - text/plain
       *     MIMETYPE_TEXT_HTML - text/html
       *     MIMETYPE_TEXT_URI - text/uri
       *     MIMETYPE_TEXT_WANT - text/want
       *     MIMETYPE_PIXELMAP - pixelMap
       *   value - 需要保存到剪切板的数据
       *     可用类型有 string | image.PixelMap | Want | ArrayBuffer
       *
       * pasteboard.getSystemPasteboard() - 获取 SystemPasteboard 对象
       *   setData() - 复制指定 PasteData 对象到剪切板
       *   getData() - 从剪切板中获取 PasteData 对象
       *   hasData() - 剪切板中是否有数据
       *   hasDataType() - 剪切板中是否有指定类型的数据
       *   clearData() - 清除剪切板中的数据
       *   getRecord() - 获取 PasteData 对象中指定索引位置的 PasteDataRecord 对象
       *   getRecordCount() - 获取 PasteData 对象中的 PasteDataRecord 对象的数量
       *
       * PasteData - 复制/粘贴对象
       *   getPrimaryMimeType() - PasteData 对象中的数据的类型
       *   getPrimaryText() - 从 PasteData 对象中获取 text/plain 类型的数据
       *   getPrimaryHtml() - 从 PasteData 对象中获取 text/html 类型的数据
       *   getPrimaryUri() - 从 PasteData 对象中获取 text/uri 类型的数据
       *   getPrimaryWant() - 从 PasteData 对象中获取 text/want 类型的数据
       *   getPrimaryPixelMap() - 从 PasteData 对象中获取 pixelMap 类型的数据
       *   addRecord() - 添加指定的 PasteDataRecord 对象
       *
       * PasteDataRecord - 保存在 PasteData 对象中的某一条数据
       *   mimeType - PasteDataRecord 对象中的数据的类型
       *   plainText - 从 PasteDataRecord 对象中获取 text/plain 类型的数据
       *   htmlText - 从 PasteDataRecord 对象中获取 text/html 类型的数据
       *   uri - 从 PasteDataRecord 对象中获取 text/uri 类型的数据
       *   want - 从 PasteDataRecord 对象中获取 text/want 类型的数据
       *   pixelMap - 从 PasteDataRecord 对象中获取 pixelMap 类型的数据
       */

      Button("复制多条数据").onClick(async () => {
        let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, `hello ${Helper.getTimestampString()}`);
        let uriRecord: pasteboard.PasteDataRecord = pasteboard.createRecord(pasteboard.MIMETYPE_TEXT_URI, 'https://webabcd.cnblogs.com/')
        let htmlRecord: pasteboard.PasteDataRecord = pasteboard.createRecord(pasteboard.MIMETYPE_TEXT_HTML, '<span>hello world</span>')
        pasteData.addRecord(uriRecord);
        pasteData.addRecord(htmlRecord);

        let systemPasteboard = pasteboard.getSystemPasteboard()
        systemPasteboard.setData(pasteData, (err, data) => {
          if (err) {
            this.message = `复制多条数据失败：${err.message}`
          } else {
            this.message = `复制多条数据成功`
          }
        });
      })

      Button("粘贴多条数据").onClick(() => {
        this.message = ""
        let systemPasteboard = pasteboard.getSystemPasteboard()
        systemPasteboard.getData().then((pasteData: pasteboard.PasteData) => {
          for (let i = 0; i < pasteData.getRecordCount(); i++) {
            let pasteDataRecord = pasteData.getRecord(i)
            switch (pasteDataRecord.mimeType) {
              case 'text/html':
                this.message += `text/html: ${pasteDataRecord.htmlText}\n`
                break
              case 'text/uri':
                this.message += `text/uri: ${pasteDataRecord.uri}\n`
                break
              case 'text/plain':
                this.message += `text/plain: ${pasteDataRecord.plainText}\n`
                break
              default :
                break
            }
          }
        }).catch((err: BusinessError) => {
          this.message = `粘贴多条数据失败：${err.message}`
        });
      })
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  aboutToAppear(): void {
    let listener = () => {
      this.message = `剪切板中的数据发生了变化 ${Helper.getTimestampString()}`
    };
    pasteboard.getSystemPasteboard().on('update', listener);
  }

  aboutToDisappear(): void {
    pasteboard.getSystemPasteboard().off('update');
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * pasteboard.getSystemPasteboard() - 获取 SystemPasteboard 对象
       *   on('update') - 监听剪切板中的数据的变化
       *   off('update') - 取消监听剪切板中的数据的变化
       *
       * PasteData - 复制/粘贴对象
       *   setProperty() / getProperty() - 获取或设置 PasteData 的属性（一个 PasteDataProperty 对象）
       *
       * PasteDataProperty
       *   shareOption - 数据的有效范围（ShareOption 枚举）
       *     INAPP - 仅允许应用内粘贴
       *     LOCALDEVICE - 允许设备内任何应用粘贴
       *   additions - 附加数据，数据类型为 {[key:string]:object}
       *   tag - 自定义标签
       *   mimeTypes - 剪切板中的数据类型（只读）
       *   timestamp - 剪切板中的数据的写入时间戳（只读，单位：毫秒）
       */

      Button("监听剪切板中的数据的变化").onClick(async () => {
        let pasteData: pasteboard.PasteData = pasteboard.createData('text/plain', 'xxx')
        pasteboard.getSystemPasteboard().setDataSync(pasteData)
      })

      Button("setProperty()/getProperty()").onClick(() => {
        type AdditionsType = Record<string, Record<string, Object>>;

        let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, 'abc')
        pasteData.setProperty({
          shareOption: pasteboard.ShareOption.LOCALDEVICE,
          additions: { 'group1': { 'k1': 1 }, 'group2': { 'k2': '2' } } as AdditionsType,
          tag: 'myTag',
          mimeTypes: [],
          timestamp: 0,
          localOnly: false
        })

        let property = pasteData.getProperty()
        this.message = `plainText: ${pasteboard.getSystemPasteboard().getDataSync().getPrimaryText()}\n`
        this.message += `timestamp: ${property.timestamp}\n`
        this.message += `tag: ${property.tag}\n`
        this.message += `mimeTypes: ${JSON.stringify(property.mimeTypes)}\n`
        this.message += `additions: ${JSON.stringify(property.additions)}`
      })
    }
  }
}
