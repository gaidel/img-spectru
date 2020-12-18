#! /usr/bin/env bash
docker run --privileged -i --rm -v $(pwd):/mnt urpylka/img-tool:0.7.1 /bin/bash img-tool $1 exec hzchevo.sh