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

      Button("json 序列化（并格式化）").onClick(() => {
        let person = new Person("webabcd", 44)
        // 序列化时，如果需要格式化输出，则可以通过第 3 个参数控制缩进的空格数
        let json = JSON.stringify(person, null, 2)
        this.message = `json:${json}`
      })

      Button("json 反序列化（对象）").onClick(() => {
        let json = '{"name":"webabcd", "age":44}'
        let person = JSON.parse(json) as Person
        this.message = `name:${person.name}, age:${person.age}`
      })

      Button("json 反序列化（对象数组）").onClick(() => {
        let json = '[{"name":"webabcd", "age":44}]'
        let personList = JSON.parse(json) as Person[]
        this.message = `name_0:${personList[0].name}, age_0:${personList[0].age}`
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

      Button("解析 json 对象（通过 object 的方式）").onClick(() => {
        let json = '{"name":"webabcd", "age":44}'
        let obj = JSON.parse(json) as object
        this.message = `name:${obj?.["name"]}, age:${obj?.["age"]}\n`
        this.message += `obj 是否有 name:${JSON.has(obj, "name")}, obj 是否有 age:${JSON.has(obj, "age")}`
      })

      Button("解析 json 对象（通过 Record 的方式）").onClick(() => {
        let json = '{"name":"webabcd", "age":44}'
        // 关于 Record 的用法，请参见 arkts/advanced/RecordPartial.ets 中的说明
        let obj = JSON.parse(json) as Record<string, Object>
        this.message = `name:${obj.name}, age:${obj.age}\n`
      })

      Button("解析 json 数组").onClick(() => {
        let json = '[{"name":"webabcd", "age":44}]'
        let ary = JSON.parse(json) as object[]
        this.message = `length:${ary.length}, name_0:${ary[0]["name"]}, age_0:${ary[0]["age"]}`
      })

      Text(this.message)
    }
  }
}