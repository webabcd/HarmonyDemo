# 指定构建此项目所需的 CMake 的最低版本为 3.5.0
cmake_minimum_required(VERSION 3.5.0)

# 定义项目名称
project(HarmonyDemo)

# 定义一个变量，并赋值为当前 CMake 文件所在目录
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 添加头文件 .h 目录，用于告诉 cmake 去这里找代码引入的头文件
include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# 生成一个名为 ndk1 的动态链接库（比如 .so 文件），源文件为 napi_init.cpp
# 生成的 .so 文件的名称为 libndk1.so，其要与 libndk1/oh-package.json5 中的 name 一致
add_library(ndk1 SHARED napi_init.cpp)

# 将动态链接库 ndk1 链接到 libace_napi.z.so 库（libace_napi.z.so 是 OpenHarmony 的 NAPI 接口实现）
target_link_libraries(ndk1 PUBLIC libace_napi.z.so)