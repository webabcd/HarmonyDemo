/*
 * @Sendable - 多线程共享对象
 * 被 @Sendable 装饰的类的对象，在多线程之间传递时，传递的是对象的地址，即多线程之间会共享这个对象
 *
 * 本例有 2 个示例
 * 第 1 个示例演示了，多线程之间传递普通对象，对象会做深拷贝
 * 第 2 个示例演示了，多线程之间传递 @Sendable 装饰的类的对象，多线程之间会共享对象
 *
 * 注：在 @Sendable 中可以通过 sendableContextManager 管理并传递 context 对象（参见 WorkerDemo.ets 中的相关说明）
 */

import { TitleBar, MyLog } from '../../TitleBar';
import { taskpool } from '@kit.ArkTS';

class MyClass1 {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}
@Concurrent
async function fun1_1(myClass: MyClass1): Promise<MyClass1> {
  for (let i = 0; i <  1000_000; i++) {
    myClass.id += 1
  }
  return myClass
}
@Concurrent
async function fun1_2(myClass: MyClass1): Promise<MyClass1> {
  for (let i = 0; i <  1000_000; i++) {
    myClass.id += 1
  }
  return myClass
}
async function sample1(): Promise<string> {
  try {
    let myClass1 = new MyClass1(0)
    let task1: taskpool.Task = new taskpool.Task(fun1_1, myClass1)
    let task2: taskpool.Task = new taskpool.Task(fun1_2, myClass1)

    let resultList: MyClass1[] = []
    await Promise.allSettled([taskpool.execute(task1), taskpool.execute(task2)]).then(results => {
      results.forEach(result => {
        if (result.status == 'fulfilled') {
          resultList.push(result.value as MyClass1)
        }
      })
    });
    return resultList.map(p => p.id).join(',')
  } catch (e) {
    return "taskpool error: " + e
  }
}

@Sendable
class MyClass2 {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}
@Concurrent
async function fun2_1(myClass: MyClass2): Promise<MyClass2> {
  for (let i = 0; i <  1000_000; i++) {
    myClass.id += 1
  }
  return myClass
}
@Concurrent
async function fun2_2(myClass: MyClass2): Promise<MyClass2> {
  for (let i = 0; i <  1000_000; i++) {
    myClass.id += 1
  }
  return myClass
}
async function sample2(): Promise<string> {
  try {
    let myClass2 = new MyClass2(0)
    let task1: taskpool.Task = new taskpool.Task(fun2_1, myClass2)
    let task2: taskpool.Task = new taskpool.Task(fun2_2, myClass2)

    let resultList: MyClass2[] = []
    await Promise.allSettled([taskpool.execute(task1), taskpool.execute(task2)]).then(results => {
      results.forEach(result => {
        if (result.status == 'fulfilled') {
          resultList.push(result.value as MyClass2)
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
struct SendableDemo {

  @State message:string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      // 本例演示了多线程之间传递普通对象，对象会做深拷贝，无并发问题
      Button("button1")
        .fontSize(16)
        .onClick(async () => {
          this.message = await sample1()
        })

      // 本例演示了多线程之间传递 @Sendable 装饰的类的对象，多线程之间会共享对象，有并发问题
      Button("button2")
        .fontSize(16)
        .onClick(async () => {
          this.message = await sample2()
        })
    }
  }
}