#!/bin/bash

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting

EOS_DIR="/home/philippe.landry/gpr-eos-stacking/EoS/mrgagn/"
OUTPUT_EOS_DIR=$HOME"/local_mrgagn_big_with_cs2/"
NUM_PER_DIR=1000
DIR_INDEX=$MAIN_DIR/used_eos.csv
process-calculus \
    $DIR_INDEX \
    differentiate \
    energy_densityc2 \
    pressurec2 \
    --new-column cs2c2 \
    --eos-num-per-dir $NUM_PER_DIR \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --eos-dir $EOS_DIR\
    --eos-column eos \
    --output-eos-dir $OUTPUT_EOS_DIR
