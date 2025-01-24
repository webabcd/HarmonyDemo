/*
 * TaskPool - 任务池
 *
 * 注：先把 TaskPoolDemo.ets 和 TaskPoolDemo2.ets 都看明白，然后再看这个
 */

import { TitleBar, RadioBar, MyLog } from '../../TitleBar';
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct TaskPoolDemo3 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('在任务运行中，接收任务传递过来的数据').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('任务的事件').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('任务的依赖').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('任务的 setTransferList()').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('任务的 setCloneList()').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Concurrent
async function f1(): Promise<void> {
  let t = Date.now()
  while ((Date.now() - t) < 10000) {
    await new Promise<void>((r) => { setTimeout(r, 1000) })
    // 向当前的任务对象发送数据
    taskpool.Task.sendData(Date.now())
    continue;
  }
}
@Component
struct MySample1 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool.Task - 任务对象
       *   实例方法 onReceiveData() - 接收当前的任务传递过来的数据
       *   类方法 sendData() - 向当前的任务对象发送数据
       */
      Button('在任务运行中，接收任务传递过来的数据').onClick(async () => {
        let task: taskpool.Task = new taskpool.Task(f1)
        // 接收当前的任务传递过来的数据
        task.onReceiveData((data: number) => {
          this.message += `onReceiveData:${data}\n`
        })
        await taskpool.execute(task)
        this.message += `task ok\n`
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Concurrent
function f2_1() {

}
@Concurrent
function f2_2() {
  throw new Error("我是异常信息")
}
@Component
struct MySample2 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool.Task - 任务对象
       *   onEnqueued() - 任务进入队列时的回调
       *   onStartExecution() - 任务开始执行时的回调
       *   onExecutionSucceeded() - 任务执行成功时的回调
       *   onExecutionFailed() - 任务执行异常时的回调，可以从回调参数中获取异常信息
       */

      Button('常用事件').onClick(() => {
        let task: taskpool.Task = new taskpool.Task(f2_1)
        task.onEnqueued(()=>{
          this.message += `onEnqueued\n`
        });
        task.onStartExecution(()=>{
          this.message += `onStartExecution\n`
        });
        task.onExecutionSucceeded(() => {
          this.message += `onExecutionSucceeded\n`
        })
        taskpool.execute(task)
      })

      Button('异常事件').onClick(() => {
        let task: taskpool.Task = new taskpool.Task(f2_2)
        task.onExecutionFailed((e:Error) => {
          this.message += `onExecutionFailed:${JSON.stringify(e)}\n`
        })
        taskpool.execute(task)
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Concurrent
async function f3(delay:number) {
  await new Promise<void>((r) => { setTimeout(r, delay) })
}
@Component
struct MySample3 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool.Task - 任务对象
       *   addDependency() - 添加依赖关系（即当指定的任务执行完毕后，才能执行当前的任务）
       *   removeDependency() - 删除依赖关系
       */

      Button('用于演示任务的依赖关系').onClick(() => {

        let task1:taskpool.Task = new taskpool.Task(f3, 500);
        let task2:taskpool.Task = new taskpool.Task(f3, 3000);
        let task3:taskpool.Task = new taskpool.Task(f3, 3000);

        // 当 task2 和 task3 执行完毕后，才能执行 task1
        task1.addDependency(task2, task3);

        // task1 会等待 task2 和 task3 执行完成后才开始执行
        taskpool.execute(task1).then(() => {
          this.message += "task1 ok\n"
        })

        // task2 和 task3 会并行执行
        taskpool.execute(task2).then(() => {
          this.message += "task2 ok\n"
        })
        taskpool.execute(task3).then(() => {
          this.message += "task3 ok\n"
        })
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}


@Concurrent
function f4(arg: ArrayBuffer) {

}
@Component
struct MySample4 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool.Task - 任务对象
       *   setTransferList() - 将指定的传递给任务的 ArrayBuffer 类型的数据设置为 transfer 的
       *     transfer 的意思就是把 ArrayBuffer 对象的控制权转交给工作线程，而当前的 ArrayBuffer 会变为空
       */

      Button('为任务传递 ArrayBuffer 对象，且不调用 setTransferList()').onClick(async () => {
        let view: Int32Array = new Int32Array(100);
        this.message += `buffer byteLength:${view.byteLength}\n` // buffer byteLength:400
        let task: taskpool.Task = new taskpool.Task(f4, view)
        await taskpool.execute(task)
        this.message += `buffer byteLength:${view.byteLength}\n` // buffer byteLength:400
      })

      Button('为任务传递 ArrayBuffer 对象，且调用 setTransferList()').onClick(async () => {
        let view: Int32Array = new Int32Array(100);
        this.message += `buffer byteLength:${view.byteLength}\n` // buffer byteLength:400
        let task: taskpool.Task = new taskpool.Task(f4, view)
        // 将 view.buffer 的控制权转交给 task
        // 也就是说，此任务开始执行后 view 对象就交给 task 了，而当前的 view 就变为空了
        // 注意：这里通过 setTransferList() 设置的是相关的 ArrayBuffer 而不是相关的视图
        task.setTransferList([view.buffer]);
        await taskpool.execute(task)
        // view 变为空了
        this.message += `buffer byteLength:${view.byteLength}\n` // buffer byteLength:0
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Sendable
class MyClass {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}
@Concurrent
async function f5(myClass: MyClass): Promise<MyClass> {
  myClass.id += 1
  return myClass
}
@Component
struct MySample5 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool.Task - 任务对象
       *   setCloneList() - 将指定的传递给任务的 @Sendable 对象变为非 @Sendable 的
       */

      Button('为任务传递 @Sendable 对象，且不调用 setCloneList()').onClick(async () => {
        let myClass = new MyClass(0)
        let task: taskpool.Task = new taskpool.Task(f5, myClass)
        // myClass 是 @Sendable 的，其在线程之间是共享的
        let myClassFromTask = await taskpool.execute(task) as MyClass
        this.message += `${myClass.id}, ${myClassFromTask.id}\n` // 1, 1
      })

      Button('为任务传递 @Sendable 对象，且不调用 setCloneList()').onClick(async () => {
        let myClass = new MyClass(0)
        let task: taskpool.Task = new taskpool.Task(f5, myClass)
        // myClass 是 @Sendable 的，通过 setCloneList() 让其变为非 @Sendable 的
        // 即 myClass 在线程之间会变为通过深拷贝传递
        task.setCloneList([myClass])
        let myClassFromTask = await taskpool.execute(task) as MyClass
        this.message += `${myClass.id}, ${myClassFromTask.id}\n` // 0, 1
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}