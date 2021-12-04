#!/bin/bash

### make plots of nuclear parameters alongside EoS params and macroscopic observables

# E_beta,E_PNM,x,S0,L,Ksym,eps_total,eps_electron,mu_electron,EoS,Mmax,numbranches,logweight_NICER,logweight_GW170817,logweight_GW190425,logweight_J0348,logweight_J0740,logweight_J1614,pressurec2(baryon_density=1.4e+14),pressurec2(baryon_density=2.8e+14),pressurec2(baryon_density=4.2e+14),pressurec2(baryon_density=5.6e+14),pressurec2(baryon_density=8.4e+14),pressurec2(baryon_density=1.12e+15),energy_densityc2(baryon_density=1.4e+14),energy_densityc2(baryon_density=2.8e+14),energy_densityc2(baryon_density=4.2e+14),energy_densityc2(baryon_density=5.6e+14),energy_densityc2(baryon_density=8.4e+14),energy_densityc2(baryon_density=1.12e+15),R(M=1.4),R(M=1.6),Lambda(M=1.4),Lambda(M=1.6)

#-------------------------------------------------

NUM_POINTS=101
MAX_NUM_SAMPLES=100000


#---

# plot different posteriors for the same set of prior draws
#TAGS="/home/philippe.landry/nseos/eos/gp/mrgagn/"

declare -A TAGMAP
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

PARTAGS="cs sp pp"
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

    PARTAG=${TAGMAP[$TAG]}
    NP_SAMPS=$MAIN_DIR"/corrected_np_all_post.csv"
    
    REFERENCE="causality"
    REFERENCE_DATA=$HOME"/ParametricPaper/ExternalResults/kalogera-baym-mr.csv"

    NPPRIOR="nonparametric (prior)"
    PSR="PSR"
    PSRGW="PSR+GW"
    NP="nonparametric (astro)"

    # These things will have to change for each parametric instance
    PAR_SAMPS=$MAIN_DIR"/corrected_${TAG}_all_post.csv"
    PARPRIOR="${PARTAG} (prior)"
    PAR="${PARTAG} (astro)"
    


    kde-corner-samples \
        "pressurec2(baryon_density=5.6e+14)" "pressurec2(baryon_density=1.68e+15)" \
        --logcolumn 'pressurec2(baryon_density=5.6e+14)' \
        --column-label 'pressurec2(baryon_density=5.6e+14)' '$\log_{10}\left(p_{2.0}/c^2\ [\mathrm{g}/\mathrm{cm}^3]\right)$' \
        --logcolumn 'pressurec2(baryon_density=1.68e+15)' \
        --column-label 'pressurec2(baryon_density=1.68e+15)' '$\log_{10}\left(p_{6.0}/c^2\ [\mathrm{g}/\mathrm{cm}^3]\right)$' \
        --column-range 'pressurec2(baryon_density=1.68e+15)' 14.2 15.5 \
        --column-range 'pressurec2(baryon_density=5.6e+14)' 12.9 14.38 \
        --column-bandwidth 'pressurec2(baryon_density=1.68e+15)' 0.10 \
        --column-bandwidth 'pressurec2(baryon_density=5.6e+14)' 0.08 \
        --column-multiplier "pressurec2(baryon_density=1.68e+15)" .43429\
        --column-multiplier "pressurec2(baryon_density=5.6e+14)" .43429\
        -s "$NP" $NP_SAMPS \
        --weight-column "$NP" logweight_total\
        --weight-column-is-log "$NP" logweight_total\
        -s "$NPPRIOR" $NP_SAMPS\
        -s "$PARPRIOR" $PAR_SAMPS\
        -s "$PAR" $PAR_SAMPS \
        --color "$NP" ${COLORS["np"]}\
        --color "$NPPRIOR" ${COLORS["np_prior"]}\
        --color "$PAR" ${COLORS[$TAG]}\
        --color "$PARPRIOR" ${COLORS[${TAG}_"prior"]}\
        --linestyle "$NPPRIOR" "dashdot"\
        --linestyle "$PARPRIOR" "dashdot"\
        --weight-column "$PAR" logweight_total\
        --weight-column-is-log "$PAR" logweight_total\
        --output-dir $MAIN_DIR \
        --tag "${TAG}-p2-p6"\
        --num-proc 2 \
        --num-points $NUM_POINTS \
        --level .9\
        --legend \
        --no-scatter\
        --grid \
        --rotate-xticklabels 90 \
        --figwidth 5 \
        --figheight 5 \
        --Verbose
done
