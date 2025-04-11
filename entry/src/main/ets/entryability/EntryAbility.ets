/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 * UIAbility 的相关配置，请参见 module.json5 配置文件中的 abilities 标签
 */

import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { MyLog } from '../utils/MyLog';
import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { Helper } from '../utils/Helper';
import { rpc } from '@kit.IPCKit';

export default class EntryAbility extends UIAbility {

  // 用于保存通过卡片的 call 的方式拉起了 ability 时，传递过来的名为 method 的参数
  private cardCallMethod = ""

  // UIAbility 实例创建完成时（冷启动）
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d(`ability onCreate, parameters:${JSON.stringify((want.parameters))}`);

    this.handleCard(want)
  }

  // 当 UIAbility 已经启动了，之后再次启动时（热启动）
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MyLog.d(`ability onNewWant, parameters:${JSON.stringify((want.parameters))}`);

    this.handleCard(want)
  }

  // 当通过卡片的 router 或 call 方式拉起了此 ability 时
  handleCard(want: Want) {

    // 有 method 参数，所以是 call 方式拉起的
    // 当卡片通过 call 的方式调用此应用时：
    // 1、此应用未启动时，则会拉起此应用，可以在 onCreate() 中通过 Want 获取到卡片传递过来的数据，但是此应用不会出现在最近任务列表中
    // 2、此应用已启动时，则在 callee.on() 中通过 data.readString() 获取卡片传递过来的数据
    // 3、此应用必须具有 ohos.permission.KEEP_BACKGROUND_RUNNING 权限
    if (want.parameters && want.parameters["method"] !== undefined) {
      this.cardCallMethod = want.parameters["method"].toString(); // 通过卡片的 call 的方式拉起了 ability 时，肯定有名为 method 的参数

      // 监听 Callee 与 Caller 约定的消息通知字符串（即通过卡片的 call 的方式拉起了 ability 时，其中的名为 method 的参数）
      // 注：本例是在 call 方式拉起应用时监听的，如果不是 call 方式拉起的则监听不到，要避免此问题，则别管谁拉起的都按约定值监听即可
      this.callee.on(this.cardCallMethod, (data: rpc.MessageSequence) => {

        // 通过 data.readString() 可以获取卡片通过 call 方式传递过来的数据
        MyLog.d(`this.callee.on, ${this.cardCallMethod}, ${data.readString()}}`)

        // 1 秒后更新卡片的信息
        setTimeout(() => {
          let formId = want.parameters!['ohos.extra.param.key.form_identity'].toString();
          let formData: Record<string, string> = {
            'content': Helper.getTimestampString()
          };
          let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData)
          formProvider.updateForm(formId, formInfo)
        }, 1000)

        // 这里必须要返回一个 rpc.Parcelable 对象（空的 rpc.Parcelable 对象即可）
        return new MyParcelable();
      });
    }

    // 有 ohos.extra.param.key.form_identity 参数，所以是 router 或 call 方式拉起的
    if (want.parameters && want.parameters['ohos.extra.param.key.form_identity'] !== undefined) {
      // 获取卡片 id 并更新卡片的信息（关于这部分的说明，请参见 /entryformability/EntryFormAbility.ets）
      let formId = want.parameters['ohos.extra.param.key.form_identity'].toString();
      let formData: Record<string, string> = {
        'content': Helper.getTimestampString()
      };
      let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData)
      formProvider.updateForm(formId, formInfo)
    }
  }

  // UIAbility 实例销毁时
  onDestroy(): void {
    MyLog.d('ability onDestroy');

    if (this.cardCallMethod != '') {
      // 取消监听
      this.callee.off(this.cardCallMethod)
    }
  }

  // UIAbility 的窗口创建完成时
  // 在这里需要通过 windowStage.loadContent() 加载当前 UIAbility 的首页
  onWindowStageCreate(windowStage: window.WindowStage): void {
    MyLog.d('ability onWindowStageCreate');

    let record: Record<string, number> = {
      'myNumber': 5000
    };
    let storage: LocalStorage = new LocalStorage(record);

    // 加载当前 UIAbility 的首页
    //   必须是 @Entry 组件
    //   必须在 main_pages.json 文件（在 module.json5 中通过 "pages":"$profile:main_pages" 指定的）中声明
    // 这里指定的 LocalStorage 对象的数据，会自动合并到当前 UIAbility 的 LocalStorage.getShared() 中
    windowStage.loadContent('pages/Index', storage, (err) => {
      if (err.code) {
        MyLog.d(`windowStage.loadContent() failed, ${JSON.stringify(err)}`)
        return;
      }
      MyLog.d(`windowStage.loadContent() succeeded`)
    });
  }

  // UIAbility 的窗口销毁之前
  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    MyLog.d('ability onWindowStageWillDestroy');
  }

  // UIAbility 的窗口销毁时
  onWindowStageDestroy(): void {
    MyLog.d('ability onWindowStageDestroy');
  }

  // 切换到前台时
  onForeground(): void {
    MyLog.d('ability onForeground');
  }

  // 切换到后台时
  onBackground(): void {
    MyLog.d('ability onBackground');
  }

  // 内存占用级别发生变化时的回调
  // 注：在 AbilityStage 中也有此回调
  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    // MEMORY_LEVEL_MODERATE - 内存占用适中
    // MEMORY_LEVEL_LOW - 内存占用低
    // MEMORY_LEVEL_CRITICAL - 内存占用高
    MyLog.d(`ability onMemoryLevel ${level}`);
  }

  // 全局的环境配置发生变化时的回调（比如系统语言，深色浅色模式等）
  // 注：在 AbilityStage 中也有此回调
  onConfigurationUpdate(newConfig: Configuration): void {
    MyLog.d(`ability onConfigurationUpdate ${JSON.stringify(newConfig)}`);
  }
}

class MyParcelable implements rpc.Parcelable {
  num: number;
  str: string;

  constructor()
  constructor(num: number, str: string)

  constructor(num?: number, str?: string) {
    this.num = num ?? 0;
    this.str = str ?? "";
  }

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeInt(this.num);
    messageSequence.writeString(this.str);
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    this.num = messageSequence.readInt();
    this.str = messageSequence.readString();
    return true;
  }
}