/*
 * UIAbility - 用于为应用提供绘制界面的窗口
 *
 * 本例演示了如何获取上下文对象，如何返回数据给父 UIAbility，如何在一个 UIAbility 内做事件的发布和订阅
 * 本页面所属的 UIAbility 请参见 /entry/src/main/ets/entryability/EntryAbility2.ets 中的代码
 */

import { MyLog, TitleBar } from '../TitleBar';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct UIAbilityDemo2 {

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

  /*
   * getContext(this) - 获取上下文对象
   */
  context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    /*
     * context.eventHub - 用于在当前 UIAbility 内做事件的发布和订阅
     *   on() - 订阅指定的事件，并接收发布事件时的参数
     *   off() - 取消订阅指定的事件
     */
    this.context.eventHub.on('my_event', (p1: string, p2: number) => {
      this.message = `监听到 my_event 事件 ${p1} ${p2}`
    });
  }

  aboutToDisappear(): void {
    this.context.eventHub.off('my_event');
  }

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      Button("杀死当前 UIAbility").onClick(() => {
        this.context.terminateSelf()
      })

      Button("杀死当前 UIAbility 并返回结果给父 UIAbility").onClick(() => {
        /*
         * context.terminateSelfWithResult() - 杀死当前 UIAbility 并将指定的 AbilityResult 对象返回给父 UIAbility
         * AbilityResult - 返回给父 UIAbility 的对象
         *   resultCode - 需要返回的 code
         *   want - 父 ability 的相关信息
         *     parameters - 需要返回的数据
         */
        let abilityResult: common.AbilityResult = {
          resultCode: 123,
          want: {
            bundleName: 'com.webabcd.harmonydemo', // 父 ability 的 bundle 的名称
            abilityName: 'com.webabcd.harmonydemo.EntryAbility', // 父 ability 的名称
            parameters: { // 传参
              'k3': 'v3',
              'k4': 'v4',
            }
          },
        };
        this.context.terminateSelfWithResult(abilityResult, (err) => {
          MyLog.d(`terminateSelfWithResult failed, ${JSON.stringify(err)}`)
        });
      })
    }
  }
}
