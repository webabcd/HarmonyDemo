/*
 * @State 表示组件中的状态变量，状态变量变化会触发相关 UI 刷新
 * 即系统会自动监测 @State 变量的变化，如果发生了变化，则会刷新绑定了此 @State 变量的组件
 *
 * 注：
 * 1、@State 不支持嵌套属性的变化监测
 * 2、@State 装饰的变量声明时必须初始化
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

@Entry
@Component
struct StateDemo {

  @State num: number = 0
  @State person1: Person = new Person(new Name("aaa"), 10)
  @State person2: Person = new Person(new Name("bbb"), 20)
  @State person3: Person = new Person(new Name("ccc"), 30)
  @State person4: Person = new Person(new Name("ddd"), 40)
  @State myArray: number[] = [1, 2, 3, ]
  @State mySet: Set<number> = new Set([1, 2, 3, ]);
  @State myMap: Map<number, string> = new Map([[1, "a"], [2, "b"], [3, "c"]]);

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(`${this.num}`)
      Text(`${this.person1.name.value} ${this.person1.age}`)
      Text(`${this.person2.name.value} ${this.person2.age}`)
      Text(`${this.person3.name.value} ${this.person3.age}`)
      Text(`${this.person4.name.value} ${this.person4.age}`)
      Text(`${this.myArray[0]}`)
      Text(`${Array.from(this.mySet)[0]}`)
      Text(`${this.myMap.get(1)}`)

      Button('button0').onClick(() => {
        // 修改 @State 装饰的变量，则会刷新绑定了此变量的组件
        this.num ++
      })

      Button('button1').onClick(() => {
        // 修改 @State person1 对象，会刷新绑定了 person1 的组件
        this.person1 = new Person(new Name("aaaaaa"), 100)
      })
      Button('button2').onClick(() => {
        // 修改 @State person2 对象的属性，会刷新绑定了 person2 的组件
        this.person2.age = 200
      })
      Button('button3').onClick(() => {
        // 修改 @State person3 对象的属性的属性（嵌套属性），不会刷新绑定了 person3 的组件
        this.person3.name.value = "cccccc"
      })
      Button('button4').onClick(() => {
        // 修改 @State person4 对象的属性的属性（嵌套属性），不会刷新绑定了 person4 的组件
        // 然后修改 @State person4 对象的属性，会刷新绑定了 person4 的组件
        // 此时，因为绑定了 person4 的组件会刷新，所以此对象的属性的属性（嵌套属性）的变化也会被刷新
        this.person4.name.value = "dddddd"
        this.person4.age = 400
      })

      Button('button5').onClick(() => {
        // 修改 @State myArray 中的元素，会刷新绑定了 myArray 的组件
        this.myArray[0] = 100
      })
      Button('button6').onClick(() => {
        // 修改 @State mySet 中的元素，会刷新绑定了 mySet 的组件
        this.mySet.clear()
        this.mySet.add(100)
      })
      Button('button7').onClick(() => {
        // 修改 @State myMap 中的键值，会刷新绑定了 myMap 的组件
        this.myMap.set(1, "100")
      })
    }
  }
}
