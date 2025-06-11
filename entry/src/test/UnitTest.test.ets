import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Helper } from '../main/ets/utils/Helper';

// 需要先在 /entry/src/test/List.test.ets 文件的 testsuite 函数内调用 UnitTestTest()
// 在本页面的 UnitTestTest() 名字上点击右键，然后点击右键菜单中的相关选项，就可以运行测试用例了
// 运行本例后的测试结果为：
// Test Results（失败）
// └── UnitTestTests（失败）
//     ├── MyTest1（成功）
//     │   ├── test1（成功）
//     │   └── test2（成功）
//     └── MyTest2（失败）
//         ├── test1（失败）
//         └── test2（成功）
export default function UnitTestTest() {
  // describe() - 定义测试用例组
  describe('MyTest1', () => {
    beforeAll(() => {
      // 组内所有测试用例执行前执行
    })
    beforeEach(() => {
      // 组内每个测试用例执行前执行
    })
    afterEach(() => {
      // 组内每个测试用例执行后执行
    })
    afterAll(() => {
      // 组内所有测试用例执行后执行
    })

    // it() - 定义测试用例
    // expect() - 测试指定的变量，返回一个 Assert 断言
    //   assertEqual() - 断言两个值是否相等
    //   not() - 获取结果相反的 Assert 断言
    //   注：还有好多其他方法，详见文档
    it('test1', 0, () => {
      let a = Helper.formatWithThousandSeparator(31_415_926)
      expect(a).assertEqual('31,415,926') // 断言 a 等于 '31,415,926'
    })

    it('test2', 0, () => {
      expect(1).not().assertEqual(2) // 断言 1 不等于 2
    })

  })

  describe('MyTest2', () => {
    beforeAll(() => { })
    beforeEach(() => { })
    afterEach(() => { })
    afterAll(() => { })

    it('test1', 0, () => {
      expect(1).assertEqual(2)
    })

    it('test2', 0, () => {
      expect(1).assertEqual(1)
    })
  })
}