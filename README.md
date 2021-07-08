# Cross-compile C++ for Windows from WSL2 using Clang/LLVM

A working example of a C++ project compiling for Windows from Ubuntu on WSL using Clang/LLVM.

## Requirements
-   [Make](https://www.gnu.org/software/make/)
-   [Docker](https://docs.docker.com/get-docker/)
-   ~~[Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)~~
    -   ~~[Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019)~~
        -   ~~Install **Desktop development with C++** (ID: Microsoft.VisualStudio.Workload.VCTools)~~
    -   ~~[Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)~~
        -   ~~[Ubuntu on WSL](https://ubuntu.com/wsl)~~
            -   ~~[LLVM for Ubuntu](https://apt.llvm.org/)~~
            -   ~~[CMake for Ubuntu](https://apt.kitware.com/)~~

## Notes

-   This example CMake C++ project is taken from [**Step 1 of the CMake Tutorial**](https://cmake.org/cmake/help/latest/guide/tutorial/index.html#a-basic-starting-point-step-1).
-   The `clang_windows_cross.cmake` toolchain file was taken from a [**gist by HilmJulien**](https://gist.github.com/HiImJulien/3eb47d7d874fe5483810bd77940e74c0), whom based it on [`WinMsvc.cmake`](https://github.com/llvm/llvm-project/blob/llvmorg-12.0.0/llvm/cmake/platforms/WinMsvc.cmake) toolchain file provided by LLVM.
-   The version of your MSVC or Windows 10 SDK may differ depending on when you installed the [**Build Tools for Visual Studio 2019**](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019).

    To figure out what version you have installed check the following directories.
    ```shell
    $ make shell

    root@b69d7b2d42ef:/usr/bin# ls /opt/msvc/VC/Tools/MSVC
    14.29.30037

    root@b69d7b2d42ef:/usr/bin# ls /opt/msvc/Program\ Files/Windows\ Kits/10/Include
    10.0.19041.0
    ```
    Update the variables in `clang_windows_cross.cmake` appropriately.

## Getting Started

1.  Clone this repository.

2.  Run `make` (has to be ran 3 times for CMake to pick up the dependencies).
    ```shell
    $ make
    docker build --tag windows-cpp-build-tools .
    [+] Building 0.1s (14/14) FINISHED                                                                                       
    => [internal] load build definition from Dockerfile                                                                0.0s
    => => transferring dockerfile: 38B                                                                                 0.0s
    => [internal] load .dockerignore                                                                                   0.0s
    => => transferring context: 2B                                                                                     0.0s
    => [internal] load metadata for docker.io/library/ubuntu:20.04@sha256:aba80b77e27148d99c034a987e7da3a287ed4553903  0.0s
    => https://raw.githubusercontent.com/mstorsjo/msvc-wine/84a46610378ef6118e60fc5d53a161f12e8d1b76/vsdownload.py     0.0s
    => [windows-cpp-build-tools 1/5] FROM docker.io/library/ubuntu:20.04@sha256:aba80b77e27148d99c034a987e7da3a287ed4  0.0s
    => CACHED [windows-cpp-build-tools 2/5] RUN apt-get update && apt-get install --yes --no-install-recommends pytho  0.0s
    => CACHED [windows-cpp-build-tools 3/5] WORKDIR /opt/msvc                                                          0.0s
    => CACHED [windows-cpp-build-tools 4/5] ADD https://raw.githubusercontent.com/mstorsjo/msvc-wine/84a46610378ef611  0.0s
    => CACHED [windows-cpp-build-tools 5/5] RUN PYTHONUNBUFFERED=1 python vsdownload.py --accept-license --only-unpac  0.0s
    => CACHED [cmake-llvm 2/5] COPY --from=windows-cpp-build-tools /opt/msvc /opt/msvc                                 0.0s
    => CACHED [cmake-llvm 3/5] RUN apt-get update && apt-get install --no-install-recommends --yes wget=1.20.3-1ubunt  0.0s
    => CACHED [cmake-llvm 4/5] RUN ln -s /usr/lib/llvm-12/bin/clang /usr/bin/clang-cl-12                               0.0s
    => CACHED [cmake-llvm 5/5] RUN mv /opt/msvc/Program Files/Windows Kits/10/Lib/10.0.19041.0/um/x64/kernel32.Lib /o  0.0s
    => exporting to image                                                                                              0.0s
    => => exporting layers                                                                                             0.0s
    => => writing image sha256:eeb938cf86b2cf7e80297eb42746f7672a0059996db9ff1f5b9733347f360a21                        0.0s
    => => naming to docker.io/library/windows-cpp-build-tools                                                          0.0s
    docker run --interactive --rm --tty --volume `pwd`:/usr/src --workdir /usr/src windows-cpp-build-tools make build
    mkdir -p Step1_build 
    wget -q -O - https://www.oxpal.com/downloads/uv-checker/checker-map_tho.png > Step1_build/hello_world.png
    cd Step1_build; cmake -Wno-dev -DCMAKE_MODULE_PATH=../cmake/sdl2 -DCMAKE_TOOLCHAIN_FILE=../clang_windows_cross.cmake ../Step1
    -- The C compiler identification is Clang 12.0.1 with MSVC-like command-line
    -- The CXX compiler identification is Clang 12.0.1 with MSVC-like command-line
    -- Detecting C compiler ABI info
    -- Detecting C compiler ABI info - done
    -- Check for working C compiler: /usr/bin/clang-cl-12 - skipped
    -- Detecting C compile features
    -- Detecting C compile features - done
    -- Detecting CXX compiler ABI info
    -- Detecting CXX compiler ABI info - done
    -- Check for working CXX compiler: /usr/bin/clang-cl-12 - skipped
    -- Detecting CXX compile features
    -- Detecting CXX compile features - done
    -- Found OpenGL: opengl32   
    -- Found SDL2: /usr/src/Step1_build/_deps/sdl2-src/lib/x64/SDL2.lib (found version "2.0.14") 
    -- Found SDL2main: /usr/src/Step1_build/_deps/sdl2-src/lib/x64/SDL2main.lib (found version "2.0.14") 
    -- Found SDL2_image: /usr/src/Step1_build/_deps/sdl2_image-src/lib/x64/SDL2_image.lib (found version "2.0.5") 
    -- Configuring done
    -- Generating done
    -- Build files have been written to: /usr/src/Step1_build
    cd Step1_build; cmake --build .
    make[1]: Entering directory '/usr/src/Step1_build'
    make[2]: Entering directory '/usr/src/Step1_build'
    make[3]: Entering directory '/usr/src/Step1_build'
    Scanning dependencies of target Tutorial
    make[3]: Leaving directory '/usr/src/Step1_build'
    make[3]: Entering directory '/usr/src/Step1_build'
    [ 50%] Building CXX object CMakeFiles/Tutorial.dir/tutorial.cxx.obj
    [100%] Linking CXX executable Tutorial.exe
    make[3]: Leaving directory '/usr/src/Step1_build'
    [100%] Built target Tutorial
    make[2]: Leaving directory '/usr/src/Step1_build'
    make[1]: Leaving directory '/usr/src/Step1_build'
    ```

3.  Run the resulting `Tutorial.exe` executable in the `Step1_build` directory from Windows.
    ![image](https://user-images.githubusercontent.com/1833542/125002789-9dd4ba80-e04d-11eb-8f56-ea92b1531158.png)
