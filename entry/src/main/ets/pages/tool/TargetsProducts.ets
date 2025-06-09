/*
 * Targets, Products
 *
 * 一个 hap, hsp, har 可以定制出多个 target，每个 target 都是一个定制的 hap, hsp, har
 * 一个 app 可以定制出多个 product，每个 product 都是一个定制的 app
 *
 * 步骤：
 * 1、在 entry/build-profile.json5 中做 targets 配置
 * 2、在 hsp1/build-profile.json5 中做 targets 配置
 * 3、在 app 级的 build-profile.json5 中做 products 配置和 modules 配置
 */

// 不同的 target 定制了不同的 MyConfig.ets（地址分别为：entry/src/default/MyConfig.ets, entry/src/target1/MyConfig.ets, entry/src/target2/MyConfig.ets）
// 通过类似 import { getTargetName } from 'entry/MyConfig'; 的方式导入，则不同的 target 会导入对应的不同的代码
import { getTargetName } from 'entry/MyConfig';
import { TitleBar } from '../TitleBar';

@Entry
@Component
struct TargetsProducts {

  @State message: string = ""

  aboutToAppear(): void {
    // 不同的 target 使用不同的代码
    this.message = getTargetName()
  }

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      // 不同的 target 使用不同的字符串资源
      Text($r('app.string.mytarget_name'))

      // 不同的 target 使用不同的图片资源
      Image($r('app.media.mytarget_logo')).width(100).height(100)
    }
  }
}