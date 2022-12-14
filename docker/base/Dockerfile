ARG DEBIAN_VERSION="bullseye"
FROM debian:${DEBIAN_VERSION}-slim

# Container annotations
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md#annotations
LABEL org.opencontainers.image.title="Development environment (base)"
LABEL org.opencontainers.image.description="Base image for development environments"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/invasy/dev-env"
LABEL org.opencontainers.image.url="https://github.com/invasy/dev-env/pkgs/container/dev-env-base"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.authors="Vasiliy Polyakov <docker@invasy.dev>"
LABEL org.opencontainers.image.vendor="Vasiliy Polyakov <docker@invasy.dev>"
LABEL maintainer="Vasiliy Polyakov <docker@invasy.dev>"

# Create user
RUN set -eux; \
    useradd --user-group --create-home --comment='Remote Builder' --shell=/bin/bash builder; \
    yes builder | passwd --quiet builder; touch ~builder/.hushlogin; \
    mkdir -p ~builder/.ssh; touch ~builder/.ssh/environment; \
    chown -R builder: ~builder; chmod -R go= ~builder

# Update package info, install dependencies, apply config, clean up
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update -q; apt-get upgrade -qy; \
    apt-get install -qy --no-install-recommends \
        ca-certificates \
        gnupg \
        openssh-server \
        rsync \
        unzip \
        wget \
    ; \
    echo 'kernel.perf_event_paranoid=1' > /etc/sysctl.d/99-perf.conf; \
    rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/* /tmp/* /root/.gnupg
COPY sshd_config /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
