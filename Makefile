C_compiler ?= gcc
CXX_compiler ?= g++

build_type ?= Release

.SILENT:

all: build/CMakeLists.txt.copy
	$(info Build_type is [${build_type}])
	$(MAKE) --no-print-directory -C build

clean:
	rm -rf build bin lib

build/CMakeLists.txt.copy: CMakeLists.txt Makefile
	mkdir -p build
	cd build && cmake -DCMAKE_BUILD_TYPE=$(build_type) \
		-DCMAKE_TOOLCHAIN_FILE=/opt/microsoft/vcpkg/scripts/buildsystems/vcpkg.cmake \
		-DCMAKE_CXX_COMPILER=$(CXX_compiler) \
		-DCMAKE_C_COMPILER=$(C_compiler) ..
	cp CMakeLists.txt build/CMakeLists.txt.copy
