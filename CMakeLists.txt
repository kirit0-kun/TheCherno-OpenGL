cmake_minimum_required(VERSION 3.0.0)
project(TheCherno VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

include(CTest)
enable_testing()

set( GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE )
set( GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE )
set( GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE )

set(DEPENDENCIES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies)
set(GLFW_DIR ${DEPENDENCIES_DIR}/glfw)
set(GLEW_DIR ${DEPENDENCIES_DIR}/glew)
set(GLEW_INCLUDE_DIRS ${GLEW_DIR}/include)

add_subdirectory( ${GLFW_DIR} )
add_subdirectory( ${GLEW_DIR}/build/cmake )

find_library(OPENGL_LIBRARY OpenGL REQUIRED)

if (APPLE)
    find_library(COCOA_LIBRARY Cocoa REQUIRED)
    find_library(IOKIT_LIBRARY IOKit REQUIRED)
    find_library(CORE_VIDEO_LIBRARY CoreVideo REQUIRED)
    set(REQUIRED_LIBS ${COCOA_LIBRARY} ${IOKIT_LIBRARY} ${CORE_VIDEO_LIBRARY})
endif (APPLE)

file(GLOB_RECURSE SRC_FILES src/*.cpp)

add_executable(${PROJECT_NAME} main.cpp ${SRC_FILES})

target_link_libraries(${PROJECT_NAME} PUBLIC ${REQUIRED_LIBS} ${OPENGL_LIBRARY} glfw glew_s)

target_include_directories(${PROJECT_NAME} PRIVATE 
                                            ${CMAKE_CURRENT_SOURCE_DIR}/include
                                            ${GLEW_INCLUDE_DIRS} 
                                            )

add_definitions(
    -DTW_STATIC
    -DTW_NO_LIB_PRAGMA
    -DTW_NO_DIRECT3D
    -DGLEW_STATIC
    )

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)