# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ninja"
version = v"1.9.0"

# Collection of sources required to build ninja
sources = [
    "https://github.com/ninja-build/ninja/archive/v1.9.0.tar.gz" =>
    "5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd ninja-1.9.0/
if [[ $target == *linux* ]]; then
./configure.py --host=linux --platform=linux
elif [[ $target == *apple* ]]; then
./configure.py --host=linux --platform=darwin
elif [[ $target == *mingw* ]]; then
./configure.py --host=linux --platform=mingw
elif [[ $target == *freebsd* ]]; then
./configure.py --host=linux --platform=freebsd
fi
ninja
mkdir -p ${prefix}/bin
if [[ $target == *mingw* ]]; then
    install ninja.exe ${prefix}/bin/
else
    install ninja ${prefix}/bin/
fi

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "ninja", :ninja)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
