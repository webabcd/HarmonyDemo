// 导出 default 变量或函数或对象
// 一个模块中只能有一个 export default
export default class MyClass{
  public name: string;
  constructor(name: string) {
    this.name = name;
  }
  hello() {
    return "hello";
  }
}
