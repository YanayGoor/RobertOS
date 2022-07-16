cmake_minimum_required(VERSION 3.17)

if (NOT ROBERTOS_PATH)
    set(ROBERTOS_PATH ${CMAKE_CURRENT_LIST_DIR})
endif ()

macro(robertos_init_arch)
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

    include("${ROBERTOS_PATH}/arch/${ARCH}/CMakeLists.txt")
endmacro()

macro(robertos_init)
    if (NOT CMAKE_PROJECT_NAME)
        message(WARNING "robertos_init() should be called after the project is created (and languages added)")
    endif()

    configure_file(${ROBERTOS_PATH}/config.h.in ${ROBERTOS_PATH}/config.h)

    set(SOURCES
        ${SOURCES}
        ${ROBERTOS_PATH}/dummy_main/roberto.c
        ${ROBERTOS_PATH}/drivers/enc28j60/internal.c
        ${ROBERTOS_PATH}/drivers/enc28j60/enc28j60.c
        ${ROBERTOS_PATH}/kernel/sched/context_switch.s
        ${ROBERTOS_PATH}/kernel/sched/sched.c
        ${ROBERTOS_PATH}/kernel/sched/future.c
        ${ROBERTOS_PATH}/kernel/time.c
    )

    include_directories(${ROBERTOS_PATH}/include)

    set_property(SOURCE ${ROBERTOS_PATH}/kernel/sched/context_switch.s PROPERTY LANGUAGE C)

    robertos_init_arch()

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -Wall")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --specs=nosys.specs")

    add_library(RobertOS ${SOURCES} ${HEADERS})
endmacro()