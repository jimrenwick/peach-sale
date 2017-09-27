#!/bin/bash

set -x
for f in $(find ~/Downloads/ -name orders_\*.csv -newer ~/Downloads/boa.hold); do
    new_name=$(basename $f .csv).tsv
    cp $f data/$new_name
done
set +x

