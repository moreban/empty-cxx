cmake_minimum_required(VERSION 3.25)

project(empty_cc)
include(CTest)

option(BUILD_DOCUMENTATION "configure it for buildng documentation" OFF)

set(CMAKE_CXX_STANDARD 17)

add_executable(empty_cc
   main.cc
 )

if(BUILD_DOCUMENTATION)
  add_subdirectory(docs/)
  attach_doxygen_to(empty_cc)
  endif()
