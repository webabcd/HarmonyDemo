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
  let a = "\x7A"; // 十六进制的 “7A” 是字符 “z”
  let b = "\u{7A}"; // 十六进制的 “7A” 是字符 “z”
  let c = "\u{738B}"; // UTF-8 (Unicode) 中 /u4e00-/u9fa5 是中文，\u738B 代表的是汉字 “王”
  let d = "王".charCodeAt(0).toString(16); // 将指定的字符转换为 UTF-8 (Unicode) 编码
  MyLog.d(`${a} ${b} ${c} ${d}`); // z z 王 738b


  // 将其他类型的数据转换为字符串
  MyLog.d(`${String(123)}, ${String(true)}`); // 123 true


  // 可以通过 '' 或 "" 或 `` 定义字符串
  MyLog.d('"""'); // """
  MyLog.d("'''",); // '''
  MyLog.d(`'''"""`); // '''"""


  // includes() - 是否包含指定的字符串
  // startsWith() - 是否以指定的字符串开头, 第 2 个参数是可选的用于指定开始查找的位置
  // endsWith() - 是否以指定的字符串结尾, 第 2 个参数是可选的用于指定结束查找的位置
  let e = "abc,ijk,xyz";
  MyLog.d(`${e.includes("ijk")} ${e.startsWith("abc")} ${e.startsWith("ijk", 4)} ${e.endsWith("xyz")} ${e.endsWith("ijk", 7)}`);
  // true true true true true


  // padStart() - 指定字符串的最小长度，以及当长度不够时左侧需要补全的字符串
  MyLog.d("abc".padStart(10, "x")) // xxxxxxxabc
  // padEnd() - 指定字符串的最小长度，以及当长度不够时右侧需要补全的字符串
  MyLog.d("abc".padEnd(10, "x")) // abcxxxxxxx


  // trimStart() - 去除字符串左侧的空白字符
  MyLog.d('  hello world  '.trimStart()); // "hello world  "
  // trimEnd() - 去除字符串右侧的空白字符
  MyLog.d('  hello world  '.trimEnd()); // "  hello world"
  // trim() - 去除字符串两侧的空白字符
  MyLog.d('  hello world  '.trim()); // "hello world"


  const str = 'aaabbbccc';
  // replace() - 替换第一个匹配的字符串
  MyLog.d(str.replace("b", "z")); // aaazbbccc
  // replaceAll() - 替换所有匹配的字符串，而不仅仅是第一个匹配的字符串
  MyLog.d(str.replaceAll("b", "z")); // aaazzzccc


  // repeat() - 让字符串重复指定的次数
  let f = "webabcd,";
  MyLog.d(`${f.repeat(3)}`); // webabcd,webabcd,webabcd,


  // `` 这玩意叫模板字符串（template string），可以在 ${} 中执行表达式或函数或变量等
  let g = "webabcd"
  MyLog.d(`hello: ${g}, ${g.length}`); // hello: webabcd, 7

  // 可以通过 template string 定义多行文本
  let h = `123
 456 " ' \` \\n`;
  MyLog.d(`${h}`);
  // 123
  //  456 " ' ` \n


  // 标签模板（tagged template），就是自定义的模板字符串
  // 本例中 strings 的值为 ["key1: ", ", key2: ", ""]
  // 本例中 values 的值为["value1", "value2"]
  let i = (strings: TemplateStringsArray, ...values: string[]) => {
    let result = "";
    for (let i = 0; i < strings.length; i++) {
      result += strings[i];
      if (i < values.length) {
        result += values[i];
      }
    }
    return result;
  }
  MyLog.d(i`key1: ${"value1"}, key2: ${"value2"}`); // key1: value1, key2: value2
}