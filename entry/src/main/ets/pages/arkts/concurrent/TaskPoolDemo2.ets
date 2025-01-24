/*
 * TaskPool - 任务池
 *
 * 注：先把 TaskPoolDemo.ets 都看明白，然后再看这个
 */

import { TitleBar, RadioBar, MyLog } from '../../TitleBar';
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct TaskPoolDemo2 {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('任务执行').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('任务管理').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('任务串行').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('任务组').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Concurrent
function f1(name: string): string {
  MyLog.d(`f1 ${name}`)
  return `hello:${name}`
}
@Component
struct MySample1 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool - 任务池（多个任务会并行执行）
       *   execute() - 执行指定的函数，并为函数传参
       *   Task() - 指定函数名及其参数，返回一个 taskpool.Task 对象
       *   LongTask() - 指定函数名及其参数，返回一个 taskpool.LongTask 对象，执行此任务的线程会一直存在
       *     也就是说，即使 @Concurrent 不是 async 的，也不会受到 3 分钟的时间限制
       *     即使任务执行完成或取消，任务所属的线程也不会被线程池销毁，只有当调用了 terminateTask() 之后，线程池才会在适当的时候将其销毁
       *   execute() - 执行指定的任务，并指定任务的优先级（Priority 枚举：IDLE, LOW, MEDIUM, HIGH）
       *   executeDelayed() - 延迟执行指定的任务
       *   executePeriodically() - 循环执行指定的任务
       */

      Button('在任务池中执行指定的任务').onClick(() => {
        // 执行指定的 @Concurrent 函数，并传参
        taskpool.execute(f1, "webabcd").then((value) => {
          // 获取函数的返回值
          this.message += `result ${value}\n`
        })
      })

      Button('在任务池中执行指定的任务，并指定任务的优先级').onClick(() => {
        // 实例化任务（指定任务的 @Concurrent 函数，并传参）
        let task1: taskpool.Task = new taskpool.Task(f1, "aaa");
        let task2: taskpool.Task = new taskpool.Task(f1, "bbb");
        let task3: taskpool.Task = new taskpool.Task(f1, "ccc");
        let task4: taskpool.Task = new taskpool.Task(f1, "ddd");
        // 执行指定的任务，并指定任务的优先级
        taskpool.execute(task1, taskpool.Priority.IDLE).then((value) => {
          // 获取任务的 @Concurrent 函数的返回值
          this.message += `result(idle) ${value}\n`
        });
        taskpool.execute(task2, taskpool.Priority.LOW).then((value) => {
          this.message += `result(low) ${value}\n`
        });
        taskpool.execute(task3, taskpool.Priority.MEDIUM).then((value) => {
          this.message += `result(medium) ${value}\n`
        });
        taskpool.execute(task4, taskpool.Priority.HIGH).then((value) => {
          this.message += `result(high) ${value}\n`
        });
      })

      Button('执行长时任务，且任务所属的线程一直存在').onClick(() => {
        // 执行此任务的线程一直存在（也就是说，即使 @Concurrent 不是 async 的，也不会受到 3 分钟的时间限制）
        let task: taskpool.LongTask = new taskpool.LongTask(f1, "webabcd");
        taskpool.execute(task).then((value) => {
          this.message += `result ${value}\n`
        });
      })

      Button('延迟执行任务').onClick(() => {
        let task: taskpool.Task = new taskpool.Task(f1, "webabcd");
        // 1000 毫秒后执行指定的任务
        taskpool.executeDelayed(1000, task, taskpool.Priority.IDLE).then((value) => {
          this.message += `result ${value}\n`
        }).catch((e: BusinessError) => {
          this.message += `error ${e.message}\n`
        })
      })

      Button('循环执行任务').onClick(() => {
        let task: taskpool.Task = new taskpool.Task(f1, "webabcd");
        // 1000 毫秒后执行指定的任务，然后每 1000 毫秒再执行一次此任务
        taskpool.executePeriodically(1000, task, taskpool.Priority.IDLE);
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Concurrent
async function f2(name: string): Promise<string> {
  let t: number = Date.now();
  while (Date.now() - t < 10000) {
    await new Promise<void>((r) => { setTimeout(r, 500) })
    MyLog.d(`f2 ${name} running`)
    // 任务如果在运行中被取消的话，只是不再等待任务返回了，但是任务对应的函数仍然会继续执行，直到执行完毕为止
    // 所以建议在这里判断任务是否被取消了，如果被取消了，则不需要再执行后续逻辑了
    if (taskpool.Task.isCanceled()) {
      MyLog.d(`f2 ${name} isCanceled`)
      break
    }
    continue;
  }
  return `hello:${name}`
}
@Component
struct MySample2 {

  @State message:string = ""
  task: taskpool.Task = new taskpool.Task(f2, "webabcd");
  longTask: taskpool.LongTask = new taskpool.LongTask(f2, "wanglei");

  build() {
    Column({space:10}) {

      /*
       * taskpool - 任务池
       *   isConcurrent() - 用于判断指定的函数是否是 @Concurrent 装饰的
       *   getTaskPoolInfo() - 获取当前的任务池的信息（返回一个 TaskPoolInfo 对象）
       *     threadInfos - 任务池中的全部线程的信息，返回一个 ThreadInfo 对象数组
       *       tid - 此线程的 id
       *       taskIds - 此线程中的全部任务的 id 集合
       *       priority - 此线程的优先级（Priority 枚举：IDLE, LOW, MEDIUM, HIGH）
       *     taskInfos - 任务池中的全部任务的信息，返回一个 TaskInfo 对象数组
       *       id - 此任务的 id
       *       name - 此任务的对应的 @Concurrent 函数的名称
       *       duration - 此任务到目前为止的执行的时长（单位：毫秒）
       *       state - 此任务的状态（State 枚举：WAITING, RUNNING, CANCELED）
       *   cancel() - 取消指定的任务
       *     任务如果还未执行，就不再执行了
       *     任务如果执行完了，就会抛出异常
       *     任务如果执行中，则不会在等待其返回结果，但是任务对应的函数会继续执行（建议在函数中判断 taskpool.Task.isCanceled() 如果被取消了则退出即可）
       *   terminateTask() - 终止指定的长时任务（即告诉任务池，此线程在适当的时候可以被销毁了）
       *     建议长时任务执行完成后调用此方法，如果不调用的话，此长时任务所属的线程将永远都不会被任务池销毁
       *
       * taskpool.Task, taskpool.LongTask - 任务对象
       *   实例方法 isDone() - 此任务是否执行完成了
       *   类方法 isCanceled() - 当前任务是否被取消了
       */

      Button('执行任务').onClick(() => {
        // 执行一个任务
        taskpool.execute(this.task).then((value) => {
          this.message += `result ${value}\n`
        });
        // 执行一个长时任务
        taskpool.execute(this.longTask).then((value) => {
          this.message += `result ${value}\n`
        });
      })

      Button('获取任务信息').onClick(() => {
        this.message += `f2 isConcurrent:${taskpool.isConcurrent(f2)}\n`
        this.message += `task isDone:${this.task.isDone()}\n`
        this.message += `longTask isDone:${this.longTask.isDone()}\n`
      })

      Button('获取任务池信息').onClick(() => {
        let info: taskpool.TaskPoolInfo = taskpool.getTaskPoolInfo();
        let threadInfos = Array.from(info.threadInfos)
        for (let threadInfo of threadInfos) {
          this.message += `threadId:${threadInfo.tid}, taskIds:${threadInfo.taskIds?.join("|")}, priority:${threadInfo.priority}\n`
        }
        let taskInfos = Array.from(info.taskInfos)
        for (let taskInfo of taskInfos) {
          this.message += `taskId:${taskInfo.taskId}, name:${taskInfo.name}, duration:${taskInfo.duration}, state:${taskInfo.state}\n`
        }
      })

      Button('取消任务').onClick(() => {
        try {
          // 取消指定的任务
          taskpool.cancel(this.task);
        } catch (e) {
          // 任务如果已经执行完了，则取消时就会抛出异常
          this.message += `task cancel error, errCode:${e.code}, errMessage:${e.message}`;
        }

        try {
          // 取消指定的任务
          taskpool.cancel(this.longTask);
          // 终止指定的长时任务（即告诉任务池，此线程在适当的时候可以被销毁了）
          taskpool.terminateTask(this.longTask);
        } catch (e) {
          // 任务如果已经执行完了，则取消时就会抛出异常
          this.message += `longTask cancel error, errCode:${e.code}, errMessage:${e.message}`;
        }
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Concurrent
async function f3(name: string): Promise<string> {
  await new Promise<void>((r) => { setTimeout(r, 1000) })
  return `hello:${name}`
}
@Component
struct MySample3 {

  @State message:string = ""

  build() {
    Column({space:10}) {

      /*
       * taskpool.SequenceRunner - 串行任务管理器
       *   constructor() - 通过构造函数指定串行任务管理器的名称和优先级，返回一个 taskpool.SequenceRunner 对象
       *   execute() - 执行指定的任务，多个任务会串行执行
       *
       * 注：用 taskpool 的 execute() 执行的多个任务会并行执行
       */

      Button('串行执行任务').onClick(async () => {
        let task1:taskpool.Task = new taskpool.Task(f3, "aaa");
        let task2:taskpool.Task = new taskpool.Task(f3, "bbb");
        let task3:taskpool.Task = new taskpool.Task(f3, "ccc");
        // 指定串行任务管理器的名称和优先级，返回一个 taskpool.SequenceRunner 对象
        let sequenceRunner:taskpool.SequenceRunner = new taskpool.SequenceRunner("mySequenceRunner", taskpool.Priority.HIGH);
        // 执行 task1
        sequenceRunner.execute(task1).then((value) => {
          this.message += `task1 result ${value}\n`;
        });
        // task1 执行完成后才会执行 task2
        sequenceRunner.execute(task2).then((value) => {
          this.message += `task2 result ${value}\n`;
        });
        // task2 执行完成后才会执行 task3
        let result = await sequenceRunner.execute(task3);
        this.message += `task3 result ${result}\n`;
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Concurrent
async function f4(name: string): Promise<string> {
  await new Promise<void>((r) => { setTimeout(r, 3000) })
  return `hello:${name}`
}
@Component
struct MySample4 {

  @State message:string = ""
  taskGroup?: taskpool.TaskGroup;

  build() {
    Column({space:10}) {

      /*
       * taskpool - 任务池
       *   TaskGroup() - 指定任务组名称，返回一个 taskpool.TaskGroup 对象
       *   addTask() - 添加任务（可以指定一个 @Concurrent 函数并为函数传参，或者指定一个 taskpool.Task 对象）
       *   execute() - 并行执行指定的任务组中的所有任务
       *     任务全部成功，则任务组成功
       *     如果有失败的任务，则抛出第一个失败的任务的异常
       */
      Button('执行任务组').onClick(async () => {
        this.taskGroup = new taskpool.TaskGroup("myTaskGroup");
        this.taskGroup.addTask(f4, "aaa");
        this.taskGroup.addTask(new taskpool.Task(f4, "bbb"));
        this.taskGroup.addTask(f4, "ccc");
        taskpool.execute(this.taskGroup, taskpool.Priority.HIGH).then((array: Array<Object>) => {
          // 返回的数据是每个任务的执行结果的列表，顺序与 addTask() 的顺序是一样的
          array.forEach((value, index) => {
            this.message += `task index:${index}, result:${value}\n`
          });
        })
      })

      Button('取消任务').onClick(async () => {
        try {
          // 取消指定的任务组（关于任务组的取消请参见上面的 MySample2 中的说明）
          taskpool.cancel(this.taskGroup);
        } catch (e) {
          this.message += `task cancel error, errCode:${e.code}, errMessage:${e.message}`;
        }
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}