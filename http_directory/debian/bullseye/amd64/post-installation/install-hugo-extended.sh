#!/bin/bash

export HUGO_VERSION_DEFAULT="0.100.2"

if [ "x${HUGO_VERSION}" == "x" ]; then
  echo "[$0] - The HUGO_VERSION environment variable is not set, so it will default to [${HUGO_VERSION_DEFAULT}] "
fi;

export PATH=$PATH:/usr/local/go/bin
# check you hugo version with [hugo version] command
# My hugonon extended installed  version was [v0.78.2] so I set HUGO_VERSION to 0.78.2 (without the v, to be pure semver)
# Set the HUGO_VERSION to the version of your hugo installation
# export HUGO_VERSION=0.78.2
export HUGO_VERSION=${HUGO_VERSION:-"${HUGO_VERSION_DEFAULT}"}
echo "HUGO_VERSION=[${HUGO_VERSION}]"

mkdir -p ~/.hugo.extended/v${HUGO_VERSION}
export GOPATH=~/.hugo.extended/v${HUGO_VERSION}/

git clone https://github.com/gohugoio/hugo.git ~/.hugo.extended/v${HUGO_VERSION}
cd ~/.hugo.extended/v${HUGO_VERSION}
git checkout "v${HUGO_VERSION}"

go install --tags extended
# Now hugo binary is installed at $GOPATH/bin/hugo 

ln -s $GOPATH/bin/hugo /usr/local/bin/hugo
hugo version
