import sys
import random
import math

positron_file = open(sys.argv[1], "r")
if(len(sys.argv) == 3):
    neutron_file = open(sys.argv[2], "w")
else:
    # Use input name, get rid of extension
    neutron_file = open(sys.argv[1][:-7]+"_neutron.nuance", "w")


for line in positron_file:
    if(line[:6] == "vertex"):
        # naunce vertex and track info is of the format:
        # vertex X Y Z 0
        # track P_ID ENERGY PX PY PZ 0
        vtx = line.split()[1:4]
        vtx = [float(a) for a in vtx]

        vx = random.uniform(-1,1)
        vy = random.uniform(-1,1)
        vz = random.uniform(-1,1)

        px = vx/math.sqrt(vx*vx+vy*vy+vz*vz)
        py = vy/math.sqrt(vx*vx+vy*vy+vz*vz)
        pz = vz/math.sqrt(vx*vx+vy*vy+vz*vz)

        neutron_file.write("begin \n")
        neutron_file.write("nuance 1 \n")
        neutron_file.write("vertex %f %f %f 0\n" % (vtx[0],vtx[1],vtx[2]))
        neutron_file.write("track 22 2.2 %f %f %f 0\n" % (px, py, pz))

        neutron_file.write("end\n")

neutron_file.write("stop\n")