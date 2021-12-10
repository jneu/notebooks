#!/bin/bash

set \
    -o errexit \
    -o pipefail \
    -o nounset

for d in $(
    find . -iname '*.ipynb' -print0 |
    xargs -0 dirname |
    sort --unique
)
do
    if test -e "$d/requirements.txt"
    then
        echo "$d"

        sudo \
        docker run \
            --interactive \
            --tty \
            --publish 127.0.0.1:8888:8888 \
            --mount type=bind,src="$(pwd)/$d,dst=/home/nb/notebooks/src,readonly" \
            nb \
            /home/nb/notebooks/run_notebooks.bash
    fi
done
