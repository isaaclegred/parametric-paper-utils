import numpy as np
import pandas as pd
target_file="corrected_no_j0740_post.csv"

to_replace="logweight_total"

out_name="corrected_all_miller_no_logweight.csv"

target_data = pd.read_csv(target_file)

target_data.drop(labels=to_replace, axis="columns", inplace=True)

header_list = target_data.columns
header= ""
for elt in header_list:
    header+=elt+","
header=header[:-1]
writeable_data = np.array(target_data)

np.savetxt(out_name,writeable_data, delimiter=",", header=header)
