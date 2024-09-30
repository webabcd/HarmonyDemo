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


// tuple - 元组
{
  let a: [string, number] = ['webabcd', 22];
  a[0] = 'wanglei';
  a[1] = 44;

  MyLog.d(`${a}, ${a[0]}, ${a[1]}`); // ['wanglei', 44] wanglei 44
  MyLog.d(`${a.slice(0)}, ${a.slice(1)}`); // ['wanglei', 44] [44]

  // 通过 push() 可以为元组扩容（注：扩充的数据的数据类型必须符合元组中已有的数据类型）
  a.push(100);
  a.push('abc');
  MyLog.d(`${a}`); // ['wanglei', 44, 100, 'abc']
}