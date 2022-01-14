cmake_minimum_required(VERSION 3.16)
project(ros-spotsdk-integration)

# Spot SDK Dependencies
find_package(Eigen3 REQUIRED)
find_package(protobuf REQUIRED)
find_package(gRPC REQUIRED)
include_directories(SYSTEM $<TARGET_PROPERTY:gRPC::grpc++,INTERFACE_INCLUDE_DIRECTORIES>)


add_library(bosdyn_api SHARED IMPORTED)
set_target_properties(bosdyn_api PROPERTIES
    IMPORTED_LOCATION "/opt/boston-dynamics/spot-cpp-sdk/lib/libbosdyn_api.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/boston-dynamics/spot-cpp-sdk/include/api/protos"
)

add_library(bosdyn_client SHARED IMPORTED)
set_target_properties(bosdyn_client PROPERTIES
    IMPORTED_LOCATION "/opt/boston-dynamics/spot-cpp-sdk/lib/libbosdyn_client.so"
    INTERFACE_INCLUDE_DIRECTORIES "/opt/boston-dynamics/spot-cpp-sdk/cpp"
)


add_executable(hello_spot
    hello_spot.cpp
)
target_link_libraries(hello_spot bosdyn_client bosdyn_api)
