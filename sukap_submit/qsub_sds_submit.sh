source /usr/local/sklib_gcc4.8.5/skofl_16c/env.sh

card_dir=/disk01/usr4/goldsack/sds_io
card_file=$card_dir/reactor_positron.card
nuance_file=$card_dir/reactor_s20000.nuance
skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh

if [ -z $out_file]
then 
    out_file=$card_dir/"reactor_positron.root"
fi

$skds $card_file $out_file
