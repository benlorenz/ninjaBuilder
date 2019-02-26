using BinaryBuilder

version = v"1.9.0"

script = raw"""
mkdir -p ${prefix}/bin
cp ninja ${prefix}/bin/
chmod +x ${prefix}/bin/ninja
"""

products(prefix) = [
    ExecutableProduct(prefix, "ninja", :ninja)
]

dependencies = [
]

# linux binary source
sources = [
    "https://github.com/ninja-build/ninja/releases/download/v$(version)/ninja-linux.zip" =>
        "609cc10d0f226a4d9050e4d4a57be9ea706858cce64b9132102c3789c868da92",
]

platforms = [
    Linux(:x86_64, libc=:glibc)
]

build_tarballs(ARGS, "ninjaBuilder", version, sources, script, platforms, products, dependencies)


