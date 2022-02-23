#!/bin/bash

# Put whitespace seperated output in arr
jobnumstrs=($(pjstat))
# jobnumstrs=("JOB_ID     JOB_NAME   MD ST  USER     START_DATE      ELAPSE_LIM NODE_REQUIRE    VNODE  CORE V_MEM 43067      pjsub_test NM RUN goldsack 02/23 20:53:49  0024:00:00            -               1      1    4096 MiB")

# Get rid of header
jobnumstrs=("${jobnumstrs[@]:11}")

# echo $jobnumstrs
# for jobnumstr in $jobnumstrs
end=${#jobnumstrs[@]}
end=$((end/13))
for ((i=0;i<end;i++))
do
    jobnum_i=$((i*13))
    jobnum=${jobnumstrs[jobnum_i]}
    # jobnum=$(echo $jobnumstr|grep -Eo '[[:digit:]]{8}')
    # jobnum=${jobnumstr:0:8}
    echo "Killing ${jobnum}..."

    if [ "$jobnum" != "" ]
    then
        pjdel $jobnum
    fi
done
