/*
 * TaskPool - 任务池
 *   自动管理任务池中的线程（比如新开线程，线程复用等）
 *   任务执行的上限是 3 分钟（不包括任务中的 Promise 和 async/await 异步调用的耗时）
 *   调用任务时，可以直接做参数传递和返回值获取，无需特殊处理
 *
 * 注：
 * 1、无法用 Previewer 测试 TaskPool，需要用模拟器或真机
 * 2、关于 Promise 和 async/await 请参见 arkts/advanced/Promise.ets, arkts/advanced/AsyncAwait.ets 中的相关说明
 */

import { TitleBar, MyLog } from '../../TitleBar';
import { taskpool } from '@kit.ArkTS';
import { myFunction, MyClass } from './MyFunctionAndClass';

// @Concurrent 表示函数可以被创建为一个被任务池执行的任务
@Concurrent
function fun1(a: number, b: number): number {
  return a + b
}
/*
 * taskpool.Task() - 创建一个任务（指定一个 @Concurrent 函数，及其需要的参数）
 * taskpool.execute() - 在任务池中执行指定的任务
 */
async function sample1(): Promise<string> {
  try {
    let task: taskpool.Task = new taskpool.Task(fun1, 1, 2)
    return `taskpool result: ${await taskpool.execute(task)}`
  } catch (e) {
    return "taskpool error: " + e
  }
}

// @Concurrent 支持异步函数，且异步执行的过程不受任务的 3 分钟执行上限的时间限制
@Concurrent
async function fun2(a: number, b: number): Promise<number> {
  // 睡 1 秒
  await new Promise<void>((r) => { setTimeout(r, 1000) })
  return a + b
}
async function sample2(): Promise<string> {
  try {
    let task: taskpool.Task = new taskpool.Task(fun2, 2, 3)
    return `taskpool result: ${await taskpool.execute(task)}`
  } catch (e) {
    return "taskpool error: " + e
  }
}

// 一个 catch 到任务异常的示例
@Concurrent
async function fun3(a: number, b: number): Promise<number> {
  return await new Promise((resolve, reject) => {
    setTimeout(()=>{
      reject("error message");
    }, 1000)
  });
}
async function sample3(): Promise<string> {
  try {
    let task: taskpool.Task = new taskpool.Task(fun3, 3, 4)
    return `taskpool result: ${await taskpool.execute(task)}`
  } catch (e) {
    return "taskpool error: " + e
  }
}

// @Concurrent 函数无法调用同文件内的其他函数或类
// 如果要在 @Concurrent 函数内调用其他函数或类，那么被调用的函数或类必须定义在其他 .ets 文件中（参见 MyFunctionAndClass.ets.ets 中的示例）
@Concurrent
async function fun4(): Promise<string> {
  await new Promise<void>((r) => { setTimeout(r, 1000) })
  let a = myFunction()
  let b = new MyClass().name
  let c = new MyClass().hello()
  return `${a}, ${b}, ${c}`
}
async function sample4(): Promise<string> {
  try {
    let task: taskpool.Task = new taskpool.Task(fun4)
    return `taskpool result: ${await taskpool.execute(task)}`
  } catch (e) {
    return "taskpool error: " + e
  }
}

@Entry
@Component
struct TaskPool {

  @State message:string = ""

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message).fontSize(16)

      Button("button1")
        .fontSize(16)
        .onClick(async () => {
          this.message = await sample1()
        })

      Button("button2")
        .fontSize(16)
        .onClick(async () => {
          this.message = "ing"
          this.message = await sample2()
        })

      Button("button3")
        .fontSize(16)
        .onClick(async () => {
          this.message = "ing"
          this.message = await sample3()
        })

      Button("button4")
        .fontSize(16)
        .onClick(async () => {
          this.message = await sample4()
        })
    }
  }
}