/*
 * http 请求
 * 本例用于演示如何通过 rcp 实现 http 请求，进阶
 * 相对于 Network Kit 的 HttpRequest 来说，通过 Remote Communication Kit 的 rcp 实现 http 请求会更简单且功能更强大
 *
 * 需要在 src/main/module.json5 中添加 ohos.permission.INTERNET 权限
 */

import {  TitleBar } from '../TitleBar';
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';

@Entry
@Component
struct RcpDemo2 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('自动重定向').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('收集每个阶段耗费的时间').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('监听请求的过程').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('指定 dns 服务器').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('拦截并修改请求和响应').align(Alignment.Top)
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
   * rcp.Request - http 请求的请求对象
   *   configuration.transfer - 可以设置自动重定向的相关参数
   *     autoRedirect - 是否自动重定向（默认值为 true）
   *     maxAutoRedirects - 自动重定向的最大次数（默认值为 50）
   * 注：在 rcp.createSession() 时也可以设置 requestConfiguration 参数，但是如果有冲突则以 rcp.Request 中的设置为准
   *
   * rcp.Response - http 请求的响应对象
   *   effectiveUrl - 重定向之后的 url
   *
   * rcp.Request - http 请求的请求对象
   *   url - 请求的 url
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://192.168.8.197:8001/redirect", 'GET');
    request.configuration = {
      transfer: {
        autoRedirect: true,
        maxAutoRedirects: 50,
      }
    }

    const session = rcp.createSession()
    session.fetch(request).then((response: rcp.Response) => {
      this.message += `response result: ${response.toString()}\n`
      this.message += `original url: ${request.url.toString()}\n`
      this.message += `effective url: ${response.effectiveUrl}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("自动重定向").onClick(async () => {
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
   *   configuration.tracing - 可以设置是否需要收集每个阶段耗费的时间
   *     collectTimeInfo - 是否需要收集每个阶段耗费的时间（默认值为 false）
   * 注：在 rcp.createSession() 时也可以设置 requestConfiguration 参数，但是如果有冲突则以 rcp.Request 中的设置为准
   *
   * rcp.Response - http 请求的响应对象
   *   timeInfo - 当 collectTimeInfo 设置为 true 时，此对象会保存请求的每个阶段耗费的时间
   *     nameLookupTimeMs - 从发起请求到 dns 完成时的耗时（单位：毫秒）
   *     connectTimeMs - 从发起请求到连接完成时的耗时（单位：毫秒）
   *     tlsHandshakeTimeMs - 从发起请求到 tls 握手完成时耗时（单位：毫秒）
   *     preTransferTimeMs - 从发起请求到服务端接收到业务数据时的耗时（单位：毫秒）
   *     startTransferTimeMs - 从发起请求到从服务端接收到首包时的耗时（单位：毫秒）
   *     totalTimeMs - 从发起请求到结束时的总耗时（单位：毫秒）
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://192.168.8.197:8001/api", 'GET');
    request.configuration = {
      tracing: {
        collectTimeInfo: true
      }
    }

    const session = rcp.createSession()
    session.fetch(request).then((response) => {
      this.message += `response result: ${response.toString()}\n`

      if (response.timeInfo) {
        this.message += `nameLookupTimeMs: ${response.timeInfo.nameLookupTimeMs}\n`
        this.message += `connectTimeMs: ${response.timeInfo.connectTimeMs}\n`
        this.message += `tlsHandshakeTimeMs: ${response.timeInfo.tlsHandshakeTimeMs}\n`
        this.message += `preTransferTimeMs: ${response.timeInfo.preTransferTimeMs}\n`
        this.message += `startTransferTimeMs: ${response.timeInfo.startTransferTimeMs}\n`
        this.message += `totalTimeMs: ${response.timeInfo.totalTimeMs}\n`
      }

    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("收集每个阶段耗费的时间").onClick(async () => {
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
   *   configuration.tracing - 可以设置监听请求的过程
   *     httpEventsHandler - 监听请求的过程
   *       onDataReceive - 流式接收到一部分数据后的回调，回调参数为此次接收到的 ArrayBuffer 数据
   *       onUploadProgress - 上传进度发生变化时的回调
   *       onDownloadProgress - 下载进度发生变化时的回调
   *       onHeaderReceive - 收到 header 时的回调
   *       onDataEnd - 请求结束时的回调
   *       onCanceled - 请求取消时的回调
   * 注：在 rcp.createSession() 时也可以设置 requestConfiguration 参数，但是如果有冲突则以 rcp.Request 中的设置为准
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"

    const request = new rcp.Request("http://192.168.8.197:8001/api", 'GET');
    request.configuration = {
      tracing: {
        httpEventsHandler: {
          onDataReceive: (incomingData: ArrayBuffer) => {
            // 注：每次接收到一部分数据都会触发 onDataReceive 回调，本例只是为了演示才直接把其转为字符串
            this.message += `onDataReceive: ${buffer.from(incomingData).toString('utf-8')}\n`
          },
          onUploadProgress: (totalSize: number, transferredSize: number) => {
            this.message += `onUploadProgress: ${transferredSize}/${totalSize}\n`
          },
          onDownloadProgress: (totalSize: number, transferredSize: number) => {
            this.message += `onDownloadProgress: ${transferredSize}/${totalSize}\n`
          },
          onHeaderReceive: (headers: rcp.ResponseHeaders) => {
            this.message += `onHeaderReceive: ${JSON.stringify(headers)}\n`
          },
          onDataEnd: () => {
            this.message += `onDataEnd\n`
          },
          onCanceled: () => {
            this.message += `onCanceled\n`
          }
        }
      }
    }

    const session = rcp.createSession()
    session.fetch(request).then((response) => {
      // 注：如果监听了 onDataReceive 回调，则无法再通过 response 的 boyd 或 toString() 或 toJSON() 获取响应结果
      this.message += `response result: ${response.toString()}\n`
    }).catch((err: BusinessError) => {
      this.message += `error: ${JSON.stringify(err)}\n`
    }).finally(() => {
      session.close()
    });
  }

  build() {
    Column({space:10}) {

      Button("监听请求的过程").onClick(async () => {
        await this.fetch_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  /*
   * rcp.Request - http 请求的请求对象
   *   configuration.dns - 可以设置 dns 的相关参数
   *     dnsRules - 设置 dns 服务器
   * 注：在 rcp.createSession() 时也可以设置 requestConfiguration 参数，但是如果有冲突则以 rcp.Request 中的设置为准
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://www.baidu.com", 'GET');
    request.configuration = {
      dns: {
        dnsRules: [
          {
            ip: '114.114.114.114', // dns 的 ip 地址
            port: 53, // dns 的端口号
          },
          {
            ip: '8.8.8.8', // dns 的 ip 地址
            port: 53, // dns 的端口号
          },
        ]
      }
    }

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

      Button("指定 dns 服务器").onClick(async () => {
        await this.fetch_sample()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  /*
   * rcp.createSession() - 创建一个 rcp.Session 对象
   *   interceptors - 指定当前 session 的拦截器
   */
  async fetch_sample() {
    this.message = "通过 fetch 做 http 请求\n"
    const request = new rcp.Request("http://192.168.8.197:8001/api", 'GET');

    const session = rcp.createSession({
      interceptors: [
        new MyInterceptor()
      ]
    })
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

      Button("拦截并修改请求和响应").onClick(async () => {
        await this.fetch_sample()
      })

      Text(this.message)
    }
  }
}
// 自定义拦截器
export class MyInterceptor implements rcp.Interceptor {

  // 拦截并修改请求和响应
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {

    // 拦截并修改请求
    context.request.headers = {
      'custom-header1': 'xyz'
    }

    // 开始请求
    const response = await next.handle(context);

    // 拦截并修改响应
    const toReturn: rcp.Response = {
      request: response.request,
      statusCode: response.statusCode,
      httpVersion: response.httpVersion,
      headers: response.headers,
      effectiveUrl: response.effectiveUrl,
      timeInfo: response.timeInfo,
      toJSON: () => response.toJSON(),
      toString: () => "修改后的响应结果 " + response.toString(),
    };

    return toReturn;
  }
}