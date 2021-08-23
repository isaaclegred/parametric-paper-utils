import numpy as np
import matplotlib
matplotlib.use("agg")
import matplotlib.pyplot as plt
import seaborn as sns

matplotlib.rcParams['figure.figsize'] = (9.7082039325, 6.0)
matplotlib.rcParams['xtick.labelsize'] = 20.0
matplotlib.rcParams['ytick.labelsize'] = 20.0
matplotlib.rcParams['axes.labelsize'] = 25.0
matplotlib.rcParams['legend.fontsize'] = 16.0
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

c_cgs=lal.C_SI*100
rhonuc=2.8e14


fig = plt.figure(figsize=(9.7082039325, 6))


path="../../np_psr_quantiles.csv"
columns = open(path, 'r').readline().strip().split(',')
data = np.loadtxt(path, delimiter=',', skiprows=1)
baryon_density = [float(_.split('=')[1][:-1]) for _ in columns[1:]]
pressures50 = data[50,:]*c_cgs*c_cgs
pressures5 = data[5,:]*c_cgs*c_cgs
pressures95 = data[95,:]*c_cgs*c_cgs

plt.fill_between(baryon_density,pressures5[1:],pressures95[1:],color='deepskyblue',alpha=0.2)
plt.plot(baryon_density,pressures5[1:],c='deepskyblue',lw=2.5,label='NONPARAMETRIC(PSR)')
plt.plot(baryon_density,pressures95[1:],c='deepskyblue',lw=2.5)

path="../../spectral_psr_quantiles.csv"
columns = open(path, 'r').readline().strip().split(',')
data = np.loadtxt(path, delimiter=',', skiprows=1)
baryon_density = [float(_.split('=')[1][:-1]) for _ in columns[1:]]
pressures50 = data[50,:]*c_cgs*c_cgs
pressures5 = data[5,:]*c_cgs*c_cgs
pressures95 = data[95,:]*c_cgs*c_cgs

plt.fill_between(baryon_density,pressures5[1:],pressures95[1:],alpha=0.5,color="m")
plt.plot(baryon_density,pressures50[1:],c='m')
plt.plot(baryon_density,pressures5[1:],c='m',lw=2.5,label='SPECTRAL(PSR)')
plt.plot(baryon_density,pressures95[1:],c='m',lw=2.5)


path="../../np_psr_prior_quantiles.csv"
columns = open(path, 'r').readline().strip().split(',')
data = np.loadtxt(path, delimiter=',', skiprows=1)
baryon_density = [float(_.split('=')[1][:-1]) for _ in columns[1:]]
pressures50 = data[50,:]*c_cgs*c_cgs
pressures5 = data[5,:]*c_cgs*c_cgs
pressures95 = data[95,:]*c_cgs*c_cgs


plt.plot(baryon_density,pressures5[1:],c='b',lw=2.5,label='PRIOR(NONPARAMETRIC)')
plt.plot(baryon_density,pressures95[1:],c='b',lw=2.5)

path="../../spectral_psr_prior_quantiles.csv"
columns = open(path, 'r').readline().strip().split(',')
data = np.loadtxt(path, delimiter=',', skiprows=1)
baryon_density = [float(_.split('=')[1][:-1]) for _ in columns[1:]]
pressures50 = data[50,:]*c_cgs*c_cgs
pressures5 = data[5,:]*c_cgs*c_cgs
pressures95 = data[95,:]*c_cgs*c_cgs


plt.plot(baryon_density,pressures5[1:],c='r',lw=2.5,label='PRIOR(PARAMETRIC)')
plt.plot(baryon_density,pressures95[1:],c='r',lw=2.5)


plt.axvline(rhonuc,c='k')
plt.axvline(2*rhonuc,c='k')
plt.axvline(6*rhonuc,c='k')

plt.tick_params(direction='in')
plt.yscale('log')
plt.xscale('log')

plt.tight_layout()
plt.grid(alpha=0.5)
plt.ylabel('$ P \,(\mathrm{dyn/cm}^2)$')
plt.xlabel('$\\rho \,(\mathrm{g/cm}^3)$')
plt.xlim(4e13,3e15)
plt.ylim(4e31,1e37)
plt.legend(frameon=True,fancybox=True,framealpha=1,fontsize=18)
plt.text(3e14,0.6e32,'$\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
plt.text(6e14,0.8e32,'$2\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)
plt.text(18e14,0.8e32,'$6\\rho_{\mathrm{nuc}}$',fontsize=28,rotation=90)

plt.show()
fig.savefig("../../plot_p-rho_quantiles_comparison.pdf",bbox_inches='tight')
