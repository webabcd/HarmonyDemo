// .d.ts 是类型声明文件，用于帮助 TypeScript 编译器理解 .so 中导出的函数和变量（此文件的路径是在 oh-package.json5 中的 types 标签配置的）
// 以本例来说，此处的 add 函数要与 napi_init.cpp 中的导出内容一致
export const add: (a: number, b: number) => number;