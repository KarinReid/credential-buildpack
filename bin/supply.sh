#!/usr/bin/env bash
set -eo pipefail

BUILD_DIR=${1}
CACHE_DIR=${2}
DEPS_DIR=${3}
INDEX=${4}

BUILDPACK_DIR=$(dirname $(readlink -f ${BASH_SOURCE%/*}))

echo "BUILDPACK_DIR = ${BUILDPACK_DIR}"
echo "BUILD_DIR     = ${BUILD_DIR}"
echo "CACHE_DIR     = ${CACHE_DIR}"
echo "DEPS_DIR      = ${DEPS_DIR}"
echo "INDEX         = ${INDEX}"

# pushd: save current dir to stack. Move to new dir.
pushd "${DEPS_DIR}/${INDEX}"
  # Create hello_world.txt file within DEPS_DIR/INDEX
  # This will eventually be replaced. The aim is to provide a keystore.
  echo 'Hello World!' > hello_world.txt
popd

# Create a .profile folder within the build directory
mkdir -p "${BUILD_DIR}/.profile.d"
# Create an param to reference build .profile + script
# source_me.sh - found in etc folder
CUSTOM_KEYSTORE_PATH="${BUILD_DIR}/.profile.d/source_me.sh"
# Make CUSTOM_KEYSTORE available as env variable
echo "export CUSTOM_KEYSTORE=/var/vcap/deps/${INDEX}/hello_world.txt" > "${CUSTOM_KEYSTORE_PATH}"