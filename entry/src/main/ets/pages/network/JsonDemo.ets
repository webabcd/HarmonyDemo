/*
 * json
 */

import { TitleBar } from '../TitleBar';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct JsonDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('json 序列化和反序列化').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('解析 json 数据').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

class Person {
  name: string
  age: number
  constructor(name: string, age: number) {
    this.name = name
    this.age = age
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      /*
       * JSON - JSON
       *   stringify() - 对象转 json 字符串
       *   parse() - json 字符串转对象
       */

      Button("json 序列化").onClick(() => {
        let person = new Person("webabcd", 44)
        let json = JSON.stringify(person)
        this.message = `json:${json}`
      })

      Button("json 反序列化").onClick(() => {
        let json = '{"name":"webabcd", "age":44}'
        let person = JSON.parse(json) as Person
        this.message = `name:${person.name}, age:${person.age}`
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      /*
       * JSON - JSON
       *   parse() - json 字符串转对象
       *   has() - 判断对象是否包含指定名称的属性
       */

      Button("解析 json 对象").onClick(() => {
        let json = '{"name":"webabcd", "age":44}'
        let obj = JSON.parse(json) as object
        this.message = `name:${obj?.["name"]}, age:${obj?.["age"]}\n`
        this.message += `obj 是否有 name:${JSON.has(obj, "name")}, obj 是否有 age:${JSON.has(obj, "age")}`
      })

      Button("解析 json 数组").onClick(() => {
        let json = '[{"name":"webabcd", "age":44}]'
        let obj = JSON.parse(json)
        this.message = `length:${(obj as [])?.length}, name_0:${(obj as object)?.[0]["name"]}, age_0:${(obj as object)?.[0]["age"]}`
      })

      Text(this.message)
    }
  }
}