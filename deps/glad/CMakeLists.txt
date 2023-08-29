cmake_minimum_required(VERSION 3.16...3.25)

find_package(OpenGL REQUIRED)

add_library(obsglad STATIC EXCLUDE_FROM_ALL )
add_library(OBS::glad ALIAS obsglad)

if(OBS_CMAKE_VERSION VERSION_LESS 3.0.0)
  add_library(OBS::obsglad ALIAS obsglad)
endif()

target_sources(obsglad PRIVATE src/glad.c include/glad/glad.h)

target_include_directories(obsglad PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")

add_library(glad SHARED
	${glad_SOURCES}
	${glad_PLATFORM_SOURCES})
set_target_properties(glad PROPERTIES
	FOLDER "deps"
	OUTPUT_NAME obsglad
	VERSION "0"
	SOVERSION "0"
	POSITION_INDEPENDENT_CODE ON)
target_include_directories(glad
	PUBLIC include
	${glad_include_dirs})
target_compile_definitions(glad
	PRIVATE GLAD_GLAPI_EXPORT_BUILD)

if(NOT MSVC)
	target_compile_options(glad
		PRIVATE -DPIC -fvisibility=hidden)
endif()

    target_link_libraries(obsglad PRIVATE OpenGL::EGL)
  endif()
endif()

set_target_properties(obsglad PROPERTIES FOLDER deps POSITION_INDEPENDENT_CODE TRUE)
