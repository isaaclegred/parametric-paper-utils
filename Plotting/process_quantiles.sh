#!/bin/bash

### test extracting quantiles
#

counter="$1"
echo "counter in add-covariates"
echo $counter
TAGS="$2"
EOS_DIR_TAGS="$3"
EOS_CS2C2_DIR_TAGS="$4"
EOS_PER_DIR="$5"
OUTTAG="$6"
LOGWEIGHT_ARGUMENTS="$7"
DONT_MAKE_PRIOR="$8"

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting


# #echo \




PRETAGS=($TAGS)
PRETAG=${PRETAGS[$counter]}
TAG=$PRETAG"_post.csv"

EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}

EOS_COUNT_ARR=($EOS_PER_DIR)
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}

OUTPATH=$MAIN_DIR"/"$PRETAG"_"$OUTTAG"_quantiles.csv"
PRIOR_OUTPATH=$MAIN_DIR"/"$PRETAG"_"$OUTTAG"_prior_quantiles.csv"

process2quantiles \
    $MAIN_DIR"/"$TAG \
    $OUTPATH\
    baryon_density \
    pressurec2 \
    2.8e13 2.8e15 \
    --logcolumn baryon_density \
    --max-num-samples 250000 \
    $LOGWEIGHT_ARGUMENTS\
    --eos-column eos \
    --eos-dir $EOS_DIR \
    --eos-num-per-dir $EOS_NUM_PER_DIR \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --num-points 100 \
    --Verbose

if [ $DONT_MAKE_PRIOR == 0 ];
then
# Get prior quantiels
    process2quantiles \
        $MAIN_DIR"/"$TAG \
        $PRIOR_OUTPATH\
        baryon_density \
        pressurec2 \
        2.8e13 2.8e15 \
        --logcolumn baryon_density \
        --max-num-samples 100000 \
        --eos-column eos \
        --eos-dir $EOS_DIR \
        --eos-num-per-dir $EOS_NUM_PER_DIR \
        --eos-basename 'eos-draw-%(draw)06d.csv' \
        --num-points 100 \
        --Verbose; 
fi
