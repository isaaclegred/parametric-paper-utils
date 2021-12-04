# Plotting extracted quantiles, and overplotting tablulated equations of state.
#################
import numpy as np
import matplotlib
matplotlib.use("agg")
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd


print("Warning! This module modifies matplotlib params upon import, \
this is probably fine (tbh the normal matplotlib state is also arbitary and worse) \
but if something goes wonky it's probably this.")
matplotlib.rcParams['figure.figsize'] = (9.7082039325, 6.0)
matplotlib.rcParams['xtick.labelsize'] = 27.0
matplotlib.rcParams['ytick.labelsize'] = 27.0
matplotlib.rcParams['axes.labelsize'] = 27.0
matplotlib.rcParams['legend.fontsize'] = 22.0
matplotlib.rcParams['font.family']= 'Times New Roman'
matplotlib.rcParams['font.sans-serif']= ['Bitstream Vera Sans']
matplotlib.rcParams['text.usetex']= True
matplotlib.rcParams['mathtext.fontset']= 'stixsans'
matplotlib.rcParams['xtick.top'] = True
matplotlib.rcParams['ytick.right'] = True

import lal
import scipy
import random
from random import randint

import csv
from scipy.interpolate import interp1d
from scipy.integrate import solve_ivp

### Path to the directory where this file is
c_cgs=lal.C_SI*100
rhonuc=2.8e14


def get_file_type(variables, explicit_file_type=None):
    ''' 
    Find the file type based on the variables requested
    If you ask for inconsistent variables (i.e. M and baryon_density), the code will give you 
    the one that you ask for first, and it will only fail when  "draw_curve" tries to find data 
    in the file that doesn't exist
    '''
    if explicit_file_type is not None:
        return explcit_file_type
    if ("M" in variables or "R" in variables or "Lambda" in variables or "rhoc" in variables):
        return "macro-draw-"
    elif ("baryon_density"  in variables or "pressurec2" in variables or "energy_densityc2" in variables or "cs2c2" in variables):
        return "eos-draw-"
    else :
        raise("unrecognized variables", variables)
def get_logweights(weight_file, eos_column="eos", logweight_column="logweight_total"):
    '''
    Get a Dictionary of logweights from a file with eoss and logweights
    '''
    eos = np.array(pd.read_csv(weight_file)["eos"])
    logweight = np.array(pd.read_csv(weight_file)[logweight_column])
    return {eos[i] : logweight[i] for i in range(len(eos))}
        
# Data will come out in the order the variables are put in, if using explicit_file_type make sure it agrees with the variables being used, otherwise 
# the function will just find the right file to grab.  This can return arbitrary dimensional data, the more variables the more data. 
def draw_curve(eos_dir="/home/philippe.landry/nseos/eos/gp/mrgagn/", eos_per_dir=1000, num_dirs=2299, variables=("M","R"), explicit_file_type=None, \
               logweights=None, logweight_threshold=-10.0, known_index=None):
    '''
    Draw a curve from either an eos or macro file, if no logweights are provided, then draw from all of the possible eoss based on
    the num_dirs variable, otherwise, draw from the list of eoss in the logweights dictionary (logweights.keys())
    '''
    num_eos = eos_per_dir  * num_dirs
    # logweight doesn't matter if eos is fixed apriori
    if known_index is not None:
        draw_index = known_index
   
    # Use the list of logweights to draw from
    elif logweights is not None:
        logweight_sufficient = False
        while not logweight_sufficient:
            draw_index = np.random.choice(np.array(list(logweights.keys()), dtype=int))
            logweight_sufficient =  (logweights[draw_index] > logweight_threshold)
    else:
        draw_index = np.random.randint(num_eos)
    
    
    draw_dir = draw_index // eos_per_dir
    drawn_file = eos_dir + "DRAWmod" +str(eos_per_dir) + "-"+ str(draw_dir).zfill(6) + "/" + get_file_type(variables) + str(draw_index).zfill(6) + ".csv"
    data_curve = (np.array(pd.read_csv(drawn_file)[variable_name]) for i, variable_name in enumerate(variables))
    return data_curve
def apply_if(f, x, condition):
    '''
    Return f(x) if `condition` is satisfied, otherwise return x
    '''
    if condition:
        return f(x)
    else:
        return x
# If we don't want the units in /c2 units
def regularize_c2_scaling(data_curve, variables):
    '''
    If any `variables` contain the substring c2, this indicates they are divided by c2, this function multiplies back this c2, in 
    cgs, to these variables.
    '''
    fix_this_scaling = lambda name : ("c2" in name)
    modified_data_curve = (apply_if(lambda data : data*c_cgs**2, data, fix_this_scaling(variables[i])) for (i, data) in enumerate(data_curve))
    return modified_data_curve
def normalize_density(data_curve, variables):
    '''
    If any `variables` are "baryon_density", change their units to units of rho_nuc
    '''
    fix_this_scaling = lambda name : ("baryon_density" in name)
    modified_data_curve = (apply_if(lambda data : data/rhonuc, data, fix_this_scaling(variables[i])) for (i, data) in enumerate(data_curve))
    return modified_data_curve
######################################################
# PLOT FAIR DRAWS
######################################################
def plot_fair_draws(these_logweights, these_vars, eos_dir, N=1, regularize_cs2_scaling=True, divide_by_rho_nuc=False):
    for i in range(N):
        data = draw_curve(eos_dir = sp_eos_dir,eos_per_dir=100, variables=these_vars, logweights=these_logweights)
        if regularize_cs2_scaling:
            data = regularize_c2_scaling(data, these_vars)
        if divide_by_rho_nuc:
            data = normalize_density(data, these_vars)
        plt.plot(*data, color="k", lw=.7)

# Special helper functions for normalizing a rho axis
get_x_label = lambda normalize_axis : '$\\rho \,(\mathrm{g/cm}^3)$' if not normalize_axis else  '$\\rho \,( \\rho_{\mathrm{nuc}})$'
get_x_lim = lambda normalize_axis : (6e13/rhonuc,2.8e15/rhonuc) if normalize_axis else  (4e13,2.8e15)
