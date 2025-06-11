/*
 * 单元测试
 * 参见 /entry/src/test/List.test.ets 和 /entry/src/test/UnitTest.test.ets 中的说明
 *
 * 创建测试用例的方式一（自动方式）：
 * 在 DevEco Studio 中打开 ets 文件，然后右键，然后点击 Show Context Actions 之后，创建测试文件即可
 *
 * 创建测试用例的方式一（手动方式）：
 * 1、在 /entry/src/test 目录中创建一个 .test.ets 测试文件，并写自定义的测试用例
 * 2、在 /entry/src/test/List.test.ets 文件的 testsuite 函数内调用你的 .test.ets 测试文件中的函数
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct UnitTest {

  @State message: string = ""

  build() {
    Column({space:10}) {
      TitleBar()
      Text(this.message)
    }
  }
}