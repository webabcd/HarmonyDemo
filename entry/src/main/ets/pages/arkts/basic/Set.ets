import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct SetDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// set 是一个集合，先进先出，不会插入重复数据，数据支持类型的多样性
// 常规操作有 add(), delete(), has(), clear(), size 等
{
  let mySet = new Set<number>();
  mySet.add(1);
  mySet.add(2);
  mySet.add(2); // 不会插入重复数据


  // 遍历
  for (let value of mySet) {
    MyLog.d(`${value}`);
  }
  // 遍历
  mySet.forEach((value) => {
    MyLog.d(`${value}`);
  });


  // set 对象转数组
  MyLog.d(`${Array.from(mySet)}`); // [1, 2]


  // 实例化 set 对象时，初始化其数据集合
  MyLog.d(`${new Set(["1", "2", "3"])}`); // {1, 2, 3}


  // string 转 set
  MyLog.d(`${new Set("webabcd")}`); // {"w", "e", "b", "a", "b", "c", "d"}


  // set 可以给数组排重（array 转 set ）
  MyLog.d(`${new Set([3, 1, 2, 3, 2])}`); // {3, 1, 2}
}