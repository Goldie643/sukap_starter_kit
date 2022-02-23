source /usr/local/sklib_gcc4.8.5/skofl_16c/env.sh

card_dir=/disk01/usr4/goldsack/sds_io/card_files
skds=/disk01/usr4/goldsack/r26400_skdetsim_sletrg_timetbabugfix_noruncut_qe_4_3/skdetsim.sh
skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh

if [ -z "$out_file" ]
then 
    echo "OUT FILE NOT SET"
    # out_file=$card_dir/"reactor_positron.root"
    exit 1
fi

if [ -z "$card_file" ]
then 
    echo "CARD FILE NOT SET"
    # card_file=$card_dir/"reactor_positron.card"
    exit 1
fi

echo "Card file: $card_file"
echo "Out file: $out_file"

$skds $card_file $out_file
