/*
 * mvvm - model, view ,viewmodel
 *   model - 负责数据的获取和存储，以及业务逻辑等，不与 view 关联
 *   view - 负责用户界面的展现，以及用户的输入等，不与 model 关联
 *   viewmodel - 是连接 model 和 view 的桥梁
 *     负责将 model 的数据转为 view 的数据，并管理用户界面状态
 *     负责处理用户的交互逻辑，并将相关数据交由 model 处理
 */

import { TaskListViewModel } from './viewmodel/MyViewModel';
import MyTopView from './view/MyTopView';
import MyListView from './view/MyListView';
import MyBottomView from './view/MyBottomView';
import { TitleBar } from '../../TitleBar';
import { LoadingDialog } from '@kit.ArkUI';

@Entry
@ComponentV2
struct MVVMDemo {

  @Local taskList: TaskListViewModel = new TaskListViewModel()

  loading: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ content: 'loading' }),
  })

  async aboutToAppear() {
    this.loading.open()
    await this.taskList.loadTasks();
    this.loading.close()
  }

  get taskCount(): number {
    return this.taskList.tasks.length
  }

  build() {
    Column({space:10}) {
      TitleBar()
      MyTopView({ taskCount: this.taskCount })
      MyListView({ taskList: this.taskList });
      MyBottomView({ taskList: this.taskList });
    }
    .margin({left:10,right:10})
  }
}
