# docker2singularity

[![](https://github.com/kathoef/docker2singularity/actions/workflows/test-docker-image.yml/badge.svg?branch=main)](https://github.com/kathoef/docker2singularity/blob/main/.github/workflows/test-docker-image.yml)
[![](https://shields.io/docker/image-size/kathoef/docker2singularity/latest)](https://hub.docker.com/r/kathoef/docker2singularity)

This is an alternative implementation of [docker2singularity](https://github.com/singularityhub/docker2singularity) that does not rely on Docker in Docker and having to grant the container host device root capabilities via the `--privileged` flag.
(Which should in general be done only if absolutely necessary, could be considered bad practice, and turned out not to be necessary for the local container build workflows that are described below.)

The Docker image provided here was originally specified for [container image portability tests](https://github.com/ExaESM-WP4/Batch-scheduler-Singularity-bindings/blob/e4be0220f8938b9cc3275267bc44be44e925b3ea/test_image_compatibility/) and to have a fully controllable Singularity pull environment available.
It turned out that my local Docker image Singularity build tasks also worked quite well and only required the Docker socket to be mounted.
(No tinkering with default Docker run privileges necessary.)

As I use these Docker-based fully local Singularity container image build pipelines quite often (mainly because CI and/or hub-based workflows add complexity to a single-user project that feels unnecessary and also because I have seen `singularity pull` attempts on the big machines failing) I thought I'd provide a bit more of a structured ground here.

Maybe it's useful to others as well, feedback is welcome.

## Use case

Build a Singularity image from a Docker image that was built locally on your system,

```
$ ls -l Dockerfile
-rw-rw-r-- 1 kathoef kathoef 58 Mai 15 17:14 Dockerfile
$ docker build -t localhost/test .
```

```
$ docker pull kathoef/docker2singularity:latest
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/output \
kathoef/docker2singularity singularity build test.sif docker-daemon://localhost/test:latest
```

This was tested on Linux, MacOS and Windows 10 (w/ Hyper-V backend) and [Docker Desktop](https://www.docker.com/products/docker-desktop) v20.10.6 installed.

### For Linux

You might want to change the Singularity image's file ownership afterwards,

```
$ ls -l test.sif
-rwxr-xr-x 1 root root 2777088 Mai 15 17:19 test.sif
$ sudo chown $(id -u):$(id -g) test.sif
$ ls -l test.sif
-rwxr-xr-x 1 kathoef kathoef 2777088 Mai 15 17:19 test.sif
```

## References

* https://github.com/singularityhub/docker2singularity
* https://sylabs.io/guides/3.7/admin-guide/installation.html#installation-on-linux
* https://github.com/hpcng/singularity
