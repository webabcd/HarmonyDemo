/*
 * AVPlayer - 播放器（可以播放视频或音频）
 */

import { TitleBar } from '../TitleBar'
import { BusinessError } from '@kit.BasicServicesKit'
import { media } from '@kit.MediaKit'
import { LengthMetrics } from '@kit.ArkUI'
import { fileIo as fs } from '@kit.CoreFileKit';

@Entry
@Component
struct AVPlayerDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('播放本地媒体').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('码流').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('轨道').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('外挂字幕').align(Alignment.Top)
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

  /*
   * XComponentController - 用于和绑定的 XComponent 之间的交互
   * AVPlayer - 播放器（可以播放视频或音频）
   *   media.createAVPlayer() - 创建一个 AVPlayer 对象
   *   url/fdSrc - 需要播放的视频或音频的 url 地址或 fd 地址（支持 mp4, mp3, hls, dash 等）
   *     注：仅 AVPlayer 处于 idle 状态时，才能设置 url/fdSrc 属性，设置 url/fdSrc 后，播放器会变为 initialized 状态
   *   setPlaybackStrategy() - 设置播放参数（一个 PlaybackStrategy 对象）
   *     preferredBufferDuration - 缓冲持续时间（单位：秒）
   *     preferredBufferDurationForPlaying - 起播缓冲的缓冲持续时间（单位：秒），要求 api version 18 或以上
   *     showFirstFrameOnPrepare - 播放器 prepared 后是否显示起播首帧，默认不显示，要求 api version 17 或以上
   *   on('startRenderFrame')/off('startRenderFrame') - 首帧渲染时的回调
   *   on('error')/off('error') - 发生错误时的回调
   *     建议在此回调内，调用 reset() 重置播放器
   *   on('durationUpdate')/off('durationUpdate')- 媒体源的总时长发生变化时的回调
   *   on('timeUpdate')/off('timeUpdate') - 播放进度发生变化时的回调
   *   on('videoSizeChange')/off('videoSizeChange') - 视频的分辨率发生变化时的回调
   *   on('bufferingUpdate')/off('bufferingUpdate') - 缓冲相关的回调
   *     infoType - 当前回调的值的类型（BufferingInfoType 枚举）
   *       BUFFERING_START - 缓冲开始
   *       BUFFERING_END - 缓冲结束
   *       BUFFERING_PERCENT - 缓冲百分比，即缓冲进度，到 100% 了则缓冲结束
   *       CACHED_DURATION - 已缓冲数据的可播时长
   *     value - 值
   *   on('speedDone')/off('speedDone') - 调用 setSpeed() 成功之后的回调
   *   on('volumeChange')/off('volumeChange') - 调用 setVolume() 成功之后的回调
   *   on('seekDone')/off('seekDone') - 调用 seek() 之后，视频开始播放时的回调
   *   on('stateChange')/off('stateChange') - 播放状态发生变化时的回调
   *     idle, initialized, prepared, playing, paused, completed, stopped, released, error
   *     调用 reset() 后，播放器会变为 idle 状态
   *     设置 url/fdSrc 后，播放器会变为 initialized 状态
   *     在进入 initialized 状态时，设置播放器的 surfaceId 属性，以及调用 prepare() 方法
   *     在进入 prepared 状态后，就可以调用播放器的 play() 方法了
   *   play() - 播放
   *   pause() - 暂停
   *   stop() - 停止
   *   reset() - 重置，播放器会变为 idle 状态
   *   release() - 清理资源
   *   seek() - seek 操作
   *     timeMs - 需要跳转到的时间点
   *     mode - 基于视频 i 帧的跳转模式（SeekMode 枚举）
   *       SEEK_NEXT_SYNC - 跳转到指定时间点的下一个关键帧
   *       SEEK_PREV_SYNC - 跳转到指定时间点的上一个关键帧
   *       SEEK_CLOSEST - 跳转到距离指定时间点最近的关键帧
   *     注：我这里测试发现，播放 hls 调用 seek 时，指定的 mode 是无效的，每次 seek 后都会从指定的时间点的下一片开始播放（比如 10 秒一片，如果 seek 到 1000 毫秒，则从第 3 片开始播放）
   *   setSpeed() - 设置播放倍速（PlaybackSpeed 枚举）
   *     0.75, 1, 1.25, 1.75, 2, 0.5, 1.5, 3, 0.25, 0.125
   *   setVolume() - 设置播放器的音量（0 -1 之间）
   *   getPlaybackInfo() - 获取播放过程中的相关信息
   *   getPlaybackPosition() - 获取当前的播放位置（要求 api version 18 或以上）
   */
  private xComponentController: XComponentController = new XComponentController()
  private avPlayer?: media.AVPlayer

  async createPlayer(surfaceId: string) {
    let avPlayer: media.AVPlayer = await media.createAVPlayer()
    avPlayer.url = 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8'
    avPlayer.setPlaybackStrategy({
      preferredBufferDuration: 2
    })
    this.avPlayer = avPlayer

    avPlayer.on('startRenderFrame', () => {
      this.message += 'startRenderFrame\n'
    });
    avPlayer.on('error', (err: BusinessError) => {
      this.message += `error: ${err.code}, ${err.message}\n`
      // 重置播放器，之后播放器会进入 idle 状态
      avPlayer.reset()
    });
    avPlayer.on('durationUpdate', (duration: number) => {
      this.message += `durationUpdate: ${duration}\n`
    });
    avPlayer.on('timeUpdate', (time: number) => {
      // this.message += `timeUpdate: ${time}\n`
    });
    avPlayer.on('videoSizeChange', (width: number, height: number) => {
      this.message += `videoSizeChange: ${width}, ${height}\n`
    });
    avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      // this.message += `bufferingUpdate: ${infoType}, ${value}\n`
    });
    avPlayer.on('speedDone', (speed: number) => {
      this.message += `speedDone: ${speed}\n`
    });
    avPlayer.on('volumeChange', (volume: number) => {
      this.message += `volumeChange: ${volume}\n`
    });
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      this.message += `seekDone: ${seekDoneTime}\n`
    });
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      this.message += `stateChange: ${state}, ${reason}\n`
      switch (state) {
        case 'idle':
          break;
        case 'initialized':
          // 在进入 initialized 状态时，设置播放器的 surfaceId 属性，以及调用 prepare() 方法
          avPlayer.surfaceId = surfaceId
          avPlayer.prepare()
          break;
        case 'prepared':
          // 播放
          avPlayer.play()
          break;
        case 'playing':
          break;
        case 'paused':
          break;
        case 'completed':
          break;
        case 'stopped':
          break;
        case 'released':
          break;
        case 'error':
          break;
        default:
          break;
      }
    });
  }

  // 释放资源
  release(): void {
    this.avPlayer?.off('startRenderFrame')
    this.avPlayer?.off('error')
    this.avPlayer?.off('durationUpdate')
    this.avPlayer?.off('timeUpdate')
    this.avPlayer?.off('videoSizeChange')
    this.avPlayer?.off('bufferingUpdate')
    this.avPlayer?.off('speedDone')
    this.avPlayer?.off('volumeChange')
    this.avPlayer?.off('seekDone')
    this.avPlayer?.off('stateChange')
    this.avPlayer?.stop()
    this.avPlayer?.reset()
    this.avPlayer?.release()
  }

  build() {
    Column({ space: 10 }) {

      /*
       * XComponent - 用于绘制媒体内容
       *   id - 标识
       *   type - 写死 XComponentType.SURFACE 即可
       *   controller - 绑定的 XComponentController 对象
       *   onLoad() - 加载完成时的回调
       * XComponentController - 用于和绑定的 XComponent 之间的交互
       *   getXComponentSurfaceId() - 获取 surfaceId（注：在 XComponent 的 onLoad 回调之后才能获取到 surfaceId）
       */
      XComponent({
        id: 'xComponentId',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .onLoad(async () => {
          // 获取 surfaceId
          // 需要在 AVPlayer 的 initialized 状态时，赋值给 AVPlayer 的 surfaceId 属性
          const surfaceId = this.xComponentController.getXComponentSurfaceId()
          this.createPlayer(surfaceId)
        })
        .width('100%')
        .height(200)

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) } }) {
        Button('play').onClick(() => {
          this.avPlayer?.play()
        })
        Button('pause').onClick(() => {
          this.avPlayer?.pause()
        })
        Button('stop').onClick(() => {
          this.avPlayer?.stop()
        })
        Button('reset').onClick(() => {
          this.avPlayer?.reset()
        })
        Button('release').onClick(() => {
          this.avPlayer?.release()
        })
        Button('seek').onClick(() => {
          this.avPlayer?.seek(5_000, media.SeekMode.SEEK_CLOSEST)
        })
        Button('setSpeed').onClick(() => {
          this.avPlayer?.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_3_00_X)
        })
        Button('setVolume').onClick(() => {
          this.avPlayer?.setVolume(0.5)
        })
        Button('getPlaybackInfo').onClick(async () => {
          let playbackInfo = await this.avPlayer?.getPlaybackInfo()
          this.message += `${JSON.stringify(playbackInfo)}`
        })
      }

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  /*
   * AVPlayer - 播放器（可以播放视频或音频）
   *   url/fdSrc - 需要播放的视频或音频的 url 地址或 fd 地址（支持 mp4, mp3, hls, dash 等）
   *     注：仅 AVPlayer 处于 idle 状态时，才能设置 url/fdSrc 属性，设置 url/fdSrc 后，播放器会变为 initialized 状态
   */
  private xComponentController: XComponentController = new XComponentController()
  private avPlayer?: media.AVPlayer

  async createPlayer(surfaceId: string) {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    this.avPlayer = avPlayer

    avPlayer.on('error', (err: BusinessError) => {
      this.message += `error: ${err.code}, ${err.message}\n`
      avPlayer.reset()
    });
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      this.message += `stateChange: ${state}, ${reason}\n`
      switch (state) {
        case 'initialized':
          avPlayer.surfaceId = surfaceId
          avPlayer.prepare()
          break;
        case 'prepared':
          avPlayer.play()
          break;
        case 'completed':
          // 播放完成后，调用 reset() 将播放器置为 idle 状态
          avPlayer.reset()
          break;
        default:
          break;
      }
    });
  }

  aboutToAppear(): void {
    // 复制 rawfile 中的指定的文件到指定的沙箱地址
    let filePath = getContext(this).filesDir + "/1.mp3"
    getContext(this).resourceManager.getRawFileContent('audio/1.mp3', (err, value) => {
      let myBuffer: ArrayBufferLike = value.buffer
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      fs.writeSync(file.fd, myBuffer)
      fs.closeSync(file)
    })
  }

  build() {
    Column({ space: 10 }) {

      XComponent({
        id: 'xComponentId',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      }).onLoad(async () => {
        this.createPlayer(this.xComponentController.getXComponentSurfaceId())
      }).width('100%').height(200)

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) } }) {
        Button('播放本地的资源媒体').onClick(async () => {
          // 将本地的资源媒体转为 AVFileDescriptor 并赋值给 AVPlayer 的 fdSrc 属性
          let fileDescriptor = await getContext(this).resourceManager.getRawFd('audio/1.mp3')
          let avFileDescriptor: media.AVFileDescriptor = { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length }
          if (this.avPlayer) {
            this.avPlayer.fdSrc = avFileDescriptor
          }
        })

        Button('播放本地的沙箱媒体').onClick(async () => {
          // 将本地的沙箱媒体转为 fd:// 地址并赋值给 AVPlayer 的 url 属性
          let filePath = getContext(this).filesDir + "/1.mp3"
          let file = fs.openSync(filePath);
          let fdPath = 'fd://' + file.fd;
          if (this.avPlayer) {
            this.avPlayer.url = fdPath;
          }
          fs.closeSync(file)
        })
      }

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Component
struct MySample3 {

  bitrates: number[] = []
  currentBitrateIndex: number = -1
  @State message: string = ""

  /*
   * AVPlayer - 播放器（可以播放视频或音频）
   *   on('availableBitrates')/off('availableBitrates') - 拿到 hls 或 dash 的可用的码流列表时的回调
   *   on('bitrateDone')/off('bitrateDone') -  调用 setBitrate() 成功之后的回调
   *     注：并不是当前播放的码流发生变化时触发这个回调，而是调用 setBitrate() 成功之后触发这个回调，而调用 setBitrate() 后并不会马上播放对应的码流，而只是在下载新片时下载指定的码流切片
   *   setBitrate() - 指定播放的码流
   *     具体的码流可以从 on('availableBitrates') 获取到
   *     默认是码流自适应的，调用 setBitrate() 后就会尝试播放指定的码流，但是不知道怎么再变回码流自适应
   *     调用 setBitrate() 后并不会马上播放对应的码流，而只是在下载新片时下载指定的码流切片
   */
  private xComponentController: XComponentController = new XComponentController()
  private avPlayer?: media.AVPlayer

  async createPlayer(surfaceId: string) {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    avPlayer.url = 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8'
    this.avPlayer = avPlayer

    avPlayer.on('error', (err: BusinessError) => {
      this.message += `error: ${err.code}, ${err.message}\n`
      avPlayer.reset()
    });
    avPlayer.on('availableBitrates', (bitrates: number[]) => {
      this.bitrates = bitrates
      this.message += `availableBitrates: ${JSON.stringify(bitrates)}\n`
    });
    avPlayer.on('bitrateDone', (bitrate: number) => {
      this.message += `bitrateDone: ${bitrate}\n`
    });
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      this.message += `stateChange: ${state}, ${reason}\n`
      switch (state) {
        case 'initialized':
          avPlayer.surfaceId = surfaceId
          avPlayer.prepare()
          break;
        case 'prepared':
          avPlayer.play()
          break;
        default:
          break;
      }
    });
  }

  build() {
    Column({ space: 10 }) {

      XComponent({
        id: 'xComponentId',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      }).onLoad(async () => {
        this.createPlayer(this.xComponentController.getXComponentSurfaceId())
      }).width('100%').height(200)

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) } }) {
        Button('switchBitrate').onClick(() => {
          if (this.bitrates.length > 0) {
            this.currentBitrateIndex += 1
            if (this.currentBitrateIndex > this.bitrates.length - 1) {
              this.currentBitrateIndex = 0
            }
          }
          this.avPlayer?.setBitrate(this.bitrates[this.currentBitrateIndex])
        })

        Scroll() {
          Text(this.message)
        }
        .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
      }
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  /*
   * AVPlayer - 播放器（可以播放视频或音频）
   *   getTrackDescription() - 获取每条轨道的信息（返回一个 MediaDescription 数组）
   *     轨道的类型有：音频，视频，字幕
   *     可以通过 key/value 的方式获，从 MediaDescription 中获取轨道的指定的信息
   *     MediaDescriptionKey.MD_KEY_TRACK_INDEX - 轨道的索引
   *     MediaDescriptionKey.MD_KEY_TRACK_TYPE - 轨道的类型（0是音频，1是视频，2是字幕）
   *     MediaDescriptionKey.MD_KEY_TRACK_NAME - 轨道的名称
   *     MediaDescriptionKey.MD_KEY_CODEC_MIME - 音频或视频轨道的编码类型
   *     MediaDescriptionKey.MD_KEY_DURATION - 音频或视频轨道的时长（单位：ms）
   *     MediaDescriptionKey.MD_KEY_BITRATE - 音频或视频轨道的码流（单位：bps）
   *     MediaDescriptionKey.MD_KEY_WIDTH - 视频轨道的宽（单位：px）
   *     MediaDescriptionKey.MD_KEY_HEIGHT - 视频轨道的高（单位：px）
   *     MediaDescriptionKey.MD_KEY_FRAME_RATE - 视频轨道的帧率
   *     MediaDescriptionKey.MD_KEY_AUD_CHANNEL_COUNT - 音频轨道的声道数
   *     MediaDescriptionKey.MD_KEY_AUD_SAMPLE_RATE - 音频轨道的采样率
   *     MediaDescriptionKey.MD_KEY_AUD_SAMPLE_DEPTH - 音频轨道的位深
   *   getSelectedTracks() - 获取当前播放的轨道的索引的集合
   *   selectTrack() - 播放指定索引的轨道
   *   deselectTrack() - 取消指定索引的轨道的播放
   *   on(‘trackChange’)/off(‘trackChange’) - 播放的轨道发生变化时的回调
   *   on(‘trackInfoUpdate’)/off(‘trackInfoUpdate’) - 播放的轨道的信息更新时的回调
   */
  private xComponentController: XComponentController = new XComponentController()
  private avPlayer?: media.AVPlayer

  async createPlayer(surfaceId: string) {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    avPlayer.url = 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8'
    this.avPlayer = avPlayer

    avPlayer.on('error', (err: BusinessError) => {
      this.message += `error: ${err.code}, ${err.message}\n`
      avPlayer.reset()
    });
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      this.message += `stateChange: ${state}, ${reason}\n`
      switch (state) {
        case 'initialized':
          avPlayer.surfaceId = surfaceId
          avPlayer.prepare()
          break;
        case 'prepared':
          avPlayer.play()
          break;
        default:
          break;
      }
    });
  }

  build() {
    Column({ space: 10 }) {

      XComponent({
        id: 'xComponentId',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      }).onLoad(async () => {
        this.createPlayer(this.xComponentController.getXComponentSurfaceId())
      }).width('100%').height(200)

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) } }) {
        Button('获取轨道信息').onClick(async () => {
          let trackList = await this.avPlayer?.getTrackDescription()
          if (trackList != null && trackList.length > 0) {
            for (let i = 0; i < trackList.length; i++) {
              let mediaDescription = trackList[i]
              this.message += `index:${mediaDescription[media.MediaDescriptionKey.MD_KEY_TRACK_INDEX]}\n`
              this.message += `type:${mediaDescription[media.MediaDescriptionKey.MD_KEY_TRACK_TYPE]}\n`
              this.message += `name:${mediaDescription[media.MediaDescriptionKey.MD_KEY_TRACK_NAME]}\n`
              this.message += `mime:${mediaDescription[media.MediaDescriptionKey.MD_KEY_CODEC_MIME]}\n`
            }
          }
        })
      }

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  /*
   * AVPlayer - 播放器（可以播放视频或音频）
   *   addSubtitleFromFd() - 挂载 fd 地址的字幕
   *   addSubtitleFromUrl() - 挂载 url 地址的字幕
   *   on('subtitleUpdate')/off('subtitleUpdate') - 当前显示的字幕更新时的回调（仅外挂字幕有效），回调参数是一个 SubtitleInfo 对象
   *     text - 字幕文本
   *     startTime - 当前显示的字幕的开始时间（单位：毫秒）
   *     duration - 当前显示的字幕的持续时间（单位：毫秒）
   *
   * 注：
   * 1、本例演示的是如何拿到当前应该显示的字幕文本，至于文本如何显示则需要自己写代码
   * 2、如果是内置字幕的话，即视频的字幕轨道，请参见 MySample4 中的相关说明
   */
  private xComponentController: XComponentController = new XComponentController()
  private avPlayer?: media.AVPlayer

  async createPlayer(surfaceId: string) {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    avPlayer.url = 'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8'
    this.avPlayer = avPlayer

    // 获取本地字幕文件的 FileDescriptor
    let fileDescriptor = await getContext(this).resourceManager.getRawFd('mysrt.srt')
    // 挂载 fd 地址的字幕
    avPlayer.addSubtitleFromFd(fileDescriptor.fd, fileDescriptor.offset, fileDescriptor.length);
    // 挂载 url 地址的字幕
    // avPlayer.addSubtitleFromUrl('http://a.b.c/mysrt.srt')

    avPlayer.on('error', (err: BusinessError) => {
      this.message += `error: ${err.code}, ${err.message}\n`
      avPlayer.reset()
    });
    avPlayer.on('subtitleUpdate', (info: media.SubtitleInfo) => {
      // 当前显示的字幕更新时
      this.message += `text:${info.text}, startTime:${info.startTime}, duration:${info.duration}\n`
    });
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      this.message += `stateChange: ${state}, ${reason}\n`
      switch (state) {
        case 'initialized':
          avPlayer.surfaceId = surfaceId
          avPlayer.prepare()
          break;
        case 'prepared':
          avPlayer.play()
          break;
        default:
          break;
      }
    });
  }

  build() {
    Column({ space: 10 }) {

      XComponent({
        id: 'xComponentId',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      }).onLoad(async () => {
        this.createPlayer(this.xComponentController.getXComponentSurfaceId())
      }).width('100%').height(200)

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}