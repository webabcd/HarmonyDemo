/*
 * SoundPool - 音效播放器，用于低时延播放短音频（要求音频解码后在 1MB 以内）
 *
 * 大致的流程为：
 * 1、创建 SoundPool 实例，并监听相关事件
 * 2、加载指定的短音频文件，拿到对应的 soundId
 * 3、根据 soundId 播放短音频（如果指定的 soundId 正在播放，则会将其停止，然后重新播放），并拿到对应的 streamId
 * 4、根据 streamId 停止短音频的播放，根据 soundId 卸载短音频文件
 */

import { TitleBar } from '../TitleBar'
import { BusinessError } from '@kit.BasicServicesKit'
import { media } from '@kit.MediaKit'
import { LengthMetrics } from '@kit.ArkUI'
import { fileIo as fs } from '@kit.CoreFileKit';
import { audio } from '@kit.AudioKit';

@Entry
@Component
struct SoundPoolDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
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
  soundIdList: number[] = []
  streamIdList: Set<number> = new Set<number>()

  /*
   * SoundPool - 音效播放器
   *   media.createSoundPool() - 创建 SoundPool 对象
   *     maxStreams - 音频池内的最大的音频流的数量（1 - 32 之间）
   *     audioRenderInfo - 音频渲染器的信息
   *       usage - 音频流的类型，写死 audio.StreamUsage.STREAM_USAGE_MUSIC 即可
   *       rendererFlags - 音频渲染器标志，写死 0 即可
   *     注：api 18 或以上，一个进程最多可以创建 128 个 SoundPool 实例；api 18 以下，一个进程只能创建 1 个 SoundPool 实例
   *   on('loadComplete')/off('loadComplete') - 短音频文件加载完成时的回调
   *   on('playFinished')/off('playFinished') - 短音频播放完成时的回调
   *   on('playFinishedWithStreamId')/off('playFinishedWithStreamId')/ - 短音频播放完成时的回调，可以从回调参数中拿到 streamId
   *     ‘playFinishedWithStreamId’ 仅在 api 18 或以上有效
   *     如果 ‘playFinished’ 和 ‘playFinishedWithStreamId’ 都监听了，则只会触发 ‘playFinishedWithStreamId’
   *   on('error') - 发生异常时的回调
   *   load() - 通过 fd:// 协议的方式或 FileDescriptor 的方式加载短音频文件，返回的是 soundId
   *   play() - 根据 soundId 播放指定的短音频
   *     soundID - 需要播放的 soundId
   *     params - 播放参数（一个 PlayParameters 对象）
   *       loop - 循环次数（比如设置为 2 时，则代表一共播放 3 次）
   *       rate - 播放倍速（AudioRendererRate 枚举）
   *         RENDER_RATE_NORMAL - 正常倍速
   *         RENDER_RATE_DOUBLE - 2 倍速
   *         RENDER_RATE_HALF - 0.5 倍速
   *       leftVolume - 左声道音量（0 - 1 之间）
   *       rightVolume - 右声道音量（0 - 1 之间）
   *       priority - 优先级（0 代表最低优先级）
   *     callback - 从此回调中可以拿到 streamId
   *   stop() - 停止指定的 streamId 的播放
   *   unload() - 卸载指定的 soundId 的文件
   *   release() - 清理资源
   */
  soundPool: media.SoundPool | undefined

  async aboutToAppear() {
    await this.initSoundPool()
    await this.loadSound()
  }

  // 创建 SoundPool 实例，并监听相关事件
  async initSoundPool() {
    // 如果需要的话，可以通过 canIUse 判断当前设备是否支持 SoundPool
    let supported = canIUse('SystemCapability.Multimedia.Media.SoundPool')
    this.message += `是否支持 SoundPool: ${supported}\n`

    this.soundPool = await media.createSoundPool(6, {
      usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
      rendererFlags: 0
    })

    this.soundPool.on('loadComplete', (soundId: number) => {
      this.message += `loadComplete soundId:${soundId}\n`
    });

    this.soundPool.on('playFinished', () => {
      this.message += `playFinished\n`
    });
    /*
    this.soundPool.on('playFinishedWithStreamId', (streamId: number) => {
      this.message += `playFinishedWithStreamId streamId:${streamId}\n`
    });
    */
    this.soundPool.on('error', (error: BusinessError) => {
      this.message += `error errCode:${error.code}, errMessage:${error.message}\n`
    });
  }

  // 加载短音频文件
  async loadSound() {
    /*
    // 下面的注销的示例用于演示，如何通过 fd:// 协议的方式加载指定的沙箱地址中的短音频文件
    for (let i = 0; i < 6; i++) {
      // 从 rawfile 中复制文件到指定的沙箱地址
      let filePath = getContext(this).getApplicationContext().filesDir + `/${i +  1}.mp3`
      let myBuffer: ArrayBufferLike = (await getContext(this).resourceManager.getRawFileContent(`audio/${i +  1}.mp3`)).buffer
      let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      await fs.write(file.fd, myBuffer)
      // 加载指定的沙箱地址中的短音频文件（通过 fd:// 协议的方式）
      let fdPath = 'fd://' + (file.fd).toString()
      let soundId = await this.soundPool?.load(fdPath)
      if (soundId) {
        this.soundIdList.push(soundId)
      }
      await fs.close(file)
    }
    */

    // 加载指定的 rawfile 中的短音频文件（通过 FileDescriptor 的方式）
    for (let i = 0; i < 6; i++) {
      let fileDescriptor = await getContext(this).resourceManager.getRawFd(`audio/${i +  1}.mp3`)
      let soundId = await this.soundPool?.load(fileDescriptor.fd,  fileDescriptor.offset,  fileDescriptor.length)
      if (soundId) {
        this.soundIdList.push(soundId)
      }
    }
  }

  // 播放指定的短音频
  playSound(soundId: number) {
    // 短音频的播放参数
    let playParameters: media.PlayParameters = {
      loop: 0, // 播放 1 此
      rate: audio.AudioRendererRate.RENDER_RATE_NORMAL,
      leftVolume: 0.5,
      rightVolume: 0.5,
      priority: 100,
    };

    // 根据 soundId 播放短音频（如果指定的 soundId 正在播放，则会将其停止，然后重新播放），并拿到对应的 streamId
    this.soundPool?.play(soundId, playParameters, (error, streamId: number) => {
      this.message += `play soundId:${soundId}, streamId:${streamId}\n`
      this.streamIdList.add(streamId)

      /*
      // 设置指定 streamId 的播放参数（播放参数与上面的 PlayParameters 是一样的）
      this.soundPool?.setLoop(streamId, 0)
      this.soundPool?.setRate(streamId, audio.AudioRendererRate.RENDER_RATE_NORMAL)
      this.soundPool?.setVolume(streamId, 0.5, 0.5)
      this.soundPool?.setPriority(streamId, 100)
      */
    });
  }

  // 清理资源
  async release() {
    this.soundPool?.off('loadComplete')
    this.soundPool?.off('playFinished')
    /*
    this.soundPool.on('playFinishedWithStreamId')
    */
    this.soundPool?.off('error')
    for (let streamId of this.streamIdList) {
      await this.soundPool?.stop(streamId)
    }
    for (let soundId of this.soundIdList) {
      await this.soundPool?.unload(soundId)
    }
    await this.soundPool?.release()
  }

  async aboutToDisappear() {
    await this.release()
  }

  build() {
    Column({ space: 10 }) {

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround, space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(10) } }) {
        Button("play 0").onClick(() => {
          this.playSound(this.soundIdList[0])
        })
        Button("play 1").onClick(() => {
          this.playSound(this.soundIdList[1])
        })
        Button("play 2").onClick(() => {
          this.playSound(this.soundIdList[2])
        })
        Button("play 3").onClick(() => {
          this.playSound(this.soundIdList[3])
        })
        Button("play 4").onClick(() => {
          this.playSound(this.soundIdList[4])
        })
        Button("play 5").onClick(() => {
          this.playSound(this.soundIdList[5])
        })
      }

      Text(this.message)
    }
  }
}
