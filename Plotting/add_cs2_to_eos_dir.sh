#!/bin/bash
counter=$1
cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting

NONPAR_EOS_DIR="/home/philippe.landry/gpr-eos-stacking/EoS/mrgagn/"
SP_EOS_DIR=$HOME"/parametric-eos-priors/eos_draws/production_eos_draw_spectral/"
PP_EOS_DIR=$HOME"/parametric-eos-priors/eos_draws/production_eos_draw_piecewise/"
SOS_EOS_DIR=$HOME"/parametric-eos-priors/eos_draws/production_eos_draw_sos/"



EOS_DIR_TAGS="$SP_EOS_DIR $PP_EOS_DIR $SOS_EOS_DIR"
EOS_PER_DIR="100 100 100"
EOS_COUNT_ARR=($EOS_PER_DIR)


EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}
INPATH=$MAIN_DIR$TAG
echo $INPATH
OUTPATH=$INPATH
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}
DIR_INDEX=$MAIN_DIR/par_dir_index.csv

process-calculus \
    $DIR_INDEX \
    differentiate \
    energy_densityc2 \
    pressurec2 \
    --new-column cs2c2 \
    --eos-num-per-dir $EOS_NUM_PER_DIR \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --eos-dir $EOS_DIR\
    --eos-column eos\
    --overwrite\
    --Verbose
#    --output-eos-dir $OUTPUT_EOS_DIR
