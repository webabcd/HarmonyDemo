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
  // 需要通过接口定义 Object，但是不能定义方法（typescript 是可以的），如需要的话就通过 class 的方式实现接口
  interface MyInterface {
    name:string;
    age:number;
  }
  const a: MyInterface = {name, age}; // 定义对象时省略属性名（其属性名默认为变量名称）
  const b: MyInterface = {"name":name, "age":age}; // 这个等价于上面的写法
  MyLog.d(`${JSON.stringify(a)}`); // {"name":"webabcd","age":40}
  MyLog.d(`${JSON.stringify(b)}`); // {"name":"webabcd","age":40}
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