import sys
import csv

e_min = float(sys.argv[3])
e_max = float(sys.argv[4])
width = 0.01 #MeV

e = e_min

with open (sys.argv[1]) as in_file:
    with open (sys.argv[2], 'wb') as out_file:
        reader = csv.reader(in_file)
        writer = csv.writer(out_file, lineterminator='\n')
        in_file.readline()
        for row in reader:
            writer.writerow([e] + row)
            e+=width
