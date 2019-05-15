# Generating Gd capture events (3 gammas with sum E 8 MeV)
import numpy as np
import sys
import random
import argparse
import math
import csv

sk_r = 1492
sk_hh = 1610

parser = argparse.ArgumentParser()

parser.add_argument("-n", 
        "--n_events", 
        help = "Number of events",
        type = int,
        default = -1)
parser.add_argument("-ng", 
        "--gamma_n", 
        help = "Number of gammas",
        type = int,
        default = -1)
parser.add_argument("-esum", 
        "--gamma_esum", 
        help = "Energy sum of gammas",
        type = int,
        default = 8)
parser.add_argument("-o", 
        "--out_filename", 
        help = "Name of output file.nuance", 
        type = str)

args = parser.parse_args()

if (args.gamma_n == -1):
    print("Please enter the number of gammas to be produced in each event.")
    sys.exit(0)

out = open(args.out_filename + ".nuance","w+")

for i in range(args.n_events):
    out.write("begin \n")
    out.write("info 2 949000 0.0000E+00 \n")

    # Array of energies which sum to 8
    energies = (np.random.dirichlet(np.ones(args.gamma_n),size=1)*args.gamma_esum)[0]

    # Vertex position
    # -1 to get rid of rounding errors causing events
    # to appear outside the tank
    theta = random.uniform(0,2*math.pi)
    x = (sk_r-1)*math.cos(theta)
    y = (sk_r-1)*math.sin(theta)
    z = random.uniform(-sk_hh,sk_hh)

    out.write("vertex %f %f %f 0\n" % (x,y,z))

    for energy in energies:
        vx = random.uniform(-1,1)
        vy = random.uniform(-1,1)
        vz = random.uniform(-1,1)
        
        px = vx/math.sqrt(vx*vx+vy*vy+vz*vz)
        py = vy/math.sqrt(vx*vx+vy*vy+vz*vz)
        pz = vz/math.sqrt(vx*vx+vy*vy+vz*vz)

        # 22 is pdg code for gamma
        out.write("track %i %f %f %f %f 0\n" % (22, energy, px, py, pz))

    out.write("end\n")

out.write("stop\n")
