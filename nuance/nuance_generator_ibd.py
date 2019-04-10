from scipy import stats
import matplotlib.pyplot as plt
import numpy as np
import sys
import random
import argparse
import math
import csv

sk_r = 1492
sk_hh = 1610

parser = argparse.ArgumentParser()

parser.add_argument("-p",
        "--p_id", 
        help = "Particle ID (PDG)", 
        type=int)
parser.add_argument("-e", 
        "--p_e", 
        help = "Particle total energy (if fixed)", 
        type = float, 
        default = -1)
parser.add_argument("-ef", 
        "--e_file", 
        help = 
        ".csv of Particle energies in format energy,total,etc", 
        type = str,
        default = "NULL")
parser.add_argument("-l", 
        "--linear",
        help = """Use this if you want to have at least 1 event in
            each energy bin from the energy file, otherwise the
            energy will pick along the energy distribution""",
        action="store_true")
parser.add_argument("-n", 
        "--n_events", 
        help = "Number of events",
        type = int,
        default = -1)
parser.add_argument("-o", 
        "--out_filename", 
        help = "Name of output file.nuance", 
        type = str)
parser.add_argument("-no_kc", 
        "--kin_corr",
        help = "Use this if you do NOT want to correct for IBD kinematics",
        action="store_false")
parser.add_argument("-plot", 
        "--plot",
        help = "Use this if you want to show the E distribution generated",
        action="store_true")

args = parser.parse_args()

if(args.p_e == -1 and args.e_file == "NULL"):
    print("***Please specify particle energy using -e or -ef***")
    sys.exit()

out = open(args.out_filename + ".nuance","w+")
e_file = open(args.e_file, "rb")
e_reader = csv.reader(e_file)

n_events = 0
scale = 20000.0 #Scales height of each bin so each has >=1 event TODO: calculate
correction = 0
if(args.kin_corr):
    correction = 0.511 + (939.565413358-938.27204621) #Kinematic correction
    print("CORRECTING FOR KINEMATICS IN IBD:")
    print(correction)

# Setting n events, either fixed n for fixed n events
# Or n events needed to have each bin have at least 1 event for file

if(args.p_e != -1):
    for i in range(args.n_events):
        out.write("begin \n")
        # out.write("nuance 3 \n")

        theta = random.uniform(0,2*math.pi)

        # -1 to get rid of rounding errors causing events
        # to appear outside the tank
        x = (sk_r-1)*math.cos(theta)
        y = (sk_r-1)*math.sin(theta)
        z = random.uniform(-sk_hh,sk_hh)

        px = random.uniform(0,1)
        py = random.uniform(0,1)
        pz = random.uniform(0,1)

        px = px/(px+py+pz)
        py = py/(px+py+pz)
        pz = pz/(px+py+pz)

        out.write("vertex %f %f %f 0\n" % (x,y,z))
        out.write("track %i %f %f %f %f 0\n" % (args.p_id, args.p_e, px, py, pz))
        out.write("end")
elif(args.linear):
    #Cycle through each energy bin
    for row in e_reader:
        #Keep producing events for given energy until n events
        #is more than the (scaled) n events in distribution
        for i in range(int(math.ceil(float(row[1])*scale))):
            n_events += 1
            out.write("begin\n")

            theta = random.uniform(0,2*math.pi)

            x = (sk_r-1)*math.cos(theta)
            y = (sk_r-1)*math.sin(theta)
            z = random.uniform(-sk_hh,sk_hh)

            px = random.uniform(0,1)
            py = random.uniform(0,1)
            pz = random.uniform(0,1)

            px = px/math.sqrt(px*px+py*py+pz*pz)
            py = py/math.sqrt(px*px+py*py+pz*pz)
            pz = pz/math.sqrt(px*px+py*py+pz*pz)

            out.write("vertex %f %f %f 0\n" % (x,y,z))
            out.write("track %i %s %f %f %f 0\n" % (args.p_id, float(row[0])-correction, px, py, pz))
            out.write("end\n")
    print("N Events: %i" % n_events)
else:
    # Setting up the prob distribution from the file using rv_discrete
    # rv_discrete only works with integers, so have to map energies to
    # list of integers
    file_energies = []
    probs = []
    prob_sum = 0
    for row in e_reader:
        file_energies.append(float(row[0]))
        probs.append(float(row[1]))
        prob_sum+=float(row[1])
    int_map = range(len(file_energies))
    probs[:] = [x/prob_sum for x in probs]


    prob_distribution = stats.rv_discrete(name="prob_distribution", values=(int_map,probs))

    rvs = prob_distribution.rvs(size=args.n_events)

    print(len(rvs))

    for rv in rvs:
        out.write("begin \n")
        # out.write("nuance 3 \n")

        theta = random.uniform(0,2*math.pi)

        # -1 to get rid of rounding errors causing events
        # to appear outside the tank
        x = (sk_r-1)*math.cos(theta)
        y = (sk_r-1)*math.sin(theta)
        z = random.uniform(-sk_hh,sk_hh)

        px = random.uniform(0,1)
        py = random.uniform(0,1)
        pz = random.uniform(0,1)

        px = px/(px+py+pz)
        py = py/(px+py+pz)
        pz = pz/(px+py+pz)

        out.write("vertex %f %f %f 0\n" % (x,y,z))
        out.write("track %i %f %f %f %f 0\n" % (args.p_id, file_energies[rv], px, py, pz))
        out.write("end \n")
    if(args.plot):
        energies = []
        for rv in rvs:
            energies.append(file_energies[rv])
        plt.hist(energies, bins = 50)
        plt.show()

out.write("stop\n")
