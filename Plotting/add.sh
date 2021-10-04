FV="1 2 3"
SV="4 5 6"

FIRST_VARS=$FV
SECOND_VARS=$SV



print_arr ()
{
    args1="$1"
    args2="$2"
    array=($args1)
    len=${#array[@]}
    ## Use bash for loop 
    for (( i=0; i<$len; i++ )); do echo "${array[$i]}" ; done
    coarray=($args2)
    colen=${#coarray[@]}
    for (( k=0; k<$colen; k++ )); do
        local j=$(($colen-k - 1))
        echo "${coarray[$j]}" ; done
}
print_arr "$FIRST_VARS" "$SECOND_VARS"

# ARGS=($FIRST_VARS $SECOND_VARS)
# echo $ARGS

# ARR_ARGS=($ARGS)
# for i in 0 1
# do
#     A=${ARGS[i]}
#     for j in 0 1 2
#     do
#         echo ${A[$j]}
#     done
# done
