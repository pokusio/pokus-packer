#!/bin/bash

export GOLANG_VERSION_DEFAULT="1.18.3"

if [ "x${GOLANG_VERSION}" == "x" ]; then
  echo "[$0] - The GOLANG_VERSION environment variable is not set, so it will default to [${GOLANG_VERSION_DEFAULT}] "
fi;


export GOLANG_VERSION=${GOLANG_VERSION:-"${GOLANG_VERSION_DEFAULT}"}
echo "GOLANG_VERSION=[${GOLANG_VERSION}]"


curl -LO https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz -o ./go${GOLANG_VERSION}.linux-amd64.tar.gz

rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz


export PATH=$PATH:/usr/local/go/bin
go version
