#!/bin/bash

### make plots of nuclear parameters alongside EoS params and macroscopic observables


NUM_POINTS=101
MAX_NUM_SAMPLES=100000


#---

# Choose which parametric tags to make the plots for
PARTAGS="sp"


declare -A TAGMAP
# Each parametric model has a Tag and a namedeclare -A TAGMAP
declare -A COLORS
TAGMAP["sp"]="spectral"
TAGMAP["pp"]="piecewise"
TAGMAP["cs"]="speed-of-sound"

COLORS["np"]="deepskyblue"
COLORS["np_prior"]="blue"
COLORS["sp"]="orange"
COLORS["sp_prior"]="darkgoldenrod"
COLORS["pp"]="sandybrown"
COLORS["pp_prior"]="saddlebrown"
COLORS["cs"]="lightcoral"
COLORS["cs_prior"]="darkred"


for TAG in $PARTAGS
do

    echo "----------"
    echo "processing $TAG"
    echo "----------"
    # Again this is silly but will make things easier
    # This script should only be called by condor, and in particular with
    # the submit file that requires you to be in the correct directory anways
    # this shouldn't cause big problems for now
    cd ../..
    MAIN_DIR=$(pwd)
    cd Utils/Plotting

    PARNAME=${TAGMAP[$TAG]}
    echo TAG is $TAG
    echo PARNAME is $PARNAME
    NP_SAMPS=$MAIN_DIR"/corrected_np_all_post.csv"
    PAR_SAMPS=$MAIN_DIR"/corrected_${TAG}_all_post.csv"
    
    NPPRIOR="nonparametric (prior)"
    PARPRIOR="${PARNAME} (prior)"
    PSR="PSR"
    PSRGW="PSR+GW"
    NP="nonparametric (astro)"
    PAR="$PARNAME (astro)"

    DEFAULT_COLOR_SCHEME="--color $NP deepskyblue ""--color $NPPRIOR blue "" --color $PAR orange
  ""--color  $PARPRIOR darkgoldenrod"

    REFERENCE="causality"
    REFERENCE_DATA=$HOME"/ParametricPaper/ExternalResults/kalogera-baym-mr.csv"

    kde-corner-samples \
        Mmax "R(M=1.4)" \
        --column-label 'Mmax' '$M_{\mathrm{max}}\ [M_{\odot}]$'\
        --column-label 'R(M=1.4)' '$R_{1.4}\ [\mathrm {km}]$'\
        --column-range 'Mmax' 1.9 3.0\
        --column-range 'R(M=1.4)' 8.5 16.5\
        -s "$NP" $NP_SAMPS \
        --weight-column "$NP" logweight_total\
        --weight-column-is-log "$NP" logweight_total\
        -s "$NPPRIOR" $NP_SAMPS\
        -s "$PARPRIOR" $PAR_SAMPS\
        -s "$PAR" $PAR_SAMPS \
        --linestyle "$NPPRIOR" "dashdot"\
        --linestyle "$PARPRIOR" "dashdot"\
        --weight-column "$PAR" logweight_total\
        --weight-column "$PAR" logweight_total\
        --weight-column-is-log "$PAR" logweight_total\
        --weight-column "$NPPRIOR" Mmax_prior_kde \
        --invert-weight-column "$NPPRIOR" Mmax_prior_kde \
        --weight-column-is-log "$NPPRIOR" Mmax_prior_kde \
        --weight-column "$PARPRIOR" Mmax_prior_kde \
        --invert-weight-column "$PARPRIOR" Mmax_prior_kde \
        --weight-column-is-log "$PARPRIOR" Mmax_prior_kde \
        --weight-column "$NP" Mmax_prior_kde \
        --invert-weight-column "$NP" Mmax_prior_kde \
        --weight-column-is-log "$NP" Mmax_prior_kde \
        --weight-column "$PAR" Mmax_prior_kde \
        --invert-weight-column "$PAR" Mmax_prior_kde \
        --weight-column-is-log "$PAR" Mmax_prior_kde \
        --color "$NP" ${COLORS["np"]}\
        --color "$NPPRIOR" ${COLORS["np_prior"]}\
        --color "$PAR" ${COLORS[$TAG]}\
        --color "$PARPRIOR" ${COLORS[${TAG}_"prior"]}\
        --linestyle "$NPPRIOR" "dashdot"\
        --linestyle "$PARPRIOR" "dashdot"\
        --output-dir $MAIN_DIR \
        --tag "${TAG}-Mmax_Rtyp_normalized-99" \
        --num-proc 2 \
        --num-points $NUM_POINTS \
        --level 0.99 \
        --legend \
        --no-scatter\
        --grid \
        --rotate-xticklabels 90 \
        --figwidth 5.5 \
        --figheight 5.5 \
        --reference $REFERENCE $REFERENCE_DATA\
        --reference-color $REFERENCE "k" \
        --reference-legend\
        --Verbose         
done
