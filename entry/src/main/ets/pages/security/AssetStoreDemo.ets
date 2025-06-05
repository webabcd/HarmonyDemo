/*
 * 关键资产，来自 AssetStoreKit
 *
 * 关键资产用于保存敏感信息，系统会自动对其做加密和解密，只有关键资产的所有者才能访问
 * 关键资产允许应用卸载后仍然保留，以便下次应用再次安装后可以访问之前的关键资产
 */

import { TitleBar } from '../TitleBar';
import {  util } from '@kit.ArkTS';
import { asset } from '@kit.AssetStoreKit';
import { Helper } from '../../utils/Helper';

@Entry
@Component
struct AssetStoreDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  stringToArray(str: string): Uint8Array {
    let textEncoder = new util.TextEncoder();
    return textEncoder.encodeInto(str);
  }

  arrayToString(arr: Uint8Array): string {
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
    let str = textDecoder.decodeToString(arr, { stream: false })
    return str;
  }

  /*
   * asset - 关键资产
   *   add() - 添加一个 asset.AssetMap 对象
   * asset.AssetMap - 关键资产的键值对
   *   asset.Tag.ACCESSIBILITY - 用于说明什么情况下可以访问关键资产（asset.Accessibility 枚举）
   *     DEVICE_POWERED_ON - 开机后可访问
   *     DEVICE_FIRST_UNLOCKED - 首次解锁后，任意时间可访问
   *     DEVICE_UNLOCKED - 解锁状态时可访问
   *   asset.Tag.IS_PERSISTENT - 应用卸载后是否需要保留关键资产
   *     注：需要申请 ohos.permission.STORE_PERSISTENT_DATA 权限（参见 module.json5 中的相关配置）
   *   asset.Tag.ALIAS - 关键资产的别名，即标识
   *     注：此 key 对应的 value 是 Uint8Array 类型，长度为 1 - 256 字节
   *   asset.Tag.SECRET - 关键资产的明文（系统会自动对其加密和解密）
   *     注：此 key 对应的 value 是 Uint8Array 类型，长度为 1 - 1024 字节
   */
  async add() {
    let assetMap: asset.AssetMap = new Map();
    assetMap.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_POWERED_ON);
    assetMap.set(asset.Tag.IS_PERSISTENT, true);
    assetMap.set(asset.Tag.ALIAS, this.stringToArray('myAlias'));
    assetMap.set(asset.Tag.SECRET, this.stringToArray(`mySecret ${Helper.getTimestampString()}`));
    try {
      await asset.add(assetMap)
      this.message += `添加成功\n`
    } catch (e) {
      // 如果存在同 ALIAS 的关键资产，则添加失败
      this.message += `添加失败: ${JSON.stringify(e)}\n`
    }
  }

  /*
   * asset - 关键资产
   *   update() - 更新关键资产
   */
  async update() {
    let assetMapOld: asset.AssetMap = new Map();
    assetMapOld.set(asset.Tag.ALIAS, this.stringToArray('myAlias'));
    let assetMapNew: asset.AssetMap = new Map();
    assetMapNew.set(asset.Tag.SECRET, this.stringToArray(`mySecret ${Helper.getTimestampString()}`));
    try {
      // 更新 asset.Tag.ALIAS 为 myAlias 的关键资产的 asset.Tag.SECRET 的值
      await asset.update(assetMapOld, assetMapNew)
      this.message += `更新成功\n`
    } catch (e) {
      // 如果找不到指定 ALIAS 的关键资产，则更新失败
      this.message += `更新失败: ${JSON.stringify(e)}\n`
    }
  }

  /*
   * asset - 关键资产
   *   remove() - 删除关键资产
   */
  async remove() {
    let assetMap: asset.AssetMap = new Map();
    assetMap.set(asset.Tag.ALIAS, this.stringToArray('myAlias'));
    try {
      // 删除 asset.Tag.ALIAS 为 myAlias 的关键资产
      await asset.remove(assetMap)
      this.message += `删除成功\n`
    } catch (e) {
      // 如果找不到指定 ALIAS 的关键资产，则删除失败
      this.message += `删除失败: ${JSON.stringify(e)}\n`
    }
  }

  /*
   * asset - 关键资产
   *   remove() - 查询关键资产
   */
  async query() {
    let assetMap: asset.AssetMap = new Map();
    assetMap.set(asset.Tag.ALIAS, this.stringToArray('myAlias'));
    assetMap.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL); // 返回关键资产的键值对，且键值对中包括 asset.Tag.SECRET
    try {
      // 查询 asset.Tag.ALIAS 为 myAlias 的关键资产
      let queryResult: Array<asset.AssetMap> = await asset.query(assetMap)
      if (queryResult.length > 0) {
        let secret: Uint8Array = queryResult[0].get(asset.Tag.SECRET) as Uint8Array;
        this.message += `myAlias: ${this.arrayToString(secret)}\n`
      }
    } catch (e) {
      // 如果找不到指定 ALIAS 的关键资产，则查询失败
      this.message += `查询失败: ${JSON.stringify(e)}\n`
    }
  }

  build() {
    Column({ space: 10 }) {

      Button("添加关键资产").onClick(async () => {
        await this.add()
      })

      Button("更新关键资产").onClick(async () => {
        await this.update()
      })

      Button("删除关键资产").onClick(async () => {
        await this.remove()
      })

      Button("查询关键资产").onClick(async () => {
        await this.query()
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}
