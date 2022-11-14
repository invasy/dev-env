# Containerized Development Environments

[![invasy/dev-env @ GitHub][gh]][github]
[![invasy/dev-env @ GitLab][gl]][gitlab]
[![invasy/dev-env @ Bitbucket][bb]][bitbucket]
[![GitHub Workflow Status][badge-github-wf]][github-wf]
[![GitLab CI Pipeline Status][badge-gitlab-ci]][gitlab-ci]

## Images
| Stack | Name        | ![Docker Hub][dh]                | ![GitHub Container Registry][gh]         | ![GitLab Container Registry][gl]                     |
|-------|-------------|:--------------------------------:|:----------------------------------------:|:----------------------------------------------------:|
|       | **[base]**  | [invasy/dev-env-base][base-dh]   | [ghcr.io/invasy/dev-env-base][base-gh]   | [registry.gitlab.com/invasy/dev-env/base][base-gl]   |
|       | **[cpp]**   | [invasy/dev-env-cpp][cpp-dh]     | [ghcr.io/invasy/dev-env-cpp][cpp-gh]     | [registry.gitlab.com/invasy/dev-env/cpp][cpp-gl]     |
| C/C++ | **[clang]** | [invasy/dev-env-clang][clang-dh] | [ghcr.io/invasy/dev-env-clang][clang-gh] | [registry.gitlab.com/invasy/dev-env/clang][clang-gl] |
| C/C++ | **[gcc]**   | [invasy/dev-env-gcc][gcc-dh]     | [ghcr.io/invasy/dev-env-gcc][gcc-gh]     | [registry.gitlab.com/invasy/dev-env/gcc][gcc-gl]     |

## See Also
- [Remote development | CLion](https://www.jetbrains.com/help/clion/remote-development.html "Remote development | CLion")
- [Using Docker with CLion — The CLion Blog](https://blog.jetbrains.com/clion/2020/01/using-docker-with-clion/ "Using Docker with CLion — The CLion Blog")

[dh]: docs/images/docker.png
[gh]: docs/images/github.png
[gl]: docs/images/gitlab.png
[bb]: docs/images/bitbucket.png

[github]: https://github.com/invasy/dev-env "invasy/dev-env @ GitHub"
[gitlab]: https://gitlab.com/invasy/dev-env "invasy/dev-env @ GitLab"
[bitbucket]: https://bitbucket.org/invasy/dev-env "invasy/dev-env @ Bitbucket"
[github-wf]: https://github.com/invasy/dev-env/actions "GitHub Workflow Status"
[badge-github-wf]: https://github.com/invasy/dev-env/actions/workflows/docker.yml/badge.svg "GitHub Workflow Status"
[gitlab-ci]: https://gitlab.com/invasy/dev-env/-/pipelines/latest "GitLab CI Pipeline Status"
[badge-gitlab-ci]: https://gitlab.com/invasy/dev-env/badges/master/pipeline.svg "GitLab CI Pipeline Status"

[base]: docker/base/README.md "Base image"
[base-dh]: https://hub.docker.com/r/invasy/dev-env-base "invasy/dev-env-base @ Docker Hub"
[base-gh]: https://github.com/invasy/dev-env/pkgs/container/dev-env-base "ghcr.io/invasy/dev-env-base @ GitHub Container Registry"
[base-gl]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/base @ GitLab Container Registry"

[cpp]: docker/cpp/README.md "C/C++ base image"
[cpp-dh]: https://hub.docker.com/r/invasy/dev-env-cpp "invasy/dev-env-cpp @ Docker Hub"
[cpp-gh]: https://github.com/invasy/dev-env/pkgs/container/dev-env-cpp "ghcr.io/invasy/dev-env-cpp @ GitHub Container Registry"
[cpp-gl]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/cpp @ GitLab Container Registry"

[clang]: docker/clang/README.md "clang 14"
[clang-dh]: https://hub.docker.com/r/invasy/dev-env-clang "invasy/dev-env-clang @ Docker Hub"
[clang-gh]: https://github.com/invasy/dev-env/pkgs/container/dev-env-clang "ghcr.io/invasy/dev-env-clang @ GitHub Container Registry"
[clang-gl]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/clang @ GitLab Container Registry"

[gcc]: docker/gcc/README.md "GCC 12"
[gcc-dh]: https://hub.docker.com/r/invasy/dev-env-gcc "invasy/dev-env-gcc @ Docker Hub"
[gcc-gh]: https://github.com/invasy/dev-env/pkgs/container/dev-env-gcc "ghcr.io/invasy/dev-env-gcc @ GitHub Container Registry"
[gcc-gl]: https://gitlab.com/invasy/dev-env/container_registry "registry.gitlab.com/invasy/dev-env/gcc @ GitLab Container Registry"
