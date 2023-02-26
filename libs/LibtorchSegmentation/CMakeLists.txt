cmake_minimum_required(VERSION 3.10)
include(../../cmake-modules/Macros.cmake)
include(GenerateExportHeader)

project(LibtorchSegmentation)
set(CMAKE_CXX_STANDARD 14)

FILE(GLOB ALL_SOURCES "*.cpp" "./src/*.cpp"  "./src/architectures/*.cpp"  "./src/backbones/*.cpp"  "./src/utils/*.cpp" )
add_library(LibtorchSegmentation SHARED ${ALL_SOURCES})

generate_export_header(LibtorchSegmentation EXPORT_FILE_NAME ${CMAKE_BINARY_DIR}/exports/LibtorchSegmentation_export.h)

TARGET_INCLUDE_EXPORTS(LibtorchSegmentation)
TARGET_LINK_OPENCV(LibtorchSegmentation)
TARGET_LINK_TORCH(LibtorchSegmentation)
