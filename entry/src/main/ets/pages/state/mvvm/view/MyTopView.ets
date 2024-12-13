@ComponentV2
export default struct MyTopView {

  @Param taskCount: number = 0;

  build() {
    Column() {
      Text(`任务总数: ${this.taskCount}`)
    }
  }
}
