/*
 * 拖拽
 */

import { MyLog, TitleBar } from '../TitleBar';
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { ImageModifier } from '@kit.ArkUI';

@Entry
@Component
struct DragDropDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('拖拽基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('拖拽预览图').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('多选拖拽').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""
  @State targetText: string = ""
  @State targetImage: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * draggable() - 是否支持按下后的拖拽操作（注：设置为 true 后，还必须要监听 onDragStart() 事件，才能支持拖拽操作）
       * allowDrop() - 当拖拽组件落入当前组件时，指定允许传递的数据类型（一个 UniformDataType 枚举数组）
       *   PLAIN_TEXT, IMAGE, 等
       *
       * onDragStart() - 拖拽开始时的回调（当长按时间大于 500 毫秒，且拖拽距离大于 10vp 时触发回调）
       * onPreDrag() - 拖拽发起前的回调
       * onDragEnd() - 拖拽完成后的回调
       *
       * onDrop() - 当拖拽组件在当前组件释放时的回调
       * onDragEnter(), onDragMove(), onDragLeave() - 当拖拽组件进入当前组件，在当前组件上移动，离开当前组件时的回调（当监听了 onDrop() 时才会生效）
       */

      Text('text').border({ color: Color.Black, width: 1 })
        .width('100%')
        .height(100)
        .draggable(true)
        .onDragStart((event: DragEvent) => {
          this.message = `onDragStart`
          // 设置 PlainText 类型的拖拽数据
          let data: unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText();
          data.textContent = 'textContent';
          event.setData(new unifiedDataChannel.UnifiedData(data));
        })
        .onPreDrag((status: PreDragStatus) => {
          this.message = `onPreDrag:${status}`
        })
        .onDragEnd((event: DragEvent) => {
          // 通过 event.getResult() 获取 drop 的结果（即在 onDrop() 中通过 event.setResult() 设置的结果）
          this.message = `onDragEnd:${DragResult[event.getResult()]}`
        })
      Text(this.targetText).border({ color: Color.Black, width: 1 })
        .width('100%')
        .height(100)
        .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
        .onDrop((event: DragEvent) => {
          let data: UnifiedData = event.getData();
          if (!data) {
            return;
          }
          let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
          if (!records || records.length <= 0) {
            return;
          }

          // 获取 PlainText 类型的拖拽数据
          let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
          this.targetText = plainText.textContent;

          // 设置 drop 的结果
          event.setResult(DragResult.DRAG_SUCCESSFUL);
        })
        .onDragEnter((event: DragEvent) => {
          this.message = `onDragEnter`
        })
        .onDragMove((event: DragEvent) => {
          this.message = `onDragMove`
        })
        .onDragLeave((event: DragEvent) => {
          this.message = `onDragLeave`
        })

      Image($r('app.media.app_icon')).width(100).height(100)
        .draggable(true)
        .onDragEnd((event: DragEvent) => {
          // 通过 event.getResult() 获取 drop 的结果（即在 onDrop() 中通过 event.setResult() 设置的结果）
          this.message = `onDragEnd:${DragResult[event.getResult()]}`
        })
      Image(this.targetImage).width(100).height(100).border({ color: Color.Black, width: 1 })
        .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
        .onDrop((event: DragEvent) => {
          let data: UnifiedData = event.getData();
          if (!data) {
            return;
          }
          let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
          if (!records || records.length <= 0) {
            return;
          }

          // 获取拖拽的图片的地址
          this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;

          // 设置 drop 的结果
          event.setResult(DragResult.DRAG_SUCCESSFUL);
        })
    }
  }
}

@Component
struct MySample2 {

  // 自定义拖拽预览图
  @Builder dragPreviewBuilder() {
    Column() {
      Text("dragPreview")
        .width(150)
        .height(50)
        .fontSize(20)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor(Color.Orange)
    }
  }

  // 自定义拖拽预览图的样式
  @State myModifier: ImageAttribute = new ImageModifier()
    .opacity(0.7)
    .shadow({
      radius: 10,
      color: Color.Red,
      offsetX: 20,
      offsetY: 20,
    })
    .backgroundBlurStyle(BlurStyle.Thick)

  @State targetImage: string = ""

  build() {
    Column({space:10}) {

      /*
       * dragPreview() - 拖拽过程中的跟手的自定义预览图（指定一个自定义组件）
       * dragPreviewOptions() - 拖拽预览图的相关选项
       *   value - 一个 DragPreviewOptions 对象
       *     mode - 拖拽过程中，预览图的处理方式（一个 DragPreviewMode 枚举数组）
       *       AUTO - 自动
       *       DISABLE_SCALE - 缩放
       *       ENABLE_DEFAULT_SHADOW - 阴影
       *       ENABLE_DEFAULT_RADIUS - 圆角
       *     numberBadge - 角标数字
       *     modifier - 通过 ImageAttribute 自定义拖拽预览图的样式
       *   options - 一个 DragInteractionOptions 对象
       *     defaultAnimationBeforeLifting - 通过长按启动拖拽动作时，是否显示一个点按效果动画
       */

      Image($r('app.media.son')).width(100).height(100)
        .draggable(true)

      Image($r('app.media.son')).width(100).height(100)
        .draggable(true)
        .dragPreview(this.dragPreviewBuilder)

      Image($r('app.media.son')).width("100")
        .draggable(true)
        .dragPreviewOptions({
          mode: [
            DragPreviewMode.DISABLE_SCALE,
            DragPreviewMode.ENABLE_DEFAULT_SHADOW,
            DragPreviewMode.ENABLE_DEFAULT_RADIUS
          ],
          numberBadge: 999,
        }, {
          defaultAnimationBeforeLifting: false
        })

      Image($r('app.media.son')).width("100")
        .draggable(true)
        .dragPreviewOptions({
          modifier: this.myModifier.opacity(0.3) as ImageModifier
        }, {
          defaultAnimationBeforeLifting: true
        })

      Image(this.targetImage).width(100).height(100).border({ color: Color.Black, width: 1 })
        .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
        .onDrop((event: DragEvent) => {
          let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
          this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;
          event.setResult(DragResult.DRAG_SUCCESSFUL);
        })
    }
  }
}

@Component
struct MySample3 {

  build() {
    Column({space:10}) {

      /*
       * dragPreviewOptions() - 拖拽预览图的相关选项
       *   value - 一个 DragPreviewOptions 对象
       *   options - 一个 DragInteractionOptions 对象
       *     isMultiSelectionEnabled - 是否支持多选拖拽（即拖拽时，会集合所有 selected 的 item 然后一起拖拽）
       */
      Grid() {
        ForEach([0, 1, 2, 3, 4 , 5, 6, 7, 8], (item: number) => {
          GridItem() {
            Column() {
              Text(`${item}`).fontColor(Color.White)
            }
            .backgroundColor(Color.Blue).justifyContent(FlexAlign.Center).width('100%').height('100%')
          }
          .width(80)
          .height(80)
          // 对于本例来说，如果长按 0 或 2 或 4 或 6 或 8 则会把 0, 2, 4, 6, 8 都集合到一起，然后一起拖拽
          // 对于本例来说，如果长按 1 或 3 或 5 或 7 则只针对选中的拖拽
          .selected(item % 2 == 0 ? true : false)
          .dragPreviewOptions({}, {
            isMultiSelectionEnabled:true
          })
          .onDragStart((event: DragEvent) => {

          })
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .height(300)
    }
  }
}
