/*
 * promptAction - 弹出 toast, menu, dialog, custom
 *
 * 注：promptAction 不是一个 UI 组件，而是一个全局接口
 */

import { TitleBar } from '../../TitleBar'
import { promptAction } from '@kit.ArkUI'


@Entry
@Component
struct PromptActionDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('toast').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('menu').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('dialog').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('custom').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  build() {
    Column({ space: 10 }) {

      /*
       * promptAction.showToast() - 弹出 toast（主：页面间的导航不会导致 toast 的隐藏）
       *   message - 显示内容
       *   duration - 显示时长
       *   bottom - 距底部的距离
       *   alignment - 显示位置（Alignment 枚举）
       *     TopStart, Top, TopEnd, Start, Center, End, BottomStart, Bottom, BottomEnd
       *   offset - 相对当前位置的偏移量
       *     dx, dy - 水平方向和垂直方向的偏移量
       *   backgroundColor, textColor, backgroundBlurStyle, shadow - 背景颜色，文字颜色，背景模糊效果，阴影效果
       *   showMode - 弹出模式（ToastShowMode 枚举）
       *     DEFAULT - 显示在应用内（弹出软键盘后 toast 会自动避让）
       *     TOP_MOST - 显示在应用上（弹出软键盘后 toast 的位置不会变，其会显示在软键盘之上）
       */

      Button('show toast')
        .onClick(() => {
          promptAction.showToast({
            message: 'hello webabcd',
            duration: 3000
          });
        })

      Button('show toast')
        .onClick(() => {
          promptAction.showToast({
            message: 'hello webabcd',
            duration: 3000,
            bottom: 100
          });
        })

      Button('show toast')
        .onClick(() => {
          promptAction.showToast({
            message: 'hello webabcd',
            duration: 3000,
            alignment: Alignment.Top,
            offset: {
              dx: 0,
              dy: 200
            }
          });
        })

      Button('show toast')
        .onClick(() => {
          promptAction.showToast({
            message: 'hello webabcd',
            duration: 3000,
            backgroundColor: Color.Orange,
            textColor: Color.White,
            backgroundBlurStyle: BlurStyle.Thin,
            shadow: ShadowStyle.OUTER_DEFAULT_XS
          });
        })

      Button('show toast')
        .onClick(() => {
          promptAction.showToast({
            message: 'hello webabcd',
            duration: 3000,
            showMode: promptAction.ToastShowMode.TOP_MOST,
          });
        })

      TextInput()
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      /*
       * promptAction.showToast() - 弹出 menu（显示一个标题和多个自定义按钮，自带一个取消按钮）
       *   title - 标题
       *   buttons - 自定义按钮集合
       *   isModal - 是否是模态窗口（模态窗口有遮罩层，非模态窗口无遮罩层）
       *   showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 的所属窗口之外）
       */

      Button('show menu')
        .onClick(() => {
          promptAction.showActionMenu({
            title: 'title',
            buttons: [
              { text: 'button 1', color: '#ff0000' },
              { text: 'button 2', color: '#ff0000' },
            ],
            isModal: true,
            showInSubWindow: false,
          }, (err, data) => {
            // 点击了取消按钮，或点击了空白区域
            if (err) {
              this.message = `err message:${err.message}`
              return;
            }
            // 点击了自定义按钮
            this.message = `button index:${data.index}`
          })
        })

      Text(this.message).fontSize(16)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      /*
       * promptAction.showDialog() - 弹出 dialog（显示一个标题和一个内容和多个自定义按钮）
       *   title - 标题
       *   message - 内容
       *   buttons - 自定义按钮集合
       *   isModal - 是否是模态窗口（模态窗口有遮罩层，非模态窗口无遮罩层）
       *   showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 的所属窗口之外）
       *   maskRect - 遮罩层的位置和大小（在遮罩层区域内的事件不透传，在遮罩层区域外的事件会透传）
       *   alignment - 显示位置（DialogAlignment 枚举）
       *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
       *   offset - 相对原有位置的偏移量
       *   backgroundColor, backgroundBlurStyle, shadow - 背景颜色，背景模糊效果，阴影效果
       */

      Button('show dialog')
        .onClick(() => {
          promptAction.showDialog({
            title: 'title',
            message: 'message',
            buttons: [
              { text: 'button 1', color: '#ff0000' },
              { text: 'button 2', color: '#ff0000' },
            ],
            isModal: true,
            showInSubWindow: false,
            maskRect: {x:0, y:0, width:'100%', height:'100%'},
          }, (err, data) => {
            // 点击了空白区域
            if (err) {
              // err.message 的值为 cancel
              this.message = `err message:${err.message}`
              return;
            }
            // 点击了自定义按钮，通过 data.index 获取点击的按钮的索引位置
            this.message = `button index:${data.index}`
          });
        })

      Button('show dialog')
        .onClick(() => {
          promptAction.showDialog({
            title: 'title',
            message: 'message',
            buttons: [
              { text: 'button 1', color: '#ff0000' },
              { text: 'button 2', color: '#ff0000' },
            ],
            alignment: DialogAlignment.Top,
            offset: {
              dx: 0,
              dy: 100
            },
            backgroundColor: Color.Orange,
            backgroundBlurStyle: BlurStyle.Thin,
            shadow: ShadowStyle.OUTER_DEFAULT_XS,
          });
        })

      Text(this.message).fontSize(16)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  private customDialogId: number = 0

  @Builder customDialog() {
    Column() {
      Text('message').fontSize(24)
      Row({ space: 48 }) {
        Button("确认").onClick(() => {
          /*
           * promptAction.closeCustomDialog() - 关闭指定 id 的弹出框
           */
          promptAction.closeCustomDialog(this.customDialogId)
        })
        Button("取消").onClick(() => {
          promptAction.closeCustomDialog(this.customDialogId)
        })
      }
    }
    .height(200)
    .padding(20)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column({ space: 10 }) {

      /*
       * promptAction.openCustomDialog() - 弹出自定义弹出框
       *   builder - 自定义弹出框内容（指定一个自定义组件）
       *   isModal - 是否是模态窗口（模态窗口有遮罩层，非模态窗口无遮罩层）
       *   showInSubWindow - 是否新开子窗口显示弹窗（比如小窗显示 app 时，如果新开子窗口显示弹窗，则这个弹窗会显示在 app 的所属窗口之外）
       *   maskRect - 遮罩层的位置和大小（在遮罩层区域内的事件不透传，在遮罩层区域外的事件会透传）
       *   maskColor - 遮罩层颜色
       *   keyboardAvoidMode - 软键盘弹出时，自动避让的模式（KeyboardAvoidMode 枚举）
       *     DEFAULT - 自动避让软键盘
       *     NONE - 不避让软键盘
       *   onWillAppear, onDidAppear, onWillDisappear, onDidDisappear - 弹窗显示和消失的相关事件
       *   autoCancel - 点击非弹框区域时是否自动隐藏
       *   onWillDismiss - 通过用户行为关闭弹窗之前的回调（回调参数是一个 DismissDialogAction 对象）
       *     reason - 弹窗将要关闭的原因
       *       PRESS_BACK - 点击返回按钮，手机侧边左滑/右滑，键盘 esc 键
       *       TOUCH_OUTSIDE - 点击非弹框区域
       *       CLOSE_BUTTON - 点击关闭按钮
       *       SLIDE_DOWN - 半模态转场时通过下拉关闭
       *     dismiss() - 确认关闭弹窗（如果设置了 onWillDismiss 回调，则只有调用 dismiss() 后才会关闭弹窗）
       *
       *   alignment - 显示位置（DialogAlignment 枚举）
       *     Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
       *   offset - 相对原有位置的偏移量
       *   backgroundColor, backgroundBlurStyle, shadow - 背景颜色，背景模糊效果，阴影效果
       *   borderWidth, borderColor, borderStyle, cornerRadius - 边框宽度，边框颜色，边框样式，圆角半径
       *   width, height - 指定弹框的宽和高
       *   transition - 自定义弹框的显示消失的动画效果（TransitionEffect 对象）
       *     注：关于 TransitionEffect 的使用请参见 TransitionDemo.ets 中的说明
       *
       *   then((dialogId: number) => {}) - 获取当前弹出框的 id
       *
       * promptAction.closeCustomDialog() - 关闭指定 id 的弹出框
       */

      Button('show custom')
        .onClick(() => {
          promptAction.openCustomDialog({
            builder: () => {
              this.customDialog()
            },
            isModal: true,
            showInSubWindow: false,
            maskRect: {x:0, y:0, width:'100%', height:'100%'},
            maskColor: 0x33ff0000,
            keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,
            autoCancel: true,
            onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
              this.message += `dismiss reason: ${dismissDialogAction.reason}\n`
              dismissDialogAction.dismiss()
            },
            onWillAppear: () => {
              this.message += 'onWillAppear\n'
            },
            onDidAppear: () => {
              this.message += 'onDidAppear\n'
            },
            onWillDisappear: () => {
              this.message += 'onWillDisappear\n'
            },
            onDidDisappear: () => {
              this.message += 'onDidDisappear\n'
            },
          }).then((dialogId: number) => {
            // 获取当前弹出框的 id，后续可以通过 promptAction.closeCustomDialog() 关闭指定 id 的弹出框
            this.customDialogId = dialogId
          })
        })

      Button('show custom')
        .onClick(() => {
          promptAction.openCustomDialog({
            builder: () => {
              this.customDialog()
            },
            alignment:DialogAlignment.Top,
            offset: {
              dx: 0,
              dy: 20
            },
            backgroundColor: Color.Orange,
            backgroundBlurStyle: BlurStyle.Thin,
            shadow: ShadowStyle.OUTER_DEFAULT_XS,
            borderWidth: 5,
            borderColor: Color.Red,
            borderStyle: BorderStyle.Solid,
            cornerRadius: 20,
            width: 300,
            height: 200,
            transition:TransitionEffect.asymmetric(
              // 弹框出现时的过渡动画效果
              TransitionEffect.SLIDE.animation({ duration: 1000 }),
              // 弹框消失时的过渡动画效果
              TransitionEffect.OPACITY.animation({ duration: 1000 })
            )
          }).then((dialogId: number) => {
            // 获取当前弹出框的 id，后续可以通过 promptAction.closeCustomDialog() 关闭指定 id 的弹出框
            this.customDialogId = dialogId
          })
        })

      Text(this.message).fontSize(16)
    }
  }
}