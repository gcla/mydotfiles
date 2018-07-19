#!/bin/bash

DIR=$(pwd)

for f in $(git ls-files) ; do
    ( cd ~/  && mkdir -p "$(dirname $f)" && ln -s "$DIR/$f" "$(dirname $f)/" )
done
