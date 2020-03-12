#--------------------------------------------------------------------------
# JANA Docker Container for GitHub Action
#
# This dockerfile is used to make a docker image from the latest
# JANA2 master that is then used to run some tests to confirm
# the build. This is done as a GitHub Action triggered by either
# a pull request being submitted or a direct commit to master.
# This was put together based on this documentation from GitHub:
#
# https://help.github.com/en/actions/building-actions/creating-a-docker-container-action
#
#--------------------------------------------------------------------------
#
# This builds on an image provided by the ROOT team that already contains
# a build of ROOT. It then installs packages for cmake, and zmq so JANA2
# can be built with zmq support. The base image already contains a c++
# compiler (gcc 7.2 at the time of this writing). It also contains python3
# and the python development packages (presumably since ROOT needs them).
#
# The JANA2 build is done here as part of the container build and the
# "entrypoint.sh" script used to run tests of the software.
#
# Note that we are restricted to using package versions and settings used
# in the ROOT base image. Specifically, the gcc compiler version and the
# C++ standard they used to build ROOT. The standard is set use the
# CXX_STANDARD ARG below which may need to be updated when the base container
# changes.
#
#--------------------------------------------------------------------------
# Normally, this is built as a temporary image by GitHub in order
# to run the tests. To build it manually do this:
#
#   docker build -f Dockerfile . -t janatest
#
#
# To run the test manually do this:
#
#   docker run --rm -it janatest
#
#
# To get a bash shell in the container for debugging do this:
#
#   docker run --rm -it --entrypoint /bin/bash janatest
#--------------------------------------------------------------------------

# Use ROOT supplied container
FROM rootproject/root-conda:6.20.00

# This needs to be set to whatever was used to build the ROOT version
# in the container. I don't know a good way of knowing this other than
# trial and error.
ARG CXX_STANDARD=17
ARG BRANCH=master

RUN conda install -y \
	cmake \
	make \
	czmq \
	pyzmq

# Download JANA source
RUN git clone https://github.com/JeffersonLab/JANA2 /opt/JANA2

# Compile and install JANA source
#RUN cd /opt/JANA2 \
#    && git checkout $BRANCH
#    && mkdir build \
#    && cd build \
#    && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/JANA2/Linux -DCMAKE_CXX_STANDARD=17 \
#    && make -j8 install

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
