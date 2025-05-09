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

    // 属性（不用初始化），注意此处 ? 的用法（age 的类型实际上是 number | undefined）
    age:number|undefined;
    // 属性（不用初始化），注意此处 ? 的用法（age 的类型实际上是 number | undefined）
    age2?:number;
    // 属性（不用初始化），注意此处 ! 的用法
    age3!:number;
    // 属性（声明时初始化）
    weight:number = 0;
    // 属性（在构造函数中初始化）
    name:string;
    // 只读属性（在构造函数中初始化）
    readonly id:number;

    // 构造函数（注：关于构造函数的重载，与函数的重载差不多，请参见 Function.ets 中的相关说明）
    constructor(name:string) // 构造函数的重载签名
    constructor(name:string, id:number) // 构造函数的重载签名
    constructor(name:string, id?:number) { // 构造函数的重载实现
      this.name = name;
      this.id = id ?? -1;
    }

    // 方法（返回类型可以省略）
    hello(): string {
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

  MyLog.d(`${a.age2}`); // undefined
  // 注意此处 ! 的用法，如果不加 ! 的话会编译报错的
  MyLog.d(`${a.age2! * 2}`); // NaN
  a.age2 = 44;
  MyLog.d(`${a.age2 * 2}`); // 88

  MyLog.d(`${a.age3}`); // undefined
  MyLog.d(`${a.age3 * 2}`); // NaN
  a.age3 = 44;
  MyLog.d(`${a.age3 * 2}`); // 88

  a.description = "I am wanglei.";
  MyLog.d(`${a.description}`); // I am wanglei.

  MyLog.d(`${Person.num}`); // 1314

  MyLog.d(`${Person.hello("webabcd")}`); // hello: webabcd
}

{
  class Animal {
    name:string;
    constructor(name:string) {
      this.name = name;
    }
    hello():string {
      return `hello`;
    }
  }
  // 类通过 extends 继承
  class Dog extends Animal {
    constructor(name:string) {
      // 调用父类的构造函数（注：子类如果定义了构造函数，则必须要调用父类的构造函数）
      super("dog name:" + name);
    }
    hello():string {
      // 调用父类的方法
      return `${super.hello()}`;
    }
  }

  let dog:Dog = new Dog("collie");
  MyLog.d(dog.name); // dog name:collie
  MyLog.d(dog.hello()); // hello
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

// 关于普通函数和箭头函数的 this 指向问题（详细参见我在 typescript 项目中的说明）
{
  class Person {
    public name: string
    constructor(name:string) {
      this.name = name
    }

    // 普通函数定义的是原型方法，动态 this（实例化对象后，可以通过 call() 等修改 this 的指向）
    hello() {
      return `hello:${this.name}`;
    }

    // 箭头函数定义的是实例方法，静态 this（实例化对象后，无法通过 call() 等修改 this 的指向）
    hello2 = () => {
      return `hello:${this.name}`;
    }
  }

  let a = new Person('webabcd');
  MyLog.d(a.hello()); // hello:webabcd
  MyLog.d(a.hello2()); // hello:webabcd
}

// 关于 ? 与 ! 的用法
{
  class Person {
    public name: string
    constructor(name:string) {
      this.name = name
    }
    hello() {
      return `hello:${this.name}`;
    }
    static create(name:string | undefined) {
      if (name == undefined) {
        return undefined;
      }
      return new Person(name);
    }
  }

  let a = Person.create('webabcd');
  let b = Person.create(undefined);

  // 编译时报错
  // MyLog.d(`${a.hello()}`);

  MyLog.d(`${a?.hello()}`); // hello:webabcd

  MyLog.d(`${a!.hello()}`); // hello:webabcd

  // 编译时报错
  // MyLog.d(`${b.hello()}`);

  MyLog.d(`${b?.hello()}`); // undefined

  // 运行时报错
  // MyLog.d(`${b!.hello()}`);
}

// 关于 ?.() 的用法
{
  interface Person {
    name: string;
    hello?: () => string;
  }
  const person1: Person = {
    name: "webabcd",
    hello() {
      return `hello: ${this.name}`;
    }
  }
  const person2: Person = {
    name: "wanglei",
  };

  // 编译时报错
  // MyLog.d(`${person1.hello()}`)
  // MyLog.d(`${person2.hello()}`)

  MyLog.d(`${person1.hello?.()}`) // hello: webabcd
  MyLog.d(`${person2.hello?.()}`) // undefined
}