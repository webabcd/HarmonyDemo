/*
 * http 请求
 * 本例用于演示如何通过 rcp 实现 http 请求，基础
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

import {  TitleBar } from '../TitleBar';
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct RcpDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('get/post/fetch').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('自定义 headers, cookies 等').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('超时时间').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('取消请求').align(Alignment.Top)
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
   * rcp.Session - 用于实现 http 请求的对象
   *   get(), post(), put(), head(), delete() - 发起指定的 http 请求
   *   fetch() - 通过 fetch 发起 http 请求
   *   close() - 关闭请求对象（注：如果 session 不再使用了，则需要调用此方法释放资源）
   * 注：一个 session 可以同时发起多个 http 请求，当某个 session 的所有请求都完成了再调用 close() 释放资源
   *
   * rcp.Response - http 请求的响应对象
   *   request - http 请求的请求对象
   *   statusCode - 响应的状态码
   *   headers - 响应的 header
   *   cookies - 响应的 cookie
   *   body - 响应的数据（一个 ArrayBuffer 对象）
   *   toString() - 将响应的数据转为字符串
   *   toJSON() - 将响应的数据转为 json 对象
   *
   * rcp.Request - http 请求的请求对象
   *   id - 请求的唯一标识，由系统生成
   *   url - 请求的 url
   *   method - 请求的方法
   *   headers - 请求的 header
   *   cookies - 请求的 cookie
   *   content - 请求的内容，比如 post 的数据
   *     可以是 string 或 ArrayBuffer 或 Form 或 object 等
   */

  async get_sample() {
    this.message = "开始 get 请求\n"

    const session: rcp.Session = rcp.createSession()
    session.get("http://192.168.8.197:8001/api?k1=v1&k2=v2").then((response: rcp.Response) => {
      this.message += `response code: ${response.statusCode}\n`
      this.message += `response string: ${response.toString()}\n`
      this.message += `response length: ${response.body?.byteLength}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  async post_sample() {
    this.message = "开始 post 请求\n"
    const postData: rcp.RequestContent = {
        name: "webabcd",
        age: 44,
    }

    const session = rcp.createSession()
    session.post("http://192.168.8.197:8001/api?k1=v1&k2=v2", postData).then((response) => {
      this.message += `response result: ${response.toString()}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://192.168.8.197:8001/api?k1=v1&k2=v2", 'POST');
    request.content = "post data"

    const session = rcp.createSession()
    session.fetch(request).then((response) => {
      this.message += `response result: ${response.toString()}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {
      Button("get").onClick(async () => {
        await this.get_sample()
      })

      Button("post").onClick(async () => {
        await this.post_sample()
      })

      Button("fetch").onClick(async () => {
        await this.fetch_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  /*
   * rcp.Request - http 请求的请求对象
   *   id - 请求的唯一标识，由系统生成
   *   url - 请求的 url
   *   method - 请求的方法
   *   headers - 请求的 header
   *   cookies - 请求的 cookie
   *   content - 请求的内容，比如 post 的数据
   *     可以是 string 或 ArrayBuffer 或 Form 或 object 等
   *
   * rcp.createSession() - 创建一个 rcp.Session 对象
   *   headers - 请求的 header（此处的 header 会合并到 rcp.Request 的 header 中，同名的则以 rcp.Request 中的为准）
   *   cookies - 请求的 cookie（此处的 cookie 会合并到 rcp.Request 的 cookie 中，同名的则以 rcp.Request 中的为准）
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://192.168.8.197:8001/api?k1=v1&k2=v2");
    request.method = 'POST'
    request.headers = {
      'custom-header1': 'abc'
    }
    request.cookies = { }
    request.content = "post data"

    let session = rcp.createSession()
    session.fetch(request).then((response) => {
      this.message += `response result: ${response.toString()}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("自定义 headers, cookies 等").onClick(async () => {
        await this.fetch_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  /*
   * rcp.Request - http 请求的请求对象
   *   configuration.transfer.timeout - 请求的超时时间
   *     connectMs - 连接的最大时间，单位：毫秒
   *     transferMs - 数据传输的最大时间，单位：毫秒
   *     inactivityMs - 无数据传输的最大时间，单位：毫秒
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://192.168.8.197:8001/api?k1=v1&k2=v2");
    request.configuration = {
      transfer: {
        timeout: {
          connectMs: 1000,
          transferMs: 2000,
          inactivityMs: 3000
        }
      }
    }

    let session = rcp.createSession()
    session.fetch(request).then((response) => {
      this.message += `response result: ${response.toString()}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("超时时间").onClick(async () => {
        await this.fetch_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""
  session?: rcp.Session

  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request: rcp.Request = new rcp.Request("http://192.168.8.197:8001/api?k1=v1&k2=v2", 'GET');
    this.session = rcp.createSession()
    this.session.fetch(request).then((response) => {
      this.message += `response result: ${response.toString()}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      this.session?.close()
    });
  }

  /*
   * rcp.Session - 用于实现 http 请求的对象
   *   cancel() - 取消当前 session 的全部请求
   *   cancel(rcp.Request) - 取消当前 session 的指定的 rcp.Request 请求
   */
  async cancel() {
    this.session?.cancel()
    // this.session?.cancel(rcp.Request)
    this.session = undefined
  }

  build() {
    Column({space:10}) {

      Button("fetch").onClick(async () => {
        await this.fetch_sample()
      })

      Button("cancel").onClick(async () => {
        await this.cancel()
      })

      Text(this.message)
    }
  }
}