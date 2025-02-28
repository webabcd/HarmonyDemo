/*
 * AppStorageV2 - 应用的全局的状态存储（保存在内存中）
 *   用于为指定的对象提供全局共享的能力
 *
 * connect() - 创建一个全局的状态存储
 *   type - 全局对象的类型
 *   keyOrDefaultCreator - 标识（用于在不同的页面关联同一个全局对象）
 *   defaultCreator - 默认构造器（如果在内存中找不到指定标识的对象，则使用此构造器构造实例）
 * remove() - 删除指定标识的全局对象
 * keys() - 获取应用中所有全局对象的标识列表
 */

import { AppStorageV2, router } from "@kit.ArkUI";
import { TitleBar } from "../../TitleBar";
import { MyClass } from "./AppStorageV2Demo";

@Entry
@ComponentV2
struct AppStorageV2Demo_Page1 {

  // 此对象可全局共享（通过标识关联同一个全局对象）
  myClass: MyClass = AppStorageV2.connect(MyClass, "myKey", () => new MyClass())!;

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button('返回')
        .onClick(() => {
          router.back()
        })

      Button(`更新数据 ${this.myClass.count}`)
        .onClick(() => {
          this.myClass.count ++
        })
    }
  }
}