/*
 *
 */

import { TitleBar } from '../TitleBar';

class Data {
  code: number;

  constructor(code: number) {
    this.code = code;
  }
}
// 创建新实例并使用给定对象初始化
let para: Record<string, number> = { 'PropA': 47 };
let storage: LocalStorage = new LocalStorage(para);
storage.setOrCreate('PropB', new Data(50));

// 使LocalStorage可从@Component组件访问
@Entry(storage)
@Component
struct LocalStorageDemo {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
  @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') parentLinkObject: Data = new Data(0);

  build() {
    Column({ space: 10 }) {
      TitleBar()
      Button(`Parent from LocalStorage ${this.parentLinkNumber}`) // 由于LocalStorage中PropA已经被初始化，因此this.parentLinkNumber的值为47
        .onClick(() => {
          this.parentLinkNumber += 1;
        })

      Button(`Parent from LocalStorage ${this.parentLinkObject.code}`) // 由于LocalStorage中PropB已经被初始化，因此this.parentLinkObject.code的值为50
        .onClick(() => {
          this.parentLinkObject.code += 1;
        })
      // @Component子组件自动获得对Parent LocalStorage实例的访问权限。
      Child()
    }
  }
}

@Component
struct Child {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
  @LocalStorageLink('PropA') childLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') childLinkObject: Data = new Data(0);

  build() {
    Column({ space: 15 }) {
      Button(`Child from LocalStorage ${this.childLinkNumber}`) // 更改将同步至LocalStorage中的'PropA'以及Parent.parentLinkNumber
        .onClick(() => {
          this.childLinkNumber += 1;
        })

      Button(`Child from LocalStorage ${this.childLinkObject.code}`) // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
        .onClick(() => {
          this.childLinkObject.code += 1;
        })
    }
  }
}