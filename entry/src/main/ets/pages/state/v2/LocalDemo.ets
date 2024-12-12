/*
 * v2 @Local - v2 版状态管理
 *   用于监测 @Local 装饰的变量的本身的变化
 *
 * 说明：
 * 1、对于 @Local 装饰的变量本身提供变化监测能力，有变化则刷新绑定了此变量的组件
 * 2、array, set, map 之类的增删改也可以监测到
 * 3、无法监测对象的属性的变化，需要的话可以使用 @ObservedV2/@Trace，请参见 /state/v2/ObservedV2Demo.ets 中的说明
 * 4、@Local 装饰的变量声明时必须初始化，且不允许构造组件时从外部初始化 @Local 装饰的变量
 *
 * 注：使用 v2 版状态管理的组件要用 @ComponentV2 装饰
 */

import { TitleBar } from '../../TitleBar';

class Person {
  public name: string;
  public age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

// 构造此组件时，不能从外部初始化 @Local 装饰的变量
@ComponentV2
struct MyComponent1 {
  @Local num: number = 0
  build() {
    Text(`num:${this.num}`)
  }
}

@Entry
@ComponentV2
struct LocalDemo {

  @Local num: number = 0
  @Local person: Person = new Person("webabcd", 44)
  @Local myArray: number[] = [1, 2, 3, ]
  @Local mySet: Set<number> = new Set([1, 2, 3, ]);
  @Local myMap: Map<number, string> = new Map([[1, "a"], [2, "b"], [3, "c"]]);

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // MyComponent1 的 num 是 @Local 装饰的，无法通过如下方式初始化
      // MyComponent1({num:100})

      Text(`num:${this.num}`)
      Text(`person name:${this.person.name}, age:${this.person.age}`)
      Text(`${this.myArray[0]}`)
      Text(`${Array.from(this.mySet)[0]}`)
      Text(`${this.myMap.get(1)}`)

      Button('button0').onClick(() => {
        this.num ++
      })

      Button('button1')
        .onClick(() => {
          this.person = new Person("wanglei", 100)
        })

      // @Local 装饰的 array, set, map 之类的增删改也可以监测到
      Button('button2').onClick(() => {
        this.myArray[0] = 100
      })
      Button('button3').onClick(() => {
        this.mySet.clear()
        this.mySet.add(100)
      })
      Button('button4').onClick(() => {
        this.myMap.set(1, "100")
      })
    }
  }
}