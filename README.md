# docker2singularity

![](https://github.com/kathoef/docker2singularity/actions/workflows/test-docker-image.yml/badge.svg?branch=main&event=push&event=workflow_dispatch)
![](https://shields.io/docker/image-size/kathoef/docker2singularity/latest)

This is an alternative implementation to [docker2singularity](https://github.com/singularityhub/docker2singularity) that does not rely on Docker in Docker and granting a container root capabilities to all host system devices via the `--privileged` flag. (Which should be done only if absolutely necessary, and can be considered bad practice.)

It turns out tha `singularity build` from inside a Docker container is possible using the default Docker run privileges, and requires only the `/var/run/docker.sock` socket to be mounted. It was [originally developed](https://github.com/ExaESM-WP4/Batch-scheduler-Singularity-bindings/blob/e4be0220f8938b9cc3275267bc44be44e925b3ea/test_image_compatibility/) to have a fully controllable Singularity pull environment available.

The container image provided here is designed with local `docker-daemon://` Singularity build pipelines in mind. I use these quite often, and this repository is an attempt to provide a ready-to-use Docker container for this.

## Use case

Build a Singularity image from a Docker image that is stored on your host system,

```
$ docker pull kathoef/docker2singularity:latest

$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/output \
kathoef/docker2singularity singularity build alpine.sif docker-daemon://alpine:latest
```

On a Linux system you might want to change the file's ownership afterwards,

```
$ ls -l alpine.sif
-rwxr-xr-x 1 root root 2777088 Mai 15 17:11 alpine.sif

$ sudo chown $(id -u):$(id -g) alpine.sif

$ ls -l alpine.sif
-rwxr-xr-x 1 kathoef kathoef 2777088 Mai 15 17:11 alpine.sif
```

## References

* https://github.com/hpcng/singularity
* https://sylabs.io/guides/3.7/admin-guide/installation.html#installation-on-linux
* https://github.com/singularityhub/docker2singularity
