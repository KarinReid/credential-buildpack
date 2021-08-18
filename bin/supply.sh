#!/usr/bin/env bash
set -eo pipefail

BUILD_DIR=${1}
CACHE_DIR=${2}
DEPS_DIR=${3}
INDEX=${4}

PASSWORD=1234
KEY=myKey.pem
CERT=myCert.crt
KEYSTORE=myKeystore.pfx

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
#  echo 'Hello World!' > hello_world.txt

echo Generating Self-signed Certificate
echo Generating Key and certificate
openssl genrsa -out $KEY
openssl req -new -x509 -key $KEY -out $CERT -days 365 -config conf.cnf

echo Generating Keystore
openssl pkcs12 -export -out $KEYSTORE -inkey $KEY -in $CERT -passout pass:$PASSWORD -name "$KEYSTORE"
openssl pkcs12 -passout pass:$PASSWORD -export -out $KEYSTORE -inkey $KEY -in $CERT

echo Printing Keystore contents
keytool -list -v -keystore $KEYSTORE -storepass $PASSWORD
popd

# Create a .profile folder within the build directory
mkdir -p "${BUILD_DIR}/.profile.d"
# Create a param to reference build .profile + script
# custom_credentials.sh will be run when the app starts. Can be named whatever you want.
CUSTOM_KEYSTORE_PATH="${BUILD_DIR}/.profile.d/custom_credentials.sh"
# Make CUSTOM_KEYSTORE available as env variable when the script is run.
echo "export CUSTOM_KEYSTORE=/var/vcap/deps/${INDEX}/${KEYSTORE}" > "${CUSTOM_KEYSTORE_PATH}"