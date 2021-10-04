ls#!/bin/bash

### test extracting quantiles
############################
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


# #echo \




EOS_DIRS_CS2=($EOS_CS2C2_DIR_TAGS)
EOS_DIR_cs2c2=${EOS_DIRS_CS2[$counter]}


PRETAGS=($TAGS)
PRETAG=${PRETAGS[$counter]}



TAG="/corrected_"$PRETAG"_post.csv"
EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}

EOS_COUNT_ARR=($EOS_PER_DIR)
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}

echo "EOS_NUM_PER_DIR is"
echo $EOS_NUM_PER_DIR

# Since we only care about cs2 information,
# we exclusively use the cs2 directories here
process2quantiles \
    $MAIN_DIR"/"$TAG \
    $MAIN_DIR"/"$PRETAG"_cs2_quantiles.csv"\
    baryon_density \
    cs2c2 \
    2.8e13 2.8e15 \
    --logcolumn baryon_density \
    --max-num-samples 200000 \
    --weight-column logweight_total \
    --weight-column-is-log logweight_total \
    --eos-column eos \
    --eos-dir $EOS_DIR_cs2c2 \
    --eos-num-per-dir $EOS_NUM_PER_DIR \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --num-points 100 \
    --Verbose 


# Prior is special case
process2quantiles \
    $MAIN_DIR"/"$TAG \
    $MAIN_DIR"/"$PRETAG"_prior_cs2_quantiles.csv"\
    baryon_density \
    cs2c2 \
    2.8e13 2.8e15 \
    --logcolumn baryon_density \
    --max-num-samples 80000 \
    --eos-column eos \
    --eos-dir $EOS_DIR_cs2c2 \
    --eos-num-per-dir $EOS_NUM_PER_DIR\
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --num-points 100 \
    --Verbose
