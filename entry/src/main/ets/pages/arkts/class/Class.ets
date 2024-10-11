import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct ClassDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


{
  class Person {
    // 注：类的属性和方法支持 3 种访问修饰符，分别是 private, protected, public（默认都是 public 的）

    // 属性（不用初始化），注意此处 ? 的用法
    age?:number;
    // 属性（声明时初始化）
    weight:number = 0;
    // 属性（在构造函数中初始化）
    name:string;
    // 只读属性（在构造函数中初始化）
    readonly id:number;
    // 构造函数
    constructor(name:string, id:number) {
      this.name = name;
      this.id = id;
    }
    // 方法
    hello() {
      return `id:${this.id} name:${this.name}`;
    }

    // 属性的 getter 和 setter
    private _description:string = "";
    get description():string {
      return this._description;
    }
    set description(value:string) {
      this._description = value;
    }

    // 静态属性
    static num = 1314;

    // 静态方法
    static hello(name:string) {
      return `hello: ${name}`
    }

    // 静态块，类似于静态构造函数，只会在类的第一次实例化时执行一次，后续实例化不会再执行
    static {
      MyLog.d("static block");
    }
  }

  let a = new Person('webabcd', 123);
  a.weight = 50;
  MyLog.d(`${a.hello()}, weight:${a.weight}`); // id:123 name:webabcd, weight:50

  MyLog.d(`${a.age}`); // undefined
  // 注意此处 ! 的用法，如果不加 ! 的话会编译报错的
  MyLog.d(`${a.age! * 2}`); // NaN
  a.age = 44;
  MyLog.d(`${a.age * 2}`); // 88

  a.description = "I am wanglei.";
  MyLog.d(`${a.description}`); // I am wanglei.

  MyLog.d(`${Person.num}`); // 1314

  MyLog.d(`${Person.hello("webabcd")}`); // hello: webabcd
}

{
  // 抽象类不允许被实例化
  abstract class Animal {
    public name: string;
    public constructor(name: string) {
      this.name = name;
    }
    // 抽象方法
    public abstract hello():string;
    // 抽象类可以定义有具体逻辑的方法
    public walk():string {
      return `walk: ${this.name}`;
    }
  }

  class Dog extends Animal {
    // 必须要实现父抽象类的抽象方法
    public hello() {
      return `hello: ${this.name}`;
    }
    public run():string {
      return `run: ${this.name}`;
    }
  }

  // 注：一个类只能继承自另一个类，但是可以继承自多个接口
  class BigDog extends Dog {
    // 重写父类的方法
    public run():string {
      return `runrunrun: ${this.name}`;
    }
  }

  let dog:Dog = new Dog("collie");
  MyLog.d(`${dog.hello()}, ${dog.walk()}, ${dog.run()}`); // hello: collie, walk: collie, run: collie

  let bigDog:BigDog = new BigDog("collie");
  MyLog.d(`${bigDog.run()}`); // runrunrun: collie
}

{
  // 接口用于定义对象的形状

  interface Interface1 {
    hello1(): void;
  }
  interface Interface2 {
    hello2(): void;
  }
  // 接口可以继承多个接口
  interface Interface3 extends Interface1, Interface2 {
    hello3(): void;
  }

  // 类可以实现多个接口
  class MyClass implements Interface3 {
    hello1() {
      MyLog.d('hello1');
    }
    hello2() {
      MyLog.d('hello2');
    }
    hello3() {
      MyLog.d('hello3');
    }
  }

  let a = new MyClass();
  a.hello1();
  a.hello2();
  a.hello3();
}

{
  class Animal {
    public name: string;
    constructor(name: string) {
      this.name = name;
    }
  }
  class Dog extends Animal {
    run() {
      MyLog.d("run");
    }
  }

  let f1 = (animal: Animal) => {
    // 通过 instanceof 判断一个基类对象是否是某个子类对象
    if (animal instanceof Dog) {
      // 通过 as 将基类对象转换为子类对象（这里的 as 被称为类型断言 Type Assertions）
      let dog = animal as Dog;
      dog.run();
    }
  }
  f1(new Dog("dog"));
}