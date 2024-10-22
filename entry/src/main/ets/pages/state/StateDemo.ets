/*
 * @State 表示组件中的状态变量，状态变量变化会触发 UI 刷新（即系统会自动观测 @State 变量的变化，如果发生了变化则触发 UI 刷新）
 */

import { TitleBar } from '../TitleBar';

class Name {
  public value: string;
  constructor(value: string) {
    this.value = value;
  }
}

class Person {
  public name: Name;
  public age: number;
  constructor(name: Name, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Entry
@Component
struct StateDemo {
  @State person1: Person = new Person(new Name("aaa"), 10)
  @State person2: Person = new Person(new Name("bbb"), 20)
  @State array: number[] = [1, 2, 3, ]
  @State set: Set<number> = new Set([1, 2, 3, ]);
  @State map: Map<number, string> = new Map([[1, "a"], [2, "b"], [3, "c"]]);

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Text(`${this.person1.name.value} ${this.person1.age}`)
      Text(`${this.person2.name.value} ${this.person2.age}`)
      Text(`${this.array[0]}`)
      Text(`${Array.from(this.set)[0]}`)
      Text(`${this.map.get(1)}`)
      Button('button')
        .onClick(() => {
          // 修改 @State 标记的变量会触发 UI 刷新
          this.person1 = new Person(new Name("aaaaaa"), 100)
          // 修改 @State 标记的对象的属性会触发 UI 刷新
          this.person2.age = 200
          // 修改 @State 标记的对象的内嵌对象的属性也会触发 UI 刷新
          this.person2.name.value = "bbbbbb"
          // 修改 @State 标记的 array 中的元素会触发 UI 刷新
          this.array[0] = 100
          // 修改 @State 标记的 set 中的元素会触发 UI 刷新
          this.set.clear()
          this.set.add(100)
          // 修改 @State 标记的 map 中的元素会触发 UI 刷新
          this.map.set(1, "100")
        })
    }
  }
}
