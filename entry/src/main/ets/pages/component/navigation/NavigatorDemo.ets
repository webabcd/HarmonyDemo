/*
 * Navigator - 导航器，支持通过页面地址导航
 *   页面需要用 @Entry 装饰，且需要在 main_pages.json 文件（在 module.json5 中通过 "pages":"$profile:main_pages" 指定的）中声明
 *
 * 注：此组件已过时（deprecated），如需通过页面地址导航请使用 router（参见 RouterDemo.ets 中的说明）
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct NavigatorDemo {

  build() {
    Column({space:10}) {
      TitleBar()

      /*
       * Navigator - 导航器，支持通过页面地址导航
       *   点击这个 Navigator 组件，则会触发这个 Navigator 的导航行为
       *   target - 目标页的地址
       *   type - 导航类型（NavigationType 枚举）
       *     Push - 跳转到指定页
       *     Replace - 销毁当前页，并用目标页替换
       *     Back - 从栈顶到栈底查找，返回到指定的目标页，找不到则不响应，未设置目标页则返回上一页
       *   params() - 传递给目标页的数据
       *   active() - 是否触发当前 Navigator 的导航行为
       *
       * 注：其他用法请参见 component/navigation/pages/NavigatorDemo_Page1.ets 中的说明
       */
      Navigator({ target: 'pages/component/navigation/pages/NavigatorDemo_Page1', type: NavigationType.Push }) {
        Text('push').fontSize(24)
      }
      .params(new Person("webabcd", 44))
    }
  }
}

export class Person {
  public name: string;
  public age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}