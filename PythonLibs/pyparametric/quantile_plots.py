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


################################
# DEFINE PLOTTING FUNCTIONS
################################


def plot_generic_p_rho_curve(post_path, prior_path, post_color="magenta", prior_color="red", this_label='GENERIC', 
                             lower=5, center=50, upper=95, divide_by_rho_nuc=False):
    ######################################################
    # GENERIC PRIOR
    ######################################################

    columns = open(prior_path, 'r').readline().strip().split(',')
    data = np.loadtxt(prior_path, delimiter=',', skiprows=1)
    baryon_density = np.array([float(_.split('=')[1][:-1]) for _ in columns[1:]])
    if divide_by_rho_nuc:
        baryon_density = baryon_density/rhonuc
    pressures50 = data[center,:]*c_cgs*c_cgs
    pressures5 = data[lower,:]*c_cgs*c_cgs
    pressures95 = data[upper,:]*c_cgs*c_cgs

    #plt.fill_between(baryon_density,pressures5[1:],pressures95[1:],color='r',alpha=0.2)
    plt.plot(baryon_density,pressures5[1:],c=prior_color,lw=2.5,label=f'PRIOR({this_label})')
    plt.plot(baryon_density,pressures95[1:],c=prior_color,lw=2.5)

    ######################################################
    # GENERIC POSTERIOR
    ######################################################

    columns = open(post_path, 'r').readline().strip().split(',')
    data = np.loadtxt(post_path, delimiter=',', skiprows=1)
    baryon_density = np.array([float(_.split('=')[1][:-1]) for _ in columns[1:]])
    if divide_by_rho_nuc:
        baryon_density = baryon_density/rhonuc
    pressures50 = data[50,:]*c_cgs*c_cgs
    pressures5 = data[5,:]*c_cgs*c_cgs
    pressures95 = data[95,:]*c_cgs*c_cgs

    plt.fill_between(baryon_density,pressures5[1:],pressures95[1:],alpha=0.4, color=post_color)
    #plt.plot(baryon_density,pressures50[1:],c='b')
    plt.plot(baryon_density,pressures5[1:],c=post_color,lw=2.5,label=this_label)
    plt.plot(baryon_density,pressures95[1:],c=post_color,lw=2.5)

def complete_p_rho_plot(divide_by_rho_nuc=False):
    if divide_by_rho_nuc:
        local_rhonuc = 1
        local_rho2nuc = 2
        local_rho6nuc = 6
    else : 
        local_rhonuc = rhonuc
        local_rho2nuc = 2*rhonuc
        local_rho6nuc = 6*rhonuc
    plt.axvline(local_rhonuc,c='k')
    plt.axvline(local_rho2nuc,c='k')
    plt.axvline(local_rho6nuc,c='k')

    plt.tick_params(direction='in')
    plt.yscale('log')
    plt.xscale('log')

    plt.tight_layout()
    plt.grid(alpha=0.5)
    plt.ylabel('$ P \,(\mathrm{dyn/cm}^2)$')

    plt.xlabel(get_x_label(divide_by_rho_nuc))
  
    plt.xlim(*get_x_lim(divide_by_rho_nuc))
    plt.ylim(4e31,1e37)
    plt.legend(frameon=True,fancybox=True,framealpha=1,fontsize=18)
    if divide_by_rho_nuc:
        plt.xticks([.5,1,2,3,4,5,6,7,8,9], labels =[".5", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    if not divide_by_rho_nuc:
        plt.text(3e14,0.6e32,'$\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
        plt.text(6e14,0.8e32,'$2\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
        plt.text(18e14,0.8e32,'$6\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)





Msol_in_km=lal.MSUN_SI*lal.G_SI/lal.C_SI/lal.C_SI/1000
 
def plot_generic_mr_curve(post_path, prior_path, post_color="magenta", prior_color="red", this_label='GENERIC', lower=5, median=50, upper=95):
    columns = open(prior_path, 'r').readline().strip().split(',')
    data = np.loadtxt(prior_path, delimiter=',', skiprows=1)
    mass = [float(_.split('=')[1][:-1]) for _ in columns[1:]]
    radius50 = data[median,:]
    radius5 = data[lower,:]
    radius95 = data[upper,:]

    #plt.fill_between(radius5[1:],radius95[1:],mass,color='r',alpha=0.2)
    plt.plot(radius5[1:],mass,c=prior_color,lw=2.5,label=f'PRIOR({this_label})',linestyle="-.")
    plt.plot(radius95[1:],mass,c=prior_color,lw=2.5,linestyle="-.")

    columns = open(post_path, 'r').readline().strip().split(',')
    data = np.loadtxt(post_path, delimiter=',', skiprows=1)
    mass = [float(_.split('=')[1][:-1]) for _ in columns[1:]]
    radius50 = data[median,:]
    radius5 = data[lower,:]
    radius95 = data[upper,:]

    plt.fill_betweenx(mass, radius5[1:],radius95[1:],alpha=0.4, color=post_color)
    #plt.plot(mass,radius50[1:],c='b')
    plt.plot(radius5[1:],mass,c=post_color,lw=2.5,label=this_label)
    plt.plot(radius95[1:],mass,c=post_color,lw=2.5)

def complete_mr_plot():
    plt.tight_layout()
    plt.grid(alpha=0.5)
    plt.xlabel('$ R$ (km)')
    plt.ylabel('$M \, (M_{\odot})$')
    plt.ylim(0.75,2.5)
    plt.xlim(6,18)

    plt.fill_between(np.arange(6,20,2),2.15,2.01,color='grey',alpha=0.5)
    plt.fill_between(np.arange(6,20,2),2.08,1.97,color='grey',alpha=0.3)

    plt.text(6.5,1.99,'J0348+0432',color='k',fontsize=25)
    plt.text(6.5,2.07,'J0740+6620',color='k',fontsize=25)

    plt.yticks([1,1.4,1.8,2.2])
    plt.tick_params(direction='in')
    plt.legend(frameon=True,fancybox=True,framealpha=0.5,loc="lower left",fontsize=18)


def plot_generic_cs2_curve(post_path, prior_path, post_color="magenta", prior_color="red", this_label='GENERIC', lower=5, center=50, upper=95, divide_by_rho_nuc=False):
    ######################################################
    # GENERIC PRIOR
    ######################################################
    columns = open(prior_path, 'r').readline().strip().split(',')
    data = np.loadtxt(prior_path, delimiter=',', skiprows=1)
    baryon_density = np.array([float(_.split('=')[1][:-1]) for _ in columns[1:]])
    if divide_by_rho_nuc:
        baryon_density = baryon_density/rhonuc
    cs2s50 = data[50,:]
    cs2s5 = data[5,:]
    cs2s95 = data[95,:]

    plt.plot(baryon_density,cs2s5[1:],c=prior_color,lw=2.5,linestyle="-", label=f'PRIOR({this_label})')
    plt.plot(baryon_density,cs2s95[1:],c=prior_color,lw=2.5, linestyle="-")
    
    ######################################################
    # GENERIC POST
    ######################################################
    columns = open(post_path, 'r').readline().strip().split(',')
    data = np.loadtxt(post_path, delimiter=',', skiprows=1)
    baryon_density = np.array([float(_.split('=')[1][:-1]) for _ in columns[1:]])
    if divide_by_rho_nuc:
        baryon_density = baryon_density/rhonuc
    cs2s50 = data[50,:]
    cs2s5 = data[5,:]
    cs2s95 = data[95,:]

    plt.fill_between(baryon_density,cs2s5[1:],cs2s95[1:],color=post_color,alpha=0.25)
    plt.plot(baryon_density,cs2s5[1:],c=post_color,lw=2.5,label=this_label)
    plt.plot(baryon_density,cs2s95[1:],c=post_color,lw=2.5)
def complete_cs2_plot(divide_by_rho_nuc=False, log_cs2_axis=True):
    if divide_by_rho_nuc:
        local_rhonuc = 1
        local_rho2nuc = 2
        local_rho6nuc = 6
    else : 
        local_rhonuc = rhonuc
        local_rho2nuc = 2*rhonuc
        local_rho6nuc = 6*rhonuc
    plt.axvline(local_rhonuc,c='k')
    plt.axvline(local_rho2nuc,c='k')
    plt.axvline(local_rho6nuc,c='k')
    plt.axhline(1/3, c='k')

    plt.tick_params(direction='in')

    plt.xscale('log')
    if log_cs2_axis:
        plt.yscale('log')

    plt.tight_layout()
    plt.grid(alpha=0.5)
    plt.ylabel('$ c_s^2/c^2$')
    plt.xlabel(get_x_label(divide_by_rho_nuc))
    plt.xlim(get_x_lim(divide_by_rho_nuc))
    plt.ylim(0.005,1.1)
    plt.legend(frameon=True,fancybox=True,framealpha=.4,fontsize=18, loc="lower right")
    if not divide_by_rho_nuc:
        plt.text(3e14,0.6e32,'$\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
        plt.text(6e14,0.8e32,'$2\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
        plt.text(18e14,0.8e32,'$6\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
        plt.text(5e13,0.37,'$c_s^2/c^2 = 1/3$',fontsize=22)
    else:
        plt.text(5e13/rhonuc,0.37,'$c_s^2/c^2 = 1/3$',fontsize=22)
        plt.xticks([.5,1,2,3,4,5,6,7,8,9], labels =[".5", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
