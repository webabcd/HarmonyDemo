/*
 * AVMetadataExtractor - 提取视频或音频的元数据信息
 */

import { MyLog, TitleBar } from '../TitleBar';
import { fileIo as fs } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct AVMetadataExtractorDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('通过 fdSrc 的方式提取').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过 dataSrc 的方式提取').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * AVMetadataExtractor - 用于提取视频或音频的元数据信息
       *   canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor") - 判断当前设备是否具有支持 AVMetadataExtractor 的能力
       *   media.createAVMetadataExtractor() - 创建 AVMetadataExtractor 对象
       *   fdSrc - 需要提取元数据的文件的 AVFileDescriptor 对象
       *   fetchMetadata() - 提取视频或音频的元数据（返回一个 AVMetadata 对象）
       *     album - 专辑标题
       *     albumArtist - 专辑艺术家
       *     artist	- 艺术家
       *     author - 作者
       *     dateTime - 创建时间
       *     dateTimeFormat - 创建时间的格式化方式，比如 YYYY-MM-DD HH:mm:ss
       *     composer - 作曲家
       *     duration - 时长
       *     genre - 类型
       *     hasAudio - 媒体是否包含音频
       *     hasVideo - 媒体是否包含视频
       *     mimeType - 媒体的 mime 类型
       *     trackCount - 媒体的轨道数
       *     sampleRate - 音频的采样率
       *     title - 标题
       *     videoHeight - 视频高
       *     videoWidth - 视频宽
       *     videoOrientation - 视频的旋转度数
       *     hdrType - 视频的 hdr 类型
       *     location - 媒体的地理位置
       *     customInfo - 从 moov.meta.list 获取的自定义键值表
       *   fetchAlbumCover() - 提取音频的专辑封面（返回一个 PixelMap 对象）
       *   release() - 清理资源
       */
      Button('click me').onClick(async () => {
        let context = this.getUIContext().getHostContext()
        if (!context) {
          return;
        }

        if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
          let avMetadataExtractor: media.AVMetadataExtractor = await media.createAVMetadataExtractor();

          // 将 rawfile 中的视频文件转为 AVFileDescriptor 对象
          let fileDescriptor: media.AVFileDescriptor = await context.resourceManager.getRawFd('video/mp4.mp4');

          // 将沙箱路径中的视频文件转为 AVFileDescriptor 对象
          // let fileDescriptor: media.AVFileDescriptor = fs.openSync(filePath);

          avMetadataExtractor.fdSrc = fileDescriptor

          try {
            let avMetadata: media.AVMetadata = await avMetadataExtractor.fetchMetadata();
            this.message += `videoWidth: ${avMetadata.videoWidth}\n`
            this.message += `videoHeight: ${avMetadata.videoHeight}\n`
            this.message += `mimeType: ${avMetadata.mimeType}\n`
            this.message += `dateTime: ${avMetadata.dateTime}\n`
          } catch (e) {
            this.message += `fetchMetadata() error: ${JSON.stringify(e)}\n`
          }

          try {
            let albumCover: image.PixelMap = await avMetadataExtractor.fetchAlbumCover();
          } catch (e) {
            this.message += `fetchAlbumCover() error: ${JSON.stringify(e)}\n`
          }

          await avMetadataExtractor.release();
        }
      })
    }
  }
}

@Component
struct MySample2 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * AVMetadataExtractor - 用于提取视频或音频的元数据信息
       *   dataSrc - 需要提取元数据的文件的 AVDataSrcDescriptor 对象（流式）
       */
      Button('click me').onClick(async () => {
        let context = this.getUIContext().getHostContext()
        if (!context) {
          return;
        }

        if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
          let avMetadataExtractor: media.AVMetadataExtractor = await media.createAVMetadataExtractor();

          let myBuffer: ArrayBuffer = (await context.resourceManager.getRawFileContent('video/mp4.mp4')).buffer as ArrayBuffer
          /*
           * AVDataSrcDescriptor - 数据流描述符
           *   fileSize - 流的总大小，如果是 -1 则代表不确定（比如直播）
           *   callback - 需要在此回调中填充数据，此回调可能会被多次回调
           *     buffer - 当前需要填充的缓冲区
           *     len - 当前需要填充的缓冲区的长度
           *     pos - 当前需要填充的数据在源文件中的位置
           *     返回值为当前成功填充的数据的长度，返回 -1 代表到末尾了，返回 -2 代表遇到异常了
           *
           * 注：
           * 以本例来说用，通过 AVMetadataExtractor 的 AVDataSrcDescriptor 类型的 dataSrc 提取元数据信息
           * 会不停地回调 callback 以获取源文件数据，当解析到全部元数据后（不用读取全部源文件），则不再回调 callback 了
           */
          let dataSrcDescriptor: media.AVDataSrcDescriptor = {
            fileSize: myBuffer.byteLength,
            callback: (buffer, len, pos) => {
              MyLog.d(`callback: buffer:${buffer.byteLength}, len,${len}, pos:${pos}`)
              if (buffer == undefined || len == undefined || pos == undefined) {
                this.message += "dataSrc callback param invalid"
                return -1;
              }
              if (pos >= myBuffer.byteLength) {
                return -1
              }

              const targetArray = new Uint8Array(buffer);
              if (pos + len >= myBuffer.byteLength) {
                const sourceArray = new Uint8Array(myBuffer.slice(pos, myBuffer.byteLength));
                targetArray.set(sourceArray);
                return myBuffer.byteLength - pos
              } else {
                const sourceArray = new Uint8Array(myBuffer.slice(pos, pos + len));
                targetArray.set(sourceArray);
                return len
              }
            }
          };
          avMetadataExtractor.dataSrc = dataSrcDescriptor

          try {
            let avMetadata: media.AVMetadata = await avMetadataExtractor.fetchMetadata();

            this.message += `videoWidth: ${avMetadata.videoWidth}\n`
            this.message += `videoHeight: ${avMetadata.videoHeight}\n`
            this.message += `mimeType: ${avMetadata.mimeType}\n`
            this.message += `dateTime: ${avMetadata.dateTime}\n`
          } catch (e) {
            this.message += `fetchMetadata() error: ${JSON.stringify(e)}\n`
          }

          await avMetadataExtractor.release();
        }
      })
    }
  }
}
