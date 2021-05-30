# Cross-compile C++ for Windows from WSL2 using Clang/LLVM

A working example of a C++ project compiling for Windows from Ubuntu on WSL using Clang/LLVM.

## Requirements

-   [Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)
    -   [Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019)
        -   Install **Desktop development with C++** (ID: Microsoft.VisualStudio.Workload.VCTools)
    -   [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
        -   [Ubuntu on WSL](https://ubuntu.com/wsl)
            -   [LLVM for Ubuntu](https://apt.llvm.org/)
            -   [CMake for Ubuntu](https://apt.kitware.com/)

## Notes

-   This example CMake C++ project is taken from [**Step 1 of the CMake Tutorial**](https://cmake.org/cmake/help/latest/guide/tutorial/index.html#a-basic-starting-point-step-1).
-   The `clang_windows_cross.cmake` toolchain file was taken from a [**gist by HilmJulien**](https://gist.github.com/HiImJulien/3eb47d7d874fe5483810bd77940e74c0), whom based it on [`WinMsvc.cmake`](https://github.com/llvm/llvm-project/blob/llvmorg-12.0.0/llvm/cmake/platforms/WinMsvc.cmake) toolchain file provided by LLVM.
-   The version of your MSVC or Windows 10 SDK may differ depending on when you installed the [**Build Tools for Visual Studio 2019**](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019).

    To figure out what version you have installed check the following directories.
    ```shell
    $ ls /mnt/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/BuildTools/VC/Tools/MSVC
    14.29.30037

    $ ls /mnt/c/Program\ Files\ \(x86\)/Windows\ Kits/10/Include/
    10.0.19041.0
    ```
    Update the variables in `clang_windows_cross.cmake` appropriately.
-   After installing LLVM you may find you do not have `clang-cl-12`.
    ```shell
    $ clang-cl-12
    Command 'clang-cl-12' not found
    ```
    If this happens just create a symbolic link to the main `clang` binary.
    ```shell
    sudo ln -s /usr/lib/llvm-12/bin/clang /usr/bin/clang-cl-12
    ```

## Getting Started

1.  Clone this repository.

2.  Run `make`.

    ```shell
    $ make
    mkdir -p Step1_build
    cd Step1_build; cmake -DCMAKE_TOOLCHAIN_FILE=../clang_windows_cross.cmake ../Step1
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
    -- Configuring done
    -- Generating done
    -- Build files have been written to: /home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build
    cd Step1_build; cmake --build .
    make[1]: Entering directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    make[2]: Entering directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    make[3]: Entering directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    Scanning dependencies of target Tutorial
    make[3]: Leaving directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    make[3]: Entering directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    [ 50%] Building CXX object CMakeFiles/Tutorial.dir/tutorial.cxx.obj
    [100%] Linking CXX executable Tutorial.exe
    make[3]: Leaving directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    [100%] Built target Tutorial
    make[2]: Leaving directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    make[1]: Leaving directory '/home/joshua/projects/cross-compile-for-windows-from-wsl/Step1_build'
    ```

3.  Run the resulting `Tutorial.exe` executable in the `Step1_build` directory from WSL (interop) or Windows.

    ```shell
    joshua@wsl:~/projects/cross-compile-example$ ./Step1_build/Tutorial.exe 2
    The square root of 2 is 1.41421
    ```

    ```powershell
    PS Microsoft.PowerShell.Core\FileSystem::\\wsl.localhost\Ubuntu\home\joshua\projects\cross-compile-example> .\Step1_build\Tutorial.exe 2
    The square root of 2 is 1.41421
    ```