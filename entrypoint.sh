#!/bin/bash
#
# This is run from within the temporary janatest container
# that gets built by GitHub as part of a GitHub Action to test
# pull requests and commits to master.
#
# The JANA software will be installed in /usr and the plugins
# in /plugins.
#

export BRANCH=$1
echo "--- Building JANA for branch $BRANCH --------------"
cd /opt/JANA2
git checkout $BRANCH
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/JANA2/Linux -DCMAKE_CXX_STANDARD=17
make -j8 install
echo "------------------------"


echo "--- JTest --------------"
export JANA_PLUGIN_PATH=/plugins
jana -PPLUGINS=JTest -Pjana:nevents=100
echo "------------------------"

