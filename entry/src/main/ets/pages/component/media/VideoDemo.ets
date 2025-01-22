/*
 * Video - 视频播放器
 */

import { TitleBar } from '../../TitleBar'
import { LengthMetrics } from '@kit.ArkUI'

@Entry
@Component
struct VideoDemo {

  @State message: string = ""
  @State currentProgressRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X

  /*
   * VideoController - 用于和绑定的 Video 之间的交互
   *   start(), pause(), stop(), reset() - 开始，暂停，停止，重置
   *   setCurrentTime() - seek
   *     value - seek 到的时间点（单位：秒）
   *     seekMode - seek 的方式（SeekMode 枚举）
   *       PreviousKeyframe - seek 到用户指定的时间点的上一个最近的关键帧
   *       NextKeyframe - seek 到用户指定的时间点的下一个最近的关键帧
   *       ClosestKeyframe - seek 到用户指定的时间点的最近的关键帧
   *       Accurate - seek 到用户指定的时间点（精确 seek）
   *   requestFullscreen(true) - 全屏播放
   *   exitFullscreen() - 退出全屏播放
   */
  controller: VideoController = new VideoController()

  build() {
    Column({space:10}) {

      TitleBar()

      /*
       * Video - 视频播放器
       *   src - 视频地址
       *   previewUri - 预览图
       *   currentProgressRate - 播放倍速
       *     PlaybackSpeed.Speed_Forward_0_75_X 或 0.75
       *     PlaybackSpeed.Speed_Forward_1_00_X 或 1.0
       *     PlaybackSpeed.Speed_Forward_1_25_X 或 1.25
       *     PlaybackSpeed.Speed_Forward_1_75_X 或 1.75
       *     PlaybackSpeed.Speed_Forward_2_00_X 或 2.0
       *   controller - 绑定的 VideoController 对象
       *   autoPlay() - 是否自动播放
       *   loop() - 是否循环播放
       *   muted() - 是否静音
       *   controls() - 是否显示视频控制栏
       *   objectFit() - 拉伸方式（参见 /component/media/ImageDemo.ets 中的相关说明）
       *   onStart(), onPause(), onStop(), onFinish(), onError() - 视频开始时，暂停时，停止时，完成时，异常时的回调
       *   onPrepared() - 视频准备好时的回调，可以获取到视频时长
       *   onSeeking(), onSeeked() - seek 前和 seek 后的回调，可以获取到当前播放的时间点（单位：秒）
       *   onUpdate() - 播放时间点发生变化时的回调，可以获取到当前播放的时间点（单位：秒）
       *   onFullscreenChange() - 全屏播放状态与非全屏播放状态切换时的回调
       */
      Video({
        src: "https://vjs.zencdn.net/v/oceans.mp4",
        previewUri: $r('app.media.son'),
        currentProgressRate: this.currentProgressRate,
        controller: this.controller
      })
        .width('100%')
        .height(200)
        .autoPlay(false)
        .loop(false)
        .muted(false)
        .controls(true)
        .objectFit(ImageFit.Fill)
        .onStart(() => {
          this.message += "onStart\n"
        })
        .onPause(() => {
          this.message += "onPause\n"
        })
        .onStop(() => {
          this.message += "onStop\n"
        })
        .onFinish(() => {
          this.message += "onFinish\n"
        })
        .onError(() => {
          this.message += "onError\n"
        })
        .onPrepared((e: DurationObject) => { // 回调参数是匿名的，需要将其转换为一个形状相同的自定义接口
          this.message += `onPrepared:${e.duration}\n`
        })
        .onSeeking((e: TimeObject) => { // 回调参数是匿名的，需要将其转换为一个形状相同的自定义接口
          this.message += `onSeeking:${e.time}\n`
        })
        .onSeeked((e: TimeObject) => { // 回调参数是匿名的，需要将其转换为一个形状相同的自定义接口
          this.message += `onSeeked:${e.time}\n`
        })
        .onUpdate((e: TimeObject) => { // 回调参数是匿名的，需要将其转换为一个形状相同的自定义接口
          this.message += `onUpdate:${e.time}\n`
        })
        .onFullscreenChange((e: FullscreenObject) => { // 回调参数是匿名的，需要将其转换为一个形状相同的自定义接口
          this.message += `onFullscreenChange:${e.fullscreen}\n`
        })

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { cross: LengthMetrics.vp(10) } }) {
        Button('start').onClick(() => {
          this.controller.start()
        })
        Button('pause').onClick(() => {
          this.controller.pause()
        })
        Button('stop').onClick(() => {
          this.controller.stop()
        })
        Button('reset').onClick(() => {
          this.controller.reset()
        })
        Button('setCurrentTime(10.0)').onClick(() => {
          this.controller.setCurrentTime(10.0, SeekMode.Accurate)
        })
        Button('requestFullscreen').onClick(() => {
          this.controller.requestFullscreen(true)
        })
        Button('exitFullscreen').onClick(() => {
          this.controller.exitFullscreen()
        })
        Select([
          { value: '0.75' },
          { value: '1.0' },
          { value: '1.25' },
          { value: '1.75' },
          { value: '2.0' },
        ])
          .selected(1)
          .value("currentProgressRate")
          .onSelect((index:number, text?: string | undefined)=>{
            this.currentProgressRate = Number(text)
          })
      }

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}

// 用于将回调参数中的匿名对象转换为形状相同的接口
interface DurationObject {
  duration: number;
}

// 用于将回调参数中的匿名对象转换为形状相同的接口
interface TimeObject {
  time: number;
}

// 用于将回调参数中的匿名对象转换为形状相同的接口
interface FullscreenObject {
  fullscreen: boolean;
}