export skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh
source_card_file=$1
qsub_file=/disk01/usr4/goldsack/sds_io/qsub_sds_submit.sh

# n_per_file=`grep VECT-NEVT $source_card_file`
# echo "n_files (of VECT-NEVT events in .card file):"
# echo $n_per_file
# read n_files

n_per_file=$2
n_files=$3
prefix=$4
n_digits=${#n_files}

for i in $(seq 1 ${n_files})
do
    card_file=`printf "%0${n_digits}d" $i`
    export card_file="${prefix}${card_file}.card"
    cp $source_card_file $card_file
    sed -i "s/^VECT-RAND.*/VECT-RAND  $RANDOM  $RANDOM  0  0  0/g" $card_file
    sed -i "s/^VECT-NEVT.*/VECT-NEVT $n_per_file/g" $card_file
    out_file=`printf "%0${n_digits}d" $i`
    export out_file="${prefix}${out_file}.root"
    echo "================================"
    echo " i = $i"
    echo "================================"
    echo "  Card File: $card_file"
    echo "  Out File:  $out_file"
    echo "================================"
    echo ""
    qsub -x $qsub_file 
done
