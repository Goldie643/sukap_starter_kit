source_card_file=$1
n_energies=$2
n_files_per_energy=$3
n_events_per_file=$4
e_min=$5
e_max=$6
prefix=$7

n_digits=${#n_energies}

e_interval=$(bc <<<"scale=5;($e_max-$e_min)/$n_energies")
e=$e_min

for i in $(seq 1 ${n_energies})
do
    if (( $(bc <<< "$e < 1.2934") ))
    then
        echo ""
        echo "Below Cherenkov Threshold, skipping..."
        echo "(E = $e)"
        echo ""
        e=$(bc <<< "scale=5;($e + $e_interval)")
        continue
    fi
    e_prefix=`printf "%0${n_digits}d" $i`
    e_prefix="${prefix}${e_prefix}_"
    echo "Prefix for energy $e = $e_prefix"
    bash qsub_multi.sh $source_card_file $n_events_per_file $n_files_per_energy $e $e_prefix
    e=$(bc <<< "scale=5;($e + $e_interval)")
done
