#!/bin/bash
TAGS="pp_all cs_all"
COLUMNS="R(M=1.4)"
RANGE=".01 3"
WRITETAG=$COLUMNS"_prior"

for TAG in $TAGS
do
    INPATH="corrected_"$TAG"_post.csv"
    COLUMNS="$COLUMNS"
    echo "$COLUMNS"
    optimize-bandwidth \
        $INPATH \
        $COLUMNS \
        $RANGE \
        --num-withheld 100 \
        --tag $WRITETAG \
        --max-num-samples 1000 \
        --verbose
done 
