#!/bin/bash
#
# This is run from within the temporary janatest container
# that gets built by GitHub as part of a GitHub Action to test
# pull requests and commits to master.
#
# This builds JANA2 using the branch given as the only argument
# to this script. It also uses the CXX_STANDARD environment variable
# which should be set in the Dockerfile to be consistent with what
# the ROOT version used. (See Dockerfile for details.)
#
# n.b. The JANA software will be installed in /usr and the
# plugins in /plugins. This is in spite of setting the
# CMAKE_INSTALL_PREFIX below.
#

echo "--- Building JANA --------------"
cd /opt/JANA2
mkdir build
cd build
#cmake .. -DCMAKE_INSTALL_PREFIX=/opt/JANA2/Linux -DCMAKE_CXX_STANDARD=$CXX_STANDARD
#make -j8 install
echo "------------------------"


echo "--- JTest --------------"
export JANA_PLUGIN_PATH=/plugins
#jana -PPLUGINS=JTest -Pjana:nevents=100
echo "------------------------"

echo "--- tests --------------"
export JANA_PLUGIN_PATH=/plugins
#tests
echo "------------------------"

