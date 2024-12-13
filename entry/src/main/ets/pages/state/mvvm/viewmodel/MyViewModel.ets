import { MyData, ITaskModel } from '../model/MyModel';

@ObservedV2
export class TaskViewModel {
  @Trace name: string = '';
  @Trace done: boolean = false;
  public constructor(name: string, done: boolean) {
    this.name = name;
    this.done = done;
  }
}

@ObservedV2
export class TaskListViewModel {

  myData = new MyData();

  @Trace tasks: TaskViewModel[] = [];

  async loadTasks() {
    await this.myData.loadTasks()
    for(let task of this.myData.tasks){
      let taskViewModel = new TaskViewModel(task.name, task.done);
      this.tasks.push(taskViewModel)
    }
  }

  updateAllTaskDone(done: boolean): void {
    this.myData.updateAllTaskDone(done)
    for(let task of this.tasks){
      task.done = done;
    }
  }

  addTask(task: TaskViewModel): void {
    this.myData.addTask(task.name, task.done)
    this.tasks.push(task);
  }

  removeTask(task: TaskViewModel): void {
    this.myData.remove(task.name)
    this.tasks.splice(this.tasks.indexOf(task), 1)
  }

  updateTask(task: TaskViewModel): void {
    this.myData.updateTask(task.name, task.done)
  }
}