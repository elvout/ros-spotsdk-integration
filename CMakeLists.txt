cmake_minimum_required(VERSION 3.16)
project(ros-spotsdk-integration)

# Set up rosbuild
# This must be called prior to including vcpkg, otherwise cmake tries
# to search for ros packages in the vcpkg directories.
# TODO(eyang): Why? And why doesn't rosbuild cause errors when finding
#   the Spot SDK dependency packages?
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)
set(ROS_BUILD_STATIC_LIBS true)
set(ROS_BUILD_SHARED_LIBS false)
rosbuild_init()


# Spot SDK Dependencies
include(/opt/microsoft/vcpkg/scripts/buildsystems/vcpkg.cmake)
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


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)

add_executable(hello_spot
    hello_spot.cpp
)
target_link_libraries(hello_spot bosdyn_client bosdyn_api)
