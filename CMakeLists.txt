cmake_minimum_required(VERSION 3.10)

project(Roberto VERSION 0.1.0)

configure_file(config.h.in config.h)

set(SOURCES
    ${SOURCES}
    roberto.c
    drivers/enc28j60/internal.c
    drivers/enc28j60/enc28j60.c
    kernel/sched/context_switch.s
    kernel/sched/sched.c
    kernel/sched/future.c
    kernel/time.c
)

include_directories(include)

set_property(SOURCE kernel/sched/context_switch.s PROPERTY LANGUAGE C)

if(DEFINED ENV{ARCH})
    set(ARCH $ENV{ARCH})
    message("Using ARCH from environment ('${ARCH}')")
else()
    if (NOT ARCH)
        set(ARCH "stm32f4")
        message("No ARCH given - defaulting to '${ARCH}'")
    else()
        message("ARCH is '${ARCH}'")
    endif()
endif()

include("arch/${ARCH}/CMakeLists.txt")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -Wall")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --specs=nosys.specs")

add_compile_definitions(DEBUG_LOOPBACK)

add_executable(Roberto ${SOURCES} ${HEADERS})
