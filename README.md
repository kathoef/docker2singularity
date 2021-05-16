# docker2singularity

![](https://github.com/kathoef/docker2singularity/actions/workflows/test-docker-image.yml/badge.svg?branch=main&event=push&event=workflow_dispatch)
![](https://shields.io/docker/image-size/kathoef/docker2singularity/latest)

This is an alternative implementation of [docker2singularity](https://github.com/singularityhub/docker2singularity) that does not rely on Docker in Docker and granting the running container host device root capabilities via the `--privileged` flag.
(Which should be done only if absolutely necessary, could be considered bad practice, and turned out not to be necessary for the container build workflows described below.)

This Docker image was originally developed for a few [container image portability tests](https://github.com/ExaESM-WP4/Batch-scheduler-Singularity-bindings/blob/e4be0220f8938b9cc3275267bc44be44e925b3ea/test_image_compatibility/), and therein to have a fully controllable Singularity pull environment available.
It turned out that my local Docker image Singularity build tasks also worked, which only required `/var/run/docker.sock` to be mounted.
(No tinkering with default Docker run privileges necessary.)

As I use these fully local build pipelines quite often (mainly because CI and/or hub workflows add unnecessary complexity to a single-user project and also because I have seen `singularity pull` attempts on big machines failing) I thought I'd provide a bit more of a structured ground here.
Feedback is welcome.

## Use case

Build a Singularity image from a Docker image that was build locally on your system,

```
$ docker build -t localhost/test .
$ docker pull kathoef/docker2singularity:latest
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/output \
kathoef/docker2singularity singularity build test.sif docker-daemon://localhost/test:latest
```

This works on Linux and MacOS with [Docker Desktop](https://www.docker.com/products/docker-desktop) installed.
(Windows currently untested.)

### For Linux

You might want to change the Singularity image's file ownership afterwards,

```
$ ls -l test.sif
-rwxr-xr-x 1 root root 2777088 Mai 15 17:11 test.sif
$ sudo chown $(id -u):$(id -g) test.sif
$ ls -l test.sif
-rwxr-xr-x 1 kathoef kathoef 2777088 Mai 15 17:11 test.sif
```

## References

* https://github.com/singularityhub/docker2singularity
* https://sylabs.io/guides/3.7/admin-guide/installation.html#installation-on-linux
* https://github.com/hpcng/singularity
