export skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh
qsub_file=/disk01/usr4/goldsack/sds_io/qsub_sds_submit.sh

if [ $# -eq 0 ]
    then
        echo "Give source card file as arg 1"
        exit 1
fi
card_file_source=$1
particle=`grep "VECT-PART" $card_file_source`
echo $particle
echo "N events total:"
read n_events
echo "N files:"
read n_files
n_per_file=$(( n_events/n_files ))
echo "N events per file: ${n_per_file}"
echo "Min energy:"
read e_min
echo "Max energy:"
read e_max
e_interval=$(bc <<< "scale=6;($e_max-$e_min)/$n_files")
echo "E interval: $e_interval"
n_digits=${#n_files}

mass=0.5109989461 # MeV
echo "Using particle mass of $mass"

echo "Out file name prefix:"
read prefix

# echo "** CORRECTING FOR IBD KINEMATICS **"
# kin_corr=$(bc <<< "scale=10;(939.565413358-938.27204621)")
kin_corr=0

energy=e_min
for i in $(seq 1 ${n_files})
do
    card_file=`printf "%0${n_digits}d" $i`
    export card_file="${prefix}${card_file}.card"
    cp $card_file_source $card_file
    sed -i "s/^VECT-NEVT.*/VECT-NEVT ${n_per_file}/g" $card_file 
    sed -i "s/^VECT-RAND.*/VECT-RAND  $RANDOM  $RANDOM  0  0  0/g" $card_file
    energy=$(bc <<< "scale=6;$e_min+$i*$e_interval-$kin_corr")
    momentum=$(bc <<< "scale=3;sqrt($energy*$energy-$mass*$mass)/1") 
    sed -i "s/^VECT-MOM.*/VECT-MOM $momentum $momentum/g" $card_file 
    out_file=`printf "%0${n_digits}d" $i`
    export out_file="${prefix}${out_file}.root"
    echo "================================"
    echo " i = $i, momentum = $momentum, energy = $energy"
    echo "================================"
    echo "  Card File: $card_file"
    echo "  Out File:  $out_file"
    echo "================================"
    echo ""
    qsub -x $qsub_file 
done
