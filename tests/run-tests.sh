#! /usr/bin/env bash

cd "$(dirname "$0")"

rm -rf ./bin
mkdir -p ./bin

# Ensure we fail immediately if any command fails.
set -e

pushd ./bin > /dev/null
  cmake ..
  make -j4
  ./test_boost
popd
