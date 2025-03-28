/*
 * Web - 用于显示网页的组件
 * 本例用于演示 webview 的各种拦截
 */

import { TitleBar, MyLog } from '../../TitleBar';
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { promptAction } from '@kit.ArkUI';

webview.once("webInited", () => {
  MyLog.d("webInited");
})

@Entry
@Component
struct WebDemo2 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('alert/confirm/prompt/console 拦截').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('请求拦截，然后决定是否允许请求').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('请求拦截，然后下发自定义响应').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}


// 模拟 js 的 prompt 对话框
@CustomDialog
struct MyCustomDialog {
  controller?: CustomDialogController
  okClicked: (inputMessage: string) => void = (inputMessage: string) => {  }
  cancelClicked: () => void = () => {  }

  @State inputMessage: string = ""

  build() {
    Column({space:10}) {
      Text("onPrompt")
      TextInput({ text: $$this.inputMessage })
      Button('确认')
        .onClick(() => {
          this.okClicked(this.inputMessage)
        })
      Button('取消')
        .onClick(() => {
          this.cancelClicked()
        })
    }
  }
}
@Component
struct MySample1 {

  @State message: string = ""
  controller: webview.WebviewController = new webview.WebviewController();

  openPromptDialog(event:OnConfirmEvent) {
    let dialogController: CustomDialogController = new CustomDialogController({
      builder: MyCustomDialog({
        okClicked: (inputMessage)=> {
          // event.result.handlePromptConfirm() 点击了 prompt 的确认按钮，并传递用户输入的数据
          event.result.handlePromptConfirm(inputMessage)
          dialogController.close()
        },
        cancelClicked: ()=> {
          // event.result.handleCancel() 点击了 prompt 的取消按钮
          event.result.handleCancel()
          dialogController.close()
        },
      }),
      autoCancel: false,
    })
    dialogController.open()
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * Web - 用于显示网页的组件
       *   src - 网页地址（支持网络地址，也支持 file:// 沙箱地址，也支持 $rawfile 或 resource 资源地址）
       *   controller - 绑定的 WebviewController 对象
       *   javaScriptAccess() - 是否允许执行 javascript 脚本
       *   domStorageAccess() - 是否允许使用本地存储（localStorage 和 sessionStorage）
       *   fileAccess() - 是否允许访问文件系统（注：$rawfile 地址不受此限制）
       *   imageAccess() - 是否允许加载图片资源
       *   onConsole(), onAlert(), onConfirm(), onPrompt() - 拦截 js 的 console, alert, confirm, prompt
       *     return false 代表没处理，需要执行默认的行为
       *     return true 代表已处理，不需要执行默认的行为
       *
       * 注：本例相关的 html 参见 /entry/src/main/resources/rawfile/html2.html
       */
      Web({ src: $rawfile('html2.html'), controller: this.controller })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onConsole((event) => {
          /*
           * getMessageLevel() - console 的级别（debug 是 1，info 是 2，warn 是 3，error 是 4）
           * getMessage() - console 的信息
           * getSourceId() - 调用 console 的 url
           * getLineNumber() - 调用 console 的代码的所在行
           */
          this.message += `onConsole level:${event.message.getMessageLevel()}, message:${event.message.getMessage()}, url:${event.message.getSourceId()}, line:${event.message.getLineNumber()}\n`
          return true
        })
        .onAlert((event) => {
          AlertDialog.show({
            title: 'onAlert',
            message: event.message,
            autoCancel: false,
            secondaryButton: {
              value: '确认',
              // event.result.handleConfirm() 点击了 alert 的确认按钮
              action: () => { event.result.handleConfirm(); }
            }
          })
          return true
        })
        .onConfirm((event) => {
          AlertDialog.show({
            title: 'onConfirm',
            message: this.message,
            autoCancel: false,
            primaryButton: {
              value: '取消',
              // event.result.handleCancel() 点击了 confirm 的取消按钮
              action: () => { event.result.handleCancel(); }
            },
            secondaryButton: {
              value: '确认',
              // event.result.handleConfirm() 点击了 confirm 的确认按钮
              action: () => { event.result.handleConfirm(); }
            },
          })
          return true;
        })
        .onPrompt((event) => {
          this.openPromptDialog(event)
          return true;
        })
    }
  }
}


@Component
struct MySample2 {

  @State message: string = ""
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * Web - 用于显示网页的组件
       *   onLoadIntercept(), onOverrideUrlLoading() - 请求 url 之前的回调，可以决定是否允许此次请求
       *     return true - 代表已处理，不需要执行默认的行为
       *     return false - 代表没处理，需要执行默认的行为
       *
       * WebResourceRequest - 请求对象
       *   getRequestUrl() - 此次请求的 url
       *   getRequestHeader() - 此次请求的 header
       *   getRequestMethod() - 此次请求的 method
       *   isRedirect() - 此次请求是否被服务端重定向
       *   isMainFrame() - 此次请求是否为主 frame 发起
       */
      Web({ src: $rawfile('html3.html'), controller: this.controller })
        .onLoadIntercept((event) => {
          let webResourceRequest: WebResourceRequest = event.data // 获取此次请求的 WebResourceRequest 对象
          const url: string = webResourceRequest.getRequestUrl()
          this.message += `onLoadIntercept: ${url}\n`
          // 允许此次请求，不允许的话则 return true 即可
          return false
        })
        .onOverrideUrlLoading((webResourceRequest: WebResourceRequest) => {
          const url: string = webResourceRequest.getRequestUrl()
          this.message += `onOverrideUrlLoading: ${url}\n`
          // 允许此次请求，不允许的话则 return true 即可
          return false
        })
    }
  }
}


@Component
struct MySample3 {

  @State message: string = ""
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * Web - 用于显示网页的组件
       *   onInterceptRequest() - 拦截所有请求，并根据需要使用默认响应（return null），或使用自定义响应（return 一个 WebResourceResponse 对象）
       *
       * WebResourceRequest - 请求对象
       *   getRequestUrl() - 此次请求的 url
       *   getRequestHeader() - 此次请求的 header
       *   getRequestMethod() - 此次请求的 method
       *   isRedirect() - 此次请求是否被服务端重定向
       *   isMainFrame() - 此次请求是否为主 frame 发起
       *
       * WebResourceResponse - 自定义响应对象
       *   setResponseData() - 响应的数据
       *   setResponseHeader() - 响应头
       *   setResponseMimeType() - 响应的 mime 类型
       *   setResponseEncoding() - 响应的编码方式
       *   setResponseCode(), setReasonMessage() - 响应的状态码，和此状态码的说明
       *   setResponseIsReady() - 用于说明当前响应是否已经准备就绪
       *     true - 返回 WebResourceResponse 对象后，立即下发响应
       *     false - 返回 WebResourceResponse 对象后，等待，直到设置为 true 才下发响应
       */
      Web({ src: $rawfile('html3.html'), controller: this.controller })
        .onInterceptRequest((event) => {
          let webResourceRequest: WebResourceRequest = event.request // 获取此次请求的 WebResourceRequest 对象

          // 使用本地资源作为自定义响应
          if (webResourceRequest.getRequestUrl() == "http://aaa.bbb.ccc/abc.jpg") {
            let response = new WebResourceResponse();
            response.setResponseData($rawfile('son.jpg'))
            response.setResponseMimeType("image/jpeg")
            response.setResponseCode(200)
            response.setReasonMessage('OK')
            response.setResponseIsReady(true)
            return response
          }
          // 使用网络资源作为自定义响应
          else if (webResourceRequest.getRequestUrl() == "http://aaa.bbb.ccc/xyz.jpg") {
            let response = new WebResourceResponse()
            response.setResponseIsReady(false) // 先要设置为 false
            let httpRequest = http.createHttp()
            httpRequest.request(
              "https://res-static.hc-cdn.cn/cloudbu-site/china/zh-cn/hdhomeportal/logonew.png",
              {
                method: http.RequestMethod.GET,
                expectDataType: http.HttpDataType.ARRAY_BUFFER,
              },
              (err: BusinessError, data: http.HttpResponse) => {
                response.setResponseData(data.result as ArrayBuffer)
                response.setResponseMimeType('image/png')
                response.setResponseCode(200)
                response.setReasonMessage('OK')
                response.setResponseIsReady(true) // 网络资源请求成功后，并构造好了 WebResourceResponse 对象，则设置为 true
              }
            );
            return response;
          }
          // 使用自定义 html 作为自定义响应
          else if (webResourceRequest.getRequestUrl() == "http://developer.huawei.com/") {
            let response = new WebResourceResponse()
            response.setResponseData('<p style="font-size: 64px;">hello webabcd</p>')
            response.setResponseEncoding('utf-8')
            response.setResponseMimeType("text/html")
            response.setResponseCode(200)
            response.setReasonMessage('OK')
            response.setResponseIsReady(true)
            return response;
          }
          // 可以拦截自定义协议跳转
          else if (webResourceRequest.getRequestUrl() == "custom://a.b.c/") {
            promptAction.showToast({
              message: "custom://a.b.c/",
              duration: 3000
            })
            return null;
          }

          // 使用默认响应
          return null;
        })
    }
  }
}
