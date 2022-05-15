FROM ubuntu:22.04 AS base

RUN apt update && apt install --yes --no-install-recommends \
    # add singularity build and singularity pull OS dependencies
    ca-certificates squashfs-tools \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

FROM base AS builder

# https://apptainer.org/docs/admin/main/installation.html#install-from-source

RUN apt update && apt install --yes --no-install-recommends \
    build-essential \
    uuid-dev \
    libgpgme-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup-bin

ARG TARGETPLATFORM
ARG BUILDPLATFORM

SHELL ["/bin/bash", "-c"]

RUN export VERSION=1.18.2 \
 && export ARCH=linux-${TARGETPLATFORM#'linux/'} \
 && wget --quiet https://go.dev/dl/go${VERSION}.${ARCH}.tar.gz \
 && tar -C /usr/local -xzf go${VERSION}.${ARCH}.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

RUN export VERSION=1.0.2 \
 && cd /tmp \
 && wget --quiet https://github.com/apptainer/apptainer/releases/download/v${VERSION}/apptainer-${VERSION}.tar.gz \
 && tar -xzf apptainer-${VERSION}.tar.gz \
 && mv apptainer-${VERSION} apptainer \
 && cd apptainer \
 && ./mconfig --prefix=/apptainer \
 && make -C builddir \
 && make -C builddir install

FROM base

# Add Apptainer information.

COPY --from=builder /tmp/apptainer/LICENSE*.md /apptainer/
COPY --from=builder /tmp/apptainer/README.md /apptainer/README.md

# Add this Github repository's information.

ADD README.md LICENSE Dockerfile /

# Apptainer executable.

# Full install...
#COPY --from=builder /apptainer /apptainer

# Minimal install... supports singularity pull/build workflows.
COPY --from=builder /apptainer/bin/apptainer /apptainer/bin/apptainer
COPY --from=builder /apptainer/bin/singularity /apptainer/bin/singularity
COPY --from=builder /apptainer/etc/apptainer/apptainer.conf /apptainer/etc/apptainer/apptainer.conf

# Docker image conveniences.

ENV PATH=$PATH:/apptainer/bin
RUN mkdir /output
WORKDIR /output
