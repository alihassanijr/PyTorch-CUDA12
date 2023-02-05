FROM nvidia/cuda:12.0.0-devel-ubuntu20.04

ENV TORCHVER=434eb16debf3aef08d95f19fb46e602c8fadc422
ENV VISIONVER=v0.14.1-rc2

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (1)
RUN apt-get update && apt-get install -y \
        automake autoconf libpng-dev vim \
        curl zip unzip libtool swig zlib1g-dev pkg-config \
        git wget xz-utils libpython3-dev \
        libpython3-all-dev python3-pip python3.10 \
        cpio gosu git liblapack-dev liblapacke-dev \
        build-essential ca-certificates ccache cmake \
        libjpeg-dev libpng-dev

# Install dependencies (2)
RUN pip3 install --upgrade pip \
    && pip3 install --upgrade onnx \
    && pip3 install --upgrade onnxruntime \
    && pip3 install cmake==3.25.0 \
    && pip3 install --upgrade pyyaml \
    && pip3 install --upgrade ninja \
    && pip3 install --upgrade yapf \
    && pip3 install --upgrade six \
    && pip3 install --upgrade wheel \
    && pip3 install --upgrade moc \
    && ldconfig

RUN echo $(nvcc --version)

RUN git clone --recursive https://github.com/pytorch/pytorch
RUN cd /pytorch \
    && git checkout ${TORCHVER} \
    && git submodule sync \
    && git submodule update --init --recursive \
    && sed -i -e "/^#ifndef THRUST_IGNORE_CUB_VERSION_CHECK$/i #define THRUST_IGNORE_CUB_VERSION_CHECK" \
                 /usr/local/cuda/targets/x86_64-linux/include/thrust/system/cuda/config.h \
    && cat /usr/local/cuda/targets/x86_64-linux/include/thrust/system/cuda/config.h \
    && sed -i -e "/^if(DEFINED GLIBCXX_USE_CXX11_ABI)/i set(GLIBCXX_USE_CXX11_ABI 1)" \
                 CMakeLists.txt \
    && pip3 install -r requirements.txt \
    && TORCH_CUDA_ARCH_LIST="9.0" USE_NCCL=OFF python3 setup.py install

RUN git clone https://github.com/pytorch/vision.git
RUN cd /vision \
    && git checkout ${VISIONVER} \
    && git submodule update --init --recursive \
    && TORCH_CUDA_ARCH_LIST="9.0" python3 setup.py install

WORKDIR /workspace
