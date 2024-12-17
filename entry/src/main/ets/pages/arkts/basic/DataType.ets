import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct DataTypeDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// let 声明的变量是块作用域，仅块内可用，声明必须初始化
{
  let a = 10;
  MyLog.d(`${a}`); // 10
}

// const 常量，块作用域，一旦声明必须初始化，之后不允许修改
{
  const b = 10;
  MyLog.d(`${b}`); // 10
}

{
  // 基本数据类型 boolean, number, string
  let a: boolean = true;
  let b: number = 10;
  let c: string = "abc";

  // 对象数据类型，即通过 new 出来的对象
  let e: Date = new Date();
  // 定义为 object 类型，则可以赋值为任意对象（注：ArkTS 不支持 typescript 的 any）
  let f: object = new Date();
}

{
  // 在 undefined 和 null 做比较时，== 会做类型转换，=== 不会做类型转换
  MyLog.d(`${undefined == null}, ${undefined === null}`); // true, false
  MyLog.d(`${typeof null == 'object'}, ${typeof undefined == 'undefined'}`); // true, true
  MyLog.d(`${Number(null)}, ${Number(undefined)}`); // 0, NaN
  MyLog.d(`${Boolean(null)}, ${Boolean(undefined)}`); // false, false
}

{
  // 定义变量的时候如果没有指定数据类型，但是赋值了，则 ArkTS 会自动推导出变量的数据类型
  let a = 10;
  MyLog.d(`${typeof a}`); // number

  let b = new Date()

  // 通过 typeof 判断数据类型，可以判断基本类型
  MyLog.d(`${typeof a == 'number'}`); // true

  // 通过 typeof 判断数据类型，如果是对象类型，则获取到的一律是 object，无法获取到具体的对象类型
  MyLog.d(`${typeof b == 'object'}`); // true

  // 通过 typeof 也可以判断是否是 function
  MyLog.d(`${typeof b.getDate == 'function'}`); // true

  // 如果是对象类型，则需要通过 instanceof 判断具体的对象类型
  MyLog.d(`${b instanceof Date}`); // true
}

{
  // 联合类型，可以定义变量为多个数据类型中的一个
  let a: number | string;
  a = 10;
  MyLog.d(typeof a); // number
  a = "abc";
  MyLog.d(typeof a); // string

  // 函数的参数和返回值之类的都可以使用联合类型
  let fun1 = (x: number | string): number | string | void => {
    if (typeof x == 'number') {
      return x * 2;
    } else if (typeof x == 'string') {
      return `hello ${x}`;
    } else {
      // void
    }
  }
  MyLog.d(`${fun1(100)}, ${fun1("webabcd")}`); // 200, hello webabcd

  let b: number | undefined;
  if (Math.random() > 0.5) {
    b = 10;
  } else {
    b = undefined
  }
  // 注：如果运行时才能确定变量的具体类型，且函数参数的支持类型并不能覆盖变量的所有可能的类型时，则调用函数时必须要先判断传入变量的类型，否则会编译时报错
  if (typeof b == 'number') {
    MyLog.d(`${fun1(b)}`); // 20
  }
}

{
  // 注：请注意区分类似如下的情况
  // 比如 new Number() 和 Number(), 前者是是一个类的构造函数用于实例化对象，后者是全局函数返回的是一个基本类型
  let a = new Number("10");
  let b = Number("10");
  MyLog.d(`${typeof a}, ${typeof b}`); // object, number
}

{
  // 通过 interface 声明一个自定义的数据类型
  interface MyInterface {
    key: string;
    value: string;
  }
  let a: MyInterface = {key: "key", value: "value"};
  MyLog.d(`${a.key}, ${a.value}`); // key, value
}

{
  // 支持隐式转换
  let a: number = 100;
  let b = a + "abc" // 100abc
  MyLog.d(b);

  // if 会将 0, "", null, undefined, NaN 隐式地转换为布尔值 false
  if (!0 && !"" && !null && !undefined && !NaN) {
    MyLog.d("if 条件的隐式转换");
  }
}

{
  // 通过 type 指定类型别名
  type Name = string;
  type NameMethod = () => string;
  type NameOrMethod = Name | NameMethod;
  let f1 = (p: NameOrMethod): Name => {
    if (typeof p == 'string') {
      return p;
    } else if (typeof p == 'function') {
      return p();
    }
    return "不可能";
  }

  MyLog.d(f1("webabcd")); // webabcd
  MyLog.d(f1(() => "webabcd")); // webabcd
}

{
  class Animal {
    public name: string;
    constructor(name: string) {
      this.name = name;
    }
  }
  class Dog extends Animal {
    hello() {
      MyLog.d("hello dog");
    }
  }

  let f1 = (animal: Animal) => {
    // 通过 instanceof 判断一个基类对象是否是某个子类对象
    if (animal instanceof Dog) {
      // 通过 as 将基类对象转换为子类对象
      let dog = animal as Dog;
      dog.hello(); // hello dog
    }
  }
  f1(new Dog("dog"));
}