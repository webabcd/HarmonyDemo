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
  enum Status {Ok, Error};
  // 通过枚举名称获取枚举值
  MyLog.d(`${Status["Ok"]}, ${Status["Error"]}`); // 0, 1
  // 通过枚举值获取枚举名称
  MyLog.d(`${Status[0]}, ${Status[1]}`); // Ok, Error
}

{
  // 简单枚举的赋值
  enum Status {Ok = 100, Error = 200};
  MyLog.d(`${Status["Ok"]}, ${Status["Error"]}`); // 100, 200
  MyLog.d(`${Status[100]}, ${Status[200]}`); // Ok, Error
}

{
  // 定义枚举值时可以使用简单的表达式
  enum Status { Ok = 1, Error = 1 << 2 };
  MyLog.d(`${Status.Ok}, ${Status.Error}`); // 1, 4
}

{
  // 常量枚举
  const enum Status { Ok, Error };
  MyLog.d(`${Status.Ok}, ${Status.Error}`); // 0, 1
}

{
  // 常量枚举的赋值
  const enum Status { Ok = "Ok", Error = "Error" };
  MyLog.d(`${Status.Ok}, ${Status.Error}`); // Ok, Error
}

{
  // 字符串转枚举
  enum Status {Ok, Error};
  let status = Status['Ok'] as Status
  MyLog.d(`${status == Status.Ok}`); // true

  // 枚举转字符串
  MyLog.d(`${Status[status]}`); // Ok

  // 枚举值就是整型值
  MyLog.d(`${status == 0}`); // true
}

{
  enum Permission {
    None = 0,
    Read = 1,     // 0001
    Write = 2,    // 0010
    Publish = 4,  // 0100
    Full = 7,     // 0111
  }

  // 通过按位或（|）实现 flag 型的枚举
  MyLog.d(`${(Permission.Read | Permission.Write)}`); // 3
  MyLog.d(`${(Permission.Read | Permission.Write | Permission.Publish)}`); // 7
  MyLog.d(`${(Permission.Full)}`); // 7

  // 判断 flag 型的枚举是否包含指定的枚举成员
  MyLog.d(`${((Permission.Read | Permission.Write) & Permission.Write) == Permission.Write}`); // true
  MyLog.d(`${(Permission.Full & Permission.Write) == Permission.Write}`); // true
}

{
  enum Status {Ok, Error};
  // 遍历枚举（如下方式会先按照枚举值遍历一遍，再按照枚举名称遍历一遍）
  Object.keys(Status).forEach(key => {
    MyLog.d(`key:${key}, value:${Status[key]}`);
    // key:0, value:Ok
    // key:1, value:Error
    // key:Ok, value:0
    // key:Error, value:1
  });
}