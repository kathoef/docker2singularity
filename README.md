# docker2singularity

![](https://github.com/kathoef/dgoielksdfg/actions/workflows/test-docker-image.yml/badge.svg?branch=main&event=push&event=workflow_dispatch)
![](https://shields.io/docker/image-size/kathoef/docker2singularity/latest)

alternative implementation that does not rely on Docker in Docker

## Use case

Building a Singularity image from a local Docker image registry,

```
$ docker pull kathoef/docker2singularity:latest
$ docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/output --rm kathoef/docker2singularity singularity build ubuntu.sif docker-daemon://ubuntu:20.04
```
