import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct InterfaceDemo {
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
    hello: (name: string) => string; // 方法
  };

  // 变量的形状必须和接口的形状保持一致（也就是说属性名和类型必须与接口一样，且每个属性都必须要定义，且不能定义接口未定义的属性）
  let webabcd: Person = {
    id: 1234,
    name: 'webabcd',
    age: 44,
    hello: (name: string) => {
      return 'hello: '+ name;
    }
  };
  webabcd.name = 'wanglei';
  MyLog.d(`${webabcd.id}, ${webabcd.name}, ${webabcd.age}, ${webabcd.hello("webabcd")}`); // 1234, wanglei, 44, hello: webabcd

  // 可以通过 as 把对象字面量转换为指定的接口
  let webabcd2 = {
    id: 1234,
    name: 'webabcd',
    age: 44,
    hello: (name: string) => {
      return 'hello: '+ name;
    }
  } as Person;
  webabcd2.name = 'wanglei';
  MyLog.d(`${webabcd2.id}, ${webabcd2.name}, ${webabcd2.age}, ${webabcd2.hello("webabcd")}`); // 1234, wanglei, 44, hello: webabcd

  // 可以通过 as 把信息不全的对象字面量转换为指定的接口
  let webabcd3 = { id: 1234 } as Person;
  webabcd3.age = 44
  MyLog.d(`${webabcd3.id}, ${webabcd3.name}, ${webabcd3.age}`); // 1234, undefined, 44
}

{
  interface IPerson {
    name: string;
    age?: number; // 通过 ? 定义可选属性
    hello?: (name: string) => string; // 通过 ? 定义可选方法
  };

  // 类的形状必须和接口的形状保持一致，且可选属性和可选方法可以不定义
  class MyPerson1 implements IPerson {
    public name: string;
    public constructor(name: string) {
      this.name = name;
    }
  }
  class MyPerson2 implements IPerson {
    public name: string;
    public age: number;
    public constructor(name: string, age: number) {
      this.name = name;
      this.age = age
    }
    public hello(name: string) {
      return 'hello: ' + name;
    }
  }
}

{
  interface IPerson {
    name: string;
  };

  let person: IPerson = {
    name: "webabcd"
  }

  // 通过 instanceof 可以判断一个对象是否属于某个类，但是不能通过 instanceof 判断一个对象是否属于某个接口
  // 因为编译后，所有接口都会被移除，所以不能在运行时判断一个对象是否符合某个接口
  // MyLog.d(`${person instanceof IPerson}`) // 报错 'IPerson' only refers to a type, but is being used as a value here.

  // 可以通过类似如下的方式判断一个对象是否符合某个接口
  let isIPerson = (obj: object): boolean => {
    if (typeof (obj as Partial<IPerson>).name === 'string') {
      return true
    }
    return false
  }
  MyLog.d(`${isIPerson(person)}`) // true
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
