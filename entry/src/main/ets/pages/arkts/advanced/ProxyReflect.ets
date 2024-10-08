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


// Proxy - 代理（拦截目标对象的属性操作和函数操作）
{
  class MyTarget {
    public name: string;
    public constructor(name: string) {
      this.name = name;
    }
  }

  class MyProxyHandler implements ProxyHandler<MyTarget> {
    set(target:MyTarget, propertyKey:string, value:string, receiver:MyProxyHandler): boolean { // receiver 就是 Proxy 实例本身
      target.name = `set-${value}`;
      return true; // 对于 handler 的 set() 来说，必须要有 return true
    }
    get(target:MyTarget, propertyKey:string, receiver:MyProxyHandler): string { // receiver 就是 Proxy 实例本身
      return `get-${target.name}`;
    }

    /*
     * 其他的可代理的方法请参见 interface ProxyHandler<T extends object> 接口的说明
     */
  }

  let target = new MyTarget("webabcd");
  let handler = new MyProxyHandler();

  // Proxy - 让 handler 处理 target 的属性和方法
  let proxy = new Proxy(target, handler);
  proxy.name = "wanglei"; // 会走到 handler 的 set()
  let name = proxy.name; // 会走到 handler 的 get()
  MyLog.d(`name: ${name}`) // name: get-set-wanglei
}

// Reflect - 反射
{
  class MyTarget {
    public name: string;
    public constructor(name: string) {
      this.name = name;
    }
    public hello(x: string): string {
      return `hello name:${this.name}, x:${x}`;
    }

  }

  let target = new MyTarget("webabcd");

  // Reflect.set() - 设置指定对象的指定属性
  Reflect.set(target, 'name', "wanglei");
  // Reflect.get() - 获取指定对象的指定属性
  MyLog.d(Reflect.get(target, "name")); // wanglei

  /*
   * 其他的方法请参见 Reflect 的相关说明
   */
}
