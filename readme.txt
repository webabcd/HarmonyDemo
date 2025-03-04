https://developer.huawei.com
https://docs.openharmony.cn

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
命令行工具，其存放于类似如下的地址 /sdk/12/toolchains/hdc.exe