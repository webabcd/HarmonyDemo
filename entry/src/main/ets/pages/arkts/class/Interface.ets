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


{
  // 接口用于定义对象的形状
  interface Person {
    readonly id: number; // 只读属性
    name: string;
    age: number;
    // hello(name: string): string; // 方法
  };

  // 变量的形状必须和接口的形状保持一致（也就是说属性名和类型必须与接口一样，且每个属性都必须要定义，且不能定义接口未定义的属性）
  let webabcd: Person = {
    id: 1234,
    name: 'webabcd',
    age: 44,
    // 通过这种 Object 的方式无法实现接口中的方法，会编译报错（但是 typescript 是支持的），用 class 的方式是可以实现接口的方法的
    // hello(name: string): string { return 'hello: '+ name; }
  };

  webabcd.name = 'wanglei';
  MyLog.d(`${webabcd.id}, ${webabcd.name}, ${webabcd.age}`); // 1234, wanglei, 44
}

{
  interface Person {
    name: string;
    age?: number; // 通过 ? 定义可选属性
  };

  // 变量的形状必须和接口的形状保持一致，且可选属性可以不定义
  let webabcd1: Person = {
    name: 'webabcd',
  };
  let webabcd2: Person = {
    name: 'webabcd',
    age: 44
  };
}

{
  // 通过接口定义数组，不支持（但是 typescript 是支持的）
  /*
  interface I1 {
    [index: number]: number;
  }
  */

  // 通过接口允许定义任意属性，不支持（但是 typescript 是支持的）
  /*
  interface I2 {
    [propName: string]: string | number;
  };
  */

  // 通过接口定义函数的形状，不支持（但是 typescript 是支持的）
  /*
  interface I3 {
    (p1: string, p2: string): string;
  }
  */

  // 通过接口定义泛型，不支持（但是 typescript 是支持的）
  /*
  interface I4<T> {
    (length: number, value: T): Array<T>;
  }
  */
}
