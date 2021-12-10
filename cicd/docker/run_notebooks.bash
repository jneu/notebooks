#!/bin/bash

set \
    -o errexit \
    -o pipefail \
    -o nounset \
    -o xtrace

# install any required packages - once for all notebooks
pip install -r src/requirements.txt

# run each notebook; but first, copy the src directory
shopt -s nullglob
for n in src/*.ipynb
do
    notebook="$(basename "$n")"
    work_dir="$(basename "$notebook" .ipynb)"

    cp --archive src "$work_dir"
    (
        cd "$work_dir"

        papermill \
            --no-progress-bar \
            "$notebook" \
            _output.ipynb
    )
done
