#!/bin/sh -l
#
# This is run from within the temporary janatest container
# that gets built by GitHub as part of a GitHub Action to test
# pull requests and commits to master.
#
# The JANA software will be installed in /usr and the plugins
# in /plugins.
#
export JANA_PLUGIN_PATH=/plugins

echo "--- JTest --------------"
time=$(date)
jana -PPLUGINS=JTest -Pjana:nevents=100
echo "------------------------"

