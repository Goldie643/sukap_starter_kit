source /usr/local/sklib_gcc4.8.5/skofl_16c/env.sh

card_dir=/disk01/usr4/goldsack/sds_io
# skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh
skds=/disk01/usr4/goldsack/r26400_skdetsim_sletrg_timetbabugfix_noruncut_qe_4_3/skdetsim.sh

if [ -z $out_file]
then 
    out_file=$card_dir/"reactor_positron.root"
fi

echo $card_file
echo $out_file
echo $nuance_file

$skds $card_file $out_file $nuance_file
