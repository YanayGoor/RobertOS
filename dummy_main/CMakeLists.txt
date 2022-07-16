cmake_minimum_required(VERSION 3.10)

include(../robertos_init.cmake)

project(Roberto VERSION 0.1.0)

robertos_init()

add_compile_definitions(DEBUG_LOOPBACK)

add_executable(Roberto roberto.c)
target_link_libraries(Roberto RobertOS)
