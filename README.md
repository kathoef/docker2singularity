# docker2singularity

[![](https://github.com/kathoef/docker2singularity/actions/workflows/test-dockerhub-image.yml/badge.svg?branch=main)](https://github.com/kathoef/docker2singularity/blob/main/.github/workflows/test-dockerhub-image.yml)
[![](https://shields.io/docker/image-size/kathoef/docker2singularity/latest)](https://hub.docker.com/r/kathoef/docker2singularity)

This is an alternative implementation of [docker2singularity](https://github.com/singularityhub/docker2singularity) that does not rely on Docker in Docker and granting the container full host device root capabilities via the `--privileged` flag.

(Which should in general be done only if absolutely necessary, could be considered bad practice, and turned out not to be necessary for the local container build workflows described below.)

## Use cases

### Singularity build

Build a Singularity image from a locally build Docker image,

```
$ docker pull kathoef/docker2singularity:latest
$ docker build -f Dockerfile -t localhost/test .
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -v ${PWD}:/output \
  kathoef/docker2singularity singularity build test.sif docker-daemon://localhost/test:latest
```

### Singularity pull

Build a Singularity image from a remotely hosted Docker image,

```
$ docker pull kathoef/docker2singularity:latest
$ docker run --rm -v ${PWD}:/output \
  kathoef/docker2singularity singularity pull alpine_latest.sif docker://alpine:latest
```

### Compatibility

These workflows were tested on Linux, MacOS Mojave and Windows 10 (w/ Hyper-V backend) and [Docker Desktop](https://www.docker.com/products/docker-desktop) with Docker Engine v20.10.6 installed.

### For Linux hosts

You might want to fix the Singularity image file ownership after conversion,

```
$ ls -l test.sif
-rwxr-xr-x 1 root root 2777088 Mai 15 17:19 test.sif
$ sudo chown $(id -u):$(id -g) test.sif
$ ls -l test.sif
-rwxr-xr-x 1 kathoef kathoef 2777088 Mai 15 17:19 test.sif
```

## Background information

The Docker image provided here was originally used during [container image portability tests](https://github.com/ExaESM-WP4/Batch-scheduler-Singularity-bindings/blob/e4be0220f8938b9cc3275267bc44be44e925b3ea/test_image_compatibility/) in order to have a fully controllable Singularity pull environment available.
It turned out that my local Docker image Singularity build tasks also worked quite well and only required the Docker socket to be mounted as read-only.

Since I use these Docker-based local Singularity container image build pipelines quite often [^1] I thought I'd provide a bit more of a structured ground here.
Maybe it happens to be useful to others, feedback is welcome!

[^1]: mainly because Continuous Integration and/or manual DockerHub-based workflows add complexity to a single-user science or data analysis project that feels unnecessary and also because I have seen `singularity pull` attempts on HPC machines failing

## References

Singularity/Apptainer,
* https://github.com/singularityhub/docker2singularity (the original!)
* https://sylabs.io/guides/3.7/user-guide/singularity_and_docker.html#locally-available-images-cached-by-docker
* https://github.com/apptainer/singularity

Multi-architecture build,
* https://docs.docker.com/buildx/working-with-buildx/
* https://github.com/docker/setup-buildx-action#with-qemu
* https://github.com/docker/build-push-action/blob/c5e6528d5ddefc82f682165021e05edf58044bce/docs/advanced/test-before-push.md
