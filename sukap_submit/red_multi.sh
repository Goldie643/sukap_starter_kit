prefix=$1

source ~/.bashrc

for f in $(prefix)*.root
do
    first_red red_$f $f
done
