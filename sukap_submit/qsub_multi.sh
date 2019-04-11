export card_file=$1
export skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh
qsub_file=/disk01/usr4/goldsack/sds_io/qsub_sds_submit.sh

n_per_file=`grep VECT-NEVT $card_file`
echo "n_files (of VECT-NEVT events in .card file):"
echo $n_per_file
read n_files
echo "Out file name prefix:"
read prefix

for i in $(seq 1 ${n_files})
do
    sed -i "s/^VECT-RAND.*/VECT-RAND  $RANDOM  $RANDOM  0  0  0/g" $card_file
    export out_file="${prefix}${i}.root"
    echo $out_file
    qsub -x $qsub_file 
done
