# $1 is prefix of the .root files (filename up to numbers)
# $2 is n_files run, i.e. how many files there should be, before removing any bad ones 

n_files=`ls -dq *$1* | wc -l`
n_files=$2
n_digits=`echo "${#n_files}"`
file_list=""

for i in $(seq 1 $n_files)
do
    current_file=`printf "%0${n_digits}d" $i`
    current_file="$1${current_file}.root"
    if test -f "${current_file}"; then
        echo ${current_file}
        file_list="${file_list} ${current_file}"
    else
        echo "${current_file} does not exist!"
    fi
done

# echo "File list:"
# echo ${file_list}

# echo "Output file name:"
# read out_file
file_subname=$(basename $1)
file_subname=${file_subname%_*} ${file_subname##*_}
out_file="$(dirname $1)/merge_${file_subname}.root"
echo "Merged filename: $out_file"
echo ""

hadd -f ${out_file} ${file_list}
