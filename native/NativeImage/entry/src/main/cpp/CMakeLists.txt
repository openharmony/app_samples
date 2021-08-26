# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(nativeimage)

add_library(nativeimage SHARED nativeimage.cpp)
target_link_libraries(nativeimage libimage_pixelmap.z.so)