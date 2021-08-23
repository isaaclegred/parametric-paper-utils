#!/bin/bash

### test extracting quantiles
export NONPAR_EOS_DIR="/home/philippe.landry/nseos/eos/gp/mrgagn/"
EOS_PER_DIR="200"
export PAR_EOS_DIR="/home/isaac.legred/parametric-eos-priors/production_eos_draw_spectral/"
TAGS="corrected_spec_all_current"

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting


# #echo \
EOS_DIR_TAGS="$PAR_EOS_DIR $NONPAR_EOS_DIR $NONPAR_EOS_DIR $NONPAR_EOS_DIR"
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
    
    process2quantiles \
        $MAIN_DIR"/"$TAG \
        $MAIN_DIR"/"$PRETAG"_mr_quantiles.csv"\
        M \
        R \
        .6 2.9 \
        --max-num-samples 6000 \
        --weight-column logweight_total \
        --weight-column-is-log logweight_total \
        --eos-column eos \
        --eos-dir $EOS_DIR \
        --eos-num-per-dir $EOS_NUM_PER_DIR \
        --eos-basename 'macro-draw-%(draw)06d.csv' \
        --selection-rule random \
        --branches-basename 'macro-draw-%(draw)06d-branches.csv' rhoc start_baryon_density end_baryon_density \
        --branches-dir $PAR_EOS_DIR \
        --num-points 100 \
        --Verbose 
done

# Prior is special case
process2quantiles \
    $MAIN_DIR"/corrected_spec_all_current_post.csv" \
    $MAIN_DIR"/prior_mr_quantiles.csv"\
    M \
    R \
    .6 2.9 \
    --max-num-samples 6000 \
    --eos-column eos \
    --eos-dir $PAR_EOS_DIR \
    --eos-num-per-dir 200 \
    --eos-basename 'macro-draw-%(draw)06d.csv' \
    --selection-rule random \
    --branches-basename 'macro-draw-%(draw)06d-branches.csv' rhoc start_baryon_density end_baryon_density \
    --branches-dir $PAR_EOS_DIR \
    --num-points 100 \
    --Verbose
