import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct RecordPartialDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


// Record - 让对象支持通过 .key 获取 value
{
  interface MyInterface {
    width: number;
    height: number;
  }
  let a: MyInterface = {
    width: 100,
    height: 200,
  };

  // 将 Object 转为 Record
  let b = a as Object as Record<string, number>
  MyLog.d(`${b.width}, ${b.height}, ${b.xxx}`); // 100, 200, undefined

  // 实例化一个 Record 类型的对象
  let c: Record<string, string> = { 'name': 'webabcd' };
  MyLog.d(`${c.name}`); // webabcd
}


// Partial - 实例化时允许只初始化接口的部分属性
{
  interface Person {
    name: string;
    age: number;
  }
  let a: Partial<Person> = {
    // 可以只初始化部分属性，或者所有属性都不初始化
    name: "webabcd",
  };

  MyLog.d(`name:${a.name}, age:${a.age}`); // name:webabcd, age:undefined
  a.age = 44
  MyLog.d(`name:${a.name}, age:${a.age}`); // name:webabcd, age:44
}