/*
 * NDK - Native Development Kit
 * ABI - Application Binary Interface
 * NAPI - Node API（用于提供 ArkTS 与 c/c++ 之间的交互能力）
 */

// 提供本地开发所需的接口和类型定义
#include "napi/native_api.h"

// 在 c/c++ 中定义一个名为 MyAdd 的函数
static napi_value MyAdd(napi_env env, napi_callback_info info)
{
    // 用于说明 MyAdd 函数的参数的个数为 2 个
    size_t argc = 2;
    // 用于定义一个长度为 2 的 napi_value 数组
    napi_value args[2] = {nullptr};
    // 将 2 个参数保存在 args 数组中
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);

    // 将第 1 个参数转换为 c/c++ 的 double 类型，并将此值保存在 value0 中
    double value0;
    napi_get_value_double(env, args[0], &value0);

    // 将第 2 个参数转换为 c/c++ 的 double 类型，并将此值保存在 value1 中
    double value1;
    napi_get_value_double(env, args[1], &value1);
    
    // 执行 value0 + value1 并将结果保存在 sum 中
    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;

}

// 确保 c++ 代码以 c 链接方式编译，用于解决 c++ 和 c 之间的兼容性问题
EXTERN_C_START
// 注册导出内容
static napi_value Init(napi_env env, napi_value exports)
{
    // 将 c/c++ 的名为的 MyAdd 函数导出为 arkts 的名为 add 的函数
    napi_property_descriptor desc[] = {
        { "add", nullptr, MyAdd, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
    
// 注册当前的 NAPI 模块
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "ndk1",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};
extern "C" __attribute__((constructor)) void RegisterNdk1Module(void)
{
    napi_module_register(&demoModule);
}
