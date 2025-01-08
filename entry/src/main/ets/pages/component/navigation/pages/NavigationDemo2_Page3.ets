/*
 * NavDestination - 导航组件（Navigation）导航到的目标页
 */

// 路由表中 routerMap 的 buildFunction 指定的 @Builder 函数，用于构造此路由指向的组件
// name - 路由名称
// param - 传递过来的数据
@Builder function navigationDemo2_page3_builder(name: string, param: Object) {
  NavigationDemo2_Page3()
}

@Component
struct NavigationDemo2_Page3 {

  /*
   * NavPathStack - 导航栈
   *   pushPath() - 将指定的页面入栈
   *     info - 入栈页面的信息（一个 NavPathInfo 对象）
   *     options - 选项（一个 NavigationOptions 对象）
   *       animated - 是否启用转场动画
   *       launchMode - 页面入栈的模式（LaunchMode 枚举）
   *         STANDARD - 标准的入栈
   *         MOVE_TO_TOP_SINGLETON - 从栈底向栈顶查找，如果存在相同名称的页面，则把这个相同名称的页面移动到栈顶，否则行为和 STANDARD 一样
   *         POP_TO_SINGLETON - 从栈底向栈顶查找，如果存在相同名称的页面，则路由会回退到这个相同名称的页面，否则行为和 STANDARD 一样
   *         NEW_INSTANCE - 保证使用新的页面实例入栈
   */
  navPathStack: NavPathStack = new NavPathStack()

  @State message: string = ""

  build() {
    NavDestination() {
      Column({space:10}) {

        Text(this.message)

        Button('LaunchMode.STANDARD').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page3',
          }, {
            launchMode: LaunchMode.STANDARD
          })
        })

        Button('LaunchMode.MOVE_TO_TOP_SINGLETON').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page3',
          }, {
            launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON
          })
        })

        Button('LaunchMode.POP_TO_SINGLETON').onClick(() => {
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page3',
          }, {
            launchMode: LaunchMode.POP_TO_SINGLETON
          })
        })

        Button('LaunchMode.NEW_INSTANCE').onClick(() => {
          // 连续操作导航栈时，会忽略中间过程，只显示最终的结果
          // 比如：
          // 1、先 pop 再通过 STANDARD 方式 push 相同名称的页面的话，系统会认为操作前后的结果一致从而不做任何处理
          // 2、先 pop 再通过 NEW_INSTANCE 方式 push 相同名称的页面的话，系统会先 pop 页面，然后再 push 一个新的页面实例
          this.navPathStack.pop()
          this.navPathStack.pushPath({
            name: 'navigationDemo2_page3',
          }, {
            launchMode: LaunchMode.NEW_INSTANCE
          })
        })
      }
    }
    .title('NavigationDemo2_Page3')
    .onReady((context: NavDestinationContext) => {
      this.navPathStack = context.pathStack;
      this.message = `navDestinationId:${context.navDestinationId}`
    })
  }
}