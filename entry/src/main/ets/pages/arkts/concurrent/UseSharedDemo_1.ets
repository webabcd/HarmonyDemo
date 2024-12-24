// 本例用于演示多线程之间使用的对象是在普通模块中实例化的对象，不同线程引用时使用的是不同的对象，即不同线程加载同一模块时会被加载多次，从而产生了多个不同的对象

export class MyClass1 {
  id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}

export let myClass1 = new MyClass1(0);