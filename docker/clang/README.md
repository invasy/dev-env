# C/C++ Development Environments with clang

[![invasy/dev-env-clang @ DockerHub][badge-dockerhub]][dockerhub]
[![Docker Image Size (latest by date)][badge-size]][dockerhub]
[![Docker Pulls][badge-pulls]][dockerhub]

[![ghcr.io/invasy/dev-env-clang @ GitHub Container Registry][badge-github]][github]

[![registry.gitlab.com/invasy/dev-env/clang @ GitLab Container Registry][badge-gitlab]][gitlab]

Parent image: [invasy/dev-env-cpp](../cpp/README.md "invasy/dev-env-cpp").

## Toolchain
| Tool                                       | Version                     |
|--------------------------------------------|-----------------------------|
|   [Debian] ([slim])                        | [11.4 (Bullseye)][bullseye] |
|   [OpenSSH] server                         | 8.4p1                       |
|   [rsync]                                  | 3.2.3                       |
|   [GNU Make][make]                         | 4.3                         |
|   [GNU Debugger][gdb] (gdb) with gdbserver | 10.1                        |
|   [CMake]                                  | 3.22.5                      |
|   [ninja]                                  | 1.11.0                      |
| **[clang]/[llvm]**                         | 14                          |

## Usage
1. Build image:
    ```bash
    make build-clang
    ```
2. Run service:
    ```bash
    make up-clang
    ```
3. Set up CLion toolchain (_see below_).
4. Build, run, debug your project using toolchain in the container.
5. Stop service:
    ```bash
    make down-clang
    ```

### CLion Configuration
#### Toolchains
![Toolchains](../../docs/images/clion-toolchains.png "Toolchains")

- **Name**: `dev-env-clang`
- **Credentials**: _see **SSH Configurations** below_
- **CMake**: `/usr/local/bin/cmake`
- **Make**: `/usr/local/bin/ninja` (_see also **CMake** below_)
- **C Compiler**: `/usr/bin/clang-14` (_should be detected_)
- **C++ Compiler**: `/usr/bin/clang++-14` (_should be detected_)
- **Debugger**: `/usr/bin/gdb` (_should be detected_)

#### SSH Configurations
![SSH Configurations](../../docs/images/clion-ssh.png "SSH Configurations")

- **Host**: `127.0.0.1`
- **Port**: `22001`
- **Authentication type**: `Password`
- **User name**: `builder`
- **Password**: `builder`

#### CMake
![CMake](../../docs/images/clion-cmake.png "CMake")

- **Profiles**:
  - **Debug** (_or any other profile_):
    - **CMake options**: `-G Ninja`

## SSH
### Configuration
```
# ~/.ssh/config
Host dev-env-clang
User builder
HostName 127.0.0.1
Port 22001
HostKeyAlias dev-env-clang
StrictHostKeyChecking no
NoHostAuthenticationForLocalhost yes
PreferredAuthentications password
PasswordAuthentication yes
PubkeyAuthentication no
```

Remove old host key from `~/.ssh/known_hosts` after image rebuilding (_note `HostKeyAlias` in config above_):
```bash
ssh-keygen -f "$HOME/.ssh/known_hosts" -R 'dev-env-clang'
```

### Connection
```bash
ssh dev-env-clang
```
- User name: `builder`
- Password: `builder`

## See Also
- [Remote development | CLion](https://www.jetbrains.com/help/clion/remote-development.html "Remote development | CLion")
- [Using Docker with CLion — The CLion Blog](https://blog.jetbrains.com/clion/2020/01/using-docker-with-clion/ "Using Docker with CLion — The CLion Blog")

[dockerhub]: https://hub.docker.com/r/invasy/dev-env-clang "invasy/dev-env-clang @ Docker Hub"
[badge-dockerhub]: https://img.shields.io/badge/Docker%20Hub-invasy%2Fdev--env--clang-informational?logo=docker "invasy/dev-env-clang @ Docker Hub"
[badge-size]: https://img.shields.io/docker/image-size/invasy/dev-env-clang?sort=semver "Docker Image Size (latest by semver)"
[badge-pulls]: https://img.shields.io/docker/pulls/invasy/dev-env-clang?sort=semver "Docker Pulls"

[github]: https://github.com/invasy/dev-env/pkgs/container/dev-env-clang "ghcr.io/invasy/dev-env-clang @ GitHub Container Registry"
[badge-github]: https://img.shields.io/badge/GitHub-ghcr.io%2Finvasy%2Fdev--env--clang-informational?logo=github "ghcr.io/invasy/dev-env-clang @ GitHub Container Registry"

[gitlab]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/clang @ GitLab Container Registry"
[badge-gitlab]: https://img.shields.io/badge/GitHub-registry.gitlab.com%2Finvasy%2Fdev--env%2Fclang-informational?logo=gitlab "registry.gitlab.com/invasy/dev-env/clang @ GitLab Container Registry"

[Debian]: https://www.debian.org/ "Debian"
[bullseye]: https://www.debian.org/releases/bullseye/amd64/release-notes/index.en.html "Debian 11.4 (Bullseye) Release Notes"
[slim]: https://hub.docker.com/_/debian "Debian — Docker Hub"
[OpenSSH]: https://www.openssh.com/ "OpenSSH"
[rsync]: https://rsync.samba.org/ "rsync"
[make]: https://www.gnu.org/software/make/ "GNU Make"
[gdb]: https://www.gnu.org/software/gdb/ "GNU Debugger"
[CMake]: https://cmake.org/ "CMake"
[ninja]: https://ninja-build.org/ "Ninja, a small build system with a focus on speed"
[clang]: https://clang.llvm.org/ "Clang: a C language family frontend for LLVM"
[llvm]: https://llvm.org/ "The LLVM Compiler Infrastructure"
