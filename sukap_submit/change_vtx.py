import sys
import random
import math

# -1 to keep them in the tank
fudge = 0
sk_r = 1690-fudge
sk_hh = 1810-fudge

input_file = open(sys.argv[1], "r")
if(len(sys.argv) == 3):
    output_file = open(sys.argv[2], "w")
else:
    # Use input name, get rid of extension
    output_file = open(sys.argv[1]+"_VtxChange", "w")

n_changed = 0

for line in input_file:
    if(line[:6] == "vertex"):
        # naunce vertex and track info is of the format:
        # vertex X Y Z T
        # track P_ID ENERGY PX PY PZ 0
        vtx = line.split()[1:]
        vtx = [float(a) for a in vtx]

        theta = random.uniform(0,2*math.pi)

        r = sk_r*math.sqrt(random.random())

        x = (r)*math.cos(theta)
        y = (r)*math.sin(theta)

        z = random.uniform(-sk_hh,sk_hh)

        if(abs(x) > sk_r or abs(y) > sk_r):
            print("Outside of FV r!")
            exit()
        if(x*x+y*y > sk_r*sk_r):
            print("Outside of FV r!")
            exit()
        if(abs(z) > sk_hh):
            print("Outside of FV h!")
            exit()

        output_file.write("vertex %g %g %g %g\n" % (x,y,z,vtx[-1]))

        n_changed+=1
    else:
        output_file.write(line)

print("%i vertices changed, written to %s." % (n_changed,output_file.name))

input_file.close()
output_file.close()
