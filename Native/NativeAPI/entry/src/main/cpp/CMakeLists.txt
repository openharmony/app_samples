# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(XComponent)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${NATIVERENDER_ROOT_PATH}/common
                    )

add_library(chess SHARED chess.cpp)
target_link_libraries(chess PUBLIC hilog_ndk.z.so libace_napi.z.so libc++.a)