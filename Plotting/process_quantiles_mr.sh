#!/bin/bash

counter=$1
export NONPAR_EOS_DIR="/home/philippe.landry/nseos/eos/gp/mrgagn/"
export NONPAR_EOS_DIR_CSC2="/home/isaac.legred/local_mrgagn_big_with_cs2c2/"
export SPECTRAL_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_spectral/"
export PIECEWISE_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_piecewise/"


EOS_PER_DIR="1000 100 100"
TAGS="np_all sp_all pp_all"

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting


# #echo \
EOS_DIR_TAGS="$NONPAR_EOS_DIR $SPECTRAL_EOS_DIR $PIECEWISE_EOS_DIR"
EOS_CS2C2_DIR_TAGS="$NONPAR_EOS_DIR_CSC2 $SPECTRAL_EOS_DIR $PIECEWISE_EOS_DIR"
EOS_DIRS_CS2=($EOS_CS2C2_DIR_TAGS)
EOS_DIR_cs2c2=${EOS_DIRS_CS2[$counter]}


EOS_COUNT_ARR=($EOS_PER_DIR)


PRETAGS=($TAGS)
PRETAG=${PRETAGS[$counter]}


TAG=$PRETAG"_post.csv"
EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}
INPATH=$POST_DIR_5$TAG
echo $INPATH
OUTPATH=$INPATH
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}
counter=$((counter+1))

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




