import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct EnumDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


{
  // 简单枚举
  enum Status {ok, error};
  MyLog.d(`${Status["ok"]}, ${Status["error"]}`); // 0, 1
  MyLog.d(`${Status[0]}, ${Status[1]}`); // ok, error
}

{
  // 简单枚举的赋值
  enum Status {ok = 100, error = 200};
  MyLog.d(`${Status["ok"]}, ${Status["error"]}`); // 100, 200
  MyLog.d(`${Status[100]}, ${Status[200]}`); // ok, error
}

{
  // 定义枚举值时可以使用简单的表达式
  enum Status { ok = 1, error = 1 << 2 };
  MyLog.d(`${Status.ok}, ${Status.error}`); // 1, 4
}

{
  // 常量枚举
  const enum Status { ok, error };
  MyLog.d(`${Status.ok}, ${Status.error}`); // 0, 1
}

{
  // 常量枚举的赋值
  const enum Status { ok = "ok", error = "error" };
  MyLog.d(`${Status.ok}, ${Status.error}`); // ok, error
}