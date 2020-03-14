#--------------------------------------------------------------------------
# JANA Docker Container for GitHub Action
#
# This Dockerfile is used to make a docker image that contains a C++
# compiler and optional dependency packages (e.g. ROOT, ZMQ). It also 
# clones the JANA2 repository, but does not build it. Building JANA2
# is deferred until the entrypoint.sh script is run by the container
# since that is where we can pass in arguments to specify the branch.
#
# This is done as a GitHub Action triggered by either
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
# The JANA2 build is done in the entrypoint.sh and the tests run immediately
# after.
#
# Note that we are restricted to using package versions and settings used
# in the ROOT base image. Specifically, the gcc compiler version and the
# C++ standard they used to build ROOT. The standard is set in the entrypoint.sh
# script and may need to be updated when the base container changes.
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
# trial and error. We set this an environment variable that is then
# used in the entrypoint.sh script.
ENV CXX_STANDARD=17

RUN conda install -y \
	cmake \
	make \
	czmq \
	pyzmq

# Download JANA source (compiling deferred to entrypoint.sh)
#RUN git clone https://github.com/JeffersonLab/JANA2 /opt/JANA2

# Copy entrypoint.sh to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

