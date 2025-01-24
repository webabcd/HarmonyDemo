/*
 * ASON - 对 @Sendable 对象做序列化和反序列化
 * 相对于 JSON.parse() 来说 ArkTSUtils.ASON.parse() 可以将字符串反序列化为一个 @Sendable 对象
 */

import { TitleBar, MyLog } from '../../TitleBar';
import { ArkTSUtils, taskpool } from '@kit.ArkTS';

@Sendable
class MyClass {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}

@Concurrent
async function fun1(myClass: MyClass): Promise<MyClass> {
  for (let i = 0; i <  1000_000; i++) {
    myClass.id += 1
  }
  return myClass
}
@Concurrent
async function fun2(myClass: MyClass): Promise<MyClass> {
  for (let i = 0; i <  1000_000; i++) {
    myClass.id += 1
  }
  return myClass
}
async function sample(myClass: MyClass): Promise<string> {
  try {
    let task1: taskpool.Task = new taskpool.Task(fun1, myClass)
    let task2: taskpool.Task = new taskpool.Task(fun2, myClass)

    let resultList: MyClass[] = []
    await Promise.allSettled([taskpool.execute(task1), taskpool.execute(task2)]).then(results => {
      results.forEach(result => {
        if (result.status == 'fulfilled') {
          resultList.push(result.value as MyClass)
        }
      })
    });
    return resultList.map(p => p.id).join(',')
  } catch (e) {
    return "taskpool error: " + e
  }
}


@Entry
@Component
struct ASONDemo {

  @State message:string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      // 通过 JSON.stringify(), JSON.parse() 做序列化和反序列化
      // stringify 就是字符串化的意思，ify 后缀来自于拉丁语 ificare，是使...化的意思
      Button("JSON 序列化和反序列化")
        .fontSize(16)
        .onClick(() => {
          let myClass = new MyClass(0)
          let json = JSON.stringify(myClass)
          let obj = JSON.parse(json) as MyClass
          this.message = `JSON json:${json}, id:${obj.id}`
        })

      // 通过 ArkTSUtils.ASON.stringify(), ArkTSUtils.ASON.parse() 做序列化和反序列化
      Button("ASON 序列化和反序列化")
        .fontSize(16)
        .onClick(() => {
          let myClass = new MyClass(0)
          let json = ArkTSUtils.ASON.stringify(myClass)
          let obj = ArkTSUtils.ASON.parse(json) as MyClass
          this.message = `ASON json:${json}, id:${obj.id}`
        })

      // 通过 JSON.parse() 做反序列化，反序列化出的对象无 @Sendable 特性
      Button("JSON 反序列化出的对象无 @Sendable 特性")
        .fontSize(16)
        .onClick(async () => {
          let obj = JSON.parse('{"id":0}') as MyClass
          this.message = await sample(obj)
        })

      // 通过 ArkTSUtils.ASON.parse() 做反序列化，反序列化出的对象有 @Sendable 特性
      Button("ASON 反序列化出的对象有 @Sendable 特性")
        .fontSize(16)
        .onClick(async () => {
          let obj = ArkTSUtils.ASON.parse('{"id":0}') as MyClass
          this.message = await sample(obj)
        })
    }
  }
}