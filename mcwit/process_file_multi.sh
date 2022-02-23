# $1 is mrg file
# $2 is prefix of the .root files (filename up to numbers)
export mcwit_dir=/disk01/usr4/goldsack/mcwit/
export process_file=${mcwit_dir}/src_noskip/process_file

n_files=`ls -dq $2* | wc -l`
n_digits=`echo "${#n_files}"`
echo $n_files

for i in $(seq 1 $n_files)
do
    in_file=`printf "%0${n_digits}d" $i`
    export in_file="$2${in_file}.root"
    echo $in_file
    out_file=`printf "%0${n_digits}d" $i`
    export out_file="wit_$2${out_file}.root"
    echo $out_file
    ${process_file} $1 ${in_file} ${out_file}
done
