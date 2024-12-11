/*
 * @ObjectLink/@Observed - 用于父组件 @State 与子组件 @ObjectLink 之间的双向同步
 *
 * 注：
 * 1、两个同步的变量是通过同一个地址共享的
 * 2、既支持对象的属性的双向同步，也支持对象的嵌套属性的双向同步
 * 3、组件中的 @ObjectLink 装饰的对象的类必须要用 @Observed 装饰
 * 4、组件中的 @ObjectLink 装饰的对象不能初始化
 * 5、如果是对象本身发生变化，则只支持父到子的同步，而不支持子到父的同步
 * 6、无论是父的对象本身的变化，还是父或子的属性或嵌套属性的变化，都会触发绑定了此对象的组件的刷新
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

  @ObjectLink person1: Person
  @ObjectLink person2: Person

  build() {
    Column({ space: 10 }) {
      Text(`子 person1 age:${this.person1.age}, name:${this.person1.name.value}`)
      Text(`子 person2 age:${this.person2.age}, name:${this.person2.name.value}`)

      Button('修改子')
        .onClick(() => {
          this.person1.age ++
          this.person1.name.value = "子子子"

          // 修改对象本身时会抛出异常 Cannot set property when setter is undefined
          // 从而导致子的绑定了此对象的组件不会刷新，从而导致无法子到父同步
          // this.person2 = new Person(new Name("子子子"), Math.floor(Math.random() * 1000))
        })
    }
  }
}

// 用于演示父
@Entry
@Component
struct ObjectLinkDemo {

  @State person1: Person = new Person(new Name("webabcd"), 44)
  @State person2: Person = new Person(new Name("父父父"), 0)

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 实例化子，并做参数的初始化
      MyComponent1({
        person1: this.person1,
        person2: this.person2,
      })

      Text(`父 person1 age:${this.person1.age}, name:${this.person1.name.value}`)
      Text(`父 person2 age:${this.person2.age}, name:${this.person2.name.value}`)

      Button('修改父')
        .onClick(() => {
          this.person1.age ++
          this.person1.name.value = "父父父"

          this.person2 = new Person(new Name("父父父"), Math.floor(Math.random() * 1000))
        })
    }
  }
}