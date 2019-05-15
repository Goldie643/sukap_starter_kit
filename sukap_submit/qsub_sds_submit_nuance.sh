source /usr/local/sklib_gcc4.8.5/skofl_16c/env.sh

card_dir=/disk01/usr4/goldsack/sds_io
card_file=$card_dir/reactor_positron_fromnuance.card
# nuance_file=$card_dir/reactor_s20000.nuance
skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh

if [ -z $out_file]
then 
    out_file=$card_dir/"reactor_positron.root"
fi

echo $card_file
echo $out_file
echo $nuance_file

$skds $card_file $out_file $nuance_file
