#!/bin/bash
#--output-eos-dir $HOME"/local_mrgagn_big_with_cs2c2/"\
# Only run once for the collated results
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

# All parametric draw directories currently have the same structure
process2branch-properties \
    $MAIN_DIR/par_dir_index.csv \
    --macro2eos-central-baryon-density rhoc baryon_density \
    --mass-column M \
    --output-macro-column R \
    --output-macro-column Lambda \
    --output-eos-column baryon_density \
    --output-eos-column pressurec2 \
    --output-eos-column energy_densityc2 \
    --eos-column eos \
    --eos-dir ${EOS_DIR} \
    --eos-num-per-dir $EOS_NUM_PER_DIR\
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --macro-basename 'macro-draw-%(draw)06d.csv' \
    --Verbose

