/*
 * @Provide/@Consume - 用于父组件 @Provide 与子组件 @Consume 之间的双向同步
 *
 * 注：
 * 1、@Provide 在其所在组件为祖先节点的整棵树下，与其所有后代节点的 @Consume 通过同一个地址共享
 * 2、需要同步的变量之间是通过指定的名称绑定的，而不是通过传参绑定的
 * 3、既支持对象的属性的双向同步，也支持对象的嵌套属性的双向同步，也支持对象本身的双向同步
 * 4、组件中的 @Consume 装饰的对象不能初始化
 * 5、组件中的 @Provide/@Consume 装饰的变量变化后，会更新当前组件中绑定了此变量的组件，这一点和 @State 是一样的
 */

import { TitleBar } from '../TitleBar';

class Name {
  public value: string;
  constructor(value: string) {
    this.value = value;
  }
}

@Observed
class Person {
  public name: Name;  // name.value 是 Person 的嵌套属性
  public age: number; // age 是 Person 的属性
  constructor(name: Name, age: number) {
    this.name = name;
    this.age = age;
  }
}

// 用于演示子
@Component
struct MyComponent1 {

  // 子通过 @Consume('xxx') 装饰的属性会与前辈的 @Provide 装饰的名为 xxx 属性做双向同步
  // 如果子的属性与前辈的属性的名称相同，则 @Consume('xxx') 可以简写为 @Consume
  @Consume age: number;
  @Consume person1: Person;
  @Consume person2: Person;

  build() {
    Column({ space: 10 }) {
      Text(`子 age:${this.age}`)
      Text(`子 person1 age:${this.person1.age}, name:${this.person1.name.value}`)
      Text(`子 person2 age:${this.person2.age}, name:${this.person2.name.value}`)

      Button('修改子')
        .onClick(() => {
          // 基本数据类型可以双向绑定
          this.age ++

          // 对象的属性和嵌套属性可以双向绑定
          this.person1.age ++
          this.person1.name.value = "子子子"

          // 对象本身可以双向绑定
          this.person2 = new Person(new Name("子子子"), Math.floor(Math.random() * 1000))
        })
    }
  }
}

// 用于演示父
@Entry
@Component
struct ProvideDemo {

  // 父通过 @Provide('xxx') 装饰的属性会与后代的 @Consume 装饰的名为 xxx 属性做双向同步
  // 如果父的属性与后代的属性的名称相同，则 @Provide('xxx') 可以简写为 @Provide
  @Provide age: number = 0;
  @Provide person1: Person = new Person(new Name("webabcd"), 44)
  @Provide person2: Person = new Person(new Name("wanglei"), 0)

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 实例化子，并做参数的初始化
      // 通过 @Provide/@Consume 做父子双向同步是不需要传参的
      MyComponent1({ })

      Text(`父 age:${this.age}`)
      Text(`父 person1 age:${this.person1.age}, name:${this.person1.name.value}`)
      Text(`父 person2 age:${this.person2.age}, name:${this.person2.name.value}`)

      Button('修改父')
        .onClick(() => {
          // 基本数据类型可以双向绑定
          this.age ++

          // 对象的属性和嵌套属性可以双向绑定
          this.person1.age ++
          this.person1.name.value = "父父父"

          // 对象本身可以双向绑定
          this.person2 = new Person(new Name("父父父"), Math.floor(Math.random() * 1000))
        })
    }
  }
}