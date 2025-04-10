/*
 * 卡片的具体实现（本例演示的是静态卡片）
 *
 * 静态卡片仅支持 UI 组件布局
 * 动态卡片除了支持 UI 组件布局外，还支持通用事件以及自定义动画效果，可以用于需要交互的场景
 */

@Entry
@Component
struct StaticWidgetCard {

  @LocalStorageProp('content') content: string = ''
  @LocalStorageProp('myImage') myImage: string = ''

  @LocalStorageProp('formId') cardId: string = ''
  @LocalStorageProp('width') cardWidth: string = ''
  @LocalStorageProp('height') cardHeight: string = ''
  @LocalStorageProp('dimension') cardDimension: string = ''

  build() {
    // 关于 FormLink 的详细说明请参见 FormLinkCard.ets
    FormLink({
      action: 'router', // 点击后跳转到指定的 ability
      abilityName: 'com.webabcd.harmonydemo.EntryAbility', // 需要打开的 ability 的名称
    }) {
      Row() {
        Column() {
          // 可以直接显示本地资源中的图片
          Image($r('app.media.son')).width(20).height(20)

          // 如果是沙箱文件，则需要使用此方式显示
          //   memory:// 代表显示的是内存中的图片
          //   this.myImage 代表显示的图片的文件描述符（需要在 FormExtensionAbility 打开图片，然后把文件描述符传过来，请参见 /entryformability/EntryFormAbility.ets 中的说明）
          // 注：如果需要显示一个网络图片，则先把图片下载后保存到沙箱中，然后再显示即可
          Image('memory://' + this.myImage).width(20).height(20)

          // 在卡片上更新一个文本（需要在 FormExtensionAbility 把更新后的文本传过来，请参见 /entryformability/EntryFormAbility.ets 中的说明）
          Text(this.content)

          // 卡片 id
          Text(`formId: ${this.cardId}`)
          // 卡片的规格（1代表1*2, 2代表2*2, 3代表2*4, 4代表4*4, 7代表6*4）
          Text(`cardDimension: ${this.cardDimension}`)
          // 卡片的宽
          Text(`cardWidth: ${this.cardWidth}`)
          // 卡片的高
          Text(`cardHeight: ${this.cardHeight}`)
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}