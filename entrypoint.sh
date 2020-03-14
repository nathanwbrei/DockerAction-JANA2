#!/bin/bash
#
# This is run from within the temporary janatest container
# that gets built by GitHub as part of a GitHub Action to test
# pull requests and commits to master.
#
# This builds JANA2 using the branch given by the GITHUB_REF
# environment variable (passed in by GitHub when container
# is run). What actually gets passed is not the branch
# name, but a repository reference from GITHUB_REF that looks
# something like "refs/pull/61/merge". This gets fetched from the
# origin into a branch named "CI" which is then checked out.
#
# This also uses the CXX_STANDARD environment variable
# which should be set in the Dockerfile to be consistent with
# whatever the ROOT version used. (See Dockerfile for details.)


echo "--- Checking out JANA for $GITHUB_REF --------------"
cd /opt/JANA2
git fetch origin ${GITHUB_REF}:CI
git checkout CI

echo "--- Building JANA ------------------------------"
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/JANA2/Linux -DCMAKE_CXX_STANDARD=$CXX_STANDARD
make -j8 install

echo "--- Setting up JANA environment ----------------"
export PATH=/opt/JANA2/bin:${PATH}
export JANA_PLUGIN_PATH=/plugins
echo "PATH=${PATH}"
echo "JANA_PLUGIN_PATH=${JANA_PLUGIN_PATH}"

echo "--- Running JTest plugin -----------------------"
jana -PPLUGINS=JTest -Pjana:nevents=100

echo "--- Running tests ------------------------------"
tests

echo "--- Done ---------------------------------------"

