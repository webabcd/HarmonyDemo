/*
 * http 请求
 * 本例用于演示如何通过 HttpRequest 实现 http 请求
 * 相对于 Network Kit 的 HttpRequest 来说，通过 Remote Communication Kit 的 rcp 实现 http 请求会更简单且功能更强大
 *
 * 需要在 src/main/module.json5 中添加网络权限，类似如下
 * {
 *   "module": {
 *     "requestPermissions":[
 *       {
 *         "name" : "ohos.permission.INTERNET", // 使用 Internet 网络的权限
 *         "reason": "$string:hello_webabcd", // 申请此权限的原因
 *         "usedScene": {
 *           "abilities": [ ],
 *           "when":"always" // inuse（使用时允许使用此权限），always（始终允许使用此权限）
 *         }
 *       },
 *     ]
 *   }
 * }
 */

import { MyLog, TitleBar } from '../TitleBar';
import { http } from '@kit.NetworkKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct HttpDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('get/post').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('流式下载数据').align(Alignment.Top)
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
   * HttpRequest - 用于 http 请求
   *   http.createHttp() - 创建一个 HttpRequest 实例
   *   on(), off() - 监听指定事件，取消监听指定事件
   *     headersReceive - 收到响应 header 后的事件
   *   request() - 开始 http 请求
   *     url - url
   *     options - 选项（一个 HttpRequestOptions 对象）
   *       header - 请求头
   *       method - 请求方法（RequestMethod 枚举）
   *         OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT
   *       expectDataType - 返回数据的类型（HttpDataType 枚举）
   *         STRING, OBJECT, ARRAY_BUFFER
   *       connectTimeout - 连接的超时时间（单位：毫秒）
   *       readTimeout - 读取的超时时间（单位：毫秒）
   *       extraData - post 的数据
   *     callback - 回调（回调参数是一个 BusinessError 对象和一个 HttpResponse 对象）
   *       result - 响应的结果
   *       responseCode - 响应的 http 状态码
   *   destroy() - 中断并销毁（注：请求完毕后需要调用此方法释放资源）
   */

  async get_sample() {
    this.message = "开始 get 请求\n"
    let httpRequest = http.createHttp()

    httpRequest.on('headersReceive', (header) => {
      this.message += `header: ${JSON.stringify(header)}\n`
    });

    httpRequest.request(
      "http://192.168.8.197:8001/api?k1=v1&k2=v2",
      {
        header: {
          'custom-header1': 'abc'
        },
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 60_000,
        readTimeout: 60_000,
      },
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          this.message += `result: ${JSON.stringify(data.result)}\n`
          this.message += `response code: ${data.responseCode}\n`
        } else {
          this.message += `error: ${JSON.stringify(err)}\n`
        }
        httpRequest.off('headersReceive')
        httpRequest.destroy()
      }
    );
  }

  async post_sample() {
    interface IPerson {
      name: string
      age: number
    }
    const person: IPerson = {
      name: "webabcd",
      age: 44,
    }
    const postData = JSON.stringify(person)

    this.message = "开始 post 请求\n"
    let httpRequest = http.createHttp()

    httpRequest.on('headersReceive', (header) => {
      this.message += `header: ${JSON.stringify(header)}\n`
    });

    httpRequest.request(
      "http://192.168.8.197:8001/api?k1=v1&k2=v2",
      {
        header: {
          'Content-Type': 'application/json',
          'custom-header1': 'abc'
        },
        method: http.RequestMethod.POST,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 60_000,
        readTimeout: 60_000,
        extraData: postData,
      },
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          this.message += `result: ${JSON.stringify(data.result)}\n`
          this.message += `response code: ${data.responseCode}\n`
        } else {
          this.message += `error: ${JSON.stringify(err)}\n`
        }
        httpRequest.off('headersReceive')
        httpRequest.destroy()
      }
    );
  }

  build() {
    Column({space:10}) {
      Button("get").onClick(async () => {
        await this.get_sample()
      })

      Button("post").onClick(async () => {
        await this.post_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext
  filePath = this.context.filesDir + '/test.mp4'

  controller: VideoController = new VideoController()

  /*
   * HttpRequest - 用于 http 请求
   *   http.createHttp() - 创建一个 HttpRequest 实例
   *   on(), off() - 监听指定事件，取消监听指定事件
   *     headersReceive - 收到响应 header 后的事件
   *     dataReceiveProgress - 下载数据的进度发生变化时的回调，回调参数是一个 DataReceiveProgressInfo 对象
   *       receiveSize - 已下载数据的大小（单位：字节）
   *       totalSize - 数据的总大小（单位：字节）
   *     dataReceive - 流式接收到一部分数据后的回调，回调参数为此次接收到的 ArrayBuffer 数据
   *     dataEnd - 请求完成后的回调
   *   requestInStream() - 开始 http 请求（流式下载）
   *     url - url
   *     options - 选项（一个 HttpRequestOptions 对象）
   *     callback - 回调（回调参数是一个 BusinessError 对象和此次请求的 http 响应状态码）
   *   destroy() - 中断并销毁（注：请求完毕后需要调用此方法释放资源）
   */
  async download_file() {

    // 打开沙箱文件，文件不存在则创建，存在则清空，使用数据追加模式
    let file = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC | fs.OpenMode.APPEND)
    let fileOffset = 0

    this.message = "开始下载\n"
    let httpRequest = http.createHttp()

    httpRequest.requestInStream(
      "https://vjs.zencdn.net/v/oceans.mp4",
      {
        method: http.RequestMethod.GET,
      },
      // 无论成功还是失败，都会先走到 httpRequest.on('dataEnd') 然后再走到这里
      (err: BusinessError, responseCode: number) => {
        if (!err) {
          this.message += `response code: ${responseCode}\n`
        } else {
          this.message += `error: ${JSON.stringify(err)}\n`
        }
      }
    )

    httpRequest.on("dataReceiveProgress", (data: http.DataReceiveProgressInfo) => {
      MyLog.d(`dataReceiveProgress: ${data.receiveSize}/${data.totalSize}\n`)
    })

    httpRequest.on('dataReceive', async (data: ArrayBuffer) => {
      MyLog.d(`dataReceive: ${data.byteLength}\n`)

      // 追加数据到指定的沙箱文件
      let writeLength = await fs.write(file.fd, data, {
        offset: fileOffset,
        length: data.byteLength,
      })
      fileOffset += writeLength
    })

    httpRequest.on('dataEnd', async () => {
      this.message += `dataEnd\n`
      httpRequest.off('dataReceiveProgress')
      httpRequest.off('dataReceive')
      httpRequest.off('dataEnd')
      httpRequest.destroy()

      await fs.close(file)

      // 播放下载到沙箱目录后的视频文件
      this.controller.stop()
      this.controller.reset()
      this.controller.start()
    })
  }

  build() {
    Column({space:10}) {

      // 用于播放下载到沙箱目录后的视频文件
      Video({
        // 注：播放沙箱地址，别忘了加上 file://（能播的地址类似 file:///data/storage/el2/base/haps/entry/files/test.mp4）
        src: "file://" + this.filePath,
        controller: this.controller
      })
        .width('100%')
        .height(200)
        .autoPlay(true)
        .loop(true)
        .controls(true)
        .objectFit(ImageFit.Fill)

      Button("流式下载数据").onClick(async () => {
        await this.download_file()
      })

      Text(this.message)
    }
  }
}