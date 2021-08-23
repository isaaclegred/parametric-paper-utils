TAGS="np_all_current spec_all_current"
for TAG in $TAGS
do
    cp $TAG"_post.csv" "corrected_"$TAG"_post.csv"
done
# I don't know about this either
cd Utils/Plotting
condor_submit add_submit
cd ../..



