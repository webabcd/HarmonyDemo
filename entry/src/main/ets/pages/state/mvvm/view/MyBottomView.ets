import { TaskViewModel, TaskListViewModel } from '../viewmodel/MyViewModel';

@ComponentV2
export default struct MyBottomView {

  @Param taskList: TaskListViewModel = new TaskListViewModel();
  @Local newTaskName: string = '';

  build() {
    Column({space:10}) {
      Row() {
        Button('全部完成', { buttonStyle: ButtonStyleMode.NORMAL })
          .onClick(() => {
            this.taskList.updateAllTaskDone(true)
          })
        Blank(10)
        Button('全部未完成', { buttonStyle: ButtonStyleMode.NORMAL })
          .onClick(() => {
            this.taskList.updateAllTaskDone(false)
          })
      }

      Row() {
        TextInput({ placeholder: '添加新任务', text: $$this.newTaskName }).layoutWeight(1)
        Blank(10)
        Button('+', { buttonStyle: ButtonStyleMode.NORMAL })
          .onClick(() => {
            let newTask = new TaskViewModel(this.newTaskName, false);
            this.taskList.addTask(newTask);
            this.newTaskName = '';
          })
      }
    }
  }
}
