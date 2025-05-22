/*
 * http 请求
 * 本例用于演示如何通过 rcp 实现 http 请求，上传下载和流
 * 相对于 Network Kit 的 HttpRequest 来说，通过 Remote Communication Kit 的 rcp 实现 http 请求会更简单且功能更强大
 *
 * 需要在 src/main/module.json5 中添加 ohos.permission.INTERNET 权限
 */

import {  TitleBar } from '../TitleBar';
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct RcpDemo3 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('下载文件').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('上传文件').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('流式上传').align(Alignment.Top)
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

  /*
   * rcp.createSession() - 创建一个 rcp.Session 对象
   *   downloadToStream() - 下载指定 url 的数据并保存到指定的流
   *   downloadToFile() - 下载指定 url 的数据并保存到指定的文件
   *     url - 需要下载的 url
   *     downloadTo - 需要保存到的文件（一个 DownloadToFile 对象）
   * DownloadToFile - 用于描述需要保存到的文件的信息
   *   kind - 设置为 'file' 则代表需要保存到指定的文件
   *   file - 需要保存到的文件的路径
   */
  async download_sample() {
    this.message = "开始下载文件\n"

    const savePath = getContext(this).filesDir + "/rcp_sample1.txt"
    let downloadToFile: rcp.DownloadToFile = {
      kind: 'file',
      file: savePath,
    }

    const session: rcp.Session = rcp.createSession()
    session.downloadToFile('http://192.168.8.197:8001/api?k1=v1&k2=v2', downloadToFile).then((response) => {
      this.message += `response code: ${response.statusCode}\n`
      this.message += `save path: ${savePath}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("下载文件").onClick(async () => {
        await this.download_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  /*
   * rcp.createSession() - 创建一个 rcp.Session 对象
   *   uploadFromStream() - 上传指定的流到指定的 url
   *   uploadFromFile() - 上传指定地址的文件到指定的 url
   *     url - 服务端 url
   *     uploadFrom - 需要上传的文件（一个 UploadFromFile 对象）
   * UploadFromFile - 用于描述需要上传的文件的信息
   *   filePath - 需要上传的文件的路径
   */
  async upload_sample() {
    this.message = "开始上传文件\n"

    let filePath = getContext(this).resourceDir + "/son.jpg"
    let uploadFromFile = new rcp.UploadFromFile(filePath)

    const session: rcp.Session = rcp.createSession({headers:{"filename":"son.jpg"}})
    session.uploadFromFile('http://192.168.8.197:8001/upload', uploadFromFile).then((response) => {
      this.message += `response json: ${JSON.stringify(response.toJSON())}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("上传文件").onClick(async () => {
        await this.upload_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  /*
   * rcp.createSession() - 创建一个 rcp.Session 对象
   *   post()
   *     url - 服务端 url
   *     networkInputQueue - 需要上传的数据队列（一个 NetworkInputQueue 对象）
   * NetworkInputQueue - 需要上传的数据队列
   *   write() - 向队列中写入数据，队列中的数据会按顺序被上传到服务端
   *   close() - 关闭队列，即断开连接
   */
  async upload_sample() {
    this.message = "开始流式上传\n"

    const networkInputQueue = new rcp.NetworkInputQueue();

    // 每隔 10 毫秒向队列中写入数据（队列中的数据会按顺序被上传到服务端），用于模拟流式上传数据
    let counter = 0;
    const interval = setInterval(() => {
      networkInputQueue.write(`${counter++} `);
      if (counter === 100) {
        clearInterval(interval);
        networkInputQueue.close();
      }
    }, 10);

    const session: rcp.Session = rcp.createSession({headers:{"filename":"rcp_sample3.txt"}})
    session.post('http://192.168.8.197:8001/upload', networkInputQueue).then((response) => {
      this.message += `response json: ${JSON.stringify(response.toJSON())}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("流式上传").onClick(async () => {
        await this.upload_sample()
      })

      Text(this.message)
    }
  }
}