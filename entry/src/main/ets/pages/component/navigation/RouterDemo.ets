/*
 * router - 路由接口，通过页面地址做路由
 *   页面需要用 @Entry 装饰，且需要在 main_pages.json 文件（在 module.json5 中通过 "pages":"$profile:main_pages" 指定的）中声明
 *
 * 官方建议可能的话最好使用 Navigation 组件做导航
 *
 * 注：本例演示的是如何通过页面地址做路由（必须是 @Entry 组件），如需要通过路由表做路由（允许非 @Entry 组件）请参见 NavigationDemo2.ets, NavigationDemo3.ets 中的说明
 */

import { TitleBar } from '../../TitleBar';
import { router } from '@kit.ArkUI'; // 实际导入的是 import router from '@ohos.router';

@Entry
@Component
struct RouterDemo {

  // 自定义转场动画（参见 /animation/PageTransitionDemo.ets 中的说明）
  pageTransition() {

  }

  @State message: string = ""

  onPageShow() {
    this.message += `RouterDemo pageId:${Math.floor(Math.random() * 1000).toString()}\n`
    this.message += `length:${router.getLength()}\n`
    this.message += `state:${JSON.stringify(router.getState())}\n`

    /*
     * queryRouterPageInfo() - 组件的内置方法，可以获取当前的 RouterPageInfo
     *   index - 当前页面在栈中的从栈底开始的索引位置（注：此处的索引是从 1 开始的）
     *   name - 当前页面的文件名称
     *   path - 当前页面的文件地址
     *   pageId - 由系统生成的当前页面的唯一标识
     *   state - 页面状态（一个 RouterPageState 枚举）
     *     ABOUT_TO_APPEAR - 页面即将显示
     *     ABOUT_TO_DISAPPEAR - 页面即将销毁
     *     ON_PAGE_SHOW - 页面显示了
     *     ON_PAGE_HIDE - 页面隐藏了
     *     ON_BACK_PRESS - 页面返回时
     */
    let routerPageInfo = this.queryRouterPageInfo()
    this.message += `routerPageInfo:${JSON.stringify(routerPageInfo)}\n`

    // 路由返回时需要弹出确认对话框，并指定对话框中显示的信息
    router.showAlertBeforeBackPage({
      message: '确认返回吗？'
    });
  }

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * router - 路由接口，通过页面地址做路由
       *   pushUrl() - 页面入栈
       *     options - 需要入栈的页面的信息（一个 RouterOptions 接口）
       *       url - 需要入栈的页面的地址
       *       params - 需要传递给入栈页面的数据
       *     mode - 入栈方式（RouterMode 枚举）
       *       Standard - 标准方式
       *       Single - 从栈顶到栈底查找，如果找到了目标页则将其移动到栈顶，找不动目标页则使用标准方式入栈
       *     callback - 此次路由结束后的回调（回调参数是一个 BusinessError 对象，如果入栈正常则此对象为 undefined）
       *       code - 错误代码
       *       message - 错误信息
       *   replaceUrl() - 销毁当前页面，并跳转到指定的页面，无转场动画
       *   back() - 返回到上一页，或返回到指定页并传递数据
       *   clear() - 当前栈仅保留当前页面，其他页面全部清除
       *   getLength() - 当前栈内的页面数量
       *   getState() - 获取栈顶的页面的信息（一个 RouterState 对象）
       *     index - 当前页面在栈中的从栈底开始的索引位置（注：此处的索引是从 1 开始的）
       *     name - 当前页面的文件名称
       *     path - 当前页面的文件地址
       *     params - 当前页面的传入参数
       *   showAlertBeforeBackPage() - 路由返回时需要弹出确认对话框，并指定对话框中显示的信息
       *   hideAlertBeforeBackPage() - 路由返回时不弹确认对话框
       */

      // 如果跳转到一个不存在的页面，则返回 100002 错误
      Button("pushUrl err").onClick(() => {
        router.pushUrl({
          url: 'xxx/xxx'
        }, router.RouterMode.Standard, (err) => {
          this.message += `errCode:${err.code}, errCode:${err.message}\n`
        })
      })

      // 跳转到指定的页面并传参
      Button("pushUrl").onClick(() => {
        router.pushUrl({
          url: 'pages/component/navigation/pages/RouterDemo_Page1',
          params: {
            p1: "p1",
            p2: "p2",
          }
        }, router.RouterMode.Standard, (err) => {
          // 跳转成功则 err 为 undefined
          this.message += `err:${err}\n`
        })
      })

      // 销毁当前页面，并跳转到指定的页面，无转场动画
      Button("replaceUrl").onClick(() => {
        router.replaceUrl({
          url: 'pages/component/navigation/pages/RouterDemo_Page1',
          params: {
            p1: "p1",
            p2: "p2",
          }
        }, router.RouterMode.Standard, (err) => {
          this.message += `err:${err}\n`
        })
      })

      // 返回到上一页
      Button("back 到上一页").onClick(() => {
        router.back()
      })

      // 返回到指定页并传递数据
      Button("back 到指定页").onClick(() => {
        router.back({
          url: 'pages/component/navigation/RouterDemo',
          params: {
            p1: "p111",
            p2: "p222",
          }
        })
      })

      // 当前栈仅保留当前页面，其他页面全部清除
      Button("clear").onClick(() => {
        router.clear()
      })

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1)
    }
  }
}
