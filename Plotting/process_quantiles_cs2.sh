#!/bin/bash

### test extracting quantiles
############################
# THIS WILL HAVE TO CHANGE TO BE THE
# ONE COPIED OVER WITH CS2C2
counter=$1
export NONPAR_EOS_DIR="/home/philippe.landry/nseos/eos/gp/mrgagn/"
export NONPAR_EOS_DIR_CS2C2="/home/isaac.legred/local_mrgagn_big_with_cs2c2/"
export SPECTRAL_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_spectral/"
export PIECEWISE_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_piecewise/"
export SOS_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_sos/"
EOS_PER_DIR="1000 100 100"
TAGS="np_all sp_all pp_all"

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting


# #echo \
EOS_DIR_TAGS="$NONPAR_EOS_DIR $SPECTRAL_EOS_DIR $PIECEWISE_EOS_DIR $SOS_EOS_DIR"
EOS_COUNT_ARR=($EOS_PER_DIR)


EOS_CS2C2_DIR_TAGS="$NONPAR_EOS_DIR_CS2C2 $SPECTRAL_EOS_DIR $PIECEWISE_EOS_DIR $SOS_EOS_DIR"
EOS_DIRS_CS2=($EOS_CS2C2_DIR_TAGS)
EOS_DIR_cs2c2=${EOS_DIRS_CS2[$counter]}


PRETAGS=($TAGS)
PRETAG=${PRETAGS[$counter]}



TAG="/corrected_"$PRETAG"_post.csv"
EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}
INPATH=$POST_DIR_5$TAG
echo $INPATH
OUTPATH=$INPATH
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}



# Since we only care about cs2 information,
# we exclusively use the cs2 directories here
# process2quantiles \
#     $MAIN_DIR"/"$TAG \
#     $MAIN_DIR"/"$PRETAG"_quantiles_cs2.csv"\
#     baryon_density \
#     cs2c2 \
#     2.8e13 2.8e15 \
#     --logcolumn baryon_density \
#     --max-num-samples 200000 \
#     --weight-column logweight_total \
#     --weight-column-is-log logweight_total \
#     --eos-column eos \
#     --eos-dir $EOS_DIR_cs2c2 \
#     --eos-num-per-dir $EOS_NUM_PER_DIR \
#     --eos-basename 'eos-draw-%(draw)06d.csv' \
#     --num-points 100 \
#     --Verbose 


# Prior is special case
process2quantiles \
    $MAIN_DIR"/"$TAG \
    $MAIN_DIR"/"$PRETAG"_prior_quantiles_cs2.csv"\
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
