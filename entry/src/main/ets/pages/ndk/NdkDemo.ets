/*
 * NDK 基础
 * 详见 /ndk1/src/main/ets/pages/NdkDemo.ets
 */

import { TitleBar } from '../TitleBar';
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct NdkDemo {

  context = getContext() as common.UIAbilityContext;

  build() {
    Column() {
      TitleBar()

      Button("打开 ndk 演示页面").onClick(() => {
        let want: Want = {
          bundleName: 'com.webabcd.harmonydemo',
          moduleName: 'ndk1',
          abilityName: 'com.webabcd.harmonydemo.Ndk1Ability',
        };
        this.context.startAbility(want);
      })
    }
  }
}