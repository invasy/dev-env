ARG DEBIAN_VERSION="bullseye"
ARG CMAKE_VERSION="3.23.5"
FROM invasy/dev-env-cpp:${CMAKE_VERSION}-${DEBIAN_VERSION}

# Container annotations
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md#annotations
LABEL org.opencontainers.image.title="C/C++ development environment (clang)"
LABEL org.opencontainers.image.description="C/C++ development environment with clang (LLVM), CMake, Ninja, GNU Make, GDB"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.url="https://github.com/invasy/dev-env/pkgs/container/dev-env-clang"
LABEL org.opencontainers.image.source="https://github.com/invasy/dev-env"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.authors="Vasiliy Polyakov <docker@invasy.dev>"
LABEL org.opencontainers.image.vendor="Vasiliy Polyakov <docker@invasy.dev>"
LABEL maintainer="Vasiliy Polyakov <docker@invasy.dev>"

ARG DEBIAN_VERSION="bullseye"
ARG CLANG_VERSION="14"

# Setup environment
RUN set -eux; \
    mkdir -p ~builder/.ssh; (\
        echo "CC=/usr/bin/clang-${CLANG_VERSION}"; \
        echo "CXX=/usr/bin/clang++-${CLANG_VERSION}"; \
    ) >> ~builder/.ssh/environment; \
    chown -R builder: ~builder/.ssh; chmod -R go= ~builder/.ssh
ENV CC="/usr/bin/clang-${CLANG_VERSION}" CXX="/usr/bin/clang++-${CLANG_VERSION}"

# Install clang and clangd
RUN set -eux; \
    echo "deb http://apt.llvm.org/${DEBIAN_VERSION}/ llvm-toolchain-${DEBIAN_VERSION}-${CLANG_VERSION} main" >/etc/apt/sources.list.d/llvm.list; \
    wget --quiet --output-document=/etc/apt/trusted.gpg.d/llvm.asc 'https://apt.llvm.org/llvm-snapshot.gpg.key'; \
    apt-get update -q; apt-get install -qy --no-install-recommends \
        clang-${CLANG_VERSION} \
        clang-format-${CLANG_VERSION} \
        clang-tidy-${CLANG_VERSION} \
        clang-tools-${CLANG_VERSION} \
        clangd-${CLANG_VERSION} \
        lld-${CLANG_VERSION} \
        lldb-${CLANG_VERSION} \
    ; \
    rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/* /tmp/* /root/.gnupg
