
# -------------------------------------------- requirement gathering -----------------------------------------------
MACRO(FIND_REQUIREMENTS)

    # find opencv, lines have been added to search under C:
    find_package(OpenCV REQUIRED)
    if (OpenCV_FOUND)
        message(STATUS "OpenCV -- found")
    else ()
        message(FATAL_ERROR "OpenCV -- not found" \n)
    endif()

    # set(CMAKE_PREFIX_PATH "/path2libtorch")
    set(Torch_DIR $ENV{Torch_DIR}/share/cmake/Torch)
    find_package(Torch REQUIRED)
    if (Torch_FOUND)
        message(STATUS "Torch -- found")
    else ()
        message(FATAL_ERROR "Torch -- not found" \n)
    endif()

ENDMACRO()

MACRO(TARGET_INCLUDE_EXPORTS TARGET)
    target_include_directories(${TARGET} PUBLIC ${CMAKE_BINARY_DIR}/exports)
ENDMACRO()

# -------------------------------------------- OpenCV --------------------------------------------------------------

MACRO(TARGET_LINK_OPENCV TARGET)
    # link opencv
    TARGET_LINK_LIBRARIES(${TARGET} ${OpenCV_LIBS})
    target_include_directories(${TARGET} PUBLIC ${OpenCV_INCLUDE_DIRS})
ENDMACRO()

MACRO(TARGET_INSTALL_OPENCV TARGET)
    TARGET_LINK_OPENCV(${TARGET})
    # manually set these dirs and files, because opencv does not give them in the find_package
    SET(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin")
    SET(OpenCV_VERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
    SET(OpenCV_DLLS
            "${OpenCV_BIN_DIR}\\opencv_world${OpenCV_VERSION}.dll"
            "${OpenCV_BIN_DIR}\\opencv_world${OpenCV_VERSION}d.dll"
            "${OpenCV_BIN_DIR}\\opencv_videoio_msmf${OpenCV_VERSION}_64.dll"
            "${OpenCV_BIN_DIR}\\opencv_videoio_msmf${OpenCV_VERSION}_64d.dll"
            "${OpenCV_BIN_DIR}\\opencv_videoio_ffmpeg${OpenCV_VERSION}_64.dll")

    # install opencv dlls next to the executable
    add_custom_command(TARGET ${TARGET}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${OpenCV_DLLS}
            $<TARGET_FILE_DIR:${TARGET}>)
ENDMACRO()

# ----------------------------------------------------- Torch -----------------------------------------------------

MACRO(TARGET_LINK_TORCH TARGET)
    target_link_libraries(${TARGET} ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES} ${CUDA_cudart_static_LIBRARY} ${OpenCV_LIBS})
    target_link_libraries(${TARGET} ${TORCH_LIBRARIES})
    target_include_directories(${TARGET} PUBLIC ${TORCH_INCLUDE_DIRS})
ENDMACRO()

MACRO(TARGET_INSTALL_TORCH TARGET)
    TARGET_LINK_TORCH(${TARGET})

    # install torch dlls next to the executable
    file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
    add_custom_command(TARGET ${TARGET}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${TORCH_DLLS}
            $<TARGET_FILE_DIR:${TARGET}>)
ENDMACRO()

# --------------------------------------------- LibtorchSegmentation ------------------------------------------------

MACRO(TARGET_LINK_LIBTORCH_SEGMENTATION TARGET)
    target_link_libraries(${TARGET} LibtorchSegmentation)
    target_include_directories(${TARGET} PUBLIC ${CMAKE_SOURCE_DIR}\\libs\\LibtorchSegmentation\\src)
ENDMACRO()

MACRO(TARGET_INSTALL_LIBTORCH_SEGMENTATION TARGET)
    TARGET_LINK_LIBTORCH_SEGMENTATION(${TARGET})

    add_custom_command(TARGET ${TARGET}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE_DIR:LibtorchSegmentation>/LibtorchSegmentation.dll
            $<TARGET_FILE_DIR:${TARGET}>)
ENDMACRO()

# --------------------------------------- Requirement installation --------------------------------------------------

MACRO(TARGET_INSTALL_REQUIREMENTS TARGET)
    TARGET_INCLUDE_EXPORTS(${TARGET})
    TARGET_INSTALL_OPENCV(${TARGET})
    TARGET_INSTALL_TORCH(${TARGET})
    TARGET_INSTALL_LIBTORCH_SEGMENTATION(${TARGET})
ENDMACRO()