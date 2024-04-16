# syntax=docker/dockerfile:1

# Define default Python version and version specific arguments as build-time arguments
ARG PYTHON_VERSION=3.9
ARG PYTORCH_VERSION=2.2.1
ARG CUDA_VERSION=11.8.0
ARG CUDNN_VERSION=8

# Use an NVIDIA CUDA development image with the necessary PyTorch, CUDA, and cuDNN versions
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive

# Re-declare ARGS after FROM if not using them directly in RUN commands that follow immediately
ARG PYTORCH_VERSION
ARG PYTHON_VERSION

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh

ENV PATH="/opt/conda/bin:${PATH}"

# Debugging output
RUN echo "Installing PyTorch Version: ${PYTORCH_VERSION}"

# Install Python and PyTorch
RUN conda install -y python=${PYTHON_VERSION}
RUN conda install -y pytorch==${PYTORCH_VERSION} torchvision==0.17.1 torchaudio==2.2.1 cudatoolkit=11.8 -c pytorch 
# if above doesnt work, then just install in conda env

# Set the working directory to /workspace
WORKDIR /workspace

# Set a default command
CMD ["sleep", "infinity"]
