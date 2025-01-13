/*
 * Navigator - 导航器，支持通过页面地址导航
 */

import { router } from '@kit.ArkUI'
import { TitleBar } from '../../../TitleBar'
import { Person } from '../NavigatorDemo'

@Entry
@Component
struct NavigatorDemo_Page1 {

  // 获取传递过来的数据（即上一页的 Navigator 的 params() 设置的数据）
  @State person?: Person = router.getParams() as Person
  @State active: boolean = false

  build() {
    Column({space:10}) {
      TitleBar()

      Text(`pageId:${Math.floor(Math.random() * 1000).toString()}`).fontSize(24)

      Text(`name:${this.person?.name}, age:${this.person?.age}`).fontSize(24)

      /*
       * Navigator - 导航器，支持通过页面地址导航
       *   点击这个 Navigator 组件，则会触发这个 Navigator 的导航行为
       *   target() - 目标页的地址
       *   type() - 导航类型（NavigationType 枚举）
       *     Push - 跳转到指定页
       *     Replace - 销毁当前页，并用目标页替换
       *     Back - 从栈顶到栈底查找，返回到指定的目标页，找不到则不响应，未设置目标页则返回上一页
       *   params() - 传递给目标页的数据
       *   active() - 是否触发当前 Navigator 的导航行为
       */
      Navigator() {
        Text('push').fontSize(24)
      }
      .target('pages/component/navigation/pages/NavigatorDemo_Page1')
      .type(NavigationType.Push)

      Navigator() {
        Text('replace').fontSize(24)
      }
      .target('pages/component/navigation/pages/NavigatorDemo_Page1')
      .type(NavigationType.Replace)

      Navigator() {
        Text('back').fontSize(24)
      }
      .target('pages/component/navigation/pages/NavigatorDemo_Page1')
      .type(NavigationType.Back)

      // 啥都不设置，默认就是返回上一页
      Navigator() {
        Text('返回上一页').fontSize(24)
      }

      // 不设置 Navigator 的子组件，则这个 Navigator 不会有任何界面上的绘制（也就是说，不能通过点击这个 Navigator 组件触发其导航行为）
      // 后续可以通过设置这个 Navigator 的 active() 为 true 来触发这个 Navigator 的导航行为
      Navigator() { }.active(this.active)
      Button("返回上一页").onClick(() => {
        this.active = true
      })
    }
  }
}