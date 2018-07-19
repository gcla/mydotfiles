#!/bin/bash

DIR=$(pwd)

for f in $(git ls-files) ; do
    ( cd ~/  && ln -s "$DIR/$f" )
done
