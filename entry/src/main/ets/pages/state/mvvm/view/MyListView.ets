import { TaskViewModel, TaskListViewModel } from '../viewmodel/MyViewModel';

@ComponentV2
struct MyListItem {

  @Param task: TaskViewModel = new TaskViewModel('', false);
  @Event deleteTask: () => void = () => {};
  @Event updateTask: () => void = () => {};

  build() {
    Row({space:10}) {
      Image($r('app.media.app_icon')).width(24).height(24)
      Text(this.task.name).fontSize(20)
      Blank(10)
      Button('删除').onClick(() => this.deleteTask())
    }
    .width('100%')
    .height(50)
    .padding({left:10, right:10})
    .backgroundColor(this.task.done ? '#FFA500' : '#99f1f1f1')
    .borderRadius(10)
    .onClick(() => {
      this.task.done = !this.task.done
      this.updateTask()
    })
  }
}

@ComponentV2
export default struct MyListView {
  @Param taskList: TaskListViewModel = new TaskListViewModel();

  build() {
    Repeat<TaskViewModel>(this.taskList.tasks)
      .each((obj: RepeatItem<TaskViewModel>) => {
        MyListItem({
          task: obj.item,
          deleteTask: () => this.taskList.removeTask(obj.item),
          updateTask: () => this.taskList.updateTask(obj.item),
        })
      })
  }
}
