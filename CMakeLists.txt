cmake_minimum_required(VERSION 3.25.1)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_BINARY_DIR build)
set(CMAKE_SOURCE_DIR src)

set(NAME ezdwm)
set(VERSION 0.1.0)

project(${NAME} VERSION ${VERSION})

add_definitions(-DVERSION=\"${VERSION}\")
add_definitions(-DXINERAMA)
add_definitions(-D_DEFAULT_SOURCE)

file(GLOB_RECURSE SRC_FILES src/*.cpp)
add_executable(${NAME} ${SRC_FILES})

target_include_directories(${NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(${NAME} PUBLIC /usr/X11R6/include)
target_include_directories(${NAME} PUBLIC /usr/include/freetype2)

target_link_libraries(${NAME} X11 Xft Xinerama fontconfig)

install(
    TARGETS ${NAME} CONFIGURATIONS Release
    RUNTIME
        DESTINATION bin
        PERMISSIONS
            OWNER_READ
            OWNER_WRITE
            OWNER_EXECUTE
            GROUP_READ
            GROUP_EXECUTE
            WORLD_READ
            WORLD_EXECUTE
)
