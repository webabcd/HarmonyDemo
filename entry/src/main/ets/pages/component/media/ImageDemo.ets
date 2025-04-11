/*
 * Image - 图片
 */

import { RadioBar, TitleBar } from '../../TitleBar'
import { image } from '@kit.ImageKit'
import { LayeredDrawableDescriptor } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct ImageDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('拉伸').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('9-Slice').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('PixelMap').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  context = getContext(this) as common.UIAbilityContext;

  // ResourceStr 的意思是 string | Resource
  @State resourceStr:ResourceStr = ""

  aboutToAppear() {
    setTimeout(() => this.resourceStr = $r('app.media.son'), 3000);
  }

  build() {
    Column({space: 10}) {

      /*
       * Image - 图片
       *   src - 支持 png, jpg, bmp, svg, gif, heif 等类型
       *   alt - 用于指定图片在加载过程中的占位图
       */

      Row() {
        // 显示资源中的图片文件
        Image($r('app.media.son'))
          .width(50).height(50)

        // 显示 ets 目录下的图片文件（注：文件需要放在 /src/main/ets 目录下，然后通过类似如下的方式引用）
        Image('/pages/component/media/son.jpg')
          .width(50).height(50)

        // 显示 resources 目录下的图片文件（注：文件需要放在 /src/main/resources 目录下，然后通过类似如下的方式引用）
        Image('/resources/base/media/son.jpg')
          .width(50).height(50)

        // 显示资源中 rawfile 目录中的图片文件
        Image($rawfile('son.jpg'))
          .width(50).height(50)

        // 显示资源中 resfile 目录中的图片文件（其会在第一次安装后被复制到应用的沙箱路径中）
        // 注：别忘了加上 file://（地址类似 file:///data/storage/el1/bundle/entry/resources/resfile/son.jpg）
        Image(`file://${getContext().resourceDir + "/son.jpg"}`)
          .width(50).height(50)

        // 显示一个 LayeredDrawableDescriptor 图片（将前景图片和背景图片组合为一个图片）
        // 在资源中通过 .json 文件配置 LayeredDrawableDescriptor 图片，参见 resources/base/media/layered_image.json
        // {
        //   "layered-image":
        //   {
        //     "background" : "$media:background", // 背景图片
        //     "foreground" : "$media:foreground"  // 前景图片
        //   }
        // }
        Image((this.context.resourceManager.getDrawableDescriptor($r('app.media.layered_image').id) as LayeredDrawableDescriptor))
          .width(50).height(50)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)

      // 显示网络图片
      Image('https://www.baidu.com/img/flexible/logo/pc/result.png')
        .alt($r('app.media.loading'))
        .width(50).height(50)

      // 先显示占位图，图片加载完成后再显示图片
      Image(this.resourceStr)
        .alt($r('app.media.loading'))
        .width(50).height(50)

      // 支持 base64 字符串
      Image('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAZAAAAGQCAYAAACAvzbMAAAAAXNSR0IArs4c6QAAIABJREFUeF7tnQnYv9W47z/LNraFnaEtQ1S4lO0ox5AhIZmiXUpEJKJMzSWVNGkeFKmoTImIToR0REUb56hj6rI3bTKUmS3DzrTOc/+f56231zs801rPWuv3Xdfl+vP3rPu+12et9/99n/Wsdd8ONREQAREQARHoQcD16KMuIiACIiACIoAERItABERABESgFwEJSC9s6iQCIiACIiAB0RoQAREQARHoRUAC0gubOomACIiACEhAtAZEQAREQAR6EZCA9MKmTiIgAiIgAhIQrQEREAEREIFeBCQgvbCpkwiIgAiIgAREa0AEREAERKAXAQlIL2zqJAIiIAIiIAHRGhABERABEehFQALSC5s6iYAIiIAISEC0BkRABERABHoRkID0wqZOIiACIiACEhCtAREQAREQgV4EJCC9sKmTCIiACIiABERrQAREQAREoBcBCUgvbOokAiIgAiIgAdEaEAEREAER6EVAAtILmzqJgAiIgAhIQLQGREAEREAEehGQgPTCpk4iIAIiIAISEK0BERABERCBXgQkIL2wqZMIiIAIiIAERGtABERABESgFwEJSC9s6iQCIiACIiAB0RoQAREQARHoRUAC0gubOomACIiACEhAtAZEQAREQAR6EZCA9MKmTiIgAiIgAhIQrQEREAEREIFeBCQgvbCp0ywQ8HB/G6eDH8zCeDVGEehKQALSlZienxkCHo5sBGT/mRm0BioCHQhIQDrA0qOzQ6ASjzsA1zcjXsvBTbMzeo1UBNoRkIC046SnZoyAh5cC726GvaOD98wYAg1XBFYkIAFZEZEemEUCHq4CNmzGfrWDjWaRg8YsAssRkIBofYjAAgIeHgN8acFfP9bBlwVLBETgFgISEK0GEfh7AXkf8OIFf/1+BzsIlgiIgAREa0AEFiXgYQ3gp8BtFzzwF2BNB78SOhEQgZqA3kC0EkRgHgEPBwKHLQHlQAdHCJgIiIAERGtABG5FwMNtmqO7ay6Bxt5M7Ejv34ROBERAbyBaAyJwMwEP2wAfXgHJNg7OFzYREAEJiNaACMwXkM8DT1oByWUONhU2ERABCYjWgAisIuBhfeBbLXFs4OCals/qMREoloA+ohc7tRpYFwIeTgNe1bLP6Q52afms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VyUwHwohbQIe1m8uz74+7UjLj04CUv4ca4QiIAIiEISABCQIVhkVAREQgfIJSEDKn2ONUAREQASCEJCABMEqoyIgAiJQPgEJSPlzrBGKgAiIQBACEpAgWGVUBERABMonIAEpf441QhEQAREIQkACEgSrjIqACIhA+QQkIOXPsUYoAiIgAkEISECCYJVRERABESifgASk/DnWCEVABEQgCAEJSBCsMioCIiAC5ROQgJQ/xxqhCIiACAQhIAEJglVGRUAERKB8AhKQ8udYIxQBERCBIAQkIEGwyqgIiIAIlE9AAlL+HGuEIiACIhCEgAQkCFYZFQEREIHyCUhAyp9jjVAEREAEghCQgATBKqMiIAIiUD4BCUj5c6wRioAIiEAQAhKQIFhlVAREQATKJyABKX+ONUIREAERCEJAAhIEq4yKgAiIQPkEJCDlz7FGKAIiIAJBCEhAgmCVUREQAREon4AEpPw51ghFQAREIAgBCUgQrDIqAiIgAuUTkICUP8caoQiIgAgEISABCYJVRkVABESgfAISkPLnWCMUAREQgSAEJCBBsMqoCIiACJRPQAJS/hxrhCIgAiIQhIAEJAhWGRUBERCB8glIQMqfY41QBERABIIQkIAEwSqjIiACIlA+AQlI+XOsEYqACIhAEAISkCBYZVQEREAEyicgASl/jjVCERABEQhCQAISBKuMioAIiED5BCQg5c+xRigCIiACQQhIQIJglVEREAERKJ+ABKT8OdYIRUAERCAIAQlIEKwyKgIiIALlE5CAlD/HGqEIiIAIBCEgAQmCVUZFQAREoHwCEpDy51gjFAEREIEgBCQgQbDKqAiIgAiUT0ACUv4ca4QiIAIiEISABCQIVhkVAREQgfIJ/H9R7ikYwoHdhAAAAABJRU5ErkJggg==')
        .width(50).height(50)

      // 可以直接显示 gif 动画
      Image($r('app.media.loading'))
        .width(50).height(50)

      // 可以直接显示 svg 图片，通过 fillColor() 指定颜色
      Image($r('app.media.ic_settings'))
        .width(50).height(50)
        .fillColor(Color.Orange)

      // 可以显示 sys.media. 资源图片，通过 fillColor() 指定颜色
      Image($r('sys.media.ohos_ic_public_play'))
        .width(50).height(50)
        .fillColor(Color.Orange)

      // 通过 SymbolGlyph() 显示 sys.symbol. 资源图片
      SymbolGlyph($r('sys.symbol.ohos_wifi'))
        .fontSize(50)
        .fontColor([Color.Orange])
    }
  }
}

@Component
struct MySample2 {

  @State imageFit: ImageFit = ImageFit.Auto
  valueList =  ["Contain", "Cover", "Auto", "Fill", "ScaleDown", "None", "TOP_START", "TOP", "TOP_END", "START", "CENTER", "END", "BOTTOM_START", "BOTTOM", "BOTTOM_END"]

  build() {
    Column({space: 10}) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.imageFit = ImageFit[this.valueList[selectedIndex]]
      }})

      /*
       * objectFit() - 拉伸方式
       *   Contain - 等比拉伸到目标大小，不剪裁，可能有黑边（本例所谓的黑边只是一个形容，实际要看父的颜色，可能是透明的，也可能是其他颜色）
       *   Cover - 等比拉伸到目标大小，并剪裁，不会有黑边
       *   Fill - 拉伸到目标大小，可能会变形
       *   TOP_START, TOP, TOP_END, START, CENTER, END, BOTTOM_START, BOTTOM, BOTTOM_END - 图片以原始大小显示在这些位置上
       */
      Image($r('app.media.son'))
        .width(300).height(200)
        .backgroundColor(Color.Orange)
        .objectFit(this.imageFit)

    }
  }
}

@Component
struct MySample3 {

  build() {
    Column({space:10}) {

      Image('/pages/component/media/dialog.png').width(321).height(137)

      /*
       * resizable() - 用于实现图片的 9 切片, 9-Slice, 9-Patch
       *   slice - 指定 9 切片的 4 条线
       *
       * 将图片分为 9 个部分
       * +----------------+----------------+----------------+
       * |      1         |      2         |      3         |
       * +----------------+----------------+----------------+
       * |      4         |      5         |      6         |
       * +----------------+----------------+----------------+
       * |      7         |      8         |      9         |
       * +----------------+----------------+----------------+
       * 拉伸图片时，1379 不会拉伸
       * 拉伸图片时，28 仅水平方向拉伸
       * 拉伸图片时，46 仅垂直方向拉伸
       * 拉伸图片时，5 水平方向和垂直方向均拉伸
       */
      Image('/pages/component/media/dialog.png').width(100).height(300)
        .resizable({
          // 注：9 切片的 4 条线的位置是相对于原图像素分辨率的位置，所以单位是 px
          slice: {
            left: '100px', // 左边线的位置
            right: '40px', // 右边线的位置
            top: '40px', // 上边线的位置
            bottom: '90px', // 下边线的位置
          }
        })
    }
  }
}

@Component
struct MySample4 {

  @State pixelMap: PixelMap | undefined = undefined

  async aboutToAppear() {
    this.pixelMap = await this.getPixmapFromResource($r('app.media.son'))
  }

  build() {
    Column() {
      // Image 可以显示一个 PixelMap 对象
      Image(this.pixelMap).width(200).height(200)
    }
  }

  // 图片资源转 PixelMap 对象
  private async getPixmapFromResource(resource: Resource): Promise<image.PixelMap> {
    // 资源转 Uint8Array 对象
    let uint8Array = await getContext(this).resourceManager.getMediaContent({
      bundleName: resource.bundleName,
      moduleName: resource.moduleName,
      id: resource.id
    })

    // 图片 Uint8Array 对象转 PixelMap 对象
    let imageSource = image.createImageSource(uint8Array.buffer)
    let pixelMap: image.PixelMap = await imageSource.createPixelMap({
      // RGBA_8888 的意思是 r 占用 8 位，g 占用 8 位，b 占用 8 位，a 占用 8 位
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    })
    await imageSource.release()
    return pixelMap
  }
}