# This is a copy of <ROBERTOS_PATH>/external/robertos_import.cmake

# This can be dropped into an external project to help locate the OS
# It should be include()ed prior to project()

# This file is based on https://github.com/raspberrypi/pico-sdk/blob/master/external/pico_sdk_import.cmake

if (DEFINED ENV{ROBERTOS_PATH} AND (NOT ROBERTOS_PATH))
    set(ROBERTOS_PATH $ENV{ROBERTOS_PATH})
    message("Using ROBERTOS_PATH from environment ('${ROBERTOS_PATH}')")
endif ()

if (DEFINED ENV{ROBERTOS_FETCH_FROM_GIT} AND (NOT ROBERTOS_FETCH_FROM_GIT))
    set(ROBERTOS_FETCH_FROM_GIT $ENV{ROBERTOS_FETCH_FROM_GIT})
    message("Using ROBERTOS_FETCH_FROM_GIT from environment ('${ROBERTOS_FETCH_FROM_GIT}')")
endif ()

if (DEFINED ENV{ROBERTOS_FETCH_FROM_GIT_PATH} AND (NOT ROBERTOS_FETCH_FROM_GIT_PATH))
    set(ROBERTOS_FETCH_FROM_GIT_PATH $ENV{ROBERTOS_FETCH_FROM_GIT_PATH})
    message("Using ROBERTOS_FETCH_FROM_GIT_PATH from environment ('${ROBERTOS_FETCH_FROM_GIT_PATH}')")
endif ()

set(ROBERTOS_PATH "${ROBERTOS_PATH}" CACHE PATH "Path to the RobertOS")
set(ROBERTOS_FETCH_FROM_GIT "${ROBERTOS_FETCH_FROM_GIT}" CACHE BOOL "Set to ON to fetch copy of SDK from git if not otherwise locatable")
set(ROBERTOS_FETCH_FROM_GIT_PATH "${ROBERTOS_FETCH_FROM_GIT_PATH}" CACHE FILEPATH "location to download SDK")

if (NOT ROBERTOS_PATH)
    if (ROBERTOS_FETCH_FROM_GIT)
        include(FetchContent)
        set(FETCHCONTENT_BASE_DIR_SAVE ${FETCHCONTENT_BASE_DIR})
        if (ROBERTOS_FETCH_FROM_GIT_PATH)
            get_filename_component(FETCHCONTENT_BASE_DIR "${ROBERTOS_FETCH_FROM_GIT_PATH}" REALPATH BASE_DIR "${CMAKE_SOURCE_DIR}")
        endif ()
        # GIT_SUBMODULES_RECURSE was added in 3.17
        if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.17.0")
            FetchContent_Declare(
                    robertos_repo
                    GIT_REPOSITORY https://github.com/YanayGoor/RobertOS
                    GIT_TAG master
                    GIT_SUBMODULES_RECURSE FALSE
            )
        else ()
            FetchContent_Declare(
                    robertos_repo
                    GIT_REPOSITORY https://github.com/YanayGoor/RobertOS
                    GIT_TAG master
            )
        endif ()

        if (NOT robertos_repo)
            message("Downloading RobertOS")
            FetchContent_Populate(robertos_repo)
            set(ROBERTOS_PATH ${robertos_repo_SOURCE_DIR})
        endif ()
        set(FETCHCONTENT_BASE_DIR ${FETCHCONTENT_BASE_DIR_SAVE})
    else ()
        message(FATAL_ERROR
                "SDK location was not specified. Please set ROBERTOS_PATH or set ROBERTOS_FETCH_FROM_GIT to on to fetch from git."
                )
    endif ()
endif ()

get_filename_component(ROBERTOS_PATH "${ROBERTOS_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")
if (NOT EXISTS ${ROBERTOS_PATH})
    message(FATAL_ERROR "Directory '${ROBERTOS_PATH}' not found")
endif ()

set(ROBERTOS_INIT_CMAKE_FILE ${ROBERTOS_PATH}/robertos_init.cmake)
if (NOT EXISTS ${ROBERTOS_INIT_CMAKE_FILE})
    message(FATAL_ERROR "Directory '${ROBERTOS_PATH}' does not appear to contain RobertOS")
endif ()

set(ROBERTOS_PATH ${ROBERTOS_PATH} CACHE PATH "Path to RobertOS" FORCE)

include(${ROBERTOS_INIT_CMAKE_FILE})