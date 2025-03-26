@Entry
@Component
struct Index {
  @State message: string = '';

  onPageShow(): void {
    // 获取 AppStorage 中的数据（本例会在 UIAbility 中解析 Want 中的参数，并保存在 AppStorage 中）
    this.message = `k1: ${AppStorage.get("k1")}\n`
    this.message += `k2: ${AppStorage.get("k2")}`
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}