/*
 * 国际化
 *
 * i18n 是 internationalization 的缩写
 *
 * 中文资源 src/main/resources/zh_CN
 * 英文资源 src/main/resources/en_US
 * 默认资源 src/main/resources/base
 */

import { TitleBar } from '../TitleBar'
import { i18n, intl } from '@kit.LocalizationKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct LocalizationDemo {

  build() {
    Column() {
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
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column({space:10}) {

      // 获取当前应用的偏好语言的对应的资源中的字符串（如果找不到语言对应的资源的话，则使用默认资源）
      Text($r('app.string.hello_webabcd'))

      Text(this.message)

      Button("获取国际化的相关信息").onClick(() => {

        /*
         * Locale - 区域信息
         *   language - 区域的语言，比如 zh
         *     标准参见 https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
         *   script - 区域的书写方式，比如 Hans
         *     标准参见 https://en.wikipedia.org/wiki/ISO_15924
         *   region - 区域的国家或地区，比如 CN
         *     标准参见 https://en.wikipedia.org/wiki/ISO_3166-1
         *   baseName - 区域的全名，比如 zh-Hans-CN
         */
        let locale = new intl.Locale();

        /*
         * i18n.System.getAppPreferredLanguage() - 获取应用的偏好语言
         * i18n.System.setAppPreferredLanguage() - 设置应用的偏好语言
         */

        // 应用的偏好语言，比如 zh-Hans
        let appPreferredLanguage = i18n.System.getAppPreferredLanguage();
        // 系统的偏好语言列表
        let preferredLanguageList = i18n.System.getPreferredLanguageList();
        // 系统的偏好语言列表中的第一个偏好语言
        let firstPreferredLanguage = i18n.System.getFirstPreferredLanguage();

        this.message += `language:${locale.language}\n`
        this.message += `script:${locale.script}\n`
        this.message += `region:${locale.region}\n`
        this.message += `baseName:${locale.baseName}\n`
        this.message += `appPreferredLanguage:${appPreferredLanguage}\n`
        this.message += `preferredLanguageList:${preferredLanguageList.join(",")}\n`
        this.message += `firstPreferredLanguage:${firstPreferredLanguage}\n`
      })

      Button("设置语言为 zh").onClick(() => {
        i18n.System.setAppPreferredLanguage("zh");
      })

      Button("设置语言为 en").onClick(() => {
        i18n.System.setAppPreferredLanguage("en");
      })

      // 找不到语言对应的资源，则使用默认资源
      Button("设置语言为 de").onClick(() => {
        i18n.System.setAppPreferredLanguage("de");
      })

      // 设置一个非法语言，则会抛出异常
      Button("设置语言为 xxx").onClick(() => {
        try {
          i18n.System.setAppPreferredLanguage("xxx");
        } catch (error) {
          let err: BusinessError = error as BusinessError;
          this.message += `error code:${err.code}, message:${err.message}\n`
        }
      })

      Button("获取指定的语言的对应的资源中的字符串").onClick(() => {
        // 获取当前的资源管理器
        let resourceManager = this.context.resourceManager
        // 自定义资源管理器的配置，以便加载 en 资源
        let overrideConfiguration = resourceManager.getOverrideConfiguration()
        overrideConfiguration.locale = "en"
        // 获取自定义的资源管理器，其加载的是 en 资源
        let overrideResourceManager = resourceManager.getOverrideResourceManager(overrideConfiguration)

        // 根据资源 id 加载其对应的字符串（同步），类似的方法还有 getColorSync(), getMediaContentSync() 等
        let a = overrideResourceManager.getStringSync($r('app.string.hello_webabcd').id)
        this.message += `英文资源：${a}\n`
        // 根据资源 name 加载其对应的字符串（同步），类似的方法还有 getColorByNameSync(), getMediaByNameSync() 等
        let b = overrideResourceManager.getStringByNameSync('hello_webabcd')
        this.message += `英文资源：${b}\n`

        // 根据资源 id 加载其对应的字符串（异步），类似的方法还有 getColor(), getMediaContent() 等
        overrideResourceManager.getStringValue($r('app.string.hello_webabcd').id, (error: BusinessError, value: string) => {
          this.message += `英文资源：${value}\n`
        });
        // 根据资源 name 加载其对应的字符串（异步），类似的方法还有 getColorByName(), getMediaByName() 等
        overrideResourceManager.getStringByName('hello_webabcd', (error: BusinessError, value: string) => {
          this.message += `英文资源：${value}\n`
        });
      })
    }
  }
}
