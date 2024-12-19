/*
 * TreeView - 树状列表
 */

import { TitleBar } from '../../TitleBar';
import { TreeController, TreeListener, TreeListenerManager, TreeListenType, NodeParam, TreeView, CallbackParam } from '@kit.ArkUI'


@Entry
@Component
struct TreeViewDemo {

  /*
   * TreeController - 用于和绑定的 TreeView 之间的交互
   *   addNode() - 添加节点（一个 NodeParam 对象）
   *     parentNodeId - 父节点 id（-1 是根父节点）
   *     currentNodeId - 当前节点 id
   *     isFolder - 是否是目录
   *     icon - 图标
   *     selectedIcon - 选中状态时的图标
   *     editIcon - 编辑状态时的图标
   *     primaryTitle - 标题
   *     secondaryTitle - 副标题
   *     container - 右键菜单（我没设备，无法测试）
   *   modifyNode() - 修改选中的节点
   *   removeNode() - 删除选中的节点
   *   buildDone() - 通过 addNode() 添加节点后，还需要再通过 buildDone() 把树构造出来
   *
   * TreeListener - 监听树的节点相关的事件
   *   on() - 注册指定事件的监听
   *   once() - 注册指定事件的监听（仅一次）
   *   off() - 取消指定事件的监听
   *   事件类型是 TreeListenType 枚举
   *     NODE_CLICK, NODE_ADD, NODE_MOVE, NODE_MODIFY, NODE_DELETE
   *   事件回调是 CallbackParam 对象
   *     currentNodeId - 触发事件的节点
   *     parentNodeId - 触发事件的节点的父节点（NODE_ADD, NODE_MOVE, NODE_MODIFY, NODE_DELETE 时有效）
   *     childIndex - 触发事件的节点在拖拽移动后，在当前父节点下的索引位置加 1 后的值（NODE_MOVE 时有效）
   */
  private treeController: TreeController = new TreeController();
  private treeListener: TreeListener = TreeListenerManager.getInstance().getTreeListener();
  @State message: string = ""

  aboutToAppear(): void {
    this.treeListener.on(TreeListenType.NODE_CLICK, (callbackParam: CallbackParam) => {
      this.message = `NODE_CLICK currentNodeId:${callbackParam.currentNodeId}, parentNodeId:${callbackParam.parentNodeId}, childIndex:${callbackParam.childIndex}`
    })
    this.treeListener.on(TreeListenType.NODE_ADD, (callbackParam: CallbackParam) => {
      this.message = `NODE_ADD currentNodeId:${callbackParam.currentNodeId}, parentNodeId:${callbackParam.parentNodeId}, childIndex:${callbackParam.childIndex}`
    })
    this.treeListener.on(TreeListenType.NODE_MOVE, (callbackParam: CallbackParam) => {
      this.message = `NODE_MOVE currentNodeId:${callbackParam.currentNodeId}, parentNodeId:${callbackParam.parentNodeId}, childIndex:${callbackParam.childIndex}`
    })
    this.treeListener.on(TreeListenType.NODE_MODIFY, (callbackParam: CallbackParam) => {
      this.message = `NODE_MODIFY currentNodeId:${callbackParam.currentNodeId}, parentNodeId:${callbackParam.parentNodeId}, childIndex:${callbackParam.childIndex}`
    })
    this.treeListener.on(TreeListenType.NODE_DELETE, (callbackParam: CallbackParam) => {
      this.message = `NODE_DELETE currentNodeId:${callbackParam.currentNodeId}, parentNodeId:${callbackParam.parentNodeId}, childIndex:${callbackParam.childIndex}`
    })

    this.treeController
      .addNode({
        parentNodeId:-1,
        currentNodeId: 1,
        isFolder: true,
        icon: $r('app.media.ic_settings'),
        selectedIcon: $r('app.media.app_icon'),
        editIcon: $r('app.media.son'),
        primaryTitle: "node_1",
        secondaryTitle: "99",
        container: this.menuBuilder
      })
      .addNode({ parentNodeId:1, currentNodeId: 2, isFolder: false, primaryTitle: "node_1_1" })
      .addNode({ parentNodeId:1, currentNodeId: 3, isFolder: true, primaryTitle: "node_1_2" })
      .addNode({ parentNodeId:3, currentNodeId: 4, isFolder: false, primaryTitle: "node_1_2_1" })
      .addNode({ parentNodeId:3, currentNodeId: 5, isFolder: false, primaryTitle: "node_1_2_2" })
      .addNode({ parentNodeId:3, currentNodeId: 6, isFolder: false, primaryTitle: "node_1_2_3" })
      .buildDone();
  }

  aboutToDisappear(): void {
    this.treeListener.off(TreeListenType.NODE_CLICK, undefined);
    this.treeListener.off(TreeListenType.NODE_ADD, undefined);
    this.treeListener.off(TreeListenType.NODE_MOVE, undefined);
    this.treeListener.off(TreeListenType.NODE_MODIFY, undefined);
    this.treeListener.off(TreeListenType.NODE_DELETE, undefined);
  }

  // 自定义节点的右键菜单（我没设备，无法测试）
  @Builder menuBuilder() {
    Button('删除').onClick((event: ClickEvent) => {
      this.treeController.removeNode();
    })
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Button('添加节点').onClick((event: ClickEvent) => {
          this.treeController.addNode();
        })
      Button('修改选中的节点').onClick((event: ClickEvent) => {
          this.treeController.modifyNode();
        })
      Button('删除选中的节点').onClick((event: ClickEvent) => {
          this.treeController.removeNode();
        })

      /*
       * TreeView - 树状列表
       *   treeController - 绑定的 TreeController 对象
       */
      TreeView({ treeController: this.treeController })
    }
  }
}