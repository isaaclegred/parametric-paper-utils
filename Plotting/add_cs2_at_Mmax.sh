#!/bin/bash
counter=0
echo $counter
MAX_NUM_SAMPLES=350000

#Sometimes need this
# --copy-column  "logweight_Romani_J1810" 


# These should be the only things that *need* to change
NONPAR_EOS_DIR="/home/philippe.landry/nseos/eos/gp/mrgagn/"
NONPAR_EOS_DIR_cs2c2="/home/isaac.legred/local_mrgagn_big_with_cs2c2/"
PARAMETRIC_EOS_DIR="/home/isaac.legred/parametric-eos-priors/good_gaussian_eos_draw_sos/"
EOS_PER_DIR="100 1000 1000 1000 1000"

# This may need "/home/isaac.legred/CompParNonParRuns/Plots/All/corrected_nonparametric_post.csv"to change if you change the overall convention
TAGS="all_miller"SPECTRAL_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_spectral/"
PIECEWISE_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_piecewise/"
SOS_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_sos/"


# Each of these things should be changed on a run by run basis
##############################################################
EOS_PER_DIR="100 100 100"

TAGS="sp_all pp_all cs_all"

EOS_DIR_TAGS="$SPECTRAL_EOS_DIR $PIECEWISE_EOS_DIR $SOS_EOS_DIR"
EOS_CS2C2_DIR_TAGS="$SPECTRAL_EOS_DIR $PIECEWISE_EOS_DIR $SOS_EOS_DIR"
##############################################################

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
OUTPATH=$MAIN_DIR$OUTTAG
EOS_NUM_PER_DIR=${EOS_COUNT_ARR[$counter]}



# look up macroscopic paramers
$(which process2samples) \
    $INPATH \
    $OUTPATH \
    baryon_density \
    cs2c2\
    --eos-column eos \
    --eos-dir ${EOS_DIR_cs2c2} \
    --eos-num-per-dir ${EOS_NUM_PER_DIR} \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --selection-rule "nearest_neighbor" \
    --default-value cs2c2 .7 \
    --max-num-samples $MAX_NUM_SAMPLES \
    --reference-value-column 'rhoc(M@Mmax)' \
    --Verbose
