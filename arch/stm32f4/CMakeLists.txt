cmake_minimum_required(VERSION 3.10)

set(SOURCES
    ${SOURCES}
    ${CMAKE_CURRENT_LIST_DIR}/boot/startup_stm32f4xx.s
    ${CMAKE_CURRENT_LIST_DIR}/boot/system_stm32f4xx.c
    ${CMAKE_CURRENT_LIST_DIR}/spi/spi.c
    ${CMAKE_CURRENT_LIST_DIR}/gpio/gpio.c
)

include_directories(include)

set_property(SOURCE ${CMAKE_CURRENT_LIST_DIR}/boot/startup_stm32f4xx.s PROPERTY LANGUAGE C)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -T${CMAKE_CURRENT_LIST_DIR}/boot/stm32_flash.ld")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=hard -mfpu=fpv4-sp-d16")

add_compile_definitions(HSE_VALUE=8000000 PLL_M=8)