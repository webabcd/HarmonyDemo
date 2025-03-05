/*
 * AppStorage - 全局级的状态存储
 * 全局 AppStorage 对象可以与 @StorageLink 做双向同步，或与 @StorageProp 做单向同步
 */

import { TitleBar } from '../TitleBar';

class Person {
  age: number;
  constructor(age: number) {
    this.age = age;
  }
}

/*
 * AppStorage.get() - 获取指定 key 的数据
 * AppStorage.setOrCreate() - 更新或新建 key/value 数据
 */
if (AppStorage.get('key1') == undefined) {
  AppStorage.setOrCreate('key1', 1000);
}
if (AppStorage.get('key2') == undefined) {
  let person = new Person(44)
  AppStorage.setOrCreate('key2', person);
}
if (AppStorage.get('key3') == undefined) {
  AppStorage.setOrCreate('key3', 2000);
}

@Entry
@Component
struct AppStorageDemo {
  /*
   * AppStorage 与 @StorageLink(key) 的指定 key 的数据会做双向同步
   * AppStorage 与 @StorageLink(key) 的指定 key 的数据会做 AppStorage 到 @StorageLink 的单向同步
   */
  @StorageLink('key1') link_key1: number = 0;
  @StorageLink('key2') link_key2: Person = new Person(0);
  @StorageProp('key3') prop_key3: number = 0;

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message)

      Button(`link_key1: ${this.link_key1}`).onClick(() => {
        this.link_key1 += 1;
      })

      Button(`link_key2: ${this.link_key2.age}`) .onClick(() => {
        this.link_key2.age += 1;
      })

      Button(`prop_key3: ${this.prop_key3}`).onClick(() => {
        this.prop_key3 += 1;
      })

      Button("获取和更新 AppStorage 的指定 key 的值").onClick(() => {
        /*
         * AppStorage
         *   get() - 获取指定 key 的数据
         *   link() - 获取指定 key 的 SubscribedAbstractProperty 对象
         *     get() - 获取当前 key 的数据
         *     set() - 更新当前 key 的数据，并双向同步
         *   delete（） - 删除指定 key 的数据
         */
        let value1: number | undefined = AppStorage.get('key1');
        let link1: SubscribedAbstractProperty<number> = AppStorage.link('key1');
        this.message = `key1:${value1}, key1:${link1.get()}`

        link1.set(3000)
      })
    }
  }
}