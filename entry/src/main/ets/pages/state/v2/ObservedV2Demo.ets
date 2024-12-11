/*
 * v2 @ObservedV2/@Trace - v2 版状态管理
 *   用于监测 @ObservedV2 的类的 @Trace 的属性的变化，有变化则刷新绑定了此对象的组件
 *
 * 说明：
 * 1、对于 ObservedV2 装饰的类中的 @Trace 装饰的属性（包括多层嵌套的），会提供变化监测能力，有变化则刷新绑定了此对象的组件
 * 2、array, set, map 之类的增删改也可以监测到
 * 3、静态属性也支持此特性
 * 4、无法监测对象本身的变化
 *
 * 注：
 * 1、v2 版状态管理与 v1 版状态管理（比如 @State 之类的）不可混用
 * 2、使用 v2 版状态管理的组件要用 @ComponentV2 装饰
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
  public age: number; // age 是 Person 的属性
  @Trace static max: number = 1000;
  constructor(name: Name, age: number) {
    this.name = name;
    this.age = age;
  }
}

@ObservedV2
class MyData {
  @Trace personList: Person[] = [];
  constructor() {
    this.personList = [
      new Person(new Name('aaa'), 11),
      new Person(new Name('bbb'), 22),
      new Person(new Name('ccc'), 33),
    ];
  }
}

@Entry
@ComponentV2
struct ObservedV2Demo {

  person: Person = new Person(new Name("webabcd"), 44)
  myData: MyData = new MyData()

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(`person name:${this.person.name.value}, age:${this.person.age}, max:${Person.max}`)

      ForEach(this.myData.personList, (item: Person, index: number) => {
        Text(`${index} ${item.name.value} ${item.age}`)
      })

      // Person 类的 max 静态属性是用 @Trace 装饰的，可以监测变化，有变化则刷新绑定了此对象的组件
      Button('更新 Person 的名为 max 的静态属性')
        .onClick(() => {
          Person.max = Math.floor(Math.random() * 1000)
        })

      // Name 类的 value 属性是用 @Trace 装饰的，可以监测变化，有变化则刷新绑定了此对象的组件
      Button('更新 person 的 name.value')
        .onClick(() => {
          this.person.name.value = "abc"
        })

      // person 类的 age 属性没有用 @Trace 装饰，无法监测变化，所以当其发生变化时不会刷新绑定了此对象的组件
      Button('更新 person 的 age')
        .onClick(() => {
          this.person.age = Math.floor(Math.random() * 1000)
        })

      // name.value 的变化，会刷新绑定了 person 的组件
      // age 的变化，不会刷新绑定了 person 的组件
      // 但是此时，因为绑定了 person 的组件会刷新，所以 age 的变化也会被刷新
      Button('更新 person 的 name.value 和 age')
        .onClick(() => {
          this.person.name.value = "xyz"
          this.person.age = Math.floor(Math.random() * 1000)
        })

      // ObservedV2 装饰的类中的 @Trace 装饰的 array, set, map 之类的增删改也可以监测到
      Button('更新 MyData 的 personList 的第一个对象的属性')
        .onClick(() => {
          this.myData.personList[0].name.value = 'wanglei'
          this.myData.personList[0].age = Math.floor(Math.random() * 1000)
        })
      Button('删除 MyData 的 personList 的第一个对象')
        .onClick(() => {
          this.myData.personList.shift()
        })
      Button('在 MyData 的 personList 的 0 位置处新增一条数据')
        .onClick(() => {
          this.myData.personList.unshift(new Person(new Name('xxx'), Math.floor(Math.random() * 1000)))
        })
    }
  }
}