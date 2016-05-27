import os
import subprocess
import numpy as np
import matplotlib.pyplot as plt


# Produce the executable ;)
FNULL = open(os.devnull, 'w')
p = subprocess.call("make", stdout=FNULL)
if p!=0:
   raise SystemExit('Get F90 compiler and fix the Makefile.')

# Planck LCDM parameters
om = 0.3089
ob = 0.0486
h  = 0.6774
s8 = 0.816
ns = 0.9667

# Example call
p = subprocess.call(["./amf.exe", "-omega_0", str(om), "-omega_bar", str(ob), "-h", str(h),
                     "-sigma_8", str(s8), "-n_s", str(ns), "-tf", "EH"], stdout=FNULL)
MassFunc = np.loadtxt("analytic.dat").T

# Plot
fig = plt.figure(figsize=(4, 4))
ax1 = fig.add_axes((0.17, 0.15, 0.79, 0.80))

ax1.loglog(MassFunc[2], MassFunc[3], ls="-", label=r"$z=0$", color="#377EB8", alpha=0.8)

ax1.legend(loc="best")
ax1.set_ylabel(r"dn/dlog(M) [(Mpc/h)$^{-3}$]")
ax1.set_xlabel(r"Mass [Msun/h]")

plt.grid()
plt.show()
plt.close()
