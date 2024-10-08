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