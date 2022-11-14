# Base Image for Development Environments

[![invasy/dev-env-base @ DockerHub][badge-dockerhub]][dockerhub]
[![Docker Image Size (latest by date)][badge-size]][dockerhub]
[![Docker Pulls][badge-pulls]][dockerhub]

[![ghcr.io/invasy/dev-env-base @ GitHub Container Registry][badge-github]][github]

[![registry.gitlab.com/invasy/dev-env/base @ GitLab Container Registry][badge-gitlab]][gitlab]

Parent image: [debian:bullseye-slim](https://hub.docker.com/_/debian "Debian - Official Image | Docker Hub").

## Toolchain
| Tool                 | Version                     |
|----------------------|-----------------------------|
|   [Debian] ([slim])  | [11.4 (Bullseye)][bullseye] |
| **[GPG]**            | 2.2.27                      |
| **[libgcrypt]**      | 1.8.8                       |
| **[OpenSSH] server** | 8.4p1                       |
| **[rsync]**          | 3.2.3                       |

## Usage
```Dockerfile
# Dockerfile
ARG DEBIAN_VERSION="bullseye"
FROM invasy/dev-env-base:${DEBIAN_VERSION}

# …
```

[dockerhub]: https://hub.docker.com/r/invasy/dev-env-base "invasy/dev-env-base @ Docker Hub"
[badge-dockerhub]: https://img.shields.io/badge/Docker%20Hub-invasy%2Fdev--env--base-informational?logo=docker "invasy/dev-env-base @ Docker Hub"
[badge-version]: https://img.shields.io
[badge-size]: https://img.shields.io/docker/image-size/invasy/dev-env-base?sort=semver "Docker Image Size (latest by date)"
[badge-pulls]: https://img.shields.io/docker/pulls/invasy/dev-env-base?sort=semver "Docker Pulls"

[github]: https://github.com/invasy/dev-env/pkgs/container/dev-env-base "ghcr.io/invasy/dev-env-base @ GitHub Container Registry"
[badge-github]: https://img.shields.io/badge/GitHub-ghcr.io%2Finvasy%2Fdev--env--base-informational?logo=github "ghcr.io/invasy/dev-env-base @ GitHub Container Registry"

[gitlab]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/base @ GitLab Container Registry"
[badge-gitlab]: https://img.shields.io/badge/GitHub-registry.gitlab.com%2Finvasy%2Fdev--env%2Fbase-informational?logo=gitlab "registry.gitlab.com/invasy/dev-env/base @ GitLab Container Registry"

[Debian]: https://www.debian.org/ "Debian"
[GPG]: https://gnupg.org/ "GNU Privacy Guard"
[libgcrypt]: https://gnupg.org/software/libgcrypt/index.html "Libgcrypt"
[bullseye]: https://www.debian.org/releases/bullseye/amd64/release-notes/index.en.html "Debian 11.4 (Bullseye) Release Notes"
[slim]: https://hub.docker.com/_/debian "Debian — Docker Hub"
[OpenSSH]: https://www.openssh.com/ "OpenSSH"
[rsync]: https://rsync.samba.org/ "rsync"
