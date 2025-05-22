/*
 * AVImageGenerator - 提取视频指定时间点的图像
 */
import { TitleBar } from '../TitleBar'
import { media } from '@kit.MediaKit'
import { image } from '@kit.ImageKit'

@Entry
@Component
struct AVImageGeneratorDemo {

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

  @State message:string = ""
  @State pixelMap: image.PixelMap | undefined = undefined;

  build() {
    Column({space:10}) {

      /*
       * AVImageGenerator - 用于提取视频指定时间点的图像
       *   canIUse("SystemCapability.Multimedia.Media.AVImageGenerator") - 判断当前设备是否具有支持 AVImageGenerator 的能力
       *   media.createAVImageGenerator() - 创建 AVImageGenerator 对象
       *   fdSrc - 需要提取图像的视频文件的 AVFileDescriptor 对象
       *   fetchFrameByTime() - 提取视频指定时间点的图像（返回一个 PixelMap 对象）
       *     timeUs - 时间点（单位：微秒）
       *     options - 用于描述传入时间点与提取的图像的所属帧的关系（AVImageQueryOptions 枚举）
       *       AV_IMAGE_QUERY_NEXT_SYNC - 传入时间点或之后的关键帧
       *       AV_IMAGE_QUERY_PREVIOUS_SYNC - 传入时间点或之前的关键帧
       *       AV_IMAGE_QUERY_CLOSEST_SYNC - 传入时间点最近的关键帧
       *       AV_IMAGE_QUERY_CLOSEST - 传入时间点最近的帧（不一定是关键帧）
       *     param - 提取的图像的输出的宽和高
       *       width - 宽
       *       height - 高
       *   release() - 清理资源
       */
      Button('click me').onClick(async () => {
        let context = this.getUIContext().getHostContext()
        if (!context) {
          return;
        }

        if (canIUse("SystemCapability.Multimedia.Media.AVImageGenerator")) {
          let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator();
          let fileDescriptor: media.AVFileDescriptor = await context.resourceManager.getRawFd('video/mp4.mp4');
          avImageGenerator.fdSrc = fileDescriptor;

          let timeUs = 10_000_000;
          let options = media.AVImageQueryOptions.AV_IMAGE_QUERY_CLOSEST;
          let param: media.PixelMapParams = {
            width: 480,
            height: 200
          };

          try {
            this.pixelMap = await avImageGenerator.fetchFrameByTime(timeUs, options, param);
          } catch (e) {
            this.message = `error: ${JSON.stringify(e)}`
          }

          avImageGenerator.release();
        }
      })

      Text(this.message)

      Image(this.pixelMap).width(480).height(200)
    }
  }
}
