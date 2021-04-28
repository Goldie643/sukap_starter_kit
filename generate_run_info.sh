min_run=$1
max_run=$2

file="${min_run}-${max_run}_run_info.csv"

echo "run_num,run_mode,run_mode_num,start_time,end_time" > $file

for (( i = $min_run; i <= $max_run; i++ ))
do
    echo -n $i, >> $file

    # Preamble (n chars up to useful info)
    pre_len=14

    run_mode_full=`summary -r $i| grep "Run Mode"`
    run_mode_full=`echo $run_mode_full | cut -c ${pre_len}-`
    run_mode=`echo $run_mode_full | cut -d ":" -f 2`
    echo -n $run_mode, >> $file
    run_mode_num=`echo $run_mode_full | cut -c 1`
    echo -n $run_mode_num, >> $file

    start_time=`summary -r $i| grep "Start time"`
    start_time=`echo $start_time | cut -c ${pre_len}-`
    start_time=`echo $start_time | cut -d " " -f 2,3,5,4`
    # Put in number format to pass to lowfitwit
    # start_time=`date -d "$start_time" "+%Y-%m-%d"`
    start_time=`date -d "$start_time" "+%Y-%m-%d %H:%M:%S"`
    echo -n $start_time, >> $file

    end_time=`summary -r $i| grep "End time"`
    end_time=`echo $end_time | cut -c ${pre_len}-`
    end_time=`echo $end_time | cut -d " " -f 2,3,5,4`
    # Put in number format to pass to lowfitwit
    # end_time=`date -d "$end_time" "+%Y-%m-%d"`
    end_time=`date -d "$end_time" "+%Y-%m-%d %H:%M:%S"`
    echo $end_time >> $file
done
