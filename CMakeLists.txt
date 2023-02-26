cmake_minimum_required(VERSION 3.23)
include(cmake-modules/Macros.cmake)

set(CMAKE_CXX_STANDARD 14)
MESSAGE("${CUDA_PATH}")
set(CUDA_TOOLKIT_ROOT_DIR ${CUDA_PATH})
set(CUDNN_INCLUDE_PATH ${CUDNN_DIR}\\include)
set(CUDNN_LIBRARY_PATH ${CUDNN_DIR}\\lib\\x64\\cudnn.lib)

# set project name
SET(PROJECT_TARGET CellScanner)
project(${PROJECT_TARGET})

FIND_REQUIREMENTS()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")

# create libs
add_subdirectory(libs)

# set up executable
add_executable(${PROJECT_TARGET} main.cpp)

TARGET_INSTALL_REQUIREMENTS(${PROJECT_TARGET})




