# PyTorch + Torchvision for CUDA 12.0
Nightly torch and torchvision builds still don't come with CUDA 12.0 wheels, 
which means there's a chance that the underlying kernels might not fully utilize
the new Hopper architecture (I'm just guessing -- because the new CUDA programming
model is introduced in 12.0.)

Given my previous unsuccessful attempts to build PyTorch from source, I figured I'd
give it a shot with docker.

This repository contains a bare minimum Dockerfile that does exactly that (starts
off the `nvidia/cuda` image, and then builds PyTorch and torchvision.)

It also supports building torch extensions (that's how we get torchvision.)

## Getting started
Just build the image:
```
docker build -t torch2-cu12 . 
```

and then just run it as you please:
```
docker run --gpus all torch2-cu12 $CMD
```

## Credits
The dockerfile is heavily based on [PINTO0309's Dockerfile](https://github.com/PINTO0309/PyTorch-build).
