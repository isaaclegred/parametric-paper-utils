#!/bin/bash
#--output-eos-dir $HOME"/local_mrgagn_big_with_cs2c2/"\
# Only run once for the collated results
cd ../..
MAIN_DIR=$(pwd)
cd Utils/Plotting

NONPAR_EOS_DIR="/home/philippe.landry/gpr-eos-stacking/EoS/mrgagn/"
PAR_EOS_DIR=$HOME"/parametric-eos-priors/production_eos_draw_spectral/"
process2branch-properties \
    $MAIN_DIR"/par_dir_index_spec.csv" \
    --macro2eos-central-baryon-density rhoc baryon_density \
    --mass-column M \
    --output-macro-column R \
    --output-macro-column Lambda \
    --output-eos-column baryon_density \
    --output-eos-column pressurec2 \
    --output-eos-column energy_densityc2 \
    --eos-column eos \
    --eos-dir $PAR_EOS_DIR \
    --eos-num-per-dir 200 \
    --eos-basename 'eos-draw-%(draw)06d.csv' \
    --macro-basename 'macro-draw-%(draw)06d.csv' \
    --Verbose

