import { myClass, MyClass } from './j';
myClass.name = 'i am k'
// 下面这句会编译时报错，因为 import 进来的变量是只读的，无法修改其本身
// myClass = new MyClass("xxx")

export { myClass }