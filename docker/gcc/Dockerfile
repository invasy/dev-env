ARG DEBIAN_VERSION="bullseye"
ARG GCC_VERSION="12.2.0"
ARG CMAKE_VERSION="3.23.5"
FROM gcc:${GCC_VERSION}-${DEBIAN_VERSION} AS gcc

FROM invasy/dev-env-cpp:${CMAKE_VERSION}-${DEBIAN_VERSION}

# Container annotations
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md#annotations
LABEL org.opencontainers.image.title="C/C++ development environment (GCC)"
LABEL org.opencontainers.image.description="C/C++ development environment with GCC, CMake, Ninja, GNU Make, GDB"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.url="https://github.com/invasy/dev-env/pkgs/container/dev-env-gcc"
LABEL org.opencontainers.image.source="https://github.com/invasy/dev-env"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.authors="Vasiliy Polyakov <docker@invasy.dev>"
LABEL org.opencontainers.image.vendor="Vasiliy Polyakov <docker@invasy.dev>"
LABEL maintainer="Vasiliy Polyakov <docker@invasy.dev>"

# Setup environment
RUN set -eux;\
    mkdir -p ~builder/.ssh; (\
        echo "CC=/usr/local/bin/gcc"; \
        echo "CXX=/usr/local/bin/g++"; \
    ) >> ~builder/.ssh/environment; \
    chown -R builder: ~builder/.ssh; chmod -R go= ~builder/.ssh
ENV CC="/usr/local/bin/gcc" CXX="/usr/local/bin/g++"

# Install GCC (g++)
COPY --from=gcc /etc/ld.so.conf.d/000-local-lib.conf /etc/ld.so.conf.d/
COPY --from=gcc \
    /usr/local/bin/c++ \
    /usr/local/bin/cpp \
    /usr/local/bin/g++ \
    /usr/local/bin/gcc \
    /usr/local/bin/gcc-ar \
    /usr/local/bin/gcc-nm \
    /usr/local/bin/gcc-ranlib \
    /usr/local/bin/
COPY --from=gcc /usr/local/include/c++ /usr/local/include/c++/
COPY --from=gcc /usr/local/lib/gcc /usr/local/lib/gcc/
COPY --from=gcc /usr/local/lib64 /usr/local/lib64/
COPY --from=gcc /usr/local/libexec/gcc /usr/local/libexec/gcc/
COPY --from=gcc \
    /usr/local/share/info/libgomp.info \
    /usr/local/share/info/libitm.info \
    /usr/local/share/info/libquadmath.info \
    /usr/local/share/info/
COPY --from=gcc /usr/local/share/locale/ru /usr/local/share/locale/ru/
COPY --from=gcc /usr/local/share/man/man1 /usr/local/share/man/man1/
COPY --from=gcc /usr/local/share/man/man7 /usr/local/share/man/man7/
COPY --from=gcc \
    /var/lib/dpkg/diversions \
    /var/lib/dpkg/diversions-old \
    /var/lib/dpkg/
COPY --from=gcc /var/lib/dpkg/alternatives/cc /var/lib/dpkg/alternatives/
RUN set -eux; \
    ldconfig -v; \
    dpkg-divert --divert /usr/bin/gcc.orig --rename /usr/bin/gcc; \
    dpkg-divert --divert /usr/bin/g++.orig --rename /usr/bin/g++; \
    update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 999; \
    rm -rf /usr/local/lib64/go /usr/local/lib64/libgo* /var/cache/* /var/log/*
