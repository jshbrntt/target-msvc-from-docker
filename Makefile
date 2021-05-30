MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
TOOLCHAIN_FILE = clang_windows_cross.cmake
TOOLCHAIN_PATH = $(CURRENT_DIR)/$(TOOLCHAIN_FILE)
CMAKE = cmake
BUILD_SRC = Step1
BUILD_DIR = $(BUILD_SRC)_build
.DEFAULT_GOAL = default

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: build-dir
build-dir:
	mkdir -p $(BUILD_DIR) 

.PHONY: configure
configure: build-dir
	cd $(BUILD_DIR); $(CMAKE) -DCMAKE_TOOLCHAIN_FILE=../$(TOOLCHAIN_FILE) ../$(BUILD_SRC)

.PHONY: build
build: build-dir
	cd $(BUILD_DIR); $(CMAKE) --build .

.PHONY: default
default: | configure build
