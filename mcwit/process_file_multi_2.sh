# $1 is prefix of the mrg files
# $2 is prefix of the .root files (filename up to numbers)
export mcwit_dir=/disk01/usr4/goldsack/mcwit
export process_file=${mcwit_dir}/src_noskip/process_file

mrg_files=`ls $1*`
n_mrg=`ls -dq $1* | wc -l`

n_files=`ls -dq $2* | wc -l`
n_digits=`echo "${#n_files}"`

if [ "${n_files}" -gt "${n_mrg}" ]
then
    echo "More files than mrg files!"
    exit 1
fi

i=1
 
for mrg_file in ${mrg_files}
do
    if [ "${i}" -gt "${n_files}" ]
    then
        exit 1
    fi
    in_file=`printf "%0${n_digits}d" $i`
    export in_file="$2${in_file}.root"
    # echo $in_file
    out_file=`printf "%0${n_digits}d" $i`
    export out_file="wit_$2${out_file}.root"
    export mrg_file
    # echo $out_file
    # ${process_file} ${mrg_file} ${in_file} ${out_file}
    echo "${process_file} ${mrg_file} ${in_file} ${out_file}"
    pjsub -X qsub_process_file.sh
    ((i = i + 1))
done
