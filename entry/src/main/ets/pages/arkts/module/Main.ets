import { TitleBar, MyLog } from '../../TitleBar';

// 从指定的模块中导入指定的被 export 的变量或函数或对象
import { name, hello } from './a';
// 从指定的模块中导入指定的被 export 的变量或函数或对象
import { name_b, hello_b } from './b';
// 从指定的模块中导入指定的被 export 的变量或函数或对象（并重命名）
import { name as name_c, hello as hello_c } from './c';
// 从指定的模块中导入指定的被 export 的变量或函数或对象（并重命名）
import { name as name_d, hello as hello_d } from './d';
// 从指定的模块中导入被 export default 的变量或函数或对象，并为其命名
// 注：对于 export default 导出的对象，在 import 的时候不需要加 {}
import class_e from './e';
// 从指定的模块中导入被 export default 的变量或函数或对象，并为其命名
// 注：对于 export default 导出的对象，在 import 的时候不需要加 {}
import obj_f from './f';
// 从指定的模块中导入指定的被 export 的变量或函数或对象
import { name as name_g, hello as hello_g }  from './g';
// 从指定的模块中导入被 export 的全部内容
import * as obj_h from './h';
// 将 './i' 文件导入并编译
import './i';

// j 中 myClass 对象的 name 属性的值为 i am j
// k 导入了 j 中的 myClass 对象，并将其 name 属性的值修改为 i am k
// l 导入了 j 中的 myClass 对象，并将其 name 属性的值修改为 i am l
// 这里导入 j, k, l 并分别输出 myClass 对象的 name 属性的值，结果都是 i am l
// 所以，当一个变量被多个其他文件导入时，实际上引用的是同一个变量，也就是说，它们共享同一个内存中的实例，而不是为每个导入创建新的副本
import { myClass as j } from './j';
import { myClass as k } from './k';
import { myClass as l } from './l';

// 导入一个命名空间（但是经测试，如果调用它的话会抛出异常，不知道为啥）
import { model } from './n'

@Entry
@Component
struct MainDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}

// 下面这句会编译时报错，因为 import 进来的变量是只读的，无法修改其本身（注：如果导入的是一个对象的话，可以修改对象的属性）
// name = 'xxx';

MyLog.d(`a: ${name} ${hello()}`);
MyLog.d(`b: ${name_b} ${hello_b()}`);
MyLog.d(`c: ${name_c} ${hello_c()}`);
MyLog.d(`d: ${name_d} ${hello_d()}`);
MyLog.d(`e: ${new class_e("name").name} ${new class_e("name").hello()}`);
MyLog.d(`f: ${obj_f.name} ${obj_f.hello()}`);
MyLog.d(`g: ${name_g} ${hello_g()}`);
MyLog.d(`h: ${obj_h.name} ${obj_h.hello()}`);

MyLog.d(`j: ${j.name}`);
MyLog.d(`k: ${k.name}`);
MyLog.d(`l: ${l.name}`);

// 动态 import（注：ESObject 是 any 的别名）
import('./m').then((ns:ESObject) => {
  MyLog.d(`m: ${ns.add(1, 2)}`); // m: 3
})