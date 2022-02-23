# $1 is mrg file
# $2 is prefix of the .root files (filename up to numbers)
# First number is variation in energy
# Second is variation in file

export mcwit_dir=/disk01/usr4/goldsack/mcwit/
export card_file=${mcwit_dir}$2
export process_file=${mcwit_dir}/src/process_file

# n_files=`ls -dq *${2}*_01 | wc -l`

echo "Number of spreads of files?"
read n_files
n_digits=`echo "${#n_files}"`

for i in $(seq 1 $n_files)
do
    in_file_prefix=`printf "%0${n_digits}d" $i`
    echo $in_file_prefix
    export in_file_prefix="$2${in_file_prefix}_"
    echo $in_file_prefix
    bash process_file_multi.sh $1 $in_file_prefix
done
