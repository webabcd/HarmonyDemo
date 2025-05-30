开发文档
https://developer.huawei.com
https://docs.openharmony.cn

第三方库
https://ohpm.openharmony.cn

OpenHarmony 是开源的
HarmonyOS 是鸿蒙操作系统，不开源，他是基于 OpenHarmony 开发的，其支持 Android 的 app 是因为其集成了 AOSP（Android Open Source Project）
HarmonyOS NEXT 是纯血鸿蒙操作系统，完全去掉了 AOSP

ArkTs
ark 是方舟的意思，ts 是 typescript
ArkTs 兼容大部分的 typescript 语法，不支持 var any unknown symbol，不支持匿名类型，不支持解构，不支持 Generator

ohos
ohos 全称是 OpenHarmony Operating System
一个 @kit 包一般会整合好多 @ohos 包
比如 import { router } from '@kit.ArkUI'; 实际导入的是 import router from '@ohos.router';
比如 import { window } from '@kit.ArkUI'; 实际导入的是 import window from '@ohos.window';

.ets 文件
ets 的全称是 extended typescript

.json5 文件
兼容 json 的基础上，引入了新的特性，比如支持注释，支持尾随逗号，允许未加引号的键名等

开发工具 DevEco Studio，其中的 DevEco 是 Development Ecosystem 的缩写
文件结构及说明如下
HarmonyDemo                         // 项目名称
|---AppScope
|   |---resources                   // 应用级的资源
|   |---app.json5                   // 应用级的配置
|---entry                           // 模块名称
|   |---src
|   |   |---main
|   |   |   |---ets                 // 用于保存代码文件
|   |   |   |---resources           // 用于保存资源文件
|   |   |   |---module.json5        // 当前模块的配置
|   |---build-profile.json5         // 当前模块的编译相关的配置
|   |---oh-package.json5            // 当前模块的依赖
|   |---oh-package-lock.json5       // 当前模块的依赖及依赖的版本
|---build-profile.json5             // 应用级的编译相关的配置
|---oh-package.json5                // 应用级的依赖
|---oh-package-lock.json5           // 应用级的依赖及依赖的版本

一个项目由多个模块（module）组成，模块的类型有 HAP（包括 entry 和 feature 两种类型）, HSP, HAR
每个 HAP 可以包含多个 UIAbility，每个 UIAbility 实例都会在最近任务列表中显示为一个对应的任务窗口，每个 UIAbility 可以包含多个页面
每个 HAP 都有一个 AbilityStage 容器，当需要加载 HAP 的入口 UIAbility 实例时，会先创建 AbilityStage 实例

通过 Previewer 可以快速查看 UI 效果，修改代码后不用重新编译即可快速看到修改后的效果，类似 flutter 的 hot reload，但是很多功能都无法使用
通过 Simulator 可以使用较完整的功能，但是它不支持 hot reload

xs（Extra Small） - 水平宽度 0vp - 320vp（左闭右开）
sm（Small） - 水平宽度 320vp - 520vp（左闭右开）
md（Medium） - 水平宽度 520vp - 840vp（左闭右开）
lg（Large） - 水平宽度 840vp - 无限大
xl（Extra Large） - 自定义
xxl（Extra Extra Large） - 自定义

sdpi（Small-scale Dots Per Inch） - dpi 在 0 - 120（左开右闭）
mdpi（Medium-scale Dots Per Inch） - dpi 在 120 - 160（左开右闭）
ldpi（Large-scale Dots Per Inch） - dpi 在 160 - 240（左开右闭）
xldpi（Extra Large-scale Dots Per Inch） - dpi 在 240 - 320（左开右闭）
xxldpi（Extra Extra Large-scale Dots Per Inch） - dpi 在 320 - 480（左开右闭）
xxxldpi（Extra Extra Extra Large-scale Dots Per Inch） - dpi 在 480 - 640（左开右闭）

ArkTS 方舟编程语言
ArkUI 提供 UI 框架，通过 ArkTS 声明式编程。比如 import { router } from '@kit.ArkUI'
Core File Kit 提供文件管理能力。比如 import { fileIo as fs } from '@kit.CoreFileKit'
Network Kit 提供网络相关能力。比如 import { http } from '@kit.NetworkKit'
Background Tasks Kit 提供后台任务能力。比如 import { backgroundTaskManager } from '@kit.BackgroundTasksKit';

hdc（OpenHarmony Device Connector）
是一个用于设备连接和调试的命令行工具，类似于 Android 开发中的 ADB（Android Debug Bridge），其存放于类似如下的地址: DevEco Studio 安装目录/sdk/default/openharmony/toolchains/hdc.exe

ohpm（OpenHarmony Package Manager）
安装指定的依赖 ohpm i @webabcd/harmony-httpserver
安装所有依赖 ohpm i
上面的 i 是 install 的缩写