FROM ubuntu:20.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --yes --no-install-recommends \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget ca-certificates \
    pkg-config \
    git \
    cryptsetup

RUN export VERSION=1.16.4 \
 && wget --quiet https://golang.org/dl/go${VERSION}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz \
 && rm /go${VERSION}.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

RUN export VERSION=3.7.3 \
 && wget --quiet https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz \
 && tar -xzf singularity-${VERSION}.tar.gz \
 && rm /singularity-${VERSION}.tar.gz \
 && cd singularity \
 && ./mconfig \
 && make -C builddir \
 && make -C builddir install \
 && rm -r /singularity

RUN mkdir /output
WORKDIR /output

