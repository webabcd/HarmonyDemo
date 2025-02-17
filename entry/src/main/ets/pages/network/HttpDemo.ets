/*
 * http 请求
 */

import { TitleBar } from '../TitleBar';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct HttpDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('get/post').align(Alignment.Top)
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
    this.message = ""
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

    this.message = ""
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