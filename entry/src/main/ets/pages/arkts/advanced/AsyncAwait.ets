import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct AsyncAwaitDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


/**
 * async/await - 用于异步编程（非多线程）
 *   async function 返回的是 Promise 对象
 *   await 用于等 Promise 对象或者 thenable 对象，其只能放在 async function 中
 *   所谓的 thenable 对象，就是定义了 then() 方法的对象
 */

// async function 的说明
// p1() 等价于 p2()
function p1() {
  return Promise.resolve("webabcd");
}
async function p2() { // 对于 async function 来说，会用 Promise.resolve() 来包装返回对象
  return "webabcd";
}
MyLog.d(`${p1()}, ${p2()}`);
// Promise {<resolved>: 'webabcd'} Promise {<resolved>: 'webabcd'}


{
  // await 的说明（只能放在 async function 中）
  let sleep = async (ms: number) => {
    await new Promise<string>((resolve) => {
      setTimeout(resolve, ms);
    });
  }
  let a = async (value: string, ms: number) => {
    await sleep(ms);
    MyLog.d(value);
  }
  let asyncFunction = a("webabcd", 1000);
  MyLog.d(`${asyncFunction}`); // 1 秒钟之后会打印 webabcd
  // 这里打印的是 Promise {<pending>}


  // 如果在非 async function 中，想实现 await 的功能怎么办，可以通过 promise 的 then() 来实现
  let b = async (value: string, ms: number) => {
    await new Promise<string>(r => setTimeout(r, 1000)); // 等 1 秒
    return value; // 对于 async function 来说，会用 Promise.resolve() 来包装返回对象
  }
  let promise = b("wanglei", 1000);
  promise.then(v => MyLog.d(v));
  // 1 秒钟之后会打印 wanglei


  // 如果一个类有 then() 方法，则这个类的实例化对象是 thenable 对象
  // await 除了用于等待 Promise 对象外，也可以用于等待 thenable 对象
  // await 一个 thenable 对象时，实际上等待的是这个对象的 then() 方法
  class Sleep {
    public timeout: number;
    constructor(timeout: number) {
      this.timeout = timeout;
    }
    then(resolve: (value: string) => void, reject?: (value: string) => void) {
      setTimeout(() => resolve("diandian"), this.timeout);
    }
  }
  (async () => {
    MyLog.d(await new Sleep(1000)); // 1 秒钟之后会打印 diandian
  })();


  // 演示如何对 await 做 try/catch
  // 演示当不对 await 做 try/catch 时，出现异常会如何处理
  let c = () => {
    return new Promise<string>((resolve, reject) =>{
      setTimeout(()=>{
        let x = new Date().getTime() % 2;
        if (x == 0) {
          return resolve("fulfilled");
        } else if (x == 1) {
          return reject("rejected");
        }
      },1000);
    });
  };
  (async () => {
    // 对 await 做 try/catch 时
    try {
      // 如果走到 Promise 的 resolve() 则可以正常收到返回数据
      MyLog.d("try: " + await c()); // try: fulfilled
    } catch(e) {
      // 如果走到 Promise 的 reject() 则会捕获到异常
      MyLog.d("catch: " + e); // catch: rejected
    }

    // 不对 await 做 try/catch 时
    // 如果没有异常，则一切正常
    // 如有发生异常，则之后的逻辑不再执行，但是并不会对外抛出异常
    MyLog.d(await c()); // fulfilled
    MyLog.d("xyz"); // xyz
  })();


  // 并发执行多个 Promise
  let i = async () => {
    return Promise.resolve("iii");
  };
  let j = async (ms:number) => {
    return new Promise<string>((resolve) => {
      setTimeout(() => resolve("jjj"), ms);
    });
  };
  let k = async (ms:number) => {
    return new Promise<string>((resolve, reject) => {
      let x = new Date().getTime() % 2;
      if (x == 0) {
        setTimeout(() => resolve("kkk"), ms);
      } else if (x == 1) {
        setTimeout(() => reject("lll"), ms);
      }

    });
  };
  (async () => {
    try {
      // 通过 Promise.all() 并发执行多个 Promise
      let result = await Promise.all([i(), j(1000), k(1000)]);
      MyLog.d(`${result[0]}, ${result[1]}, ${result[2]}`); // iii, jjj, kkk
    } catch (e) {
      // 有一个 Promise 走到了 reject()，这里就会捕获到异常
      MyLog.d(e); // lll
    }
  })();
}