FROM  tensorflow/tensorflow:2.2.3-gpu-py3 AS BUILDING
LABEL MAINTAINER "IBM Technology Garage"

ENV KF_VERSION 1.2.0

SHELL ["/bin/bash", "-c"]

#############################
# Set the locale
#############################
## TO DO: Need to optimize in one run to avoid multiple levels of images
RUN  echo 'Acquire {http::Pipeline-Depth "0";};' >> /etc/apt/apt.conf
RUN DEBIAN_FRONTEND="noninteractive"
RUN apt-get update  && apt-get -y install --no-install-recommends locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y --no-install-recommends \
    wget \
    git \
    python3-pip \
    openssh-client \
    python3-setuptools \
    google-perftools && \
    rm -rf /var/lib/apt/lists/*

##################################
# User setup
##################################
RUN useradd -m -s /bin/bash -g root -G sudo -u 1000 kflow 

#############################
# Install Anaconda 
#############################
WORKDIR /tmp
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

# Cleanup and make /bin/sh symlink to bash instead of dash:
RUN rm -rf /workspace/{nvidia,docker}-examples && rm -rf /usr/local/nvidia-examples && \
echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Set the new Allocator
ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libtcmalloc.so.4

#############################
# Install Anaconda 
#############################
RUN wget https://github.com/kubeflow/kfctl/releases/download/v${KF_VERSION}/kfctl_v${KF_VERSION}-0-gbc038f9_linux.tar.gz && \
    tar -xvf kfctl_v${KF_VERSION}-0-gbc038f9_linux.tar.gz && \
    mv ./kfctl /usr/local/bin/ && \
    rm kfctl_v${KF_VERSION}-0-gbc038f9_linux.tar.gz && \
    kfctl version 

ENTRYPOINT ["/bin/bash"]