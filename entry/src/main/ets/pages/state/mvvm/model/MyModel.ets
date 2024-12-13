export class MyData {
  tasks: ITaskModel[] = [];

  constructor() {
  }

  async loadTasks() {
    await new Promise<void>(r => setTimeout(r, 1000));
    this.tasks.push({name:"task 1", done:false})
    this.tasks.push({name:"task 2", done:false})
    this.tasks.push({name:"task 3", done:false})
  }

  addTask(name: string, done: boolean) {

  }

  remove(name: string) {

  }

  updateAllTaskDone(done: boolean) {

  }

  updateTask(name: string, done: boolean) {

  }
}

export interface ITaskModel {
  name: string;
  done: boolean;
};
