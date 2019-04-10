export card_dir=/disk01/usr4/goldsack/test_cards
export card_file=$card_dir/2mev_positron_NONOISE.card
export skds=/disk01/usr4/goldsack/skdetsim/skdetsim.sh

for i in {1..10}
do
    sed -i "s/^VECT-RAND.*/VECT-RAND  $RANDOM  $RANDOM  0  0  0/g" $card_file
    export out_file="2mev_positron_NONOISE_$i.root"
    echo $out_file
    qsub -x  $card_dir/qsub_sds_submit.sh
done
