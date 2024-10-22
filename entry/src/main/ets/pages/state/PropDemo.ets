/*
 * 对象的属性会触发 UI 刷新，可以观测到对象的属性的变化
 */

import { TitleBar } from '../TitleBar';

@Component
struct MyComponent {
  no: number = 0;
  @Prop name: string;
  @Link email: string;
  @Consume address: string;
  @ObjectLink person_name: Name;

  build() {
    Column({ space: 10 }) {
      Text(`${this.no} ${this.name} ${this.email} ${this.address} ${this.person_name.value}`)
      Button('MyComponent')
        .onClick(() => {
          this.no = 111
          this.name = "aaa"
          this.email = "bbb"
          this.address = "ccc"
          this.person_name.value = "ddd"
        })
    }
  }
}

@Observed
class Name {
  public value: string;
  constructor(value: string) {
    this.value = value;
  }
}

@Observed
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
struct PropDemo {
  @State my_no: number = 1
  @State my_name: string = "a"
  @State my_email: string = "b"
  @Provide('address') my_address: string = "c"
  @State my_person: Person = new Person(new Name("d"), 2)

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Text(`${this.my_no} ${this.my_name} ${this.my_email} ${this.my_address} ${this.my_person.name.value}`)
      MyComponent({
        no: this.my_no,
        name: this.my_name,
        email: this.my_email,
        // address: this.my_address,
        person_name: this.my_person.name,
      })
      Button('button')
        .onClick(() => {
          this.my_no = 11
          this.my_name = "aa"
          this.my_email = "bb"
          this.my_address = "cc"
          this.my_person.name.value = "dd"
          this.my_person.age = 22
        })
    }
  }
}
