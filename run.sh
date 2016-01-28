#!/bin/ksh
#This script can do the Gaussian Project automaticly.
#Author:MAKE_DI Institute:University of York
#To use this,here are some tips:
#trees shows below
#  ./run.sh
#  ./nohup.out
#  ./FAILED
#  ./PASSED
#  ./tasks/??/*.run
#  ./pass/
#  ./fail/
#
mkdir pass
mkdir fail
cd tasks
echo "~~HERE WE GO~~"
echo "~~GOOD LUCK~~"

judge () {
        grep -q "Normal termination" $log
        if [ $? -eq 1 ]
        then
                mv ${run%.*}.* ../../fail/  
                echo "${run%.*} FAILED"  >> ../../FAILED
                echo -e "!!!${run%.*} FAILED!!!\n"
        else
                formchk $chk
                rename 's/.nmr$/.nmr.fchk/' *
                cubegen 0 ShieldingDensity=zz1 ${chk%.*}.fchk ${chk%.*}.cube 100 h
#                cubegen 0 mo=lumo ${chk%.*}.fchk ${chk%.*}_lumo.cube 100 h
#                cubegen 0 mo=homo ${chk%.*}.fchk ${chk%.*}_homo.cube 100 h
                mv ${run%.*}* ../../pass/
                echo "${run%.*} calculation finished">> ../../PASSED
                echo "${run%.*} calculation finished"
        fi
}

for order in `ls -F | grep /`
do        
        cd $order
        ls | grep -q .run
        if [ $? -eq 0 ]
        then
                echo "@@STEP $order BEGIN!@@"
                for run in *.run
                do
                        log="${run%.*}.log"
                        chk="${run%.*}.chk"
                        echo "${run%.*} calculation start"
                        time g09 $run 
                        wait
                        judge
                done
                echo -e "@@STEP $order END@@\n" 
                cd ..
        else
                echo -e "***STEP $order No Input File!!***\n"
                cd ..
        fi
done 

echo "ALL DONE"