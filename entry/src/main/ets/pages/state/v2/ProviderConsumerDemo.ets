/*
 * @Provider()/@Consumer() - 用于父组件 @Provider() 与子组件 @Consumer() 之间的双向同步
 *
 * 注：
 * 1、@Provider() 在其所在组件为祖先节点的整棵树下，与其所有后代节点的 @Consumer() 共享
 * 2、如果需要对象的属性的双向同步，则可以结合 @ObservedV2/@Trace 一起实现，参见 /state/v2/ObservedV2Demo.ets 中的说明
 * 3、需要同步的变量之间是通过指定的名称绑定的，而不是通过传参绑定的
 * 4、@Provider()/@Consumer() 装饰的变量变化后，会更新当前组件中绑定了此变量的组件
 */

import { TitleBar } from '../../TitleBar';

@ObservedV2
class Name {
  @Trace public value: string;
  constructor(value: string) {
    this.value = value;
  }
}

@ObservedV2
class Person {
  public name: Name;  // name.value 是 Person 的嵌套属性
  @Trace public age: number; // age 是 Person 的属性
  constructor(name: Name, age: number) {
    this.name = name;
    this.age = age;
  }
}

// 用于演示子
@ComponentV2
struct MyComponent1 {

  // 子通过 @Consumer('xxx') 装饰的属性会与前辈的 @Provider() 装饰的名为 xxx 属性做双向同步
  // 如果子的属性与前辈的属性的名称相同，则 @Consumer('xxx') 可以简写为 @Consumer()
  @Consumer() age: number = 0;
  @Consumer() person1: Person = new Person(new Name(''), 0);
  @Consumer() person2: Person = new Person(new Name(''), 0);
  // 回调函数支持子的 @Consumer() 到父的 @Provider() 的单向同步（但是不支持父到子的同步）
  @Consumer() onCallback: (str: string) => void = (str: string) => { }

  build() {
    Column({ space: 10 }) {
      Text(`子 age:${this.age}`)
      Text(`子 person1 age:${this.person1.age}, name:${this.person1.name.value}`)
      Text(`子 person2 age:${this.person2.age}, name:${this.person2.name.value}`)

      Button('修改子')
        .onClick(() => {
          // 基本数据类型可以双向绑定
          this.age ++

          // 对象的属性和嵌套属性可以双向绑定（需要结合 @ObservedV2/@Trace 一起）
          this.person1.age ++
          this.person1.name.value = "子子子"

          // 对象本身可以双向绑定
          this.person2 = new Person(new Name("子子子"), Math.floor(Math.random() * 1000))

          // 回调函数支持子的 @Consumer() 到父的 @Provider() 的单向同步（但是不支持父到子的同步）
          this.onCallback('子子子')
        })
    }
  }
}

// 用于演示父
@Entry
@ComponentV2
struct ProviderConsumerDemo {

  // 父通过 @Provider('xxx') 装饰的属性会与后代的 @Consumer() 装饰的名为 xxx 属性做双向同步
  // 如果父的属性与后代的属性的名称相同，则 @Provider('xxx') 可以简写为 @Provider()
  @Provider() age: number = 0;
  @Provider() person1: Person = new Person(new Name("webabcd"), 44)
  @Provider() person2: Person = new Person(new Name("wanglei"), 0)
  // 回调函数支持子的 @Consumer() 到父的 @Provider() 的单向同步（但是不支持父到子的同步）
  @Provider() onCallback: (str: string) => void = (str: string) => {
    this.message = str
  }
  @Local message: string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 实例化子，并做参数的初始化
      // 通过 @Provider()/@Consumer() 做父子双向同步是不需要传参的
      MyComponent1({ })

      Text(`父 age:${this.age}`)
      Text(`父 person1 age:${this.person1.age}, name:${this.person1.name.value}`)
      Text(`父 person2 age:${this.person2.age}, name:${this.person2.name.value}`)
      Text(`父 message:${this.message}`)

      Button('修改父')
        .onClick(() => {
          // 基本数据类型可以双向绑定
          this.age ++

          // 对象的属性和嵌套属性可以双向绑定（需要结合 @ObservedV2/@Trace 一起）
          this.person1.age ++
          this.person1.name.value = "父父父"

          // 对象本身可以双向绑定
          this.person2 = new Person(new Name("父父父"), Math.floor(Math.random() * 1000))

          // 回调函数支持子的 @Consumer() 到父的 @Provider() 的单向同步（但是不支持父到子的同步）
          this.onCallback('父父父')
        })
    }
  }
}