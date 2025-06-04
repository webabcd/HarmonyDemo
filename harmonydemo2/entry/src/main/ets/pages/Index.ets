/*
 * 本例用于演示 Want 的目标应用
 * 本例用于演示系统分享的目标应用
 */

@Entry
@Component
struct Index {

  @State message: string = '';

  // 分享过来的数据
  @StorageProp('share_data') share_data: string = ''
  // 分享过来的图片地址
  @StorageProp('share_uri') share_uri: string = ''

  onPageShow(): void {
    // 获取 AppStorage 中的数据（本例会在 UIAbility 中解析 Want 中的参数，并保存在 AppStorage 中）
    this.message = `k1: ${AppStorage.get("k1")}\n`
    this.message += `k2: ${AppStorage.get("k2")}\n`
    this.message += `uri: ${AppStorage.get("uri")}\n`
  }

  build() {
    Column({space:10}) {
      Text(this.message)

      Text(`share_data: ${this.share_data}`)

      Image(`${this.share_uri}`).width(50).height(50)
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}