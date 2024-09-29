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


{
  // 将指定类型的数据转换为 number 类型
  MyLog.d(`${Number("100")}, ${Number(true)}, ${Number({})}, ${Number([])}`); // 100, 1, NaN, 0

  // 将数字格式化为字符串
  MyLog.d(1234.56789.toString()); // 1234.56789
  MyLog.d((32).toString(16)); // 20
  MyLog.d(1234.56789.toFixed(2)); // 1234.57
  let formatWithCommas = (num: number): string => {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
  MyLog.d(formatWithCommas(123456789)); // 123,456,789

  // 二进制
  MyLog.d(`${0b10}`); // 2
  // 八进制
  MyLog.d(`${0o10}`); // 8
  // 十六进制
  MyLog.d(`${0x10}`); // 16

  // 表示 1 与大于 1 的最小浮点数之间的差（大于 0 的最小浮点数）
  MyLog.d(`${Number.EPSILON}`); // 2.220446049250313e-16
  // 大于 0 的最小数
  MyLog.d(`${Number.MIN_VALUE}`); // 5e-324
  // 最大数
  MyLog.d(`${Number.MAX_VALUE}`); // 1.7976931348623157e+308
  // 精确的最小整数（非科学计数法）
  MyLog.d(`${Number.MIN_SAFE_INTEGER}`); // -9007199254740991
  // 精确的最大整数（非科学计数法）
  MyLog.d(`${Number.MAX_SAFE_INTEGER}`); // 9007199254740991
  // 无限小
  MyLog.d(`${Number.NEGATIVE_INFINITY}`); // -Infinity
  // 无限大
  MyLog.d(`${Number.POSITIVE_INFINITY}`); // Infinity

  // 判断一个数是否是有限的
  MyLog.d(`${Number.isFinite(1)}`); // true
  MyLog.d(`${Number.isFinite(0.1)}`); // true
  MyLog.d(`${Number.isFinite(NaN)}`); // false
  MyLog.d(`${Number.isFinite(Infinity)}`); // false
  MyLog.d(`${Number.isFinite(-Infinity)}`); // false

  // 判断一个数据是否是 NaN（not a number）
  MyLog.d(`${Number.isNaN(NaN)}`); // true
  MyLog.d(`${Number.isNaN(100)}`); // false
  MyLog.d(`${Number.isNaN("abc")}`); // false

  // 字符串转数字
  MyLog.d(`${Number.parseInt("100")}`); // 100
  MyLog.d(`${Number.parseInt("100", 10)}`); // 100
  MyLog.d(`${Number.parseInt("100", 16)}`); // 256
  MyLog.d(`${Number.parseFloat("123.123")}`); // 123.123

  // 判断一个数是否是整数
  MyLog.d(`${Number.isInteger(123)}`); // true
  // 判断一个数是否是精确整数（非科学计数法）
  MyLog.d(`${Number.isSafeInteger(123)}`); // true

  // 取整
  MyLog.d(`${Math.trunc(11.7)}`); // 11
  MyLog.d(`${Math.trunc(-11.7)}`); // -11

  // 向上取整
  MyLog.d(`${Math.ceil(11.7)}`); // 12
  MyLog.d(`${Math.ceil(-11.7)}`); // -11

  // 向下取整
  MyLog.d(`${Math.floor(11.7)}`); // 11
  MyLog.d(`${Math.floor(-11.7)}`); // -12

  // 幂运算符 **
  // 下面的例子用于计算 2 的 10 次方
  MyLog.d(`${2 ** 10}`) // 1024

  // 支持 _ 数字分隔符，以便提高可读性
  let billion = 1_000_000_000; // 十进制
  let hex = 0x123_abc; // 十六进制
  let binary = 0b1010_0001; // 二进制
}