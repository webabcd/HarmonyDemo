/*
 * @Prop - 父到子单项同步
 * @Link - 父子双向同步
 * @Provide/@Consume - 父子双向同步（不需要传参）
 * @Observed/@ObjectLink - 父到子单项同步（支持嵌套对象的观测）
 *
 * 注：以上装饰器标记的对象的属性发生变化时，系统也是可以观测到的
 */

import { TitleBar } from '../TitleBar';

// 用于演示子
@Component
struct MyComponent1 {
  // 父的 no 变化，不会触发子的 no 的变化
  // 子的 no 变化，不会触发父的 no 的变化
  @State no: number = 0;
  // 父的 name 变化，会触发子的 name 的变化
  // 子的 name 变化，不会触发父的 name 的变化
  @Prop name: string;
  // 父的 email 变化，会触发子的 email 的变化
  // 子的 email 变化，会触发父的 email 的变化
  @Link email: string;
  // 父的 @Provide 装饰的 address 变化，会触发子的 @Consume 装饰的 address 的变化
  // 子的 @Consume 装饰的 address 变化，会触发父的 @Provide 装饰的 address 的变化
  @Consume address: string;

  build() {
    Column({ space: 10 }) {
      Text(`子 MyComponent1 ${this.no} ${this.name} ${this.email} ${this.address}`)
      Button('修改子 MyComponent1')
        .onClick(() => {
          this.no = 111
          this.name = "aaa"
          this.email = "bbb"
          this.address = "ccc"
        })
    }
  }
}

// 用于演示子
@Component
struct MyComponent2 {
  @Require parent?: Parent
  build() {
    Column({ space: 10 }) {
      // 把需要观测的嵌套对象包装到一个组件中，并在这个组件中通过 @ObjectLink 装饰这个嵌套对象
      MyComponent2_Child({
        child: this.parent!.child
      })
      Button('修改子 MyComponent2')
        .onClick(() => {
          this.parent!.child.value = "ddd"
        })
    }
  }
}
@Component
struct MyComponent2_Child {
  // @ObjectLink 需要与 @Observed 配合使用，用于嵌套对象的属性的观测
  @ObjectLink child: Child;
  build() {
    Text(`子 MyComponent2  ${this.child.value}`)
  }
}

// @Observed 需要与 @ObjectLink 配合使用
@Observed
class Child {
  public value: string;
  constructor(value: string) {
    this.value = value;
  }
}
@Observed
class Parent {
  public child: Child;
  public other: string;
  constructor(child: Child, other: string) {
    this.child = child;
    this.other = other;
  }
}

// 用于演示父
@Entry
@Component
struct PropDemo {
  @State my_no: number = 1
  @State my_name: string = "a"
  @State my_email: string = "b"
  // 父通过 @Provide('xxx') 标记的属性会与子的 @Consume 标记的名为 xxx 属性做双向同步
  // 如果父属性与子属性的名称相同，则 @Provide('xxx') 可以简写为 @Provide
  @Provide address: string = "c"
  @State my_parent: Parent = new Parent(new Child("d"), "")

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(`父 ${this.my_no} ${this.my_name} ${this.my_email} ${this.address}`)
      // 实例化子，并做参数的初始化
      MyComponent1({
        no: this.my_no,
        name: this.my_name,
        email: this.my_email,
        // 通过 @Provide/@Consume 做父子双向同步是不需要传参的
        // address: this.my_address,
      })
      Button('修改父，配合 MyComponent1 做演示')
        .onClick(() => {
          this.my_no = 11
          this.my_name = "aa"
          this.my_email = "bb"
          this.address = "cc"
        })

      Divider()

      Text(`父 ${this.my_parent.child.value}`)
      // 实例化子，并做参数的初始化
      MyComponent2({
        parent: this.my_parent,
      })
      // 本例用于演示如何在修改嵌套对象后，触发 UI 的刷新（另外：有个简单的在 @State 装饰中修改嵌套对象后刷新 UI 的小技巧，参见 StateDemo.ets 中的说明）
      Button('修改父，配合 MyComponent2 做演示')
        .onClick(() => {
          this.my_parent.child.value = "dd"
        })
    }
  }
}