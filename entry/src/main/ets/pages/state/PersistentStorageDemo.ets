/*
 * PersistentStorage - 可持久化的状态存储（需要配合 AppStorage 使用）
 * PersistentStorage 用于为 AppStorage 提供自动持久化的能力
 *
 * 注：关于 AppStorage 请参见 AppStorageDemo.ets 中的说明
 */

import { TitleBar } from '../TitleBar';

class Person {
  age: number;
  constructor(age: number) {
    this.age = age;
  }
}

/*
 * PersistentStorage.persistProp() - 为 AppStorage 的指定 key 的数据提供自动持久化的能力
 */
if (AppStorage.get('k1') == undefined) {
  PersistentStorage.persistProp('k1', 1000);
}
if (AppStorage.get('k2') == undefined) {
  let person = new Person(44)
  PersistentStorage.persistProp('k2', person);
}
if (AppStorage.get('k3') == undefined) {
  PersistentStorage.persistProp('k3', 2000);
}

@Entry
@Component
struct PersistentStorageDemo {
  /*
   * AppStorage 与 @StorageLink(key) 的指定 key 的数据会做双向同步
   * AppStorage 与 @StorageLink(key) 的指定 key 的数据会做 AppStorage 到 @StorageLink 的单向同步
   */
  @StorageLink('k1') link_k1: number = 0;
  @StorageLink('k2') link_k2: Person = new Person(0);
  @StorageProp('k3') prop_k3: number = 0;

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message)

      Button(`link_k1: ${this.link_k1}`).onClick(() => {
        this.link_k1 += 1;
      })

      Button(`link_k2: ${this.link_k2.age}`) .onClick(() => {
        this.link_k2.age += 1;
      })

      Button(`prop_k3: ${this.prop_k3}`).onClick(() => {
        this.prop_k3 += 1;
      })

      Button("获取和更新 PersistentStorage 的指定 key 的值").onClick(() => {
        /*
         * AppStorage
         *   get() - 获取指定 key 的数据
         *   link() - 获取指定 key 的 SubscribedAbstractProperty 对象
         *     get() - 获取当前 key 的数据
         *     set() - 更新当前 key 的数据，并双向同步
         *   delete（） - 删除指定 key 的数据
         */
        let value1: number | undefined = AppStorage.get('k1');
        let link1: SubscribedAbstractProperty<number> = AppStorage.link('k1');
        this.message = `k1:${value1}, k1:${link1.get()}`

        link1.set(3000)
      })
    }
  }
}