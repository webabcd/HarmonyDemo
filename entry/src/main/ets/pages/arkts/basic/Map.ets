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


// map 是一个 key/value 集合，先进先出，遇到重复键值则后面的会覆盖前面的，key 和 value 都支持类型的多样性
// 常规操作有 set(), get(), delete(), keys(), values(), has(), clear(), size 等
{
  let myMap: Map<string, string | number> = new Map();


  // 设置和获取
  myMap.set("a", "aaa");
  myMap.set("b", 44); // key 和 value 都支持类型的多样性
  myMap.set("c", "ccc");
  myMap.set("c", "ddd"); // 遇到重复键值则后面的会覆盖前面的
  MyLog.d(`a:${myMap.get("a")}, b:${myMap.get("b")}, c:${myMap.get("c")}, size:${myMap.size}`); // a:aaa, b:100, c:ddd, size:3


  // 遍历 key/value
  for (let keyValue of myMap) {
    MyLog.d(keyValue[0] + ":" + keyValue[1]);
  }
  // 遍历 key/value（map.entries() 会返回一个新的 Iterator 对象，它按插入顺序包含了 map 对象中的 key/value 集合）
  for (let keyValue of myMap.entries()) {
    MyLog.d(keyValue[0] + ":" + keyValue[1]);
  }
  // 遍历 key
  for (let key of myMap.keys()) {
    MyLog.d(key);
  }
  // 遍历 value
  for (let value of myMap.values()) {
    MyLog.d(`${value}`);
  }
  // 遍历 key/value（forEach 方式）
  myMap.forEach((value, key) => {
    MyLog.d(key + ":" + value);
  });


  // 实例化 map 对象时，初始化其 key/value 数据集合
  MyLog.d(`${new Map([["a", "aaa"], ["b", "bbb"], ["c", "ccc"]])}`); // {a => aaa, b => bbb, c => ccc}


  // map 对象转数组
  MyLog.d(`${Array.from(new Map([["a", "aaa"], ["b", "bbb"], ["c", "ccc"]]))}`); // [["a", "aaa"], ["b", "bbb"], ["c", "ccc"], length: 3]


  // 实例化 map 对象时，可以指定数据来源的 map 对象（这个相当于 map 对象的克隆）
  let myMap1 = new Map([["a", "aaa"], ["b", "bbb"], ["c", "ccc"]]);
  let myMap2 = new Map(myMap1);
  MyLog.d(`a:${myMap2.get("a")}, b:${myMap2.get("b")}, c:${myMap2.get("c")}`); // a:aaa, b:bbb, c:ccc
}