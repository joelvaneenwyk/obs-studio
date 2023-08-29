cmake_minimum_required(VERSION 3.16...3.25)

add_library(libff-util INTERFACE)
add_library(OBS::libff-util ALIAS libff-util)

target_sources(libff-util INTERFACE libff/ff-util.c libff/ff-util.h)
target_include_directories(libff-util INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")

if(OS_WINDOWS)
  set_property(
    SOURCE libff/ff-util.c
    APPEND
    PROPERTY COMPILE_FLAGS -Dinline=__inline)
  include_directories(../w32-pthreads)
  add_definitions(-Dinline=__inline)
endif()

set_target_properties(libff PROPERTIES
  FOLDER "deps"
  POSITION_INDEPENDENT_CODE ON)
