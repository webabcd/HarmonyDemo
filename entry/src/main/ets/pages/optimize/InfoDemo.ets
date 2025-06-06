/**
 * 各种信息
 */

import { TitleBar } from '../TitleBar'
import BuildProfile from 'BuildProfile'
import { deviceInfo } from '@kit.BasicServicesKit'

@Entry
@Component
struct InfoDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  aboutToAppear(): void {
    /*
     * canIUse() - 用于判断当前系统是否支持指定的能力
     */
    let supported = canIUse('SystemCapability.Multimedia.Media.SoundPool')
    this.message += `是否支持 SoundPool: ${supported}\n`

    /*
     * BuildProfile - 获取编译相关的信息
     * 注：调试时，点击右上角工具栏“选择模块”框的左侧的“圆形”按钮，可以指定是 debug 模式还是 release 模式
     */
    this.message += `DEBUG: ${BuildProfile.DEBUG}\n` // true
    this.message += `BUILD_MODE_NAME: ${BuildProfile.BUILD_MODE_NAME}\n` // debug
    this.message += `BUNDLE_NAME: ${BuildProfile.BUNDLE_NAME}\n` // com.webabcd.harmonydemo
    this.message += `VERSION_NAME: ${BuildProfile.VERSION_NAME}\n` // 1000000
    this.message += `VERSION_CODE: ${BuildProfile.VERSION_CODE}\n` // 1.0.0

    /*
     * deviceInfo - 获取设备相关的信息
     */
    // 设备类型，可能的值有 phone, tablet, 2in1, tv, wearable, car
    this.message += `deviceType: ${deviceInfo.deviceType}\n` // phone
    // 厂家名称
    this.message += `manufacture: ${deviceInfo.manufacture}\n` // HUAWEI
    // 品牌名称
    this.message += `brand: ${deviceInfo.brand}\n` // HUAWEI
    // 设备名称
    this.message += `marketName: ${deviceInfo.marketName}\n` // emulator
    // 在“设置” -> “关于本机” -> “软件版本”中显示的信息
    this.message += `displayVersion: ${deviceInfo.displayVersion}\n` // emulator 5.0.0.112(SP2DEVC00E112R4P11log)
    // cpu 架构
    this.message += `abiList: ${deviceInfo.abiList}\n` // x86_64
    // 系统版本
    this.message += `osFullName: ${deviceInfo.osFullName}\n` // OpenHarmony-5.0.1.110
    // 系统版本中的 major 版本号
    this.message += `majorVersion: ${deviceInfo.majorVersion}\n` // 5
    // 系统版本中的 senior 版本号
    this.message += `seniorVersion: ${deviceInfo.seniorVersion}\n` // 0
    // 系统版本中的 feature 版本号
    this.message += `featureVersion: ${deviceInfo.featureVersion}\n` // 1
    // 系统版本中的 build 版本号
    this.message += `buildVersion: ${deviceInfo.buildVersion}\n` // 110
    // 由很多信息拼接而成的版本标识
    this.message += `versionId: ${deviceInfo.versionId}\n` // phone/HUAWEI/HUAWEI/emulator/OpenHarmony-5.0.1.110/emulator/default/13/default/default
    // 系统的 api 版本
    this.message += `sdkApiVersion: ${deviceInfo.sdkApiVersion}\n` // 13
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)
    }
  }
}
