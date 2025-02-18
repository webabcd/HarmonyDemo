import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct ObjectDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// 通过接口定义 Object
{
  const name = "webabcd";
  const age = 40;
  // 需要通过接口定义 Object
  interface MyInterface {
    name:string;
    age:number;
    hello: (name: string) => string;
  }
  // 定义对象时省略属性名（其属性名默认为变量名称）
  const a: MyInterface = {name, age, hello: (name: string) => {
    return 'hello: '+ name;
  }};
  // 这个等价于上面的写法
  const b: MyInterface = {"name":name, "age":age, hello: (name: string) => {
    return 'hello: '+ name;
  }};
  MyLog.d(`${a.name}, ${a.age}, ${a.hello("www")}`); // webabcd, 40, hello: www
  MyLog.d(`${b.name}, ${b.age}, ${b.hello("www")}`); // webabcd, 40, hello: www
}

// Object 和 object 的区别
{
  // 定义为 Object 类型，则可以赋值为任意基本类型或任意对象（不可以赋值为 null 和 undefined）
  let a: Object = 123;
  // 定义为 object 类型，则可以赋值为任意对象（不可以赋值为基本数据类型，以及 null 和 undefined）
  let b: object = new Date();

  // 注：ArkTS 不支持 typescript 的 any 和 unknown
}

// 关于 bind() 的用法的说明（其用于修改 this 的指向）
{
  interface MyInterface {
    name:string;
    age:number;
    hello: () => string;
    plus: (a: number, b: number) => string;
  }
  class MyClass implements MyInterface {
    public name: string;
    public age: number;
    public constructor(name: string, age: number) {
      this.name = name;
      this.age = age
    }
    public hello() {
      return 'hello: ' + this.name;
    }
    public plus(a: number, b: number) {
      return `${this.name} ${a + b}`
    }
  }

  let a = new MyClass("webabcd", 44)
  let b = new MyClass("wanglei", 44)

  MyLog.d(a.hello()) // hello: webabcd
  MyLog.d(a.plus(1, 2)) // webabcd 3

  // 关于 bind() 的用法的说明
  // hello() 中的 this 指向的是 bind() 的第 1 个参数（bind() 返回的是一个函数，要拿到结果需要再“()”一下）
  MyLog.d(a.hello.bind(b)()) // hello: wanglei
  // bind() 之后为函数传参
  MyLog.d(a.plus.bind(b)(3, 4)) // wanglei 7
}

// 遍历对象的所有属性
{
  class MyClass {
    public name: string;
    public age: number;
    public constructor(name: string, age: number) {
      this.name = name;
      this.age = age
    }
  }

  let a = new MyClass("webabcd", 44)

  Object.keys(a).forEach(key => {
    MyLog.d(`key:${key}, value:${Reflect.get(a, key)}`);
    // key:name, value:webabcd
    // key:age, value:44
  });
}