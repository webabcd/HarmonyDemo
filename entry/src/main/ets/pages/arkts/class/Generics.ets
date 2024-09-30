import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct MySample {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// 泛型的简单示例
function createArray<T>(length: number, value: T): Array<T> {
  let result: T[] = [];
  for (let i = 0; i < length; i++) {
    result[i] = value;
  }
  return result;
}

let a = createArray<string>(3, 'x');
MyLog.d(`${a}`); // ['x', 'x', 'x']

// 可以省略 <string> 因为 TypeScript 可以根据传入的参数推导出类型
let b = createArray(3, 'x');
MyLog.d(`${b}`); // ['x', 'x', 'x']


{
  /*
  function swap<T, U>(tuple: [T, U]): [U, T] {
    return [tuple[1], tuple[0]];
  }
  */
  // 可以定义多个不同的泛型类型
  let swap = <T, U>(tuple: [T, U]): [U, T] => {
    return [tuple[1], tuple[0]];
  }

  let a = swap<number, string>([7, 'seven']);
  MyLog.d(`${a}`); // ['seven', 7]

  // 可以省略 <number, string> 因为 TypeScript 可以根据传入的参数推导出类型
  let b = swap([7, 'seven']);
  MyLog.d(`${b}`); // ['seven', 7]
}

{
  // 泛型约束，用于约束泛型必须继承自某个类或某些接口

  interface Interface1 {
    name: string;
  }
  class Class1 implements Interface1 {
    public name: string;
    constructor(name: string) {
      this.name = name;
    }
  }

  // 泛型 T 必须继承自 Interface1
  let hello = <T extends Interface1>(p: T): string => {
    return `${p.name}`;
  }

  let a = new Class1('webabcd');
  MyLog.d(hello(a)); // webabcd
}

{
  // 泛型类
  class Class1<T> {
    salt?: T;
    add(x: T, y: T):number {
      if (typeof x == 'number' && typeof y == 'number' && typeof this.salt == 'number') {
        return x + y + this.salt!;
      }
      return -1;
    };
  }

  let a = new Class1<number>();
  a.salt = 10;
  MyLog.d(`${a.add(2, 3)}`); // 15
}

{
  // 泛型接口
  interface MyInterface<T, U> {
    hello(input: T): U;
  }

  // 实现泛型接口
  class MyClass implements MyInterface<number, string> {
    hello(input: number): string {
      return `hello:${input}`;
    }
  }

  let a = new MyClass();
  MyLog.d(a.hello(100)); // hello:100
}
