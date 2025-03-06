/*
 * LocalStorage - 页面级的状态存储，用于在单个 UIAbility 内共享数据
 * 当 @Entry 组件绑定了 LocalStorage 对象后，在组件内部，此 LocalStorage 对象可以与 @LocalStorageLink 做双向同步，或与 @LocalStorageProp 做单向同步
 */

import { TitleBar } from '../TitleBar';

class Person {
  age: number;
  constructor(age: number) {
    this.age = age;
  }
}

/*
 * new LocalStorage() - 创建一个新键的 LocalStorage 实例
 * LocalStorage.getShared() - 获取当前 UIAbility 内的全局 LocalStorage 实例
 *   setOrCreate() - 更新或新建 key/value 数据
 *
 * 注：在 UIAbility 中通过 windowStage.loadContent(path, localStorage) 传递的 LocalStorage 对象会自动合并到 LocalStorage.getShared() 中
 */

let record: Record<string, number> = { 'key1': 1000 }
let person = new Person(44)
// let storage: LocalStorage = new LocalStorage(record) // 新键 LocalStorage 实例
let storage: LocalStorage = LocalStorage.getShared() // 当前 UIAbility 内的全局 LocalStorage 实例
storage.setOrCreate('key1', 1000);
storage.setOrCreate('key2', person);
storage.setOrCreate('key3', 2000);

/*
 * @Entry() - 指定 @Entry 组件需要绑定的 LocalStorage 对象
 *   如果是 new LocalStorage() 的话，则绑定了它的 @Entry 组件可以与其做数据同步，当这个 LocalStorage 实例销毁后，相关数据也就都销毁了
 *   如果是 LocalStorage.getShared() 的话，则当前 UIAbility 内的所有 @Entry 组件都可以通过绑定它，而实现数据在当前 UIAbility 内的全局同步
 *   如果需要拿到在 UIAbility 中通过 windowStage.loadContent(path, localStorage) 传递的 LocalStorage 对象的数据，则需要使用 LocalStorage.getShared()
 */
@Entry(storage)
@Component
struct LocalStorageDemo {
  /*
   * LocalStorage 与 @LocalStorageLink(key) 的指定 key 的数据会做双向同步
   * LocalStorage 与 @LocalStorageProp(key) 的指定 key 的数据会做 LocalStorage 到 @LocalStorageProp 的单向同步
   */
  @LocalStorageLink('key1') parent_link_key1: number = 0;
  @LocalStorageLink('key2') parent_link_key2: Person = new Person(0);
  @LocalStorageProp('key3') parent_prop_key3: number = 0;
  // myNumber 数据来自 UIAbility 的 windowStage.loadContent(path, localStorage)，参见 /ets/entryability/EntryAbility.ets 中的相关代码
  @LocalStorageLink('myNumber') parent_link_myNumber: number = 0;

  @State message: string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message)

      Button(`parent_link_key1: ${this.parent_link_key1}`).onClick(() => {
        this.parent_link_key1 += 1;
      })

      Button(`parent_link_key2: ${this.parent_link_key2.age}`) .onClick(() => {
        this.parent_link_key2.age += 1;
      })

      Button(`parent_prop_key3: ${this.parent_prop_key3}`).onClick(() => {
        this.parent_prop_key3 += 1;
      })

      Button(`parent_link_myNumber: ${this.parent_link_myNumber}`).onClick(() => {
        this.parent_link_myNumber += 1;
      })

      Button("获取和更新 LocalStorage 的指定 key 的值").onClick(() => {
        /*
         * LocalStorage
         *   get() - 获取指定 key 的数据
         *   link() - 获取指定 key 的 SubscribedAbstractProperty 对象
         *     get() - 获取当前 key 的数据
         *     set() - 更新当前 key 的数据，并双向同步
         *   delete（） - 删除指定 key 的数据
         */
        let value1: number | undefined = storage.get('key1');
        let link1: SubscribedAbstractProperty<number> = storage.link('key1');
        this.message = `key1:${value1}, key1:${link1.get()}`

        link1.set(3000)
      })

      ChildComponent()
    }
  }
}

@Component
struct ChildComponent {
  @LocalStorageLink('key1') child_link_key1: number = 0;
  @LocalStorageLink('key2') child_link_key2: Person = new Person(0);
  @LocalStorageProp('key3') child_prop_key3: number = 0;
  @LocalStorageLink('myNumber') child_link_myNumber: number = 0;

  build() {
    Column({ space: 10 }) {
      Button(`child_link_key1: ${this.child_link_key1}`) .onClick(() => {
        this.child_link_key1 += 1;
      })

      Button(`child_link_key2: ${this.child_link_key2.age}`).onClick(() => {
        this.child_link_key2.age += 1;
      })

      Button(`child_prop_key3: ${this.child_prop_key3}`) .onClick(() => {
        this.child_prop_key3 += 1;
      })

      Button(`child_link_myNumber: ${this.child_link_myNumber}`) .onClick(() => {
        this.child_link_myNumber += 1;
      })
    }
    .backgroundColor(Color.Yellow)
  }
}