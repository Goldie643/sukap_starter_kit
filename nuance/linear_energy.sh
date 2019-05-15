# Generates a linear energy .csv file
# UNFINISHED AND DUMB, USE PYTHON

min_energy=$1
max_energy=$2
n_events=$3
n_files=${4:-1}
date=`date +%Y-%m-%d`
out_prefix=${5:-"${date}_"}

n_events_per_file=$n_events/$n_files
n_digits=`echo "${#n_files}"`

# energy_interval=`bc <<< "scale=3; $max_energy - $min_energy"`
# energy_interval=`bc <<< "scale=3 ; $energy_interval / $n_events"`
energy_interval=`echo "$max_energy $min_energy" | awk '{printf "%f", $1 - $2}'`
echo "Energy interval = $energy_interval"

for ((i=0; i < $n_files; i++))
do
    if (($i % $n_events_per_file == 0))
    then 
        file_no=$(($i+1))
        out_file=`printf "%0${n_digits}d" $file_no`
        out_file="${out_prefix}${out_file}.nuance"
        # echo -ne "Processing $out_file"\\r
        echo $out_file
    fi

    energy=`bc <<< "scale=3; $min_energy+$i * $energy_interval"`
    echo $energy; 
    # echo "$" >> $out_file
done

echo ""
echo "Done"
