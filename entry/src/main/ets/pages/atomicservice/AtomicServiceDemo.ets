/*
 * 元服务
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct AtomicServiceDemo {

  @State message: string = "元服务，示例项目在 /HarmonyDemo/atomicservicedemo 目录中"

  build() {
    Column({space:10}) {
      TitleBar()
      Text(this.message)
    }
  }
}