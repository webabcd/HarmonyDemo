/*
 * FolderStack - 折叠屏悬停状态的堆叠布局（继承自 Stack）
 *   主要用于，当折叠屏悬停状态时，让指定的组件显示到上半屏，其他组件显示到下半屏，且会自动避让折痕区域
 *
 * 注：
 * 1、折叠屏的折叠状态有：完全折叠，完全展开，半折叠
 * 2、折叠屏的适配状态有：折叠，展开，悬停（悬停的意思是半折叠且横屏，如果是半折叠且竖屏则相当于展开状态）
 */

@Entry
@Component
struct FolderStackDemo {

  @State message_FoldStatus: string = 'FoldStatus'
  @State message_HoverEventParam: string = 'HoverEventParam'

  build() {
    Column() {
      // upperItems - 一个数组，用于指定当折叠屏悬停状态时，需要显示到上半屏的组件的 id 列表，其余组件会显示到下半屏
      FolderStack({ upperItems: ["upperItems1"] }) {
        // 当折叠屏悬停并且横屏时，下面的 Column 会显示到上半屏
        Column() {
          Text(`${this.message_FoldStatus}\n${this.message_HoverEventParam}`).height("100%").width("100%").textAlign(TextAlign.Center).fontSize(24)
        }.backgroundColor(Color.Orange).width("100%").height("100%").id("upperItems1")

        // 当折叠屏悬停状态时，下面的两个 Column 会显示到下半屏
        Column() {
          Text("top bar").width("100%").height(50).textAlign(TextAlign.Center).backgroundColor(Color.Red).fontSize(24)
        }.width("100%").height("100%").justifyContent(FlexAlign.Start)
        Column() {
          Text("bottom bar").width("100%").height(50).textAlign(TextAlign.Center).backgroundColor(Color.Red).fontSize(24)
        }.width("100%").height("100%").justifyContent(FlexAlign.End)
      }
      // 是否启动动画效果
      .enableAnimation(true)
      // 当折叠屏悬停状态时，是否需要自动将应用旋转为横屏
      .autoHalfFold(true)
      // 当折叠状态发生改变时的回调（FoldStatus 枚举）
      //   foldStatus - 当前的折叠状态
      //     FOLD_STATUS_UNKNOWN - 未知
      //     FOLD_STATUS_EXPANDED - 完全展开
      //     FOLD_STATUS_FOLDED - 完全折叠
      //     FOLD_STATUS_HALF_FOLDED - 半折叠
      .onFolderStateChange((status) => {
        this.message_FoldStatus = `foldStatus: ${status.foldStatus}\n`
      })
      // 进入或退出悬停状态时的回调（HoverEventParam 枚举）
      //   foldStatus - 当前的折叠状态
      //     FOLD_STATUS_UNKNOWN - 未知
      //     FOLD_STATUS_EXPANDED - 完全展开
      //     FOLD_STATUS_FOLDED - 完全折叠
      //     FOLD_STATUS_HALF_FOLDED - 半折叠
      //   isHoverMode - 当前是否是悬停状态
      //   appRotation - 当前应用的方向（AppRotation 枚举）
      //     ROTATION_0, ROTATION_90, ROTATION_180, ROTATION_270
      //   windowStatusType - 当前窗口模式（WindowStatusType 枚举）
      //     UNDEFINED, FULL_SCREEN, MAXIMIZE, MINIMIZE, FLOATING, SPLIT_SCREEN
      .onHoverStatusChange((status) => {
        this.message_HoverEventParam = `foldStatus: ${status.foldStatus}\n`
        this.message_HoverEventParam += `isHoverMode: ${status.isHoverMode}\n`
        this.message_HoverEventParam += `appRotation: ${status.appRotation}\n`
        this.message_HoverEventParam += `windowStatusType: ${status.windowStatusType}`
      })
      .backgroundColor(Color.Yellow)
    }
  }
}