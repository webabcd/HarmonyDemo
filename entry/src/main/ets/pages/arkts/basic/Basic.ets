import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct BasicDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// try/catch/finally 的用法
{
  let f1 = (str: string): string => {
    try {
      let num = Number(str);
      if (isNaN(num)) {
        throw new Error("不是一个数字");
      }
      return "是一个数字";
    } catch (error) {
      return `catch: ${(error as Error).message}`;

      // 注：不对 error 做类型转换，而是直接像下面这样写也是可以的，因为这里 catch 到 error 是 any 类型的（注：虽然 ArkTs 不允许自己定义 any 类型，但是可以使用系统的 any 类型）
      // return `catch: ${error.message}`;
    } finally {
      MyLog.d("finally");
    }
  }

  MyLog.d(f1("100")); // finally 是一个数字
  MyLog.d(f1("abc")); // finally catch: 不是一个数字
}

// ?? 运算符
{
  let value1: string | null = null;
  let value2: string | undefined = undefined;
  let value3: string = 'Hello';

  // ?? 用于在变量为 null 或 undefined 时提供默认值
  const result1 = value1 ?? 'Default';
  const result2 = value2 ?? 'Default';
  const result3 = value3 ?? 'Default';

  MyLog.d(`${result1}, ${result2}, ${result3}`); // Default, Default, Hello
}

// ||=, &&=, ??=
{
  // ||= 仅当左侧操作数为假值时，才将右侧操作数赋值给左侧操作数
  let a = 10;
  a ||= 5; // 10
  let b = 0;
  b ||= 5; // 5

  // &&= 仅当左侧操作数为真值时，才将右侧操作数赋值给左侧操作数
  let c = 10;
  c &&= 5; // 5
  let d = 0;
  d &&= 5; // 0

  // ??= 仅当左侧操作数为 null 或 undefined 时，才将右侧操作数赋值给左侧操作数
  let e: number | null = null;
  e ??= 5; // 5
  let f: number | undefined = undefined;
  f ??= 5; // 5
  let g = 10;
  g ??= 5; // 10

  MyLog.d(`${a}, ${b}, ${c}, ${d}, ${e}, ${f}, ${g}`); // 10, 5, 5, 0, 5, 5, 10
}

// ! ?
{
  class Person {
    public name: string
    constructor(name:string) {
      this.name = name;
    }
  }

  let getPerson = (type: number): Person | undefined | null => {
    if (type == 1) {
      return new Person("webabcd")
    } else if (type == 2) {
      return undefined
    } else {
      return null
    }
  }

  let a = getPerson(1)
  // MyLog.d(`${a.name}`); // 编译时报错
  MyLog.d(`${a?.name}`); // webabcd
  MyLog.d(`${a!.name}`); // webabcd

  let b = getPerson(2)
  // MyLog.d(`${b.name}`); // 编译时报错
  MyLog.d(`${b?.name}`); // undefined
  MyLog.d(`${b?.name || "xxx"}`); // xxx
  // MyLog.d(`${b!.name}`); // 运行时报错

  let c = getPerson(3)
  // MyLog.d(`${c.name}`); // 编译时报错
  MyLog.d(`${c?.name}`); // undefined
  MyLog.d(`${c?.name || "xxx"}`); // xxx
  // MyLog.d(`${c!.name}`); // 运行时报错
}

// 单例模式
{
  class MyClass {
    private static myClass = new MyClass();
    public static getInstance() {
      return MyClass.myClass;
    }
    public n:number = 0
  }

  MyClass.getInstance().n ++;
  MyClass.getInstance().n ++;
  MyClass.getInstance().n ++;
  MyLog.d(`${MyClass.getInstance().n}`) // 3
}