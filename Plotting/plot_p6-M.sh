#!/bin/bash

### make plots of nuclear parameters alongside EoS params and macroscopic observables

# E_beta,E_PNM,x,S0,L,Ksym,eps_total,eps_electron,mu_electron,EoS,Mmax,numbranches,logweight_NICER,logweight_GW170817,logweight_GW190425,logweight_J0348,logweight_J0740,logweight_J1614,pressurec2(baryon_density=1.4e+14),pressurec2(baryon_density=2.8e+14),pressurec2(baryon_density=4.2e+14),pressurec2(baryon_density=5.6e+14),pressurec2(baryon_density=8.4e+14),pressurec2(baryon_density=1.12e+15),energy_densityc2(baryon_density=1.4e+14),energy_densityc2(baryon_density=2.8e+14),energy_densityc2(baryon_density=4.2e+14),energy_densityc2(baryon_density=5.6e+14),energy_densityc2(baryon_density=8.4e+14),energy_densityc2(baryon_density=1.12e+15),R(M=1.4),R(M=1.6),Lambda(M=1.4),Lambda(M=1.6)

#-------------------------------------------------

NUM_POINTS=101
MAX_NUM_SAMPLES=100000


#---

# plot different posteriors for the same set of prior draws
TAGS="/home/philippe.landry/nseos/eos/gp/mrgagn/"

for TAG in $TAGS
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

    NP_SAMPS=$MAIN_DIR"/corrected_np_all_current_post.csv"
    PAR_SAMPS=$MAIN_DIR"/corrected_par_all_current_post.csv"
    
    NPPRIOR="PRIOR(NONPARAMETRIC)"
    PARPRIOR="PRIOR(PARAMETRIC)"
    PSR="PSR"
    PSRGW="PSR+GW"
    NP="NONPARAMETRIC"
    PAR="PARAMETRIC"

    DEFAULT_COLOR_SCHEME="--color $NP deepskyblue ""--color $NPPRIOR blue "" --color $PAR magenta ""--color  $PARPRIOR red"


    kde-corner-samples \
        Mmax "pressurec2(baryon_density=1.68e+15)" \
        --column-label 'Mmax' '$M_{\mathrm{max}}\ [M_{\odot}]$'\
        --logcolumn 'pressurec2(baryon_density=1.68e+15)' \
        --column-label 'pressurec2(baryon_density=1.68e+15)' '$\log_{10}\left(p_{6.0}/c^2\ [\mathrm{g}/\mathrm{cm}^3]\right)$' \
        --column-range 'pressurec2(baryon_density=1.68e+15)' 14.2 15.5 \
        --column-bandwidth 'pressurec2(baryon_density=1.68e+15)' 0.10 \
        --column-multiplier "pressurec2(baryon_density=1.68e+15)" .43429\
        -s $NP $NP_SAMPS \
        --weight-column $NP logweight_total\
        --weight-column-is-log $NP logweight_total\
        -s $NPPRIOR $NP_SAMPS\
        -s $PARPRIOR $PAR_SAMPS\
        -s $PAR $PAR_SAMPS \
        --weight-column $PAR logweight_total\
        --weight-column-is-log $PAR logweight_total\
        $DEFAULT_COLOR_SCHEME \
        --output-dir $MAIN_DIR \
        --tag "Mmax_pressure" \
        --num-proc 2 \
        --num-points $NUM_POINTS \
        --no-scatter\
        --level 0.9 \
        --legend \
        --grid \
        --rotate-xticklabels 90 \
        --figwidth 6 \
        --figheight 6 \
        --Verbose         
done
