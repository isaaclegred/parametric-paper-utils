#!/bin/bash
MAX_NUM_SAMPLES=100000

#Sometimes need this
# --copy-column  "logweight_Romani_J1810" 


# This may need to change if you change the overall convention
TAGS="np_all sp_all"
BANDWIDTH_TAGS=".07 .06"
COLUMN_NAMES="Mmax"
# This is kinda a silly thing to do, but it will work for now
# Hardcode this if it's easier than worrying about where
# you call functions from
cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting




counter=0
for PRETAG in $TAGS
do
    TAG="/corrected_"$PRETAG"_post.csv"
    BANDWIDTHS=($BANDWIDTH_TAGS)
    BANDWIDTH=${BANDWIDTHS[$counter]}
    INPATH=$MAIN_DIR$TAG
    echo $INPATH
    OUTPATH=$MAIN_DIR$TAG
    EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}
    counter=$((counter+1))
    # look up pressures

    # Get the max masses
    $(which weigh-samples) \
        $INPATH \
	$INPATH \
        $INPATH \
        $COLUMN_NAMES \
        --bandwidth $BANDWIDTH \
        --output-weight-column $COLUMN_NAMES"_prior_kde"\
        -v
done
