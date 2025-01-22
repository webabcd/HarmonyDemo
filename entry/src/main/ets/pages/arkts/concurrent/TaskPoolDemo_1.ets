// 本文件用于演示函数或类如何被 @Concurrent 函数调用

// 用于演示 @Concurrent 函数调用其他 .ets 文件中的函数
export function myFunction(): string {
  return "myFunction"
}

// 用于演示 @Concurrent 函数调用其他 .ets 文件中的类
export class MyClass {
  name: string = 'MyClass'
  hello() {
    return "hello"
  }
}
