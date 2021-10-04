#!/usr/bin/bash
COUNT="$1"
TAGS="$2"
EOS_DIR_TAGS="$3"
EOS_CS2C2_DIR_TAGS="$4"
EOS_PER_DIR="$5"

EXEC_DIR=$HOME/ParametricPaper/Analysis/Utils/Plotting/


###############################

##############################
# Comment out the lines you don't want
# (for example, the transition mass is not
# particularly  useful for the parametric models)
###############################
echo $EXEC_DIR/add-covariates "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"
$EXEC_DIR/add-covariates "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"

echo $EXEC_DIR/add_delta_r.sh "$COUNT" "$TAGS"
$EXEC_DIR/add_delta_r.sh "$COUNT" "$TAGS"

echo $EXEC_DIR/correct_cs2.sh "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"
$EXEC_DIR/correct_cs2.sh "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"

echo $EXEC_DIR/add_num_branch.sh "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"
$EXEC_DIR/add_num_branch.sh "$COUNT" "$TAGS" "$EOS_DIR_TAGS" "$EOS_CS2C2_DIR_TAGS" "$EOS_PER_DIR"

#add-transition-mass


