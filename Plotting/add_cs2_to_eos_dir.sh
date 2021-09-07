#!/bin/bash

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting

#EOS_DIR="/home/philippe.landry/gpr-eos-stacking/EoS/mrgagn/"
EOS_DIR=/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_sos
#OUTPUT_EOS_DIR=$HOME"/local_mrgagn_big_with_cs2/"
NUM_PER_DIR=100
# All parametric directories currently have the same dir. structure
DIR_INDEX=$MAIN_DIR/par_dir_index.csv
SUBDIR_INDEX="$EOS_DIR/DRAWmod100-000180/subdir_index.csv"
process-calculus \
    $DIR_INDEX \
    differentiate \
    energy_densityc2 \
    pressurec2 \
    --new-column cs2c2 \
    --eos-num-per-dir $NUM_PER_DIR \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --eos-dir $EOS_DIR\
    --eos-column eos\
    --overwrite
#    --output-eos-dir $OUTPUT_EOS_DIR
