FROM ubuntu:20.04@sha256:aba80b77e27148d99c034a987e7da3a287ed455390352663418c0f2ed40417fe AS windows-cpp-build-tools

RUN apt-get update && \
apt-get install --yes --no-install-recommends \
python-six=1.14.0-2 \
python-simplejson=3.16.0-2ubuntu2 \
python-is-python2=2.7.17-4 \
msitools=0.100-1 \
ca-certificates=20210119~20.04.1 \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt/msvc

# https://github.com/mstorsjo/msvc-wine
ADD https://raw.githubusercontent.com/mstorsjo/msvc-wine/84a46610378ef6118e60fc5d53a161f12e8d1b76/vsdownload.py .

RUN PYTHONUNBUFFERED=1 \
python vsdownload.py \
--accept-license \
--only-unpack \
--ignore Microsoft.Component.MSBuild \
--ignore Microsoft.VisualStudio.Component.Roslyn.Compiler \
--ignore Microsoft.VisualStudio.Component.TestTools.BuildTools \
--ignore Microsoft.VisualStudio.Component.TextTemplating \
--ignore Microsoft.VisualStudio.Component.VC.ASAN \
--ignore Microsoft.VisualStudio.Component.VC.CMake.Project \
--ignore Microsoft.VisualStudio.Component.VC.CoreIde \
--ignore Microsoft.VisualStudio.Component.VC.Redist.14.Latest \
--dest /opt/msvc \
Microsoft.VisualStudio.Workload.VCTools

FROM ubuntu:20.04@sha256:aba80b77e27148d99c034a987e7da3a287ed455390352663418c0f2ed40417fe AS cmake-llvm

COPY --from=windows-cpp-build-tools /opt/msvc /opt/msvc

RUN apt-get update \
# Add APT repositories
&& apt-get install --no-install-recommends --yes \
wget=1.20.3-1ubuntu1 \
make=4.2.1-1.2 \
gpg=2.2.19-3ubuntu2.1 \
gpg-agent=2.2.19-3ubuntu2.1 \
ca-certificates=20210119~20.04.1 \
# LLVM
# https://apt.llvm.org/
&& wget -q -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - \
&& echo 'deb https://apt.kitware.com/ubuntu/ focal main' > /etc/apt/sources.list.d/kitware.list \
# CMake
# https://apt.kitware.com/
&& wget -q -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
&& echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-12 main' > /etc/apt/sources.list.d/llvm.list \
# Install packages
&& apt-get update \
&& apt-get install --no-install-recommends --yes \
clang-12=1:12.0.1~++20210630032618+fed41342a82f-1~exp1~20210630133332.127 \
lld-12=1:12.0.1~++20210630032618+fed41342a82f-1~exp1~20210630133332.127 \
cmake=3.20.5-0kitware1ubuntu20.04.1 \
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#apt-get
&& rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib/llvm-12/bin/clang /usr/bin/clang-cl-12

# Rename files

# kernel32.Lib => kernel32.lib
RUN mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x64/kernel32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x64/kernel32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x86/kernel32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x86/kernel32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm64/kernel32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm64/kernel32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm/kernel32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm/kernel32.lib \
# OpenGL32.Lib => opengl32.lib
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x64/OpenGL32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x64/opengl32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x86/OpenGL32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x86/opengl32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm64/OpenGL32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm64/opengl32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm/OpenGL32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/arm/opengl32.lib \
# GlU32.Lib => glu32.lib
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x64/GlU32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x64/glu32.lib \
&& mv /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x86/GlU32.Lib /opt/msvc/Program\ Files/Windows\ Kits/10/Lib/10.0.19041.0/um/x86/glu32.lib
