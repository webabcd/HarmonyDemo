import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct ObjectDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


{
  const name = "webabcd";
  const age = 40;
  // 需要通过接口定义 Object，但是不能定义方法（typescript 是可以的），如需要的话就通过 class 的方式实现接口
  interface MyInterface {
    name:string;
    age:number;
  }
  const a: MyInterface = {name, age}; // 定义对象时省略属性名（其属性名默认为变量名称）
  const b: MyInterface = {"name":name, "age":age}; // 这个等价于上面的写法
  MyLog.d(`${JSON.stringify(a)}`); // {"name":"webabcd","age":40}
  MyLog.d(`${JSON.stringify(b)}`); // {"name":"webabcd","age":40}
}