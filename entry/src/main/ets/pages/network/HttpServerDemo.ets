/*
 * 通过 socket 实现一个 http server
 */

import { MyLog, TitleBar } from '../TitleBar'

import { socket } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { webview } from '@kit.ArkWeb'
import { buffer } from '@kit.ArkTS'

@Entry
@Component
struct HttpServerDemo {

  @State message: string = ""
  controller: webview.WebviewController = new webview.WebviewController();

  // 创建一个 TCPSocketServer 对象
  tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance()

  aboutToAppear(): void {

    // 设置监听的 IP 地址和端口号
    let ipAddress: socket.NetAddress = {
      address: "0.0.0.0",
      port: 8080
    }

    // 开始监听 socket（需要 ohos.permission.INTERNET 权限）
    this.tcpServer.listen(ipAddress).then(() => {
      this.message += `监听端口成功，监听的端口号：${ipAddress.port}\n`
    }).catch((err: BusinessError) => {
      this.message += `监听端口失败：${err.message}\n`
    });

    // 监听客户端 socket 连接服务端 socket 的事件，如果需要取消监听则调用 .off("connect") 即可
    this.tcpServer.on("connect", (client: socket.TCPSocketConnection) => {
      this.message += `客户端 socket 连接到了服务端 socket\n`

      // 监听客户端 socket 发送数据到服务端 socket 的事件，如果需要取消监听则调用 .off("message") 即可
      client.on("message",  (value: socket.SocketMessageInfo)  => {

        // 将客户端发来的数据转为字符串
        let requestData = buffer.from(value.message).toString('utf-8')
        MyLog.d(`收到的客户端发来的数据: ${requestData}`)
        this.message += `收到的客户端发来的数据的前 20 个字符: ${requestData.substring(0, 20)}\n`

        // 解析 http 请求并生成响应数据
        let responseData = 'HTTP/1.1 200 OK\r\n' +
          'Content-Type: text/html\r\n\r\n' +
          '<head>\n' +
          '<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">\n' +
          '</head>\n' +
          'request data: <br />' +
          requestData

        // 构造需要发给客户端的数据
        let tcpSendOptions: socket.TCPSendOptions = {
          data: responseData,
          encoding: 'utf-8'
        }

        // 向客户端 socket 发送数据
        client.send(tcpSendOptions).then(() => {
          this.message += `向客户端 socket 发送数据，成功\n`
        }).catch((err: BusinessError) => {
          this.message += `向客户端 socket 发送数据，失败: ${err.message}\n`
        }).finally(() => {
          // 关闭与客户端 socket 的连接
          client.close().then(() => {
            this.message += `关闭与客户端 socket 的连接，成功\n`
          }).catch((err: BusinessError) => {
            this.message += `关闭与客户端 socket 的连接，失败: ${err.message}\n`
          });
        });
      });

      // 监听客户端 socket 的关闭事件，如果需要取消监听则调用 .off("close") 即可
      client.on("close", () => {
        this.message += '与客户端 socket 的连接关闭了\n';
      });
    });
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Web({
        src: 'http://127.0.0.1:8080/xxx?k1=v1',
        controller: this.controller
      })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onErrorReceive((event) => {
          this.message += `onErrorReceive errorCode:${event.error.getErrorCode()}, errorInfo:${event.error.getErrorInfo()}\n`
        })
    }
  }
}