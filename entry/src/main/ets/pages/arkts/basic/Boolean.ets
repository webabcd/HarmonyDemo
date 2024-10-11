import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct BooleanDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


{
  let a = true;
  MyLog.d(`${a}`); // true

  // 将指定类型的数据转换为 boolean 类型
  MyLog.d(`${Boolean(100)}, ${Boolean(-100)}, ${Boolean(0)}, ${Boolean("abc")}, ${Boolean("")}, ${Boolean(null)}, ${Boolean(undefined)}`);
  // true, true, false, true, false, false, false

  // 将 boolean 类型的数据转换为 number 类型
  MyLog.d(`${Number(true)}, ${Number(false)}`); // 1, 0

  // 将 boolean 类型的数据转换为 string 类型
  MyLog.d(`${String(true)}, ${String(false)}`); // true, false

  // if 会将 0, "", null, undefined, NaN 隐式地转换为布尔值 false
  if (!0 && !"" && !null && !undefined && !NaN) {
    MyLog.d("if 条件的隐式转换");
  }
}