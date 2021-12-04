#!/usr/bin/bash
COUNT="$1"
TAGS="$2"

cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting

MAX_NUM_SAMPLES=400000

PRETAGS=($TAGS)
PRETAG=${PRETAGS[$COUNT]}

TAG="/corrected_"$PRETAG"_post.csv"
samples-calculus \
    $MAIN_DIR"/"$TAG \
    $MAIN_DIR"/"$TAG \
    subtract \
    "R(M=1.4)"\
    "R(M=2.0)" \
    --new-column "DeltaR(2.0-1.4)"\
    --overwrite
