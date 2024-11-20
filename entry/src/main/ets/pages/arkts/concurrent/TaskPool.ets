import { TitleBar, MyLog } from '../../TitleBar';
import { taskpool } from '@kit.ArkTS';

@Concurrent
function add(num1: number, num2: number): number {
  return num1 + num2;
}

async function ConcurrentFunc(): Promise<void> {
  try {
    let task: taskpool.Task = new taskpool.Task(add, 1, 2);
    MyLog.d(`taskpool res is: ${await taskpool.execute(task)}`);
  } catch (e) {
    MyLog.d("taskpool execute error is: " + e);
  }
}

@Entry
@Component
struct TaskPool {

  @State message:string = ""

  build() {
    Column() {
      TitleBar()

      Button("button")
        .fontSize(32)
        .onClick(() => {
          ConcurrentFunc();
        })
    }
  }
}