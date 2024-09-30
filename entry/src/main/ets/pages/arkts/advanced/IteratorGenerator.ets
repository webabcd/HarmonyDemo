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
  /**
   * iterator - 迭代器（可迭代对象有 Array, TypedArray, Map, Set, String）
   *   next() - 迭代到下一个位置
   *     value - 当前位置的对象
   *     done - 当前位置是否是结尾
   *       true 代表结尾，也就是说，可迭代对象的最后一个元素的 done 仍然为 false，再之后才是 true
   */

  const a = ["a", "b", "c"];
  // [Symbol.iterator]() - 获取可迭代对象的迭代器
  const b = a[Symbol.iterator]();
  MyLog.d(`${b.next()}, ${b.next()}, ${b.next()}, ${b.next()}`);
  // {value: "a", done: false} {value: "b", done: false} {value: "c", done: false} {value: undefined, done: true}


  // 通过 for...of 语句迭代可迭代对象
  let c = ["a", "b", "c"];
  for (let item of c) {
    MyLog.d(item);
  }
  // a
  // b
  // c


  // 用其他方式遍历
  for (let i = 0; i < c.length; i++) { // for 语句
    MyLog.d(c[i]);
  }
  // a
  // b
  // c
  c.forEach(item => { // forEach 语句
    MyLog.d(item);
  });
  // a
  // b
  // c
}

{
  /**
   * Generator - 自定义可迭代对象，即可以支持 iterator 的对象
   *   通过 function* 定义生成器函数（generator function）
   *   每 next() 一下得到的是 generator function 的下一个 yield 的值
   *   yield 的返回值是此 yield 之后再次 next() 传进来的值
   *   如果 next() 后遇到了 return 则迭代结束，返回的 value 是 return 的值，得到的 done 为 true
   */

  // ArkTs 不支持 Generator
}