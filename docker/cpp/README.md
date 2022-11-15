# Base Image for C/C++ Development Environments

[![invasy/dev-env-cpp @ DockerHub][badge-dockerhub]][dockerhub]
[![Docker Image Size (latest by semver)][badge-size]][dockerhub]
[![Docker Pulls][badge-pulls]][dockerhub]

[![ghcr.io/invasy/dev-env-cpp @ GitHub Container Registry][badge-github]][github]

[![registry.gitlab.com/invasy/dev-env/cpp @ GitLab Container Registry][badge-gitlab]][gitlab]

Parent image: [invasy/dev-env-base](../base/README.md "invasy/dev-env-base").

## Toolchain
| Tool                                         | Version                     |
|----------------------------------------------|-----------------------------|
|   [Debian] ([slim])                          | [11.4 (Bullseye)][bullseye] |
|   [GPG]                                      | 2.2.27                      |
|   [libgcrypt]                                | 1.8.8                       |
|   [OpenSSH] server                           | 8.4p1                       |
|   [rsync]                                    | 3.2.3                       |
| **[CMake]**                                  | 3.23.5                      |
| **[ninja]**                                  | 1.11.1                      |
| **[GNU Make][make]**                         | 4.3                         |
| **[GNU Debugger][gdb] (gdb) with gdbserver** | 10.1                        |

## Usage
```Dockerfile
# Dockerfile
ARG CMAKE_VERSION="3.22.5"
ARG DEBIAN_VERSION="bullseye"
FROM invasy/dev-env-cpp:${CMAKE_VERSION}-${DEBIAN_VERSION}

# …
```

## See Also
- [Remote development | CLion](https://www.jetbrains.com/help/clion/remote-development.html "Remote development | CLion")
- [Using Docker with CLion — The CLion Blog](https://blog.jetbrains.com/clion/2020/01/using-docker-with-clion/ "Using Docker with CLion — The CLion Blog")

[dockerhub]: https://hub.docker.com/r/invasy/dev-env-cpp "invasy/dev-env-cpp @ Docker Hub"
[badge-dockerhub]: https://img.shields.io/badge/Docker%20Hub-invasy%2Fdev--env--cpp-informational?logo=docker "invasy/dev-env-cpp @ Docker Hub"
[badge-size]: https://img.shields.io/docker/image-size/invasy/dev-env-cpp?sort=semver "Docker Image Size (latest by semver)"
[badge-pulls]: https://img.shields.io/docker/pulls/invasy/dev-env-cpp?sort=semver "Docker Pulls"

[github]: https://github.com/invasy/dev-env/pkgs/container/dev-env-cpp "ghcr.io/invasy/dev-env-cpp @ GitHub Container registry"
[badge-github]: https://img.shields.io/badge/GitHub-ghcr.io%2Finvasy%2Fdev--env--cpp-informational?logo=github "ghcr.io/invasy/dev-env-cpp @ GitHub Container registry"

[gitlab]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/cpp @ GitLab Container Registry"
[badge-gitlab]: https://img.shields.io/badge/GitHub-registry.gitlab.com%2Finvasy%2Fdev--env%2Fcpp-informational?logo=gitlab "registry.gitlab.com/invasy/dev-env/cpp @ GitLab Container Registry"

[Debian]: https://www.debian.org/ "Debian"
[bullseye]: https://www.debian.org/releases/bullseye/amd64/release-notes/index.en.html "Debian 11.4 (Bullseye) Release Notes"
[slim]: https://hub.docker.com/_/debian "Debian — Docker Hub"
[OpenSSH]: https://www.openssh.com/ "OpenSSH"
[rsync]: https://rsync.samba.org/ "rsync"
[make]: https://www.gnu.org/software/make/ "GNU Make"
[gdb]: https://www.gnu.org/software/gdb/ "GNU Debugger"
[CMake]: https://cmake.org/ "CMake"
[ninja]: https://ninja-build.org/ "Ninja, a small build system with a focus on speed"
