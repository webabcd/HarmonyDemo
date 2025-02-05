https://developer.huawei.com
https://docs.openharmony.cn

ArkTs
ark 是方舟的意思，ts 是 typescript
ArkTs 兼容大部分的 typescript 语法，不支持 var any unknown symbol，不支持匿名类型，不支持解构，不支持 Generator

ohos
ohos 全称是 OpenHarmony Operating System

.ets 文件
ets 的全称是 extended typescript

.json5 文件
兼容 json 的基础上，引入了新的特性，比如支持注释，支持尾随逗号，允许未加引号的键名等

通过 Previewer 可以快速查看 UI 效果，修改代码后不用重新编译即可快速看到修改后的效果，类似 flutter 的 hot reload，但是很多功能都无法使用
通过 Simulator 可以使用较完整的功能，但是它不支持 hot reload

/entry/src/main/resources/base/profile/main_pages.json 文件
定义了 app 中包含的所有的页面路径（页面中的 @Entry 装饰的组件为入口组件），其中的第一条页面路径为 app 的入口

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