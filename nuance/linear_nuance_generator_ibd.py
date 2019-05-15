from scipy import stats
import matplotlib.pyplot as plt
import numpy as np
import sys
import random
import argparse
import math
import csv
import datetime

dt_now = datetime.datetime.now()

sk_r = 1492
sk_hh = 1610

parser = argparse.ArgumentParser()

parser.add_argument("-p",
        "--p_id", 
        help = "Particle ID (PDG)", 
        type=int)
parser.add_argument("-emin", 
        "--e_min", 
        help = "Particle min energy", 
        type = float, 
        default = -1)
parser.add_argument("-emax", 
        "--e_max", 
        help = "Particle max energy", 
        type = float, 
        default = -1)
parser.add_argument("-n", 
        "--n_events", 
        help = "Number of events",
        type = int,
        default = -1)
parser.add_argument("-o", 
        "--out_filename", 
        help = "Name of output file.nuance", 
        type = str,
        default = str(dt_now.date()))
parser.add_argument("-no_kc", 
        "--kin_corr",
        help = "Use this if you do NOT want to correct for IBD kinematics",
        action="store_false")

args = parser.parse_args()

if(args.e_min == -1):
    print("***Please specify particle energy range***")
    sys.exit()
if(args.n_events == -1):
    print("***Please specify number of events***")
    sys.exit()


n_events = 0
correction = 0
if(args.kin_corr):
    correction = 0.511 + (939.565413358-938.27204621) #Kinematic correction
    print("CORRECTING FOR KINEMATICS IN IBD:")
    print(correction)

# Setting n events, either fixed n for fixed n events
# Or n events needed to have each bin have at least 1 event for file

e_interval = (args.e_max - args.e_min) / args.n_events

out = open(args.out_filename + ".nuance","w+")

for i in range(args.n_events):
    out.write("begin \n")
    out.write("info 2 949000 0.0000E+00\n")
    # out.write("nuance 3 \n")

    theta = random.uniform(0,2*math.pi)

    # -1 to get rid of rounding errors causing events
    # to appear outside the tank
    x = (sk_r-1)*math.cos(theta)
    y = (sk_r-1)*math.sin(theta)
    z = random.uniform(-sk_hh,sk_hh)

    vx = random.uniform(-1,1)
    vy = random.uniform(-1,1)
    vz = random.uniform(-1,1)

    # print("vx = %f\n" % vx)
    # print("vy = %f\n" % vy)
    # print("vz = %f\n" % vz)

    px = vx/math.sqrt(vx*vx+vy*vy+vz*vz)
    py = vy/math.sqrt(vx*vx+vy*vy+vz*vz)
    pz = vz/math.sqrt(vx*vx+vy*vy+vz*vz)

    # print("px = %f\n" % px)
    # print("py = %f\n" % py)
    # print("pz = %f\n" % pz)

    out.write("vertex %f %f %f 0\n" % (x,y,z))
    if(args.kin_corr):
        out.write("track %i %f %f %f %f 0\n" % 
                (args.p_id, (args.e_min + i*e_interval - correction), px, py, pz))
    else:
        out.write("track %i %f %f %f %f 0\n" % 
                (args.p_id, (args.e_min + i*e_interval), px, py, pz))

    # print (args.e_min + i*e_interval)
    out.write("end\n")

out.write("stop\n")
