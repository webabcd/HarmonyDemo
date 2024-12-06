/*
 * Popup - 弹出框
 */

import { TitleBar } from '../../TitleBar'
import { Popup } from '@kit.ArkUI'

@Entry
@Component
struct PopupDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('独立的 Popup').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('与组件绑定的 Popup').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('与组件绑定的自定义的 Popup').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column() {

      Text(this.message).fontSize(16)

      /*
       * Popup - 弹出框（独立的 Popup，具体的行为和显示位置等都需要自己写）
       *   direction - 布局方向（Direction 枚举）
       *     Auto - 使用系统的默认布局方向
       *     Ltr - 从左到右布局
       *     Rtl - 从右到左布局
       *   icon - 图标（一个 PopupIconOptions 对象）
       *     image - 图标图片
       *     width, height - 宽高
       *     fillColor - 填充色
       *     borderRadius - 边框半径
       *   title - 标题（一个 PopupTextOptions 对象）
       *     text - 标题文本
       *     fontSize, fontColor, fontWeight - 字体样式
       *   message - 内容（一个 PopupTextOptions 对象）
       *     text - 内容文本
       *     fontSize, fontColor, fontWeight - 字体样式
       *   showClose - 是否显示关闭按钮
       *   onClose - 点击关闭按钮后的回调
       *   buttons - 按钮集合（PopupButtonOptions 对象的集合），最多支持 2 个按钮
       *     text - 按钮文本
       *     fontSize, fontColor - 字体样式
       *     action - 按钮点击后的回调
       */
      Popup({
        direction: Direction.Ltr,
        icon: {
          image: $r('app.media.ic_settings'),
          width:32,
          height:32,
          fillColor:Color.Orange,
          borderRadius: 2
        },
        title: {
          text: 'title',
          fontSize: 24,
          fontColor: Color.Black,
          fontWeight: 400
        },
        message: {
          text: 'message',
          fontSize: 16,
          fontColor: Color.Black,
          fontWeight: 400
        },
        showClose: true,
        onClose: () => {
          this.message = "onClose()"
        },
        buttons: [
          {
            text: 'button1',
            fontSize: 16,
            fontColor: Color.Black,
            action: () => {
              this.message = "button1 clicked"
            },
          },
          {
            text: 'button2',
            fontSize: 16,
            fontColor: Color.Black,
            action: () => {
              this.message = "button2 clicked"
            },
          },
        ],
      })
    }
  }
}

@Component
struct MySample2 {

  @State popupVisible: boolean = false
  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      /*
       * bindPopup() - 弹出框（与组件绑定的 Popup）
       *   show - 是否显示
       *   popup - 弹出框（一个 PopupOptions 对象）
       *     placement - 弹出框相对于绑定的组件的显示位置（Placement 枚举）
       *       Left, Right, Top, Bottom, TopLeft, TopRight, BottomLeft, BottomRight, LeftTop, LeftBottom, RightTop, RightBottom
       *     showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 的所属窗口之外）
       *     targetSpace - 弹出框在原有位置的基础上与绑定的组件之间的距离
       *     offset - 弹出框在当前位置的基础上的偏移距离

       *     mask - 弹出框的遮罩层的颜色
       *     popupColor - 弹出框的背景色
       *     radius - 弹出框的圆角半径
       *     shadow - 弹出框的阴影效果
       *     backgroundBlurStyle - 弹出框的背景的模糊效果
       *
       *     message - 内容
       *     messageOptions - 内容的相关选项（一个 PopupMessageOptions 对象）
       *       textColor - 颜色
       *       font - 字体（size, style, weight, family）
       *
       *     enableArrow - 是否显示箭头
       *     arrowHeight - 箭头高度
       *     arrowWidth - 箭头宽度
       *     arrowPointPosition - 箭头位置（ArrowPointPosition 枚举）
       *       START - 箭头位于绑定组件的左侧
       *       CENTER - 箭头位于绑定组件的中间
       *       END - 箭头位于绑定组件的右侧
       *     arrowOffset - 箭头相对于绑定组件的左侧的距离（在不指定 arrowPointPosition 的时候 arrowOffset 才会生效）
       *
       *     transition - 弹出框的显示消失的动画效果（TransitionEffect 对象）
       *       注：关于 TransitionEffect 的使用请参见 TransitionDemo.ets 中的说明
       *
       *     autoCancel - 点击非弹出框区域时是否自动隐藏
       *     onWillDismiss - 通过用户行为关闭弹出框之前的回调（回调参数是一个 DismissDialogAction 对象）
       *       reason - 弹窗将要关闭的原因
       *         PRESS_BACK - 点击返回按钮，手机侧边左滑/右滑，键盘 esc 键
       *         TOUCH_OUTSIDE - 点击非弹框区域
       *         CLOSE_BUTTON - 点击关闭按钮
       *         SLIDE_DOWN - 半模态转场时通过下拉关闭
       *       dismiss() - 确认关闭弹出框（如果设置了 onWillDismiss 回调，则只有调用 dismiss() 后才会关闭弹出框）
       *     primaryButton, secondaryButton - 两个按钮
       *       value - 按钮上显示的文字
       *       action - 按钮被点击后的回调
       *     onStateChange - 弹出框是否显示的状态发生变化时的回调
       *       e.isVisible - 弹出框是否是显示状态
       */
      Button('click me')
        .onClick(() => {
          this.popupVisible = !this.popupVisible
        })
        .bindPopup(this.popupVisible, {
          placement: Placement.Bottom,
          showInSubWindow: false,
          targetSpace: 10,
          offset: {
            x: 0,
            y: 0,
          },

          mask: {
            color: Color.Transparent
          },
          popupColor: Color.Orange,
          radius: 20,
          shadow: ShadowStyle.OUTER_DEFAULT_XS,
          backgroundBlurStyle: BlurStyle.Thin,

          message: 'message',
          messageOptions: {
            textColor: Color.Red,
            font: {
              size: '16',
              style: FontStyle.Italic,
              weight: FontWeight.Bolder,
              family: "HarmonyOS Sans"
            }
          },

          enableArrow: true,
          arrowHeight: 10,
          arrowWidth: 50,
          arrowPointPosition: ArrowPointPosition.CENTER,
          arrowOffset: 0,

          transition:TransitionEffect.asymmetric(
            // 弹框出现时的过渡动画效果
            TransitionEffect.SLIDE.animation({ duration: 1000 }),
            // 弹框消失时的过渡动画效果
            TransitionEffect.OPACITY.animation({ duration: 1000 })
          ),

          autoCancel: true,
          onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
            this.message += `dismiss reason: ${dismissDialogAction.reason}\n`
            dismissDialogAction.dismiss()
          },
          primaryButton: {
            value: 'primaryButton',
            action: () => {
              this.popupVisible = false
              this.message += 'primaryButton clicked\n'
            }
          },
          secondaryButton: {
            value: 'secondaryButton',
            action: () => {
              this.popupVisible = false
              this.message += 'secondaryButton clicked\n'
            }
          },
          onStateChange: (e) => {
            this.message += `onStateChange isVisible:${e.isVisible}\n`
            this.popupVisible = e.isVisible
          },
        })
    }
  }
}

@Component
struct MySample3 {

  @State popupVisible: boolean = false

  // 自定义弹出框内容
  @Builder popupBuilder() {
    Row({ space: 2 }) {
      Image($r("app.media.app_icon")).width(24).height(24)
      Text('content').fontSize(16)
    }
    .width(150).height(50).padding({ left: 10, right: 10 }).justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column({ space: 10 }) {
      /*
       * bindPopup() - 弹出框（与组件绑定的自定义的 Popup）
       *   show - 是否显示
       *   popup - 弹出框（一个 PopupOptions 对象）
       *     builder - 自定义弹出框内容（指定一个 @Builder 装饰的函数）
       */
      Button('click me')
        .onClick(() => {
          this.popupVisible = !this.popupVisible
        })
        .bindPopup(this.popupVisible, {
          builder: this.popupBuilder,
          onStateChange: (e) => {
            this.popupVisible = e.isVisible
          },
        })
    }
  }
}