cmake_minimum_required(VERSION 3.23)
SET(PROJECT_TARGET CellScanner)
project(${PROJECT_TARGET})

FIND_PACKAGE(OpenCV REQUIRED)

SET(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin")
SET(OpenCV_VERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
SET(OpenCV_DLLS
        "opencv_world${OpenCV_VERSION}"
        "opencv_world${OpenCV_VERSION}d"
        "opencv_videoio_msmf${OpenCV_VERSION}_64"
        "opencv_videoio_msmf${OpenCV_VERSION}_64d"
        "opencv_videoio_ffmpeg${OpenCV_VERSION}_64")

add_executable(${PROJECT_TARGET} main.cpp)
TARGET_LINK_LIBRARIES(${PROJECT_TARGET} ${OpenCV_LIBS})

foreach(OpenCV_DLL ${OpenCV_DLLS})
    add_custom_command(TARGET ${PROJECT_TARGET} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${OpenCV_BIN_DIR}/${OpenCV_DLL}.dll" $<TARGET_FILE_DIR:${PROJECT_TARGET}>
        COMMAND_EXPAND_LISTS
    )
endforeach()
