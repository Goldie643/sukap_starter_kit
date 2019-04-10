#!/bin/bash

jobnumstrs=$(qstat | grep $1)
echo $jobnumstrs
for jobnumstr in $jobnumstrs
do
    jobnum=$(echo $jobnumstr|grep -Eo '[[:digit:]]{8}')


    if [ "$jobnum" != "" ]
    then
	qdel $jobnum
    fi
done
