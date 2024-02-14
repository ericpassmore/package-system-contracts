#!/bin/env bash

TAG=${1}
PACKAGE_DIR="/local/eosnetworkfoundation/packages"
NAME="system-contracts-build-cdt"

VERSION="NA"
if [ -n "$CDT_BUILD_PATH" ]; then
  VERSION=$("$CDT_BUILD_PATH"/cdt-cpp --version | cut -d" " -f3)
else
  VERSION=$(cdt-cpp --version | cut -d" " -f3)
fi

if [ "$VERSION" == "NA" ]; then
  echo "No cdt-cpp found no version exiting"
  exit 127
fi

DIR="$PACKAGE_DIR"/"$NAME"-"$VERSION"
if [ -n "$TAG" ]; then
  DIR="$PACKAGE_DIR"/"$NAME"-"$VERSION"-"$TAG"
fi

mkdir $DIR

CONTRACTS=$(find * \( -path "*CMake*" -o -path "*ricardian" -o -path "*test*" \) -prune -o -type d -print)
for c in $CONTRACTS; do
  mkdir "$DIR"/"$c"
  cp "$c"/*.abi "$DIR"/"$c"
  cp "$c"/*.wasm "$DIR"/"$c"
done

find "$DIR" -type f | xargs shasum -a 256 | sed "s#$PACKAGE_DIR/##" > "$DIR"/shasum.txt
