/*
 * v2 UIUtils.makeObserved() - v2 版状态管理
 *   UIUtils.makeObserved() - 用于将指定的不可观察数据变为可观察数据
 *
 * 注：
 * 1、使用 v2 版状态管理的组件要用 @ComponentV2 装饰
 * 2、无法用 Previewer 测试，需要用模拟器或真机
 */

import { TitleBar } from '../../TitleBar';
import { UIUtils } from '@kit.ArkUI';

class MyClass {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}

@Entry
@ComponentV2
struct MakeObservedDemo {

  /*
   * UIUtils.makeObserved() - 用于将指定的不可观察数据变为可观察数据
   */
  myClass: MyClass = UIUtils.makeObserved(new MyClass(0));

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 通过 UIUtils.makeObserved() 可以观察指定的数据的变化，有变化时会更新相关 UI
      Button('click me').onClick(() => {
        this.myClass.id ++
      })
      Text(`${this.myClass.id}`)
    }
  }
}
