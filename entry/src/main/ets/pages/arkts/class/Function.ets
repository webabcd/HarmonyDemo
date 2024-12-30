import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct FunctionDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// 定义函数时要指定参数的类型和返回值的类型，无返回值时可以用 void 表示
function f1(x:number, y:number):number {
  return x + y;
}
function f2(x:string, y:string):void {

}
// 返回值的类型也可以推导出来
function f3(x:number, y:number) {
  return x * y
}
// 允许在函数参数列表和调用时使用尾随逗号（这个逗号没有实际意义，只是为了可以方便地添加或删除参数）
function f4(x:number, y:number, ) {

}
f4(1, 2)
f4(1, 2, )


{
  // 不允许在块内使用类似如下的方式直接定义函数（typescript 是支持的）
  // function f0(name:string):string { return name; }

  // 可以在块内定义箭头函数
  let f1: (name: string) => string = (name: string): string => {
    return name;
  };
  // 可以在块内定义箭头函数（具体的函数类型不必声明，可以自动推导出来）
  let f2 = (name: string): string => {
    return name;
  };
  MyLog.d(f1("webabcd")); // webabcd
  MyLog.d(f2("webabcd")); // webabcd
}

{
  // 参数默认值
  let a = (p1: string, p2: string = "webabcd"): string => {
    return `${p1} ${p2}`;
  }
  MyLog.d(`${a("hello", "wanglei")}, ${a("hello")}`);
  // hello wanglei, hello webabcd


  // 可选参数
  let b = (p1: string, p2?: string): string => {
    return `${p1} ${p2}`;
  }
  MyLog.d(`${b("hello", "wanglei")}, ${b("hello")}`);
  // hello wanglei, hello undefined


  // 通过 ... 定义剩余参数，用于接收指定类型的可变数量的参数
  let c = (p1: string, ...values: string[]) => {
    let result = "";
    for (let i = 0; i < values.length; i++) {
      result += values[i];
    }
    return `${p1} ${result}`;
  }
  MyLog.d(`${c("a", "b", "c", "d", "e")}`);
  // a bcde
}

{
  // 箭头函数（lambda 表达式）
  let a = ():string => "hello"; // 无参数，通过一行表达式实现返回值
  let b = (p1:string, p2:string):string => `${p1} ${p2}`; // 多个参数，通过一行表达式实现返回值
  let c = (p1:string, p2:string):string => { // 通过多行表达式实现返回值（加上大括号即可）
    let result = `${p1} ${p2}`;
    return result;
  };
  MyLog.d(`${a()}, ${b("hello", "webabcd")}, ${c("hello", "webabcd")}`);
  // hello, hello webabcd, hello webabcd
}

{
  // 通过函数声明（Function Declaration）的方式定义函数
  // 块外支持，块内不支持（typescript 无论块外还是块内都是支持的）
  // function f1(x: number, y: number): number { return x + y; }

  // 通过函数表达式（Function Expression）的方式定义函数
  let f2 = (x: number, y: number): number => {
    return x + y;
  };

  // 上面的函数 f2 的类型是推导出来的，如果写全的话就像下面这样
  // 这里的 => 不是 es6 中的箭头函数
  // 这里的 => 是用来定义函数类型的，左边是输入类型，需要用括号括起来，右边是输出类型
  let f3: (x: number, y: number) => number = (x: number, y: number): number => {
    return x + y;
  };
}

{
  // 虽然不支持函数重载，但是可以通过如下方式达到函数重载的效果
  let myFunc = (x: number | string): number | string | void => {
    if (typeof x == 'number') {
      return x * 2;
    } else if (typeof x == 'string') {
      return `hello ${x}`;
    } else {
      // void
    }
  }
  MyLog.d(`${myFunc(100)}, ${myFunc("webabcd")}`); // 200, hello webabcd
}

// 函数传参时，通过接口定义参数的形状
{
  interface MyOptions {
    name: string;
    age: number;
    hello: (name: string) => string;
  };

  let f1 = (options:MyOptions): string => {
    MyLog.d(options.hello(options.name)); // hello: webabcd
    return `${options.name} ${options.age}`;
  }
  let result = f1({ name:"webabcd", age:44, hello: (name: string) => {
    return `hello: ${name}`
  }})
  MyLog.d(result); // webabcd 44
}

// 回调函数的示例
{
  type CallbackFunction1 = (n: number) => void
  let f1 = (callback: CallbackFunction1): void => {
    setTimeout(() => {
      callback(100)
    }, 1000)
  }
  f1((n: number): void => {
    MyLog.d(`${n}`) // 100
  })
  // 注：函数作为参数传递时，函数参数的数据类型和函数返回值的数据类型都可以省略
  f1((n) => {
    MyLog.d(`${n}`) // 100
  })

  let f2 = (x: number, callback1: (a: number, b: number) => number, callback2: (a: number, b: number) => number): void => {
    setTimeout(() => {
      let result1 = callback1(x + 2, x + 3)
      let result2 = callback2(x * 2, x * 3)
      MyLog.d(`${result1}, ${result2}`) // 205, 500
    }, 1000)
  }
  f2(100, (a, b) => {
    return a + b
  }, (a, b) => {
    return a + b
  })
}