/*
 * 用户首选项存储（preference）
 *
 * 注：首选项数据通过 key/value 的方式操作，其通过 xml 格式保存在相关的文件中
 */

import { TitleBar } from '../TitleBar';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS'
import { preferences } from '@kit.ArkData';

@Entry
@Component
struct PreferencesDemo {

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

  // 通过 getContext(this) 获取 context
  context = getContext(this) as common.UIAbilityContext

  dataPreferences: preferences.Preferences | null = null

  async aboutToAppear() {
    // 打印首选项存储目录（类似 /data/storage/el2/base/haps/entry/preferences）
    this.message += `preferencesDir: ${this.context.preferencesDir}\n`

    /*
     * preferences.getPreferences() - 获取 Preferences 对象
     *   context - 上下文
     *   options - 选项
     *     name - 对应文件的文件名
     */
    this.dataPreferences = await preferences.getPreferences(this.context, {
      // 通过当前 Preferences 对象操作的首选项数据保存在 /data/storage/el2/base/haps/entry/preferences/myStore 文件中
      name: 'myStore'
    });

    // 删除首选项存储中的 myStore 文件
    // await preferences.deletePreferences(this.context, "myStore")
  }

  /*
   * put(), putSync() - 写入数据到缓存，然后会自动持久化
   * clear(), clearSync() - 清空缓存
   * flush() - 将缓存中的数据持久化到文件中
   *
   * key 必须是字符串类型
   * value 的可用类型有 number | string | boolean | Array<number> | Array<string> | Array<boolean> | Uint8Array | object | bigint
   */
  async writeData() {
    await this.dataPreferences?.put("key1", `hello: ${Math.floor(Math.random() * 1000)}`)
    let uint8Array = new util.TextEncoder().encodeInto(`hello: ${Math.floor(Math.random() * 1000)}`);
    await this.dataPreferences?.put('key2', uint8Array);
    await this.dataPreferences?.flush()
    this.message = "写入成功"
  }

  /*
   * has(), hasSync() - 是否存在指定 key 的数据
   * get(), getSync() - 获取指定 key 的数据
   * getAll(), getAllSync() - 获取全部数据
   */
  async readData() {
    this.dataPreferences?.getAllSync()
    this.message = ""
    if (!await this.dataPreferences?.has('key1')) {
      this.message += `没有发现 key1 数据\n`
    } else {
      let value = await this.dataPreferences?.get('key1', 'default');
      this.message += `key1:${value}\n`
    }

    if (!await this.dataPreferences?.has('key2')) {
      this.message += `没有发现 key2 数据\n`
    } else {
      let value: preferences.ValueType = await this.dataPreferences!.get('key2', new Uint8Array(0));
      let textDecoder = util.TextDecoder.create('utf-8');
      let result = textDecoder.decodeToString(value as Uint8Array);
      this.message += `key2:${result}\n`
    }
  }

  /*
   * delete(), deleteSync() - 删除指定 key 的数据
   */
  async deleteData() {
    await this.dataPreferences?.delete('key1');
    await this.dataPreferences?.delete('key2');
    this.message = "删除成功"

    // 删除首选项存储中的 myStore 文件
    // await preferences.deletePreferences(this.context, "myStore")
  }

  build() {
    Column({space:10}) {
      Button("writeData").onClick(async () => {
        await this.writeData()
      })

      Button("readData").onClick(async () => {
        await this.readData()
      })

      Button("deleteData").onClick(async () => {
        await this.deleteData()
      })

      Text(this.message)
    }
  }
}
