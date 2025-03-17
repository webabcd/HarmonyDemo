/*
 * 触摸类输入
 * 点击事件，触摸事件，拖拽事件，事件冒泡，事件透传
 */

import { TitleBar } from '../TitleBar';
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';

@Entry
@Component
struct TouchDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('点击事件').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('触摸事件').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('拖拽事件').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('事件冒泡').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('事件透传').align(Alignment.Top)
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

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * onClick() - 点击事件，当按下并抬起后触发（回调参数是一个 ClickEvent 对象）
       *   x, y - 点击位置相对于组件左上角的坐标
       *   windowX, windowY - 点击位置相对于窗口的坐标
       *   displayX, displayY - 点击位置相对于屏幕的坐标
       *   timestamp - 事件触发时，距系统启动时的时间戳
       *   target.area - 触发了事件的组件的显示区域（一个 Area 对象）
       *     width, height - 尺寸
       *     position - 区域的左上角相对于父容器的左上角的位置
       *     globalPosition - 区域的左上角相对于页面的左上角的位置
       */
      Button('click me').onClick((event: ClickEvent) => {
        this.message = "onClick\n"
        this.message += `x:${event.x}\n`
        this.message += `y:${event.y}\n`
        this.message += `windowX:${event.windowX}\n`
        this.message += `windowY:${event.windowY}\n`
        this.message += `displayX:${event.displayX}\n`
        this.message += `displayY:${event.displayY}\n`
        this.message += `timestamp:${event.timestamp}\n`
        this.message += `target area width:${event.target.area.width}\n`
        this.message += `target area height:${event.target.area.height}\n`
        this.message += `target area position:${JSON.stringify(event.target.area.position)}\n`
        this.message += `target area globalPosition:${JSON.stringify(event.target.area.globalPosition)}\n`
      })
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message)

      /*
       * onTouch() - 触摸事件，当按下或滑动或抬起时触发（回调参数是一个 TouchEvent 对象）
       *   type - 触摸的类型（TouchEvent 枚举）
       *     Down, Up, Move
       *   touches - 当前全部的触摸点的信息（一个 TouchObject 对象数组）
       *   changedTouches - 当前发生变化的触摸点的信息（一个 TouchObject 对象数组）
       *
       * TouchObject - 触摸点信息
       *   x, y - 触摸点的位置相对于组件左上角的坐标
       *   windowX, windowY - 触摸点的位置相对于窗口的坐标
       *   displayX, displayY - 触摸点的位置相对于屏幕的坐标
       *   timestamp - 事件触发时，距系统启动时的时间戳
       *   target.area - 触发了事件的组件的显示区域（一个 Area 对象）
       *     width, height - 尺寸
       *     position - 区域的左上角相对于父容器的左上角的位置
       *     globalPosition - 区域的左上角相对于页面的左上角的位置
       */
      Button('click me').onTouch((event: TouchEvent) => {
        let touches = event.touches
        let changedTouches = event.changedTouches

        this.message = "onTouch\n"
        this.message += `type:${TouchType[event.type]}\n`
        this.message += `x:${touches[0].x}\n`
        this.message += `y:${touches[0].y}\n`
        this.message += `windowX:${touches[0].windowX}\n`
        this.message += `windowY:${touches[0].windowY}\n`
        this.message += `displayX:${touches[0].displayX}\n`
        this.message += `displayY:${touches[0].displayY}\n`
        this.message += `timestamp:${event.timestamp}\n`
        this.message += `target area width:${event.target.area.width}\n`
        this.message += `target area height:${event.target.area.height}\n`
        this.message += `target area position:${JSON.stringify(event.target.area.position)}\n`
        this.message += `target area globalPosition:${JSON.stringify(event.target.area.globalPosition)}\n`
      })
    }
  }
}

@Component
struct MySample3 {

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
struct MySample4 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * 父子组件场景下
       * onTouch() 事件默认是支持冒泡的，如果不需要冒泡则调用 event.stopPropagation() 即可
       */

      Column() {
        Column() {
          Column() {

          }
          .width(100).height(100).backgroundColor(Color.Red)
          .onTouch(() => {
            this.message += "r"
          })
        }
        .width(200).height(200).backgroundColor(Color.Green)
        .onTouch(() => {
          this.message += "g"
        })
      }
      .width(300).height(300).backgroundColor(Color.Blue)
      .onTouch(() => {
        this.message += "b"
      })

      Column() {
        Column() {
          Column() {

          }
          .width(100).height(100).backgroundColor(Color.Red)
          .onTouch((event: TouchEvent) => {
            event.stopPropagation()
            this.message += "r"
          })
        }
        .width(200).height(200).backgroundColor(Color.Green)
        .onTouch((event: TouchEvent) => {
          event.stopPropagation()
          this.message += "g"
        })
      }
      .width(300).height(300).backgroundColor(Color.Blue)
      .onTouch((event: TouchEvent) => {
        event.stopPropagation()
        this.message += "b"
      })
    }
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  build() {
    Column({space:10}) {

      Text(this.message)

      /*
       * 兄弟组件场景下
       * onTouch() 事件默认是不支持透传的，如果需要透传则调用 hitTestBehavior(HitTestMode.Transparent) 即可
       */

      Stack() {
        Column().width(300).height(300).backgroundColor(Color.Blue)
          .onTouch(() => {
            this.message += "b"
          })
        Column().width(200).height(200).backgroundColor(Color.Green)
          .onTouch(() => {
            this.message += "g"
          })
        Column().width(100).height(100).backgroundColor(Color.Red)
          .onTouch(() => {
            this.message += "r"
          })
      }
      .width(300).height(300)

      Stack() {
        Column().width(300).height(300).backgroundColor(Color.Blue)
          .onTouch(() => {
            this.message += "b"
          })
          .hitTestBehavior(HitTestMode.Transparent)
        Column().width(200).height(200).backgroundColor(Color.Green)
          .onTouch(() => {
            this.message += "g"
          })
          .hitTestBehavior(HitTestMode.Transparent)
        Column().width(100).height(100).backgroundColor(Color.Red)
          .onTouch(() => {
            this.message += "r"
          })
          .hitTestBehavior(HitTestMode.Transparent)
      }
      .width(300).height(300)
    }
  }
}