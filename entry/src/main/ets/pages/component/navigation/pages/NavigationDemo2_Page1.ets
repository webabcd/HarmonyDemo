/*
 * NavDestination - 导航组件（Navigation）导航到的目标页
 */

import { LengthMetrics } from '@kit.ArkUI'

// 路由表中 routerMap 的 buildFunction 指定的 @Builder 函数，用于构造此路由指向的组件
// name - 路由名称
// param - 传递过来的数据
@Builder function navigationDemo2_page1_builder(name: string, param: Object) {
  NavigationDemo2_Page1({
    message: `路由名称:${name}, 参数:${param}\n\n`
  })
}

@Component
struct NavigationDemo2_Page1 {

  /*
   * NavPathStack - 导航栈
   *   replacePath() - 栈顶出栈，然后将指定的页面入栈
   *     info - 入栈页面的信息（一个 NavPathInfo 对象，关于 NavPathInfo 请参见 NavigationDemo2.ets 中的说明）
   *     options - 选项（一个 NavigationOptions 对象）
   *       animated - 是否支持转场动画
   *       launchMode - 页面入栈的模式
   *   replacePathByName(name: string, param: Object, animated?: boolean) - 栈顶出栈，然后将指定的页面入栈
   *   removeByName() - 让指定名称的所有页面出栈
   *   removeByIndexes() - 让指定的所有位置的页面出栈
   *   removeByNavDestinationId() - 让指定 navDestinationId 的页面出栈
   *   pop() - 出栈并传回数据（传回了数据则会触发入栈时的 onPop 回调，否则不触发）
   *   popToName() - 路由回退到从栈底开始的第一个指定名称的页面
   *   popToIndex() - 路由回退到指定索引位置的页面
   *   moveToTop() - 将从栈底开始的第一个指定名称的页面移动到栈顶
   *   moveIndexToTop() - 将指定索引位置的页面移动到栈顶
   *   clear() - 清理当前导航栈的全部页面
   *   size() - 导航栈中所有 NavDestination 的数量
   *   getAllPathName() - 导航栈中所有 NavDestination 的名称
   *   getParamByIndex() - 导航栈中指定索引位置的 NavDestination 的参数信息（入栈时传递过来的数据）
   *   getParamByName() - 导航栈中指定名称的所有 NavDestination 的参数信息（入栈时传递过来的数据）
   *   getIndexByName() - 导航栈中指定名称的所有 NavDestination 的索引位置
   *
   * 注：可以认为导航栈中的每个页面都是一个 NavDestination 组件（导航栈中不包含 Navigation 组件）
   */
  navPathStack: NavPathStack = new NavPathStack()

  navDestinationId: string = "0"

  @State message: string = ""

  build() {

    /*
     * NavDestination - 导航组件（Navigation）导航到的目标页
     *   onReady() - 当 NavDestination 构造子组件之前时的回调（回调参数是一个 NavDestinationContext 对象）
     *     pathInfo - 页面的信息（一个 NavPathInfo 对象，关于 NavPathInfo 请参见 NavigationDemo2.ets 中的说明）
     *     pathStack - 当前的导航栈（一个 NavPathStack 对象）
     *     navDestinationId - 当前 NavDestination 的标识（由系统自动生成）
     */
    NavDestination() {
      Column({space:10}) {

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { cross: LengthMetrics.vp(10) } }) {
          Button('pushPath').onClick(() => {
            this.navPathStack.pushPath({
              name: 'navigationDemo2_page1',
              param: "abc",
              onPop: (popInfo: PopInfo) => {
                this.message += `onPop name:${popInfo.info.name}, result:${popInfo.result}\n\n`
              }
            })
          })

          Button('replacePath').onClick(() => {
            this.navPathStack.replacePath({
              name: 'navigationDemo2_page1',
              param: "abc",
              onPop: (popInfo: PopInfo) => {
                this.message += `onPop name:${popInfo.info.name}, result:${popInfo.result}\n\n`
              }
            }, {
              animated: true,
              launchMode: LaunchMode.STANDARD
            })
          })

          Button('replacePathByName').onClick(() => {
            this.navPathStack.replacePathByName('navigationDemo2_page1', "abc", true)
          })

          Button('removeByName').onClick(() => {
            this.navPathStack.removeByName('navigationDemo2_page1')
          })

          Button('removeByIndexes').onClick(() => {
            this.navPathStack.removeByIndexes([this.navPathStack.size() - 1])
          })

          Button('removeByNavDestinationId').onClick(() => {
            this.navPathStack.removeByNavDestinationId(this.navDestinationId)
          })

          Button('pop').onClick(() => {
            // 出栈并传回数据，会触发入栈时的 onPop 回调
            //   第 1 个参数是传回的数据
            //   第 2 个参数用于说明是否启用转场动画
            //   返回值为出栈页面的信息（一个 NavPathInfo 对象，关于 NavPathInfo 请参见 NavigationDemo2.ets 中的说明）
            let info = this.navPathStack.pop("xyz", true);

            // 出栈但是不传回数据，不会触发入栈时的 onPop 回调
            // let info = this.navPathStack.pop(true);
          })

          Button('popToName').onClick(() => {
            // 路由回退到从栈底开始的第一个名为 navigationDemo2_page1 的页面
            //   第 1 个参数是指定的页面的名称
            //   第 2 个参数是传回的数据
            //   第 3 个参数用于说明是否启用转场动画
            //   返回值为从栈底开始的第一个名为 navigationDemo2_page1 的页面的索引位置，没有的话则返回 -1
            let index = this.navPathStack.popToName("navigationDemo2_page1", "xyz", true);
          })

          Button('popToIndex').onClick(() => {
            // 路由回退到索引位置为 0 的页面
            //   第 1 个参数是指定的页面的索引位置
            //   第 2 个参数是传回的数据
            //   第 3 个参数用于说明是否启用转场动画
            this.navPathStack.popToIndex(0, "xyz", true);
          })

          Button('moveToTop').onClick(() => {
            // 将从栈底开始的第一个名为 navigationDemo2_page1 的页面移动到栈顶
            //   第 1 个参数是指定的页面的名称
            //   第 2 个参数用于说明是否启用转场动画
            //   返回值为从栈底开始的第一个名为 navigationDemo2_page1 的页面的索引位置，没有的话则返回 -1
            let index = this.navPathStack.moveToTop("navigationDemo2_page1", true);
          })

          Button('moveIndexToTop').onClick(() => {
            // 将索引位置为 0 的页面移动到栈顶
            //   第 1 个参数是指定的页面的索引位置
            //   第 2 个参数用于说明是否启用转场动画
            this.navPathStack.moveIndexToTop(0, true);
          })

          Button('clear').onClick(() => {
            // 清理当前导航栈的全部页面
            //   第 1 个参数用于说明是否启用转场动画
            this.navPathStack.clear(true)
          })
        }

        Scroll() {
          Text(this.message)
        }
        .layoutWeight(1)
      }
    }
    .title('NavigationDemo2_Page1')
    .onReady((context: NavDestinationContext) => {
      this.navPathStack = context.pathStack
      this.navDestinationId = `${context.navDestinationId}`

      this.message += `navDestinationId:${context.navDestinationId}\n\n`
      this.message += `路由名称:${context.pathInfo.name}, 参数:${context.pathInfo.param}\n\n`
      this.message += `导航栈中所有 NavDestination 的数量:\n${this.navPathStack.size()}\n\n`
      this.message += `导航栈中所有 NavDestination 的名称:\n${JSON.stringify(this.navPathStack.getAllPathName())}\n\n`
      this.message += `导航栈中第 1 个 NavDestination 的参数信息:\n${JSON.stringify(this.navPathStack.getParamByIndex(0))}\n\n`
      this.message += `导航栈中指定名称的所有 NavDestination 的参数信息:\n${JSON.stringify(this.navPathStack.getParamByName("navigationDemo2_page1"))}\n\n`
      this.message += `导航栈中指定名称的所有 NavDestination 的索引位置:\n${JSON.stringify(this.navPathStack.getIndexByName("navigationDemo2_page1"))}\n\n`
    })
  }
}