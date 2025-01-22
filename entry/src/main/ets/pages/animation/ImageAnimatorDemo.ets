/*
 * ImageAnimator - 帧动画
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct ImageAnimatorDemo {

  @State animationStatus: AnimationStatus = AnimationStatus.Initial
  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      TitleBar()

      Text(this.message)

      /*
       * ImageAnimator - 帧动画
       *   images() - 设置帧动画的每一帧的信息（一个 ImageFrameInfo 对象数组）
       *     src - 当前帧的图片地址
       *     width, height, left, top - 当前帧的图片大小和位置（注：当设置 ImageAnimator 的 fixedSize(false) 时有效）
       *     duration - 当前帧的显示时长（注：当指定了每一帧的 duration 后，则 ImageAnimator 的 duration() 就无效了）
       *   duration() - 帧动画的总计时长，每一帧平均分配时长
       *   fixedSize() - 每一帧的图片大小是否需要与 ImageAnimator 组件自身的大小一致
       *   reverse() - 是否倒播
       *   state() - 用于指定帧动画的状态（AnimationStatus 枚举）
       *     Initial - 初始
       *     Running - 运行
       *     Paused - 暂停
       *     Stopped - 停止
       *   iterations() - 动画的播放次数（-1 代表无限循环）
       *   fillMode() - 用于指定播放停止后的停留帧（FillMode 枚举）
       *     None - 停留在第 1 帧
       *     Forwards - 停留在最后一帧
       *   onStart(), onPause(), onRepeat(), onCancel(), onFinish() - 动画开始时，暂停时，重复时，取消时，完成时的回调
       */

      ImageAnimator()
        .images([
          {
            src: $r('app.media.app_icon')
          },
          {
            src: $r('app.media.ic_settings')
          },
          {
            src: $r('app.media.son'),
          },
          {
            src: $r('sys.media.ohos_ic_public_arrow_up')
          },
          {
            src: $r('sys.media.ohos_ic_public_arrow_right')
          },
          {
            src: $r('sys.media.ohos_ic_public_arrow_down')
          },
          {
            src: $r('sys.media.ohos_ic_public_arrow_left')
          }
        ])
        .duration(5000)
        .fixedSize(true)
        .reverse(false)
        .state(this.animationStatus)
        .iterations(-1)
        .fillMode(FillMode.None)
        .width(50)
        .height(50)
        .onStart(() => {
          this.message = "onStart"
        })
        .onPause(() => {
          this.message = "onPause"
        })
        .onRepeat(() => {
          this.message = "onRepeat"
        })
        .onCancel(() => {
          this.message = "onCancel"
        })
        .onFinish(() => {
          this.message = "onFinish"
        })

      ImageAnimator()
        .images([
          {
            src: $r('app.media.app_icon'),
            width: 20,
            height: 20,
            left: 15,
            top: 15,
            duration: 1000
          },
          {
            src: $r('app.media.ic_settings'),
            width: 50,
            height: 50,
            left: 0,
            top: 0,
            duration: 2000
          },
          {
            src: $r('app.media.son'),
            width: 20,
            height: 20,
            left: 15,
            top: 15,
            duration: 3000
          },
        ])
        .fixedSize(false)
        .state(this.animationStatus)
        .iterations(-1)
        .fillMode(FillMode.Forwards)
        .width(50)
        .height(50)

      Button('Running').onClick(() => {
        this.animationStatus = AnimationStatus.Running
      })
      Button('Paused').onClick(() => {
        this.animationStatus = AnimationStatus.Paused
      })
      Button('Stopped').onClick(() => {
        this.animationStatus = AnimationStatus.Stopped
      })
    }
  }
}