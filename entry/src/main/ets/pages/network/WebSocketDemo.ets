/*
 * 通过 socket 实现一个 websocket server
 * 通过 WebSocket 实现一个 websocket client
 *
 * 注：本例中的 sha1 算法需要用到 ohpm install @ohos/crypto-js
 *
 * websocket 通信的流程
 * 1、客户端发送一个 http 请求（握手请求），用于表示客户端希望将连接升级为 websocket 协议
 * 包括的请求头有 Connection: Upgrade, Upgrade: websocket, Sec-WebSocket-Key: xxx 等
 * 2、服务端收到请求后，响应 101 Switching Protocols 表示协议升级成功（响应握手请求）
 * 包括的响应头有 Connection: Upgrade, Upgrade: websocket, Sec-WebSocket-Accept: 根据指定的算法生成的一个哈希值
 * 3、客户端检查 Sec-WebSocket-Accept 合法后则握手成功
 * 4、传输数据的基本单位是帧
 *   a) 帧包括帧头，掩码键，有效载荷等
 *   b) 帧头包括帧的类型（文本帧，二进制帧，关闭连接帧，ping帧，pong帧等），有效载荷的长度（存储这个长度值的空间可能占用 7 位或 7+16 位或 7+64 位）等
 *   c) 客户端发送的数据必须经过掩码处理（掩码处理就是通过掩码键对数据做异或操作），服务器发送的数据必须不能掩码处理
 *   d) 谁想关闭连接则需要发送关闭连接帧，接收方收到关闭连接帧后如果同意关闭则也要发送关闭连接帧，双方都发送和接收关闭帧后，则连接正式关闭
 */

import { TitleBar } from '../TitleBar'

import { socket, webSocket } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { webview } from '@kit.ArkWeb'
import { buffer } from '@kit.ArkTS'
import { CryptoJS } from '@ohos/crypto-js'

@Entry
@Component
struct WebSocketDemo {

  @State @Watch('onMessageUpdated') message: string = ""
  scroller: Scroller = new Scroller()
  controller: webview.WebviewController = new webview.WebviewController();
  onMessageUpdated(m: string): void {
    this.scroller.scrollEdge(Edge.Bottom)
  }

  // 创建一个 TCPSocketServer 对象
  tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance()
  // 握手成功的客户端列表
  clientList: socket.TCPSocketConnection[] = []

  aboutToAppear(): void {
    this.launchWebSocketServer()
  }

  // 启动 websocket 服务端
  launchWebSocketServer() {
    // 设置监听的 IP 地址和端口号
    let ipAddress: socket.NetAddress = {
      address: "0.0.0.0",
      port: 8888
    }

    // 开始监听 socket
    this.tcpServer.listen(ipAddress).then(() => {
      this.message += `监听端口成功，监听的端口号：${ipAddress.port}\n`
    }).catch((err: BusinessError) => {
      this.message += `监听端口失败：${err.message}\n`
    });

    // 监听客户端 socket 连接服务端 socket 的事件，如果需要取消监听则调用 .off("connect") 即可
    this.tcpServer.on("connect", (client: socket.TCPSocketConnection) => {
      this.message += `客户端 socket（${client.clientId}）连接到了服务端 socket\n`

      // 监听客户端 socket 发送数据到服务端 socket 的事件，如果需要取消监听则调用 .off("message") 即可
      client.on("message",  (value: socket.SocketMessageInfo)  => {
        if (!this.clientList.includes(client)) { // 尚未握手成功
          // 将客户端发来的数据转为字符串
          let requestData = buffer.from(value.message).toString('utf-8');
          this.message += `客户端发起握手请求\n`
          // 服务端响应握手
          this.handshake(client, requestData)
        } else { // 已经握手成功
          // 从客户端发来的数据中解析出有效载荷
          let requestData = parsePayload(value.message)
          this.message += `收到的客户端（${client.clientId}）发来的数据: ${requestData}\n`
        }
      });

      // 监听客户端 socket 的关闭事件，如果需要取消监听则调用 .off("close") 即可
      client.on("close", () => {
        this.message += `与客户端 socket（${client.clientId}）的连接关闭了\n`;
      });

      /*
      // 关闭与客户端 socket 的连接
      client.close().then(() => {
        this.message += `关闭与客户端 socket 的连接，成功\n`
      }).catch((err: BusinessError) => {
        this.message += `关闭与客户端 socket 的连接，失败: ${err.message}\n`
      });
      */
    });
  }

  // 服务端响应握手
  handshake(client: socket.TCPSocketConnection, requestData: string) {
    // 生成响应握手的数据
    let responseData = `HTTP/1.1 101 Switching Protocols\r\n` +
      `Upgrade: websocket\r\n` +
      `Connection: Upgrade\r\n` +
      `Sec-WebSocket-Accept: ${generateSecWebSocketAccept(requestData)}\r\n\r\n`;

    // 构造需要发给客户端的数据
    let tcpSendOptions: socket.TCPSendOptions = {
      data: responseData,
      encoding: 'utf-8'
    }

    // 向客户端 socket 发送握手数据
    client.send(tcpSendOptions).then(() => {
      this.message += `服务端响应握手，成功\n`
      this.clientList.push(client)
    }).catch((err: BusinessError) => {
      this.message += `服务端响应握手，失败: ${err.message}\n`
    });
  }

  // 向所有客户端发送数据
  sendToClient() {
    this.clientList.forEach(client => {
      client.send({
        data: constructWebSocketFrame(`timestamp: ${new Date().getTime()}`),
        encoding: 'utf-8'
      }).then(() => {
        this.message += `向客户端发送数据，成功\n`
      }).catch((err: BusinessError) => {
        this.message += `向客户端发送数据，失败: ${err.message}\n`
      });
    })
  }

  // 启动 websocket 客户端
  launchWebSocketClient() {
    let defaultIpAddress = "ws://127.0.0.1:8888/service";
    let ws = webSocket.createWebSocket();
    ws.on('open', (err:BusinessError, value: Object) => {
      ws.send("arkts 的 websocket 客户端发送数据到 arkts 的 websocket 服务端", (err: BusinessError, value: boolean) => {

      });
    });
    ws.on('message',(error: BusinessError, value: string | ArrayBuffer) => {
      this.message += `arkts 的 websocket 客户端收到数据: ${value}\n`
    });
    ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => { });
    ws.on('error', (err: BusinessError) => { });
    ws.connect(defaultIpAddress, {

    }, (err: BusinessError, value: boolean) => {

    });
    // ws.close((err: BusinessError) => { });
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Button("向所有客户端发送数据").onClick(() => {
        this.sendToClient()
      })

      Button("启动一个新的 websocket 客户端，并发送数据").onClick(() => {
        this.launchWebSocketClient()
      })

      Scroll(this.scroller) {
        Text(this.message)
      }
      .width('100%')
      .align(Alignment.TopStart)
      .backgroundColor(Color.Orange)
      .layoutWeight(1)

      Web({
        src: $rawfile('WebSocketClient.html'),
        controller: this.controller
      })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .backgroundColor(Color.Yellow)
        .layoutWeight(1)
        .onErrorReceive((event) => {
          this.message += `onErrorReceive errorCode:${event.error.getErrorCode()}, errorInfo:${event.error.getErrorInfo()}\n`
        })
    }
  }
}

// 用于生成 WebSocket 的 Sec-WebSocket-Accept
function generateSecWebSocketAccept(requestData: string): string {
  const keyMatch = requestData.match(/Sec-WebSocket-Key: (.+)/)
  if (keyMatch && keyMatch[1]) {
    let result = keyMatch[1] + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
    result = CryptoJS.enc.Base64.stringify(CryptoJS.SHA1(result))
    return result
  }
  return '';
}

function parsePayload(arrayBuffer: ArrayBuffer): string {
  // 解析帧头
  let myBuffer = buffer.from(arrayBuffer)
  const fin = (myBuffer[0] & 0x80) >> 7;
  const opcode = myBuffer[0] & 0x0f;
  const mask = (myBuffer[1] & 0x80) >> 7;

  // 解析有效载荷的长度，计算有效载荷的起始位置
  // 解析这个字节的后 7 位，如果值小于或等于 125，则此值就是有效载荷的长度
  // 解析这个字节的后 7 位，如果值为 126，则其后的 2 个字节是有效载荷的长度
  // 解析这个字节的后 7 位，如果值为 127，则其后的 8 个字节是有效载荷的长度
  let payloadLength = myBuffer[1] & 0x7f;
  let payloadStartIndex = 2;
  if (payloadLength === 126) {
    payloadLength = myBuffer.readUInt16BE(2);
    payloadStartIndex = 4;
  } else if (payloadLength === 127) {
    payloadLength = Number(myBuffer.readBigUInt64BE(2));
    payloadStartIndex = 10;
  }

  // 收到了关闭连接帧
  if (opcode === 0x8) {
    return '收到了关闭连接帧'
  }

  // 收到了 ping 帧（用于检测连接是否仍然有效）
  if (opcode === 0x9) {
    return '收到了 ping 帧'
  }

  // 收到了 pong 帧（对 ping 帧的响应）
  if (opcode === 0xA) {
    return '收到了 pong 帧'
  }

  // 如果不是最终帧，或者不是文本帧，则不处理
  if (fin !== 1 || opcode !== 0x1) {
    return '不是最终帧，或者不是文本帧'
  }

  // 读取掩码键，计算有效载荷的起始位置
  let maskKey: ArrayBuffer | null = null;
  if (mask === 1) {
    payloadStartIndex += 4;
    maskKey = arrayBuffer.slice(payloadStartIndex - 4, payloadStartIndex);
  }

  // 获取有效载荷的 buffer
  const payloadBuffer = buffer.from(arrayBuffer.slice(payloadStartIndex, payloadStartIndex + payloadLength));

  // 如果有效载荷经过掩码处理了，则通过掩码键解码
  if (maskKey) {
    for (let i = 0; i < payloadBuffer.length; i++) {
      payloadBuffer[i] ^= buffer.from(maskKey)[i % 4];
    }
  }

  // 将有效载荷转为字符串
  try {
    let payload = payloadBuffer.toString('utf8');
    return payload
  } catch (error) {
    return ''
  }
}

// 构造 WebSocket 帧
function constructWebSocketFrame(payload: string): ArrayBuffer {
  // 构造帧头
  const fin = 0x80;      // FIN=1（1 << 7）
  const opcode = 0x01;   // 文本帧
  const firstByte = fin | opcode;

  const mask = 0x00;     // 不用掩码
  let payloadLength = buffer.byteLength(payload);
  let secondByte = mask | payloadLength;  // 有效载荷的长度 <= 125 时

  // 构造 WebSocket 帧
  const frame = buffer.alloc(2 + payloadLength);
  frame.writeUInt8(firstByte, 0);
  frame.writeUInt8(secondByte, 1);
  frame.write(payload, 2, payload.length, 'utf-8');

  return frame.buffer;
}