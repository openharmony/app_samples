cmake_minimum_required(VERSION 3.4.1)
project(kikaInput)
add_library(pinyinime SHARED
            input_service/pinyin_decode_service.cpp
            share/dictbuilder.cpp
            share/dictlist.cpp
            share/dicttrie.cpp
            share/lpicache.cpp
            share/matrixsearch.cpp
            share/mystdlib.cpp
            share/ngram.cpp
            share/pinyinime.cpp
            share/searchutility.cpp
            share/spellingtable.cpp
            share/spellingtrie.cpp
            share/splparser.cpp
            share/userdict.cpp
            share/utf16char.cpp
            share/utf16reader.cpp
            share/sync.cpp)

 include_directories(src/main/cpp/include/)

 add_library(engine
               SHARED
             share/dictbuilder.cpp
             share/dictlist.cpp
             share/dicttrie.cpp
             share/lpicache.cpp
             share/mystdlib.cpp
             share/ngram.cpp
             share/searchutility.cpp
             share/spellingtable.cpp
             share/spellingtrie.cpp
             share/splparser.cpp
             share/utf16char.cpp
             share/utf16reader.cpp)

target_link_libraries(pinyinime engine)
target_link_libraries(pinyinime libace_napi.z.so)
target_link_libraries(pinyinime librawfile.z.so)
target_link_libraries(pinyinime libhilog_ndk.z.so)