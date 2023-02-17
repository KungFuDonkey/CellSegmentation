cmake_minimum_required(VERSION 3.23)

# set project name
SET(PROJECT_TARGET CellScanner)
project(${PROJECT_TARGET})

# find opencv, lines have been added to search under C:
find_package(OpenCV REQUIRED)

# manually set these dirs and files, because opencv does not give them in the find_package
SET(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin")
SET(OpenCV_VERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
SET(OpenCV_DLLS
        "opencv_world${OpenCV_VERSION}"
        "opencv_world${OpenCV_VERSION}d"
        "opencv_videoio_msmf${OpenCV_VERSION}_64"
        "opencv_videoio_msmf${OpenCV_VERSION}_64d"
        "opencv_videoio_ffmpeg${OpenCV_VERSION}_64")

# set up executable
add_executable(${PROJECT_TARGET} main.cpp)

# link opencv
TARGET_LINK_LIBRARIES(${PROJECT_TARGET} ${OpenCV_LIBS})

# install opencv dlls next to the executable
foreach(OpenCV_DLL ${OpenCV_DLLS})
    add_custom_command(TARGET ${PROJECT_TARGET} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${OpenCV_BIN_DIR}/${OpenCV_DLL}.dll" $<TARGET_FILE_DIR:${PROJECT_TARGET}>
        COMMAND_EXPAND_LISTS
    )
endforeach()
