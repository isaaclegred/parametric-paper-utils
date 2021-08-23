#Extract the relevant columns from posterior csv to create an analogous prior csv that can be
# used in the plotting functions.
import numpy as np
import argparse

tags = ["np_all_current"]
output_path = "used_eos.csv"
unique_eos = set({})
for tag in tags:
    source_path = tag + "_post.csv"
    source_data = np.loadtxt(source_path,skiprows=1,delimiter=",")
    eos = set(source_data[:,0])
    unique_eos = unique_eos.union(eos)
unique_eos = np.array(list(unique_eos))
unique_eos = np.transpose(unique_eos)
np.savetxt(output_path, unique_eos,  header = "eos", comments="", delimiter=",")
