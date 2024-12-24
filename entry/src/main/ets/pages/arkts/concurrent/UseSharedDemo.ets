/*
 * use shared - 多线程引用相同的模块只被加载一次
 * 在 .ets 文件的开头写上 "use shared" 后会将此模块标记为共享模块，其会保证此模块只被加载一次
 *
 * 本例有 2 个示例
 * 第 1 个示例演示了，多线程之间使用的对象是在普通模块中实例化的对象，不同线程引用时使用的是不同的对象，即不同线程加载同一模块时会被加载多次，从而产生了多个不同的对象
 * 第 2 个示例演示了，多线程之间使用的对象是在 "use shared" 模块中实例化的 @Sendable 对象，不同线程引用时使用的是相同的对象，即不同线程加载同一模块时只会被加载一次
 */

import { TitleBar, MyLog } from '../../TitleBar';
import { MyClass1, myClass1 } from './UseSharedDemo_1';
import { MyClass2, myClass2 } from './UseSharedDemo_2';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function fun1_1(): Promise<MyClass1> {
  myClass1.id = 0
  for (let i = 0; i <  1000_000; i++) {
    myClass1.id += 1
  }
  return myClass1
}
@Concurrent
async function fun1_2(): Promise<MyClass1> {
  myClass1.id = 0
  for (let i = 0; i <  1000_000; i++) {
    myClass1.id += 1
  }
  return myClass1
}
async function sample1(): Promise<string> {
  try {
    let task1: taskpool.Task = new taskpool.Task(fun1_1)
    let task2: taskpool.Task = new taskpool.Task(fun1_2)

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

@Concurrent
async function fun2_1(): Promise<MyClass2> {
  myClass2.id = 0
  for (let i = 0; i <  1000_000; i++) {
    myClass2.id += 1
  }
  return myClass2
}
@Concurrent
async function fun2_2(): Promise<MyClass2> {
  myClass2.id = 0
  for (let i = 0; i <  1000_000; i++) {
    myClass2.id += 1
  }
  return myClass2
}
async function sample2(): Promise<string> {
  try {
    let task1: taskpool.Task = new taskpool.Task(fun2_1)
    let task2: taskpool.Task = new taskpool.Task(fun2_2)

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
struct UseSharedDemo {

  @State message:string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      // 演示了多线程之间使用的对象是在普通模块中实例化的对象，不同线程引用时使用的是不同的对象，即不同线程加载同一模块时会被加载多次，从而产生了多个不同的对象，无并发问题
      Button("button1")
        .fontSize(16)
        .onClick(async () => {
          this.message = await sample1()
        })

      // 演示了多线程之间使用的对象是在 "use shared" 模块中实例化的 @Sendable 对象，不同线程引用时使用的是相同的对象，即不同线程加载同一模块时只会被加载一次，有并发问题
      Button("button2")
        .fontSize(16)
        .onClick(async () => {
          this.message = await sample2()
        })
    }
  }
}