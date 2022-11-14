ARG DEBIAN_VERSION="bullseye"
FROM invasy/dev-env-base:${DEBIAN_VERSION}

# Container annotations
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md#annotations
LABEL org.opencontainers.image.title="C/C++ development environment (base)"
LABEL org.opencontainers.image.description="Base image for C/C++ development environments"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.url="https://github.com/invasy/dev-env/pkgs/container/dev-env-cpp"
LABEL org.opencontainers.image.source="https://github.com/invasy/dev-env"
LABEL org.opencontainers.image.license="GPL-3.0+"
LABEL org.opencontainers.image.authors="Vasiliy Polyakov <docker@invasy.dev>"
LABEL org.opencontainers.image.vendor="Vasiliy Polyakov <docker@invasy.dev>"
LABEL maintainer="Vasiliy Polyakov <docker@invasy.dev>"

ARG CMAKE_VERSION="3.23.5"
ARG NINJA_VERSION="1.11.1"
ARG NINJA_CHECKSUM="b901ba96e486dce377f9a070ed4ef3f79deb45f4ffe2938f8e7ddc69cfb3df77"
ARG DEBIAN_VERSION="bullseye"

# Install dependencies
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update -q; apt-get upgrade -qy; \
    apt-get install -qy --no-install-recommends \
        binutils \
        gdb \
        gdbserver \
        make \
    ; \
    rm -rf /var/lib/apt/lists/* /var/cache/*

# Install ninja
RUN set -eux; cd /tmp; \
    ninja_url="https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip"; \
    wget --quiet "$ninja_url"; echo "$NINJA_CHECKSUM *ninja-linux.zip" | sha256sum --quiet --check; \
    unzip -qq ninja-linux.zip -d /usr/local/bin; \
    rm -rf /tmp/*

# Install CMake
RUN set -eux; cd /tmp; \
    cmake_url="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}" \
    cmake_pkg="cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
    cmake_sum="cmake-${CMAKE_VERSION}-SHA-256.txt" \
    cmake_dir="/opt/cmake/${CMAKE_VERSION}"; \
    wget --quiet "$cmake_url/$cmake_sum" "$cmake_url/$cmake_pkg"; \
    sha256sum --quiet --check --ignore-missing "$cmake_sum"; \
    mkdir -p "/opt/cmake/${CMAKE_VERSION}" /run/sshd; \
    tar --extract --file="$cmake_pkg" --directory="$cmake_dir" --strip-components=1 \
        --wildcards '*/bin' '*/share/cmake-*/Templates' '*/share/cmake-*/Modules'; \
    ln -vst /usr/local/bin/ "$cmake_dir/bin/"*; \
    rm -rf /tmp/*
