/*
 * Web - 用于显示网页的组件
 * 本例用于演示 webview 的基础，以及 arkts 与 js 交互
 *
 * @ohos.web.webview - 用于提供网页的控制能力
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

import { TitleBar, MyLog } from '../../TitleBar';
import { webview } from '@kit.ArkWeb'; // 实际导入的是 import webview from '@ohos.web.webview';
import { BusinessError } from '@kit.BasicServicesKit';

// 在 Web 引擎初始化完成时触发，且后续再在同一应用中继续加载其他 Web 组件时不会再触发
webview.once("webInited", () => {
  MyLog.d("webInited");
})

@Entry
@Component
struct WebDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('arkts 与 js 交互').align(Alignment.Top)
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
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column({space:10}) {

      /*
       * Web - 用于显示网页的组件
       *   src - 网页地址（支持网络地址，也支持 file:// 沙箱地址，也支持 $rawfile 或 resource 资源地址）
       *   controller - 绑定的 WebviewController 对象
       *   javaScriptAccess() - 是否允许执行 javascript 脚本
       *   domStorageAccess() - 是否允许使用本地存储（localStorage 和 sessionStorage）
       *   fileAccess() - 是否允许访问文件系统（注：$rawfile 地址不受此限制）
       *   imageAccess() - 是否允许加载图片资源
       *   onPageBegin() - 页面加载开始时的回调
       *   onPageEnd() - 页面加载完成时的回到
       *   onTitleReceive() - 解析到 html 的 title 后的回调
       *   onProgressChange() - 页面加载的进度发生变化时的回调
       *   onErrorReceive() - 请求失败时的回调
       *   onHttpErrorReceive() - 请求成功，但是返回了 http 错误码时的回调
       */
      Web({
        src: 'https://www.openharmony.cn/',
        controller: this.controller
      })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onPageBegin((event) => {
          this.message += `onPageBegin url:${event.url}\n`
        })
        .onPageEnd((event) => {
          this.message += `onPageEnd url:${event.url}\n`
        })
        .onTitleReceive((event) => {
          this.message += `onTitleReceive title:${event.title}\n`
        })
        .onProgressChange((event) => {
          this.message += `onProgressChange newProgress:${event.newProgress}\n`
        })
        .height(300)

      Web({ src: 'https://err.err.err', controller: this.controller }).height(50)
        .onErrorReceive((event) => {
          // onErrorReceive errorCode:-106, errorInfo:ERR_INTERNET_DISCONNECTED, url:https://err.err.err/
          this.message += `onErrorReceive errorCode:${event.error.getErrorCode()}, errorInfo:${event.error.getErrorInfo()}, url:${event.request.getRequestUrl()}\n`
        })

      Web({ src: 'https://www.baidu.com/404.html', controller: this.controller }).height(50)
        .onHttpErrorReceive((event) => {
          // onHttpErrorReceive code:404, url:https://www.baidu.com/404.html
          this.message += `onHttpErrorReceive code:${event.response.getResponseCode()}, url:${event.request.getRequestUrl()}\n`
        })

      Scroll() {
        Text(this.message)
      }
      .backgroundColor(Color.Yellow)
      .layoutWeight(1)
    }
  }
}

// 用于转换为 js 对象并注册到 html 中
class MyClass {
  constructor() {
  }

  // 用于演示 js 调用 arkts
  js2arkts(name: string): string {
    return `hello:${name}`;
  }
}
@Component
struct MySample2 {

  @State message: string = ""
  controller: webview.WebviewController = new webview.WebviewController();
  @State myClass: MyClass = new MyClass();

  aboutToDisappear() {
    // 建议离开时取消相关 js 对象的注册
    this.controller.deleteJavaScriptRegister("jsObj");
  }

  build() {
    Column({space:10}) {

      Text(this.message)

      Button("arkts 调用 js").onClick(() => {
        // 执行指定的 js 代码
        this.controller.runJavaScript('arkts2js("webabcd")')
          .then((result) => {
            // 获取执行的 js 代码的返回值
            this.message = `result:${result}`
          })
          .catch((error: BusinessError) => {
            this.message = `errorCode:${error.code}, errorMessage:${error.message}`
          })
      })

      /*
       * Web - 用于显示网页的组件
       *   src - 网页地址（支持网络地址，也支持 file:// 沙箱地址，也支持 $rawfile 或 resource 资源地址）
       *   controller - 绑定的 WebviewController 对象
       *   javaScriptAccess() - 是否允许执行 javascript 脚本
       *   domStorageAccess() - 是否允许使用本地存储（localStorage 和 sessionStorage）
       *   fileAccess() - 是否允许访问文件系统（注：$rawfile 地址不受此限制）
       *   imageAccess() - 是否允许加载图片资源
       *   onControllerAttached() - 当 WebviewController 成功的绑定到 Web 组件之后的回调
       *
       * WebviewController - 用于和绑定的 Web 之间的交互
       *   registerJavaScriptProxy() - 将 js 对象注册到 html 中
       *   deleteJavaScriptRegister() - 取消指定的 js 对象的注册
       *   runJavaScript() - 执行指定的 js 代码
       *
       * 注：本例相关的 html 参见 /entry/src/main/resources/rawfile/html1.html
       */
      Web({ src: $rawfile('html1.html'), controller: this.controller })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .fileAccess(true)
        .imageAccess(true)
        .onControllerAttached(() => {
          // 将 myClass 转换为名为 jsObj 的 js 对象（并指定此 js 对象包括 js2arkts 方法），并注册到 html 中
          this.controller.registerJavaScriptProxy(this.myClass, "jsObj", ["js2arkts"]);
        })
    }
  }
}