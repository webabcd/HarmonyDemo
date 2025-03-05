let storage: LocalStorage = LocalStorage.getShared()

@Entry(storage)
@Component
struct Index {
  @State message: string = 'hello feature1\n';

  aboutToAppear(): void {
    // 获取 LocalStorage 中的数据（本例会在 UIAbility 中通过 windowStage.loadContent(path, localStorage) 传递 Want 中的数据）
    this.message += `k1: ${storage.get("k1")}\n`
    this.message += `k2: ${storage.get("k2")}`
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