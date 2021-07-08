cmake_minimum_required(VERSION 3.20)

# set the project name and version
project(Tutorial VERSION 1.0)
configure_file(TutorialConfig.h.in TutorialConfig.h)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# add the executable
add_executable(${PROJECT_NAME} tutorial.cxx)
target_include_directories(${PROJECT_NAME} PUBLIC "${PROJECT_BINARY_DIR}")

# Locate dependencies
find_package(OpenGL REQUIRED)

# Link OpenGL
target_include_directories(${PROJECT_NAME} PRIVATE ${OPENGL_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${OPENGL_LIBRARIES})

target_link_libraries(${PROJECT_NAME} ${WINSDK_LIB}/um/x64/shell32.lib)

include(FetchContent)

# Download SDL2
FetchContent_Declare(
  SDL2
  URL     https://www.libsdl.org/release/SDL2-devel-2.0.14-VC.zip
  URL_MD5 2b521c5ec247955dc342235d06ebd874
)
FetchContent_MakeAvailable(SDL2)

# Find SDL2
set(SDL2_PATH ${sdl2_SOURCE_DIR})
find_package(SDL2 REQUIRED)

# Link SDL2
target_include_directories(${PROJECT_NAME} PRIVATE ${SDL2_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${SDL2_LIBRARIES})

# Copy SDL2 lib files to build directory for runtime.
add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${sdl2_SOURCE_DIR}/lib/x64
        $<TARGET_FILE_DIR:${PROJECT_NAME}>)

# Download SDL2_image
FetchContent_Declare(
  SDL2_image
  URL     https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.5-VC.zip
  URL_MD5 b6c8c85b64e01b7096364036438b3333
)
FetchContent_MakeAvailable(SDL2_image)

# Find SDL2_image
set(SDL2_IMAGE_PATH ${sdl2_image_SOURCE_DIR})
find_package(SDL2_image REQUIRED)

# Link SDL2_image
target_include_directories(${PROJECT_NAME} PRIVATE ${SDL2_IMAGE_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${SDL2_IMAGE_LIBRARIES})

# Copy SDL2_image lib files to build directory for runtime.
add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${sdl2_image_SOURCE_DIR}/lib/x64
        $<TARGET_FILE_DIR:${PROJECT_NAME}>)
