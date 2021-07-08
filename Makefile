export COMPOSE_DOCKER_CLI_BUILD = 1
export DOCKER_BUILDKIT = 1

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
TOOLCHAIN_FILE = clang_windows_cross.cmake
TOOLCHAIN_PATH = $(CURRENT_DIR)/$(TOOLCHAIN_FILE)
CMAKE = cmake
BUILD_SRC = Step1
BUILD_DIR = $(BUILD_SRC)_build
.DEFAULT_GOAL = default

.PHONY: clean-build-dir
clean-build-dir:
	rm -rf $(BUILD_DIR)

.PHONY: build-dir
build-dir:
	mkdir -p $(BUILD_DIR) 

.PHONY: download-png
download-png:
	wget -q -O - https://www.oxpal.com/downloads/uv-checker/checker-map_tho.png > $(BUILD_DIR)/hello_world.png

.PHONY: configure
configure: build-dir download-png
	cd $(BUILD_DIR); $(CMAKE) -Wno-dev -DCMAKE_MODULE_PATH=../cmake/sdl2 -DCMAKE_TOOLCHAIN_FILE=../$(TOOLCHAIN_FILE) ../$(BUILD_SRC)

.PHONY: build
build: build-dir configure
	cd $(BUILD_DIR); $(CMAKE) --build .

.PHONY: image
image:
	docker build --tag windows-cpp-build-tools .

.PHONY: run
run: image
	docker run --interactive --rm --tty --volume `pwd`:/usr/src --workdir /usr/src windows-cpp-build-tools $(COMMAND)

.PHONY: clean
clean: COMMAND = make clean-build-dir
clean: run

.PHONY: shell
shell: COMMAND = bash
shell: run

.PHONY: default
default: COMMAND = make build
default: run
