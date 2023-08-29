cmake_minimum_required(VERSION 3.16...3.25)

find_package(CURL REQUIRED)

add_library(file-updater INTERFACE)
add_library(OBS::file-updater ALIAS file-updater)

target_sources(file-updater INTERFACE file-updater/file-updater.c file-updater/file-updater.h)

target_link_libraries(file-updater INTERFACE CURL::libcurl $<$<PLATFORM_ID:Windows>:OBS::w32-pthreads>)

add_library(file-updater STATIC
	${file-updater_SOURCES}
	${file-updater_HEADERS})

target_include_directories(file-updater
	PUBLIC .)

target_link_libraries(file-updater
	${LIBCURL_LIBRARIES}
	${file-updater_PLATFORM_DEPS}
	libobs)
set_target_properties(file-updater PROPERTIES
	FOLDER "deps"
	POSITION_INDEPENDENT_CODE ON)
