FROM ros:noetic-ros-base

# https://github.com/boston-dynamics/spot-cpp-sdk/blob/master/docs/cpp/quickstart.md

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    g++ \
    git \
    libssl-dev \
    pkg-config \
    tar \
    unzip \
    zip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir /opt/microsoft
RUN git clone https://github.com/microsoft/vcpkg /opt/microsoft/vcpkg
WORKDIR /opt/microsoft/vcpkg
RUN git checkout cd7f976e99c2b2ee4c6d2ac55e6e6ed206c4865c
RUN ./bootstrap-vcpkg.sh
RUN ./vcpkg install grpc:x64-linux eigen3:x64-linux CLI11:x64-linux
RUN rm -rf buildtrees downloads packages


RUN mkdir /opt/boston-dynamics
RUN git clone https://github.com/boston-dynamics/spot-cpp-sdk.git /opt/boston-dynamics/spot-cpp-sdk
RUN mkdir /opt/boston-dynamics/spot-cpp-sdk/cpp/build
WORKDIR /opt/boston-dynamics/spot-cpp-sdk/cpp/build
RUN cmake ../ \
    -DCMAKE_TOOLCHAIN_FILE=/opt/microsoft/vcpkg/scripts/buildsystems/vcpkg.cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/boston-dynamics/spot-cpp-sdk \
    -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE \
    -DBUILD_CHOREOGRAPHY_LIBS=OFF
RUN make -j $(nproc) install
WORKDIR /opt/boston-dynamics/spot-cpp-sdk
RUN rm -rf bin build lib/*.a

COPY . /ros-spotsdk-integration
