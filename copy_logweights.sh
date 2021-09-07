#TARGET="./corrected_no_j0740_post.csv"
TARGET="./corrected_all_miller_no_logweight.csv"
MILLER_SAMPS="./all_miller_post.csv"
RILEY_SAMPS="./all_riley_post.csv"
PSR_SAMPS="./psr_post.csv "

# collate-samples \
#     "eos" \
#     $TARGET\
#     --omit-missing\
#     -s $MILLER_SAMPS logweight_total logweight_Miller_J0740\
#     --column-map $MILLER_SAMPS logweight_total miller_logweight_total\  
#     -v
collate-samples \
    "eos" \
    $TARGET\
    --omit-missing\
    -s $MILLER_SAMPS logweight_total\
    -v
# collate-samples \
#     "eos" \
#     $TARGET\
#     --omit-missing\
#     -s $PSR_SAMPS logweight_total logweight_Fonseca_J0740 logweight_Antoniadis_J0348\
#     --column-map $PSR_SAMPS logweight_total psr_logweight_total\
#     -v
