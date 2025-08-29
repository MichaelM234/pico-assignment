cmake_minimum_required(VERSION 3.13)

# Point to the Pico SDK inside your repo
set(PICO_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/pico-sdk")

# Include the SDK
include(pico-sdk/pico_sdk_init.cmake)

project(pico_assignment C CXX ASM)

# Initialize the SDK
pico_sdk_init()

# Add your executable
add_executable(pico_assignment
    main.c
    main.S
)

# Link with standard libraries and ADC
target_link_libraries(pico_assignment
    pico_stdlib
    hardware_adc
)

# Optional: generate UF2 / BIN outputs
pico_add_extra_outputs(pico_assignment)