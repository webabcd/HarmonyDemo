/*
 * v2 @Provider()/@Consumer() - v2 版状态管理
 *   @Require - 用于说明在构造组件的时候必须要传参，支持无装饰变量，以及 @Param 装饰的变量
 *   @Monitor - 用于监听指定的变量或属性，并提供回调函数
 *     1、可以在组件中监听 @Local, @Param, @Provider, @Consumer, @Computed 装饰的状态变量（如果变量是一个 @ObservedV2 对象，那也可以监听它的 @Trace 属性）
 *     2、可以在对象中监听 @ObservedV2 类的 @Trace 属性的变化
 *     3、无法监听 array, set, map 之类的增删改
 *   @Computed - 用于装饰 getter
 *     当 @Computed 装饰的 getter 中使用的变量发生变化时，如果多次调用 @Computed 装饰的 getter，则这个 getter 中的逻辑只会被执行一次
 *   !! - 自定义双向绑定
 *
 * 注：使用 v2 版状态管理的组件要用 @ComponentV2 装饰
 */

import { MyLog, TitleBar } from '../../TitleBar';

@ObservedV2
class Person {
  @Trace name: string;
  @Trace age: number;
  // 当 Person 类的 name 或 age 发生变化时的回调（如果有嵌套属性的话，就类似 xxx.xxx.xxx 即可）
  @Monitor("name", "age")
  onPropertyChange(monitor: IMonitor) {
    // 通过日志可以看到 name 和 age 的变化，会在此处监听到
    MyLog.d(`Person name:${this.name}, age:${this.age}`)
    // 通过如下方式可以遍历所有被监听的属性的变化，并拿到之前的值和之后的值
    monitor.dirty.forEach((path: string) => {
      MyLog.d(`Person ${path} before:${monitor.value(path)?.before}, now:${monitor.value(path)?.now}`)
    })
  }
  @Monitor("age")
  onAgeChange(monitor: IMonitor) {
    // 如果只监听一个属性的变化，则可以通过如下方式拿到之前的值和之后的值
    MyLog.d(`Person age before:${monitor.value()?.before}, now:${monitor.value()?.now}`)
  }
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

@Entry
@ComponentV2
struct MonitorDemo {

  @Local name: string = "webabcd"
  @Local age: number = 44;
  // 当 MonitorDemo 组件的 name 或 age 发生变化时的回调
  @Monitor("name", "age")
  onPropertyChange(monitor: IMonitor) {
    // 通过日志可以看到 name 和 age 的变化，会在此处监听到
    MyLog.d(`MonitorDemo name:${this.name}, age:${this.age}`)
    // 通过如下方式可以遍历所有被监听的变量的变化，并拿到之前的值和之后的值
    monitor.dirty.forEach((path: string) => {
      MyLog.d(`MonitorDemo ${path} before:${monitor.value(path)?.before}, now:${monitor.value(path)?.now}`)
    })
  }
  // 通过这个方式可以监听对象的属性的变化
  @Monitor("person.age")
  onAgeChange(monitor: IMonitor) {
    // 如果只监听一个变量的变化，则可以通过如下方式拿到之前的值和之后的值
    MyLog.d(`MonitorDemo person.age before:${monitor.value()?.before}, now:${monitor.value()?.now}`)
  }
  person: Person = new Person("webabcd", 44)

  // 通过日志可以看到
  // 每次 num_getter 被调用几次就会被执行几次
  // 每次 num_getter_computed 被调用多次时，只会执行一次
  @Local num: number = 0;
  get num_getter() {
    MyLog.d('num_getter')
    return this.num
  }
  @Computed
  get num_getter_computed() {
    MyLog.d('num_getter_computed')
    return this.num
  }

  @Local message: string = 'abc'

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button('演示 @Monitor')
        .onClick(() => {
          this.name = 'wanglei'
          this.age = Math.floor(Math.random() * 1000)
          this.person.name = 'wanglei'
          this.person.age = Math.floor(Math.random() * 1000)
        })

      Divider()

      Text(`${this.num_getter}, ${this.num_getter}, ${this.num_getter_computed}, ${this.num_getter_computed}`)
      Button('演示 @Computed')
        .onClick(() => {
          // num 发生了变化，则绑定了 num_getter 和 num_getter_computed 的组件都会被刷新
          // 每次刷新时，num_getter 被调用几次就会被执行几次
          // 每次刷新时，num_getter_computed 被调用多次时，只会执行一次
          this.num ++
        })

      Divider()

      Text(this.message)
      // 通过 $$ 为 TextInput 组件的 message 属性提供数据的双向同步功能
      // 注：只有部分组件的部分属性才支持此功能，比如 Checkbox 的 select 属性，Slider 的 value 属性等，详见各个组件的相关文档
      TextInput({
        text: $$this.message,
      })
      // 通过 !! 实现父的 message 和子的 text 的双向同步
      // 注：前提是子要实现 @Param 装饰的 text 和 @Event 装饰的 $text 的相关逻辑
      MyComponent({
        text: this.message!!
      })
    }
  }
}

@ComponentV2
struct MyComponent {
  // 让子组件中的变量可以和外部的 !! 双向绑定的方式
  // 1、首先要定义一个名为 xxx 的 @Param 装饰的变量，再配合一个名为 $xxx 的 @Event 装饰的回调函数
  // 2、子组件的名为 xxx 的 @Param 装饰的变量，用于父到子的数据同步
  // 3、子组件的名为 $xxx 的 @Event 装饰的回调函数，用于子到父的数据同步
  // 4、如此父组件就可以通过变量后面加 !! 实现数据的双向同步
  @Param text: string = '';
  @Event $text: (str: string) => void = (str: string) => {};

  build() {
    Column() {
      Text(`${this.text}`)
      Button(`click me`).onClick(() => {
        this.$text(`${Math.floor(Math.random() * 1000)}`);
      })
    }
  }
}