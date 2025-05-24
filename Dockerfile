# Dockerfile for PlemolSC

FROM ubuntu:22.04

LABEL maintainer="Yilin Fang <qzfyl98@outlook.com>"
LABEL description="Dockerfile to build PlemolSC fonts using FontForge and FontTools."

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fontforge \
    python3 \
    python3-fontforge \
    python3-fonttools \
    python3-pip \
    ttfautohint \
    curl \
    unzip \
    git \
    dos2unix \
    ca-certificates \
    && \
    python3 -m pip install --no-cache-dir ttfautohint-py && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy all project files from the build context
COPY . /app/

# Ensure scripts are executable and have correct line endings
RUN find /app -name "*.sh" -exec chmod +x {} \; -exec dos2unix {} \;

# Run the font download script
RUN bash /app/download_fonts.sh

# Set the main build script for all variants as the entrypoint
ENTRYPOINT ["/app/build_all.sh"]

# build_all.sh does not expect command line arguments itself
CMD []
