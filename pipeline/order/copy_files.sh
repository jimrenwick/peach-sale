#!/bin/bash

set -x
for f in $(ls ~/Downloads/orders_*.csv); do
    new_name=$(basename $f .csv).tsv
    cp $f data/$new_name
done
set +x

