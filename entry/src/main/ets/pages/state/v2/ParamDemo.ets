/*
 * v2 @Param, @Once, @Event - v2 版状态管理
 *   组件中 @Local 装饰的变量可以监测组件内变量本身的变化，有变化则刷新绑定了此变量的组件（参见 LocalDemo.ets 中的说明）
 *   组件中 @Param 装饰的变量用于父到子的同步，子收到变化后会刷新子的绑定了此变量的组件
 *   组件中 @Once 必须要结合 @Param 一起使用，代表只能父到子同步一次
 *   组件中 @Event 装饰用于定义回调函数，以便自定义子到父的数据传递
 *
 * 说明：
 * 1、v2 组件中，没有装饰的变量或 @Local 装饰的变量，在声明时必须初始化,且不允许构造组件时从外部初始化
 * 2、@Param 装饰的变量可以初始化，也可以不初始化，也可以通过叠加 @Require 要求在构造组件的时候必须要传参
 * 3、v2 组件中定义回调函数时，要通过 @Event 装饰，否则无法在构造组件时从外部传参
 * 4、如需监测对象的属性的变化，请参见 /state/v2/ObservedV2Demo.ets 中的说明
 *
 * 注：使用 v2 版状态管理的组件要用 @ComponentV2 装饰
 */

import { TitleBar } from '../../TitleBar';

@ObservedV2
class Person {
  @Trace public name: string;
  @Trace public age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@ComponentV2
struct MyComponent1 {
  @Require @Param person: Person = new Person("", 0)
  @Event onCallback: (person: Person) => void = (person: Person) => {};

  // 像下面这样 @Param @Once 代表只能父到子同步一次，这里指的是 person 本身只能父到子同步一次
  // 而 person 是 @ObservedV2 的且其属性是 @Trace 的，所以它的属性的双向同步是不受影响的
  // @Require @Param @Once person: Person = new Person("", 0)

  build() {
    Column({ space: 10 }) {
      Text(`子 person name:${this.person.name}, age:${this.person.age}`)
      Button('修改子 person 对象本身').onClick(() => {
        // 像下面这样修改 person 本身是无法实现子到父同步的
        // this.person = new Person("子子子", Math.floor(Math.random() * 1000))

        // 需要子到父传递指定的数据的话，可以使用回调函数（回调函数要用 @Event 装饰）
        this.onCallback(new Person("子子子", Math.floor(Math.random() * 1000)))
      })
      Button('修改子 person 对象属性').onClick(() => {
        // 因为子的 person 是 @Param，且 person 是 @ObservedV2 的且其属性是 @Trace 的，所以子的 person 的属性的变化会同步给父的 person
        this.person.name = '子子子'
        this.person.age = Math.floor(Math.random() * 1000)
      })
    }
  }
}

@Entry
@ComponentV2
struct ParamDemo {

  @Local person: Person = new Person("webabcd", 44)

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // 实例化子，并做参数的初始化
      MyComponent1({
        person: this.person,
        onCallback: (person: Person) => {
          this.person = person
        }
      })

      Text(`父 person name:${this.person.name}, age:${this.person.age}`)
      Button('修改父 person 对象本身').onClick(() => {
        // 因为子的 person 是 @Param，所以父的 person 本身的变化会同步给子的 person
        this.person = new Person("父父父", Math.floor(Math.random() * 1000))
      })
      Button('修改父 person 对象属性').onClick(() => {
        // 因为子的 person 是 @Param，且 person 是 @ObservedV2 的且其属性是 @Trace 的，所以父的 person 的属性的变化会同步给子的 person
        this.person.name = '父父父'
        this.person.age = Math.floor(Math.random() * 1000)
      })
    }
  }
}