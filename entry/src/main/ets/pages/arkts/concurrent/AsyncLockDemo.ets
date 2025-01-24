/*
 * AsyncLock - 异步锁
 */

import { TitleBar } from '../../TitleBar';
import { ArkTSUtils, taskpool } from '@kit.ArkTS';

// 被 @Sendable 装饰的类的对象，在多线程之间传递时，传递的是对象的地址，即多线程之间会共享这个对象
@Sendable
class MyClass1 {
  // 实例化一个 异步锁
  lock: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock();

  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }

  async getId(): Promise<number> {
    // 加锁
    return this.lock.lockAsync(() => {
      return this.id
    })
  }

  async increaseId() {
    // 加锁
    await this.lock.lockAsync(() => {
      this.id++;
    })
  }
}

@Concurrent
async function f1_1(myClass: MyClass1): Promise<MyClass1> {
  for (let i = 0; i <  1_000; i++) {
    await myClass.increaseId()
  }
  return myClass
}

@Concurrent
async function f1_2(myClass: MyClass1): Promise<MyClass1> {
  for (let i = 0; i <  1_000; i++) {
    await myClass.increaseId()
  }
  return myClass
}

@Entry
@Component
struct AsyncLockDemo {

  @State message:string = ""

  build() {
    Column() {
      TitleBar()

      Button("click me").onClick(() => {
        let myClass1 = new MyClass1(0)
        let task1: taskpool.Task = new taskpool.Task(f1_1, myClass1)
        let task2: taskpool.Task = new taskpool.Task(f1_2, myClass1)
        let taskGroup = new taskpool.TaskGroup();
        taskGroup.addTask(task1);
        taskGroup.addTask(task2);
        taskpool.execute(taskGroup).then((array: Array<Object>) => {
          array.forEach((value, index) => {
            // id:2000
            // id:2000
            this.message += `id:${(value as MyClass1).id}\n`
          });
        })
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}