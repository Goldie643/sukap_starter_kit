# $1 is the card file to pull from
# $2 is prefix of the .nuance files (filename up to numbers)
# Script assumes you run from folder above nuance_files/
# TODO: Fix this, it is dumb
export sds_io_dir=/disk01/usr4/goldsack/sds_io/
export card_file=${sds_io_dir}$1
export nuance_dir=/disk01/usr4/goldsack/sds_io/
export skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh

n_files=`ls -dq *$2* | wc -l`

for i in $(seq 1 $n_files)
do
    sed -i "s/^VECT-RAND.*/VECT-RAND  $RANDOM  $RANDOM  0  0  0/g" $card_file
    out_file=`printf "%03d" $i`
    export out_file="$2${out_file}.root"
    echo $out_file
    nuance_file=`printf "%03d" $i`
    export nuance_file="${sds_io_dir}$2${nuance_file}.nuance"
    echo $nuance_file
    qsub -x  ${sds_io_dir}qsub_sds_submit_nuance.sh
done
