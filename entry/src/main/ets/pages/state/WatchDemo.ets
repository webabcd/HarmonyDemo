/*
 * @Watch - 用于为状态变量指定变化后的回调函数
 * @Track - 对象的属性通过其装饰后可触发 UI 的更新
 * $$ - 用于为部分内置组件提供数据的双向同步功能
 */

import { TitleBar } from '../TitleBar';

@Component
struct MyComponent {
  // 通过 @Watch('xxx') 为状态变量指定名为 xxx 的回调函数
  @Prop @Watch('onCountUpdated') count: number;
  @State total: number = 0;

  // 通过 @Watch('onCountUpdated') 指定的名为 onCountUpdated 的回调函数
  onCountUpdated(propName: string): void {
    this.total += this.count;
  }

  build() {
    Text(`total: ${this.total}`)
  }
}

class Person {
  // 因为 name 有 @Track 装饰，所以 name 的变化会触发 UI 的更新（当然，前提是你的相关的对象需要是一个 @State 之类的状态变量）
  // 注：如果整个类都没有 @Track 装饰器，则所有属性的变化都会触发 UI 的更新
  @Track name: string;
  // 当前类其他属性有 @Track 装饰，但是这个 age 没有 @Track 装饰，所以 age 的变化不会触发 UI 的更新
  // 注：这种情况下 age 是不能显示到 UI 上的，否则会出现异常
  age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Entry
@Component
struct WatchDemo {

  @State count: number = 0;

  @State person: Person = new Person('webabcd', 44);

  @State text: string = 'abc'
  controller: TextInputController = new TextInputController()

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(`count: ${this.count}`)
      MyComponent({
        count: this.count
      })
      Button('演示 @Watch')
        .onClick(() => {
          this.count++
        })

      Divider()

      Text(`${this.person.name}`)
      Button('演示 @Track')
        .onClick(() => {
          this.person.name = "wanglei"
        })

      Divider()

      Text(this.text)
      // 通过 $$ 为 TextInput 组件的 text 属性提供数据的双向同步功能
      // 注：只有部分组件的部分属性才支持此功能，比如 Checkbox 的 select 属性，Slider 的 value 属性等，详见各个组件的相关文档
      TextInput({
        text: $$this.text,
        controller: this.controller
      })
    }
  }
}