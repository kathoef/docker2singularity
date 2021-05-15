# docker2singularity

![](https://github.com/kathoef/dgoielksdfg/actions/workflows/test-docker-image.yml/badge.svg?branch=main&event=push&event=workflow_dispatch)
![](https://shields.io/docker/image-size/kathoef/docker2singularity/latest)

alternative implementation that does not rely on Docker in Docker

## Use case

Building a Singularity image from a local Docker image registry,

```
$ docker pull kathoef/docker2singularity:latest
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/output \
kathoef/docker2singularity singularity build alpine.sif docker-daemon://alpine:latest
```

On a Linux system you might want to change the container's ownership,

```
$ ls -l alpine.sif
-rwxr-xr-x 1 root root 2777088 Mai 15 17:11 alpine.sif
$ sudo chown $(id -u):$(id -g) alpine.sif
$ ls -l alpine.sif
-rwxr-xr-x 1 kathoef kathoef 2777088 Mai 15 17:11 alpine.sif
```
