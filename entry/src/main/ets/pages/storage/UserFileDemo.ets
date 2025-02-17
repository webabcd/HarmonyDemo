/*
 * 用户文件（即公共目录中的文件）
 *
 * 公共目录可以在内置存储，也可以在外置存储
 * 一个公共目录的文件的 uri 的示例 file://docs/storage/Users/currentUser/Documents/myTest.txt
 * 通过 picker（文件选择对话框）拿到文件 uri 后，就得到了对其做保存和读取操作的临时权限（注：应用退出后，这个临时权限就失效了）
 */

import { TitleBar } from '../TitleBar';
import { picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

@Entry
@Component
struct PreferencesDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('保存').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('读取').align(Alignment.Top)
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

  saveUrl: string = ""

  build() {
    Column({space:10}) {
      Button("获取需要保存的文件的 url").onClick(() => {
        /*
         * DocumentSaveOptions - 保存文件的选项
         *   newFileNames - 需要保存的文件的默认文件名的数组
         *   defaultFilePathUri - 默认路径
         */
        const documentSaveOptions = new picker.DocumentSaveOptions()
        documentSaveOptions.newFileNames = ["myTest.txt"]
        documentSaveOptions.defaultFilePathUri = "file://docs/storage/Users/currentUser/Documents"

        /*
         * DocumentViewPicker - 文件选择对话框
         *   save() - 通过文件保存模式弹出文件选择对话框
         *   返回值为已保存的文件的 url 数组，后续可以通过此 url 写数据到文件（退出应用后此权限失效）
         */
        let context = getContext(this) as common.Context;
        const documentViewPicker = new picker.DocumentViewPicker(context);
        documentViewPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
          this.saveUrl = documentSaveResult.length > 0 ? documentSaveResult[0] : ""
          this.message = this.saveUrl
        }).catch((err: BusinessError) => {
          this.message = `errCode:${err.code}, errMessage:${err.message}`
        })
      })

      // 通过 fileIo 写文件，可参见 AppFileDemo.ets 中的相关说明
      Button("保存数据到通过 picker 的 save() 得到的 url").onClick(() => {
        if (this.saveUrl == "") {
          this.message = "无 url"
        } else {
          let file = fs.openSync(this.saveUrl, fs.OpenMode.READ_WRITE)
          let writeLength: number = fs.writeSync(file.fd, `hello:${this.saveUrl}`)
          this.message = `写入成功 length:${writeLength}, url:${this.saveUrl}`
          fs.close(file)
        }
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  selectUrl: string = ""

  build() {
    Column({space:10}) {
      Button("获取需要读取的文件的 url").onClick(() => {
        /*
         * DocumentSelectOptions - 选择文件的选项
         *   maxSelectNumber - 允许选择文件的最大数量
         *   defaultFilePathUri - 默认路径
         *   fileSuffixFilters - 可选文件的后缀类型
         *     比如：['图片(.png, .jpg)|.png,.jpg', '文档|.txt', '.pdf', '*']
         */
        const documentSelectOptions = new picker.DocumentSelectOptions()
        documentSelectOptions.maxSelectNumber = 1
        documentSelectOptions.defaultFilePathUri = "file://docs/storage/Users/currentUser/Documents"
        documentSelectOptions.fileSuffixFilters = ['*']

        /*
         * DocumentViewPicker - 文件选择对话框
         *   select() - 通过文件选择模式弹出文件选择对话框
         *   返回值为用户选择的文件的 url 数组，后续可以通过此 url 从文件中读取数据（退出应用后此权限失效）
         */
        let context = getContext(this) as common.Context
        const documentViewPicker = new picker.DocumentViewPicker(context);
        documentViewPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
          this.selectUrl = documentSelectResult.length > 0 ? documentSelectResult[0] : ""
          this.message = this.selectUrl
        }).catch((err: BusinessError) => {
          this.message = `errCode:${err.code}, errMessage:${err.message}`
        })
      })

      // 通过 fileIo 读文件，可参见 AppFileDemo.ets 中的相关说明
      Button("从通过 picker 的 select() 得到的 url 中读取数据").onClick(() => {
        if (this.selectUrl == "") {
          this.message = "无 url"
        } else {
          let file = fs.openSync(this.selectUrl, fs.OpenMode.READ_ONLY);
          let buffer = new ArrayBuffer(4096);
          let readLength = fs.readSync(file.fd, buffer);
          this.message = `读取成功 ${util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(buffer))}`
          fs.closeSync(file);
        }
      })

      Text(this.message)
    }
  }
}
