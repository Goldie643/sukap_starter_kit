source /usr/local/sklib_gcc4.8.5/skofl_16c/env.sh

process_file=/disk01/usr4/goldsack/mcwit/src_noskip/process_file_nofv_vlowtrig

if [ -z "$mrg_file" ]
then 
    echo "MRG FILE NOT SET"
    exit 1
fi

if [ -z "$in_file" ]
then 
    echo "IN FILE NOT SET"
    exit 1
fi

if [ -z "$out_file" ]
then 
    echo "OUT FILE NOT SET"
    exit 1
fi

${process_file} ${mrg_file} ${in_file} ${out_file}
