#!/bin/bash

counter="$1"
echo "counter in add-covariates"
echo $counter
TAGS="$2"
EOS_DIR_TAGS="$3"
EOS_CS2C2_DIR_TAGS="$4"
EOS_PER_DIR="$5"



cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting





PRETAGS=($TAGS)
PRETAG=${PRETAGS[$counter]}


TAG=$PRETAG"_post.csv"
EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}

EOS_DIRS_cs2c2=($EOS_CS2C2_DIR_TAGS)
EOS_DIR_cs2c2=${EOS_DIRS_cs2c2[$counter]}

EOS_COUNT_ARR=($EOS_PER_DIR)
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}



process2quantiles \
    $MAIN_DIR"/"$TAG \
    $MAIN_DIR"/"$PRETAG"_mr_quantiles.csv"\
    M \
    R \
    .6 2.9 \
    --max-num-samples 140000 \
    --weight-column logweight_total \
    --weight-column-is-log logweight_total \
    --eos-column eos \
    --eos-dir $EOS_DIR \
    --eos-num-per-dir $EOS_NUM_PER_DIR \
    --eos-basename 'macro-draw-%(draw)06d.csv' \
    --selection-rule random \
    --branches-basename 'macro-draw-%(draw)06d-branches.csv' rhoc start_baryon_density end_baryon_density \
    --branches-dir $EOS_DIR_cs2c2 \
    --num-points 100 \
    --Verbose 


# Prior is special case
process2quantiles \
    $MAIN_DIR"/"$TAG \
    $MAIN_DIR"/"$PRETAG"_prior_mr_quantiles.csv" \
    M \
    R \
    .6 2.9 \
    --max-num-samples 70000 \
    --eos-column eos \
    --eos-dir $EOS_DIR \
    --eos-num-per-dir $EOS_NUM_PER_DIR \
    --eos-basename 'macro-draw-%(draw)06d.csv' \
    --selection-rule random \
    --branches-basename 'macro-draw-%(draw)06d-branches.csv' rhoc start_baryon_density end_baryon_density \
    --branches-dir $EOS_DIR_cs2c2 \
    --num-points 100 \
    --Verbose




