#!/usr/bin/bash
# An example script for extracting all covariates
COUNT="$1"
NONPAR_EOS_DIR="/home/philippe.landry/gpr-eos-stacking/EoS/mrgagn/"
NONPAR_EOS_DIR_cs2c2="/home/isaac.legred/local_mrgagn_big_with_cs2/"
SPECTRAL_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_spectral/"
PIECEWISE_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_piecewise/"
SOS_EOS_DIR="/home/isaac.legred/parametric-eos-priors/eos_draws/production_eos_draw_sos/"


TAGS="pp_all cs_all"
EOS_DIR_TAGS="$PIECEWISE_EOS_DIR $SOS_EOS_DIR "
EOS_CS2C2_DIR_TAGS="$PIECEWISE_EOS_DIR $SOS_EOS_DIR"
EOS_PER_DIR="100 100"



bash $HOME/ParametricPaper/Analysis/Utils/Plotting/add_all_covariates.sh  "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"
