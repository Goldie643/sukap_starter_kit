# $1 is prefix of the .root files (filename up to numbers)

files=`ls $1*`

for file in ${files}
do
    export in_file=$file
    export out_file="red_${in_file}"
    qsub -x qsub_first_red.sh
done
