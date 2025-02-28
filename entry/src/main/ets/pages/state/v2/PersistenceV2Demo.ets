/*
 * PersistenceV2 - 应用的持久化的状态存储（保存在中）
 *   用于为指定的对象提供持久化的能力
 *   @Trace 属性的变化会触发自动持久化，如果需要手动持久化则调用 save() 即可
 *
 * connect() - 创建一个持久化的状态存储
 *   type - 持久化对象的类型
 *   keyOrDefaultCreator - 标识（用于关联同一个持久化对象）
 *   defaultCreator - 默认构造器（如果在存储中找不到指定标识的对象，则使用此构造器构造实例）
 * remove() - 删除指定标识的持久化对象
 * keys() - 获取应用中所有持久化对象的标识列表
 * save() - 手动持久化指定标识的持久化对象
 * notifyOnError() - 在保存和读取持久化对象时，其序列化和反序列化的过程中发生异常时的回调
 */

import { MyLog, TitleBar } from '../../TitleBar';
import { PersistenceV2, Type } from '@kit.ArkUI';

// 在保存和读取持久化对象时，其序列化和反序列化的过程中发生异常时的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  MyLog.d(`error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@Entry
@ComponentV2
struct PersistenceV2Demo {

  // 此对象会自动持久化
  myClass: MyClass = PersistenceV2.connect(MyClass, "myKey", () => new MyClass())!;
  myClass2: MyClass2 = PersistenceV2.connect(MyClass2, "myKey2", () => new MyClass2())!;

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Button(`更新数据（简单对象） ${this.myClass.count}`)
        .onClick(() => {
          this.myClass.count ++
        })

      Button(`更新数据（复杂对象） ${this.myClass2.myClass.count}`)
        .onClick(() => {
          this.myClass2.myClass.count ++
        })
    }
  }
}

@ObservedV2
export class MyClass {
  @Trace count: number = 0;
}

@ObservedV2
export class MyClass2 {
  // 对于复杂对象来说，需要先用 @Type 装饰使用的自定义类型，以确保序列化成功
  @Type(MyClass)
  @Trace myClass: MyClass = new MyClass();
}