/*
 * 此 worker 线程用于演示视频转码
 */

import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { common, sendableContextManager } from '@kit.AbilityKit';
import { MySendableObject } from '../pages/media/AVTranscoderDemo';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = async (event: MessageEvents) => {

  console.info('workerPort onmessage');

  const sendableObject: MySendableObject = event.data
  const sendableContext: sendableContextManager.SendableContext = sendableObject.getSendableContext()
  const context: common.Context = sendableContextManager.convertToContext(sendableContext)

  // 需要转码的文件的 rawfile 地址
  let rawfilePath = sendableObject.getRawfilePath()
  // 转码后的文件的沙箱地址
  let transcodedFilePath = sendableObject.getTranscodedFilePath()

  await transcode(context, rawfilePath, transcodedFilePath);

  workerPort.postMessage('finish');
};

workerPort.onmessageerror = (event: MessageEvents) => {
  console.info('workerPort onmessageerror');
};

workerPort.onerror = (event: ErrorEvent) => {
  console.info('workerPort onerror: ', event.message);
};


let transcoder: media.AVTranscoder | undefined
async function transcode(context: common.Context, rawfilePath: string, transcodedFilePath: string) {
  try {
    /*
     * AVTranscoder - 视频转码器
     *   media.createAVTranscoder() - 创建 AVTranscoder 对象
     *   on('complete')/off('complete') - 转码完成时的回调
     *   on('error')/off('error') - 转码异常时的回调
     *   on('progressUpdate')/off('progressUpdate') - 转码进度发生变化时的回调
     *   fdSrc - 需要转码的文件的 AVFileDescriptor 对象
     *   fdDst - 转码后的文件的 fd number
     *   prepare() - 准备转码（传入一个 AVTranscoderConfig 对象）
     *     audioBitrate - 输出的音频码率，单位：bps，默认值：48kbps
     *     audioCodec - 输出的音频的编码格式（CodecMimeType 枚举），默认值为 media.CodecMimeType.AUDIO_AAC
     *     fileFormat - 输出的文件的封装格式（ContainerFormatType 枚举），目前只支持 media.ContainerFormatType.CFT_MPEG_4
     *     videoBitrate - 输出的视频码率，单位：bps
     *     videoCodec - 输出的视频的编码格式（CodecMimeType 枚举），默认值为 media.CodecMimeType.VIDEO_AVC
     *     videoFrameWidth - 输出的视频的宽，单位：px
     *     videoFrameHeight - 输出的视频的高，单位：px
     *   start() - 开始转码，需要 prepare() 成功之后才能开始转码
     *   pause() - 暂停转码
     *   resume() - 继续转码
     *   cancel() - 取消转码
     *   release() - 清理资源
     */
    transcoder = await media.createAVTranscoder();

    transcoder.on('complete', async () => {
      console.info(`mytranscoder: complete`);
      workerPort.postMessage('mytranscoder: complete');
      await release()
    })

    transcoder.on('error', async (err: BusinessError) => {
      console.info(`mytranscoder: error`, err.code, err.message);
      workerPort.postMessage(`mytranscoder: error, ${err.code}, ${err.message}`);
      await release()
    })

    transcoder.on('progressUpdate', (progress: number) => {
      console.info(`mytranscoder: progressUpdate`, progress);
    })

    // 将需要转码的文件转为 AVFileDescriptor 对象，并赋值给 transcoder 的 fdSrc 属性
    // 将 rawfile 中的视频文件转为 AVFileDescriptor 对象
    let fileDescriptor: media.AVFileDescriptor = await context.resourceManager.getRawFd(rawfilePath);
    // 将沙箱路径中的视频文件转为 AVFileDescriptor 对象
    // let file = fs.openSync(filePath);
    // let fileSize = fs.statSync(filePath).size;
    // let fileDescriptor: media.AVFileDescriptor = { fd: file.fd, offset: 0, length: fileSize };
    transcoder.fdSrc = fileDescriptor;

    // 拿到转码后的文件的文件描述符，并赋值给 transcoder 的 fdDst 属性
    let file = fs.openSync(transcodedFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    transcoder.fdDst = file.fd;

    let avConfig: media.AVTranscoderConfig = {
      audioBitrate: 48_000,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      videoBitrate: 1_000_000,
      videoCodec: media.CodecMimeType.VIDEO_AVC,
      videoFrameWidth: 960,
      videoFrameHeight: 400,
    };
    await transcoder?.prepare(avConfig);
    await transcoder?.start();
  } catch (error) {
    console.info(`mytranscoder: ${error}`);
    workerPort.postMessage(`mytranscoder: ${error}`);
    await release()
  }
}

// 清理资源
async function release() {
  transcoder?.off('complete')
  transcoder?.off('error')
  transcoder?.off('progressUpdate')
  transcoder?.release()
}