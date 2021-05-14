# docker2singularity
alternative implementation that does not rely on Docker in Docker

## Use case

Building a Singularity image from a local Docker image registry,

```
$ docker pull kathoef/docker2singularity:latest
$ docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/output --rm kathoef/docker2singularity singularity build ubuntu.sif docker-daemon://ubuntu:20.04
```
