#!/bin/bash
counter="$1"
echo $counter
TAGS="$2"
EOS_DIR_TAGS="$3"
EOS_CS2C2_DIR_TAGS="$4"
EOS_PER_DIR="$5"

MAX_NUM_SAMPLES=350000
echo $TAGS
# This is kinda a silly thing to do, but it will work for now
# Hardcode this if it's easier than worrying about where
# you call functions from
cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting

#TAGS="$TAGS qmc-hadagn-0.5rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS qmc-hadagn-0.6rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS qmc-hadagn-0.7rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS qmc-hadagn-0.8rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS qmc-hadagn-0.9rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS qmc-hadagn-1.0rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS qmc-hadagn-1.1rho_nuc-ingo-bps-3e11"

#TAGS="$TAGS mbpt-hadagn-0.5rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-0.6rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-0.7rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-0.8rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-0.9rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-1.0rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-1.1rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-1.2rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-1.3rho_nuc-ingo-bps-3e11"
#TAGS="$TAGS mbpt-hadagn-1.4rho_nuc-ingo-bps-3e11"

#TAGS="$TAGS mrgagn-ingo-bps-1e10"




EOS_COUNT_ARR=($EOS_PER_DIR)

PRETAGS=($TAGS)
PRETAG=${PRETAGS[$counter]}

TAG="/corrected_"$PRETAG"_post.csv"
OUTTAG="/corrected_"$PRETAG"_post_test.csv"
EOS_DIRS=($EOS_DIR_TAGS)
EOS_DIR=${EOS_DIRS[$counter]}
EOS_DIRS_CS2=($EOS_CS2C2_DIR_TAGS)
EOS_DIR_cs2c2=${EOS_DIRS_CS2[$counter]}
INPATH=$MAIN_DIR$TAG
OUTPATH=$INPATH
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}



#look up macroscopic paramers
#Compute rho_c (M @ Mmax)
$(which process2samples) \
    $INPATH \
    $OUTPATH \
    M \
    rhoc \
    --eos-column eos \
    --eos-dir ${EOS_DIR} \
    --eos-num-per-dir ${EOS_NUM_PER_DIR} \
    --eos-basename 'macro-draw-%(draw)06d.csv' \
    --selection-rule "nearest_neighbor" \
    --branches-basename 'macro-draw-%(draw)06d-branches.csv' rhoc start_baryon_density end_baryon_density \
    --default-value rhoc 1e16 \
    --branches-dir ${EOS_DIR_cs2c2} \
    --max-num-samples $MAX_NUM_SAMPLES \
    --reference-value-column Mmax \
    --overwrite\
    -v
# Compute cs2c2max for rho < rhoc(M @ Mmax)
$(which process2extrema) \
    $OUTPATH \
    $OUTPATH \
    cs2c2\
    --copy-column  "logweight_total" \
    --copy-column "Mmax" \
    --copy-column "pressurec2(baryon_density=2.8e+14)" \
    --copy-column "pressurec2(baryon_density=5.6e+14)"\
    --copy-column "pressurec2(baryon_density=1.68e+15)"\
    --copy-column "pressurec2(baryon_density=1.96e+15)"\
    --copy-column "energy_densityc2(baryon_density=2.8e+14)"\
    --copy-column "energy_densityc2(baryon_density=5.6e+14)"\
    --copy-column "energy_densityc2(baryon_density=1.68e+15)" \
    --copy-column "energy_densityc2(baryon_density=1.96e+15)" \
    --copy-column "R(M=1.4)" \
    --copy-column "R(M=2.0)" \
    --copy-column "Lambda(M=1.4)" \
    --copy-column "Lambda(M=2.0)" \
    --copy-column "DeltaR(2.0-1.4)" \
    --copy-column "rhoc(M@Mmax)" \
    --dynamic-maximum baryon_density "rhoc(M@Mmax)" \
    --new-column cs2c2 cs2c2max cs2c2min \
    --column-range cs2c2 0.0 1.0 \
    --eos-column eos \
    --eos-dir ${EOS_DIR_cs2c2} \
    --eos-num-per-dir ${EOS_NUM_PER_DIR} \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --max-num-samples $MAX_NUM_SAMPLES \
    -v

#--selection-rule "nearest_neighbor" \
$(which process2samples) \
    $OUTPATH \
    $OUTPATH \
    cs2c2 \
    baryon_density pressurec2 \
    --eos-column eos \
    --eos-dir ${EOS_DIR_cs2c2} \
    --selection-rule "nearest_neighbor" \
    --eos-num-per-dir ${EOS_NUM_PER_DIR} \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --reference-value-column cs2c2max \
    --overwrite\
    -v
