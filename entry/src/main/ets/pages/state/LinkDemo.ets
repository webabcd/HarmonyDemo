/*
 * @Link - 用于父组件 @State 与子组件 @Link 之间的双向同步
 *
 * 注：
 * 1、两个同步的变量是通过同一个地址共享的
 * 2、支持对象的属性的双向同步，但是不支持对象的嵌套属性的双向同步
 * 3、组件中的 @Link 装饰的变量不能初始化
 * 4、组件中的 @Link 装饰的变量变化后，会更新当前组件中绑定了此变量的组件，这一点和 @State 是一样的
 */

import { TitleBar } from '../TitleBar';

class Name {
  public value: string;
  constructor(value: string) {
    this.value = value;
  }
}

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

  // 父的 age1 变化，不会触发子的 age1 的变化
  // 子的 age1 变化，不会触发父的 age1 的变化
  @State age1: number = 0;

  // 父的 age2 变化，会触发子的 age2 的变化
  // 子的 age2 变化，会触发父的 age2 的变化
  @Link age2: number;

  // 对象的属性也支持父与子的双向同步
  @Link person1: Person;

  // 对象的嵌套属性不支持父与子的双向同步
  @Link person2: Person;

  build() {
    Column({ space: 10 }) {
      Text(`子 age1:${this.age1}, age2:${this.age2}`)
      Text(`子 person1 age:${this.person1.age}`)
      Text(`子 person2 name:${this.person2.name.value}`)

      Button('修改子')
        .onClick(() => {
          this.age1 ++
          this.age2 ++
          this.person1.age ++
          this.person2.name.value = "xxx"
        })
    }
  }
}

// 用于演示父
@Entry
@Component
struct LinkDemo {

  @State age1: number = 0
  @State age2: number = 0
  @State person1: Person = new Person(new Name("webabcd"), 44)
  @State person2: Person = new Person(new Name("wanglei"), 22)

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 实例化子，并做参数的初始化
      MyComponent1({
        age1: this.age1,
        age2: this.age2,
        person1: this.person1,
        person2: this.person2,
      })

      Text(`父 age1:${this.age1}, age2:${this.age2}`)
      Text(`父 person1 age:${this.person1.age}`)
      Text(`父 person2 name:${this.person2.name.value}`)

      Button('修改父')
        .onClick(() => {
          this.age1 ++
          this.age2 ++
          this.person1.age ++
          this.person2.name.value = "xxx"
        })
    }
  }
}