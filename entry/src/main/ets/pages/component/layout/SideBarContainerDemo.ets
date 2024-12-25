/*
 * SideBarContainer - 侧边栏容器（包含 2 个子组件，第 1 个子组件是侧边栏，第 2 个子组件是内容区）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct SideBarContainerDemo {

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      /*
       * SideBarContainer - 侧边栏容器（包含 2 个子组件，第 1 个子组件是侧边栏，第 2 个子组件是内容区）
       *   type - 侧边栏类型（SideBarContainerType 枚举）
       *     Embed - 侧边栏与内容区并列显示
       *     Overlay - 侧边栏覆盖在内容区之上
       *   sideBarPosition() - 侧边栏的位置（SideBarPosition 枚举）
       *     Start - 左侧
       *     End - 右侧
       *   divider() - 侧边栏与内容区之间的分隔线
       *     strokeWidth, color, startMargin, endMargin
       *     注：如果需要隐藏分隔线的话，就 divider(null) 即可
       *   showSideBar() - 是否显示侧边栏
       *   showControlButton() - 是否显示侧边栏的控制按钮（控制侧边栏的显示和隐藏）
       *   controlButton() - 侧边栏的控制按钮的样式
       *     top, left, width, height
       *     icons - 按钮的图标
       *       hidden - 侧边栏隐藏时的图标
       *       shown - 侧边栏显示时的图标
       *       switching - 侧边栏在显示和隐藏之间切换时的图标
       *   sideBarWidth() - 侧边栏的宽度
       *   minSideBarWidth() - 侧边栏的最小宽度
       *   maxSideBarWidth() - 侧边栏的最大宽度
       *   autoHide() - 当侧边栏被拖动到小于最小宽度后，是否自动隐藏
       *   minContentWidth() - 内容区的最小宽度
       *   onChange() - 侧边栏的显示和隐藏状态发生变化时的回调
       */
      SideBarContainer(SideBarContainerType.Embed) {
        // 侧边栏
        Column() {
          Text('1').fontSize(16)
          Text('2').fontSize(16)
          Text('3').fontSize(16)
          Text('4').fontSize(16)
          Text('5').fontSize(16)
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor(Color.Yellow)

        // 内容区
        Text('content area').fontSize(24)
      }
      .sideBarPosition(SideBarPosition.Start)
      .divider({
        strokeWidth: 5,
        color: Color.Orange,
        startMargin: 0,
        endMargin: 0
      })
      .showSideBar(true)
      .showControlButton(true)
      .controlButton({
        top: 0,
        left: 0,
        width: 24,
        height: 24,
        icons: {
          hidden: $r('app.media.ic_settings'),
          shown: $r('app.media.ic_settings'),
          switching: $r('app.media.ic_settings')
        }
      })
      .sideBarWidth(100)
      .minSideBarWidth(50)
      .maxSideBarWidth(200)
      .autoHide(true)
      .minContentWidth(0)
      .onChange((value: boolean) => {
        this.message = `onChange:${value}`
      })
    }
  }
}