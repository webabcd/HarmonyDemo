// 本例用于演示多线程之间使用的对象是在 "use shared" 模块中实例化的 @Sendable 对象，不同线程引用时使用的是相同的对象，即不同线程加载同一模块时只会被加载一次

// 声明当前模块为共享模块（注：只能导出 @Sendable 数据）
"use shared"

@Sendable
export class MyClass2 {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}

// 保证多线程唯一
export let myClass2 = new MyClass2(0);