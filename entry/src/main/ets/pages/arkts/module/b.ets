let name = "name";
let hello = () => {
  return "hello";
};

// 导出指定的变量或函数或对象（并重命名）
export { name as name_b, hello as hello_b};