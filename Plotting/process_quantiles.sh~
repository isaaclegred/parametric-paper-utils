#!/bin/bash

### test extracting quantiles
#
export NONPAR_EOS_DIR="/home/philippe.landry/gpr-eos-stacking/EoS/mrgagn/"
export PAR_EOS_DIR="/home/isaac.legred/parametric-eos-priors/production_eos_draw_spectral/"
EOS_PER_DIR="1000 200"
TAGS="np_psr spectral_psr"

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting


# #echo \
EOS_DIR_TAGS="$NONPAR_EOS_DIR $PAR_EOS_DIR"
EOS_COUNT_ARR=($EOS_PER_DIR)
counter=0

for PRETAG in $TAGS
do
    TAG=$PRETAG"_post.csv"
    EOS_DIRS=($EOS_DIR_TAGS)
    EOS_DIR=${EOS_DIRS[$counter]}
    INPATH=$POST_DIR_5$TAG
    echo $INPATH
    OUTPATH=$INPATH
    EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}
    counter=$((counter+1))
    
    # process2quantiles \
    #     $MAIN_DIR"/"$TAG \
    #     $MAIN_DIR"/"$PRETAG"_quantiles.csv"\
    #     baryon_density \
    #     pressurec2 \
    #     2.8e13 2.8e15 \
    #     --logcolumn baryon_density \
    #     --max-num-samples 250000 \
    #     --weight-column logweight_total \
    #     --weight-column-is-log logweight_total \
    #     --eos-column eos \
    #     --eos-dir $EOS_DIR \
    #     --eos-num-per-dir $EOS_NUM_PER_DIR \
    #     --eos-basename 'eos-draw-%(draw)06d.csv' \
    #     --num-points 100 \
    #     --Verbose 
    # Get prior quantiels
    process2quantiles \
        $MAIN_DIR"/"$TAG \
        $MAIN_DIR"/"$PRETAG"_prior_quantiles.csv"\
        baryon_density \
        pressurec2 \
        2.8e13 2.8e15 \
        --logcolumn baryon_density \
        --max-num-samples 250000 \
        --eos-column eos \
        --eos-dir $EOS_DIR \
        --eos-num-per-dir $EOS_NUM_PER_DIR \
        --eos-basename 'eos-draw-%(draw)06d.csv' \
        --num-points 100 \
        --Verbose 
done
