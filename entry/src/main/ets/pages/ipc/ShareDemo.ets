/*
 * 系统分享
 *
 * 注：本例演示的是分享源，关于分享目标请参见 /harmonydemo2 项目的相关说明
 *
 * 在系统分享的目标应用的 module.json5 中做类似如下的配置
 * {
 *   "module": {
 *     "abilities": [
 *       {
 *         "skills": [
 *           // 作为系统分享的目标应用，需要做类似如下的配置
 *           {
 *             "actions": [
 *               "ohos.want.action.sendData"
 *             ],
 *             "uris": [
 *               {
 *                 // 系统分享的目标应用的协议名，必须配置为 file
 *                 "scheme": "file",
 *                 // 可接收数据的标准化数据类型
 *                 // 分享源分享此 utd 的数据时，当前应用会显示在分享面板中
 *                 "utd": "general.text",
 *                 // 可接收的分享数据的最大数量
 *                 "maxFileSupported": 1
 *               },
 *               {
 *                 "scheme": "file",
 *                 "utd": "general.jpeg",
 *                 "maxFileSupported": 1
 *               }
 *             ]
 *           }
 *         ]
 *       }
 *     ]
 *   }
 * }
 */

import { RadioBar, TitleBar } from '../TitleBar';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileUri, fileIo as fs } from '@kit.CoreFileKit';

@Entry
@Component
struct ShareDemo {

  build() {
    Column({space:10}) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('分享文本').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('分享图片').align(Alignment.Top)
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

  context = getContext(this) as common.UIAbilityContext

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * systemShare.SharedData - 分享数据
       *   utd - 标准化数据类型（utd 的全称是 uniform type descriptor）
       *     只有支持此 utd 的分享目标才会显示在分享面板中
       *     可以使用 UniformDataType.TEXT, UniformDataType.IMAGE, UniformDataType.VIDEO 等
       *     可以通过 getUniformDataTypeByFilenameExtension() 获取标准化数据类型
       *   title - 标题
       *   description - 描述
       *   content - 内容
       *   extraData - 扩展数据
       *   uri - 分享的文件的地址
       *     通过 fileUri.getUriFromPath() 获取文件的分享地址
       *   thumbnail - 分享数据左侧显示的图标（一个 Uint8Array 数据）
       *   thumbnailUri - 分享数据左侧显示的图标（一个 string 数据）
       *   addRecord() - 添加一条分享数据记录（用于一次分享多条数据记录）
       *
       * systemShare.ShareController() - 分享面板
       *   data - 指定分享数据
       *   show() - 拉起分享面板
       *     selectionMode - 选择的模式（SelectionMode 枚举）
       *       SINGLE - 单选
       *       BATCH - 多选
       *     previewMode - 预览的模式（SharePreviewMode 枚举）
       *       DEFAULT - 图文模式
       *       DETAIL - 大图模式
       */
      Button("分享文本").onClick(() => {
        let shareData: systemShare.SharedData = new systemShare.SharedData({
          utd: utd.UniformDataType.TEXT,
          title: 'title',
          description: 'description',
          content: 'content',
        })

        let controller: systemShare.ShareController = new systemShare.ShareController(shareData)
        controller.show(this.context, {
          selectionMode: systemShare.SelectionMode.SINGLE,
          previewMode: systemShare.SharePreviewMode.DEFAULT
        }).then(() => {
          this.message = "打开系统分享面板成功"
        }).catch((error: BusinessError) => {
          this.message = `打开系统分享面板失败 errCode:${error.code}, errMessage:${error.message}`
        });
      })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext

  @State previewMode: systemShare.SharePreviewMode = systemShare.SharePreviewMode.DEFAULT
  valueList =  ["DEFAULT", "DETAIL"]

  build() {
    Column({space:10}) {

      RadioBar({valueList: this.valueList, onChange: (selectedIndex: number) => {
        this.previewMode = systemShare.SharePreviewMode[this.valueList[selectedIndex]]
      }})

      Text(this.message)

      Button("分享图片").onClick(() => {

        // 需要分享的图片的沙箱地址
        let filePath = `${getContext(this).filesDir + "/share.jpg"}`

        // 从 rawfile 中复制文件到指定的沙箱地址
        let context = getContext(this) as common.UIAbilityContext;
        context.resourceManager.getRawFileContent('son.jpg', (err, value) => {
          let myBuffer: ArrayBufferLike = value.buffer
          let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          fs.writeSync(file.fd, myBuffer)
          fs.closeSync(file)
        })

        /*
         * systemShare.SharedData - 分享数据
         *   utd - 标准化数据类型（utd 的全称是 uniform type descriptor）
         *     只有支持此 utd 的分享目标才会显示在分享面板中
         *     可以使用 UniformDataType.TEXT, UniformDataType.IMAGE, UniformDataType.VIDEO 等
         *     可以通过 getUniformDataTypeByFilenameExtension() 获取标准化数据类型
         *   title - 标题
         *   description - 描述
         *   content - 内容
         *   uri - 分享的文件的地址
         *     通过 fileUri.getUriFromPath() 获取文件的分享地址
         *   extraData - 扩展数据
         *   thumbnail - 分享数据左侧显示的图标（一个 Uint8Array 数据）
         *   thumbnailUri - 分享数据左侧显示的图标（一个 string 数据）
         *   addRecord() - 添加一条分享数据记录（用于一次分享多条数据记录）
         *
         * systemShare.ShareController() - 分享面板
         *   data - 指定分享数据
         *   show() - 拉起分享面板
         *     selectionMode - 选择的模式（SelectionMode 枚举）
         *       SINGLE - 单选
         *       BATCH - 多选
         *     previewMode - 预览的模式（SharePreviewMode 枚举）
         *       DEFAULT - 图文模式
         *       DETAIL - 大图模式
         */
        let shareData: systemShare.SharedData = new systemShare.SharedData({
          utd: utd.getUniformDataTypeByFilenameExtension('.jpg', utd.UniformDataType.IMAGE),
          uri: fileUri.getUriFromPath(filePath),
          title: 'title',
          description: 'description',
        })

        let controller: systemShare.ShareController = new systemShare.ShareController(shareData)
        controller.show(this.context, {
          selectionMode: systemShare.SelectionMode.SINGLE,
          previewMode: this.previewMode
        }).then(() => {
          this.message = "打开系统分享面板成功"
        }).catch((error: BusinessError) => {
          this.message = `打开系统分享面板失败 errCode:${error.code}, errMessage:${error.message}`
        });
      })
    }
  }
}
