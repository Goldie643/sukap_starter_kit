# $1 is the card file to pull from
# $2 is the .nuance file
export sds_io_dir=/disk01/usr4/goldsack/sds_io/
# export nuance_dir=/disk01/usr4/goldsack/sds_io/nuance_files/
# export skds=/disk01/usr4/goldsack/skdetsim_qe_4_3/skdetsim.sh

export card_file=$1

export nuance_file=$2

export out_file="${nuance_file%.*}.root"

echo $card_file
echo $out_file
echo $nuance_file
qsub -x  ${sds_io_dir}qsub_sds_submit_nuance.sh
