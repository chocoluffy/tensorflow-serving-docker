FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        automake \
        build-essential \
        curl \
        git \
        libfreetype6-dev \
        libpng12-dev \
        libtool \
        libzmq3-dev \
        mlocate \
        pkg-config \
        python-dev \
        python-numpy \
        python-pip \
        software-properties-common \
        swig \
        zip \
        zlib1g-dev \
        libcurl3-dev \
        openjdk-8-jdk\
        openjdk-8-jre-headless \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up grpc

RUN pip install mock grpcio

# Set up Bazel.

ENV BAZELRC /root/.bazelrc
# Install the most recent bazel release.
ENV BAZEL_VERSION 0.10.0
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# CMD ["/bin/bash"]
RUN cd / && git clone --recurse-submodules https://github.com/krystianity/serving
#RUN cd serving/tensorflow && ./configure
#CMD ["/bin/bash"]

# RUN cd serving/tensorflow && ./tensorflow/tools/ci_build/builds/configured cpu
RUN cd serving
CMD bazel test -c opt tensorflow_serving/...

# RUN cd .. && bazel build --local_resources 4096,4.0,1.0 -j 1 //tensorflow_serving/model_servers:tensorflow_model_server

# WORKDIR /serving/bazel-bin/tensorflow_serving/model_servers
# CMD ["./tensorflow_model_server"]