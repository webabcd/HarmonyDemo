/*
 * NDK - Native Development Kit
 * ABI - Application Binary Interface
 * NAPI - Node API（用于提供 ArkTS 与 c/c++ 之间的交互能力）
 *
 * 源码方式引用本地的 ndk 模块时，需要在 oh-package.json5 中做类似如下的配置
 * {
 *   "dependencies": {
 *     "libndk1.so": "file:./src/main/cpp/types/libndk1"
 *   }
 * }
 *
 * 编译 ndk 项目需要在 build-profile 中做类似如下的配置
 * {
 *   "buildOption": {
 *     "externalNativeOptions": {
 *       "path": "./src/main/cpp/CMakeLists.txt", // cmake 文件地址
 *       "abiFilters": ["arm64-v8a", "x86_64"], // 指定编译架构
 *     }
 *   },
 * }
 */

// 导入 .so
import testNapi from 'libndk1.so';
import { TitleBar } from './TitleBar';

@Entry
@Component
struct NdkDemo {
  @State message: string = 'hello ndk';

  build() {
    Column({space:10}) {
      TitleBar()

      Text(this.message)

      Button("使用 .so 计算 2 + 3").onClick(() => {
        this.message = `2 + 3 = ${testNapi.add(2, 3)}`
      })
    }
  }
}
