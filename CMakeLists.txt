cmake_minimum_required(VERSION 3.25)

project(empty_cc)
include(CTest)

set(CMAKE_CXX_STANDARD 17)

add_executable(empty_cc
   main.cc
 )
