#!/bin/bash

DIR=$(pwd)

for f in $(git ls-files) ; do
    if [ "$f" != "setup.sh"] ; then
	( cd ~/  && mkdir -p "$(dirname $f)" && ln -s "$DIR/$f" "$(dirname $f)/" )
    fi
done
