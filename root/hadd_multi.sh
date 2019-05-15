# $1 is prefix of the .root files (filename up to numbers)

n_files=`ls -dq *$1* | wc -l`
n_digits=`echo "${#n_files}"`
file_list=""

for i in $(seq 1 $n_files)
do
    current_file=`printf "%0${n_digits}d" $i`
    current_file="$1${current_file}.root"
    echo ${current_file}
    file_list="${file_list} ${current_file}"
done

echo "File list:"
echo ${file_list}

# echo "Output file name:"
# read out_file
out_file="${1}merge.root"

hadd -f ${out_file} ${file_list}
